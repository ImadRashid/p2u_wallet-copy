import 'dart:convert';
import 'dart:developer';
import 'package:crypto/crypto.dart';
import 'package:p2u_wallet/v2/core/services/local_auth.dart';
import 'package:p2u_wallet/v2/ui/screens/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:p2u_wallet/v2/ui/widgets/password_snackbar.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../../locator.dart';
import '../models/user_model.dart';
import 'api_services.dart';

class AuthServices {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  User? firebaseUser;
  String? appleDisplayName;
  final _apiServices = ApiServices();
  GoogleSignIn googleSignIn = GoogleSignIn();

  bool isLogin = false;
  bool isIdCreated = false;

  UserModel myAppUser = UserModel();
  String? userToken;

  AuthServices();

  getUserToken() async {
    userToken = await firebaseUser!.getIdToken();
    return userToken;
  }

  init() async {
    isLogin = firebaseAuth.currentUser != null;
    if (isLogin) {
      firebaseUser = firebaseAuth.currentUser;
      userToken = await firebaseUser!.getIdToken();

      await autoLogin();
    }
  }

  autoLogin() async {
    final result = await _apiServices.fetchUser();
    isIdCreated = result != false;
    myAppUser = isIdCreated ? UserModel.fromJson(result) : UserModel();
    //log(userToken.toString());
  }

  Future<bool> genericUserLogin(credential) async {
    final userCredentialData =
        await firebaseAuth.signInWithCredential(credential);
    firebaseUser = userCredentialData.user!;
    userToken = await firebaseUser!.getIdToken();
    await autoLogin();
    return isIdCreated;
  }

  /// Sign in with Google

  Future signInWithGoogle(context) async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        return await genericUserLogin(credential);
      }
    } catch (ex) {
      isLogin = false;
      debugPrint("Error: $ex");
      Get.back();
      showCustomSnackBar("Error", "Error: $ex", Colors.black);
    }
  }

  Future signInWithFacebook(BuildContext context) async {
    try {
      debugPrint("Facebook auth calling");
      // Trigger the sign-in flow
      final LoginResult loginResult = await FacebookAuth.instance.login();
      // Create a credential from the access token
      if (loginResult.status == LoginStatus.success) {
        final OAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(loginResult.accessToken!.token);
        return await genericUserLogin(facebookAuthCredential);
      } else {
        if (loginResult.message!.contains("1675030")) {
          showCustomSnackBar(
              "Error",
              "It seems like your app is in developer mode, Please publish your app to start using Facebook login in release mode as well",
              Colors.black);
        } else if (loginResult.message!
            .contains("User has cancelled login with Facebook")) {
          debugPrint(loginResult.message!);
        } else {
          showCustomSnackBar(
              "Error", loginResult.message!.toString(), Colors.black);
        }
        return null;
      }
    } catch (ex) {
      isLogin = false;
      debugPrint(ex.toString());
      Get.back();
      showCustomSnackBar("Error", "Error: $ex", Colors.black);
    }
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future signInWithApple() async {
    debugPrint("object SIGN IN WITH APLE CALLED");
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    try {
      // Request credential for the currently signed in Apple account.
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );
      debugPrint("Given Name= ${appleCredential.givenName}");
      debugPrint("$appleCredential");
      appleDisplayName =
          "${appleCredential.givenName} ${appleCredential.familyName}";
      // appleCredential

      //  await prefs!.setString(asf:"asdf");
      debugPrint(appleCredential.authorizationCode);

      // Create an `OAuthCredential` from the credential returned by Apple.
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
        // signInMethod:
      );

      // Sign in the user with Firebase. If the nonce we generated earlier does
      // not match the nonce in `appleCredential.identityToken`, sign in will fail.
      return await genericUserLogin(oauthCredential);
    } catch (exception) {
      debugPrint(exception.toString());
    }
  }

  resetAll() {
    isLogin = false;
    myAppUser = UserModel();
    firebaseUser = null;
  }

  logout() async {
    final bioM = locator<BioMetricAuthenticationServices>();
    try {
      await firebaseAuth.signOut();
      firebaseUser!.providerData[0].providerId != "facebook.com"
          ? await googleSignIn.disconnect()
          : await FacebookAuth.instance.logOut();
      // await firebaseAuth.
      await init();
      // await GetIt.instance;
      await bioM.clearBioMetricStatus();
      myAppUser = UserModel();
      await bioM.init();
      Get.offAll(SplashScreenV2());
    } catch (e) {
      debugPrint("Exception@logoutUser ==> $e");
    }
  }
}
