import 'package:p2u_wallet/locator.dart';
import 'package:p2u_wallet/v2/core/services/auth_services.dart';
import 'package:p2u_wallet/v2/core/services/deep_link_payment.dart';
import 'package:p2u_wallet/v2/ui/screens/authentications/createid/create_id.dart';
import 'package:p2u_wallet/v2/ui/screens/authentications/login/login_screen.dart';
import 'package:p2u_wallet/v2/ui/screens/payment/mobile_payment.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/services/locator_services/internet_connectivity_service.dart';
import '../../core/services/locator_services/password_attempt.dart';
import './onboarding/onboarding_screen.dart';
import "./homescreen/base_screen.dart";
import 'fallback_error/no_internet_screen.dart';

/// A [Screen]/[Model] made up of type [StatelessWidget]
/// that displays the designed splash screen

class SplashScreenV2 extends StatefulWidget {
  @override
  State<SplashScreenV2> createState() => _SplashScreenV2State();
}

class _SplashScreenV2State extends State<SplashScreenV2> {
  @override
  void initState() {
    // calls delay function
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // executes after build
      delay();
    });
    super.initState();
  }

  /// [Function] that navigates [User] to specific page on the basis
  /// of:
  /// - [User] is logged in and [User]'s ID is created navigate to
  /// [BottomNavigation]
  /// - [User] is logged in and [User]'s ID is not created navigate
  /// to [CreateIdScreen]
  /// - [User] has already onboarded than navigate to [LoginScreen]
  /// - [User] has not onboarded than navigate to [OnBoardingScreen]
  delay() async {
    // initialize shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Widget? route;
    locator<InternetConnectivityService>();
    if (await locator<InternetConnectivityService>().checkConnection()) {
      route = NoInternetScreen();
    } else {
      // [AuthServices] object that handles [User]'s authentications
      var _authServices = locator<AuthServices>();
      await _authServices.init();
      locator<PasswordAttempt>();

      // check user is logged in and has created ID screen
      if (_authServices.isLogin && _authServices.isIdCreated) {
        // Navigate to Bottom Navigation
        route = locator<DeepLinkPayment>().hasDeepLink
            ? MobilePaymentScreen()
            : BottomNavigation(indexValue: 0);
      }
      // check user is logged in and has not created ID screen
      else if (_authServices.isLogin && !_authServices.isIdCreated) {
        // Navigate to Create ID Screen
        route = CreateIdScreen();
      } else {
        //check user has onboarding
        route = (prefs.getBool("onBoarding") ?? false)
            ? LoginScreen()
            : OnBoardingScreen();
      }
    }
    Get.offAll(() => route!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(),
          //Splash logo
          Image.asset(
            "assets/v2/logo.png",
            scale: 12.2,
          ),
        ],
      ),
    );
  }
}
