import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:p2u_wallet/v2/core/config/keys_for_testing.dart';
import 'package:p2u_wallet/locator.dart';
import 'package:p2u_wallet/main.dart';
import 'package:p2u_wallet/v2/core/services/auth_services.dart';
import 'package:p2u_wallet/v2/ui/screens/authentications/login/login_screen.dart';
import 'package:p2u_wallet/v2/ui/screens/homescreen/base_screen.dart';
import 'package:p2u_wallet/v2/ui/widgets/custom_login_button.dart';

import 'parent_wrapper.dart';
import 'utils.dart';

class LoginTest {
  String googleSignIn = "Sign in with Google";
  String facebookSignIn = "Sign in with Facebook";
  String language = "English";
  Future<void> languageChange(WidgetTester tester) async {
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpWidget(LoadMyApp(widgetChild: LoginScreen()));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));
    // Chinese Language Change
    googleSignIn = "登陆使用 Google";
    facebookSignIn = "登陆使用 Facebook";
    language = "Chinese";
    await changeLoginLanguage(tester: tester, finder: find.text('CHN').last);
    // Japanese Language Change
    googleSignIn = "でサインイン Google";
    facebookSignIn = "でサインイン Facebook";
    language = "Japanese";
    await changeLoginLanguage(tester: tester, finder: find.text('JPN').last);
    // Korean Language Change
    googleSignIn = "로 로그인하다 Google";
    facebookSignIn = "로 로그인하다 Facebook";
    language = "Korean";
    await changeLoginLanguage(tester: tester, finder: find.text('KOR').last);
    // English Language Change
    googleSignIn = "Sign in with Google";
    facebookSignIn = "Sign in with Facebook";
    language = "English";
    await changeLoginLanguage(tester: tester, finder: find.text('ENG').last);
  }

  Future<void> changeLoginLanguage(
      {required WidgetTester tester, required Finder finder}) async {
    final Finder eng = find.text('ENG');
    final Finder chn = find.text('CHN');
    final Finder jpn = find.text('JPN');
    final Finder kor = find.text('KOR');
    // Check Before Tap
    expect(eng, findsOneWidget);
    expect(chn, findsOneWidget);
    expect(jpn, findsOneWidget);
    expect(kor, findsOneWidget);
    // Drop Down Renders Menu Items 2 times
    await tester.tap(find.byKey(WidgetKey.languageChangeLoginScreen));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));
    //Check After Tap
    expect(eng, findsNWidgets(2));
    expect(chn, findsNWidgets(2));
    expect(jpn, findsNWidgets(2));
    expect(kor, findsNWidgets(2));

    await tester.tap(finder);
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byWidgetPredicate(googleLoginButtonTranslated), findsOneWidget);
    expect(
        find.byWidgetPredicate(facebookLoginButtonTranslated), findsOneWidget);
    print("Language Translation for `$language` works for Login Screen.");
  }

  bool googleLoginButtonTranslated(widget) {
    return extractFromRichText(widget) == googleSignIn;
  }

  bool facebookLoginButtonTranslated(widget) {
    return extractFromRichText(widget) == facebookSignIn;
  }

  Future<void> socialSignInWithGoogle(WidgetTester tester) async {
    await loadWidget(tester, LoginScreen());
    // Check we are on landing screen
    expect(
        find.byWidgetPredicate(
            (widget) => extractFromRichText(widget) == 'Sign in with Google'),
        findsOneWidget);
    print("✓ Landed on Login Screen");

    await genericOnTap(
        tester, find.byType(LoginButton).first, 'Google Login Pressed');
    expect(locator<AuthServices>().firebaseUser, isNotNull);
    print(
        '✓ User Logged in. Username : ${locator<AuthServices>().firebaseUser!.displayName}');
    expect(find.text('Tokens'), findsOneWidget);
    print("✓ All Checks Passed");
  }

  Future<void> socialSignInWithFacebook(WidgetTester tester) async {
    await loadWidget(tester, LoginScreen());
    // Check we are on landing screen
    expect(
        find.byWidgetPredicate(
            (widget) => extractFromRichText(widget) == 'Sign in with Facebook'),
        findsOneWidget);
    print("✓ Landed on Login Screen");

    await genericOnTap(
        tester, find.byType(LoginButton).last, 'Facebook Login Pressed');
    expect(locator<AuthServices>().firebaseUser, isNotNull);
    print(
        '✓ User Logged in. Username : ${locator<AuthServices>().firebaseUser!.displayName}');
    expect(find.text('Tokens'), findsOneWidget);
    print("✓ All Checks Passed");
  }
}
