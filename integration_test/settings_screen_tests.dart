import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:p2u_wallet/locator.dart';
import 'package:p2u_wallet/v2/core/services/auth_services.dart';
import 'package:p2u_wallet/v2/core/services/local_auth.dart';
import 'package:p2u_wallet/v2/ui/screens/authentications/login/login_screen.dart';
import 'package:p2u_wallet/v2/ui/screens/homescreen/base_screen.dart';
import 'package:p2u_wallet/v2/ui/widgets/custom_text_input_field.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'login_tests.dart';
import 'parent_wrapper.dart';
import 'utils.dart';

class SettingScreenTest {
  bool isPolygon = true;
  Future<void> testSettingsScreenDetails(WidgetTester tester) async {
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));
    await tester
        .pumpWidget(LoadMyApp(widgetChild: BottomNavigation(indexValue: 2)));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));

    await checkSettingsScreenDetails(tester);
  }

  Future<void> testUsernameCopied(WidgetTester tester) async {
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));
    await tester
        .pumpWidget(LoadMyApp(widgetChild: BottomNavigation(indexValue: 2)));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text(locator<AuthServices>().myAppUser.name!), findsOneWidget);
    print("✓ Username Present Check Passed");

    await tester.tap(find.text(locator<AuthServices>().myAppUser.name!));
    print("✓ Username Widget Pressed");
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));
    expect(find.text("username_copied".tr), findsOneWidget);
    print("✓ Username Copied Check Passed");
  }

  Future<void> testMyWalletInformation(WidgetTester tester) async {
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));
    await tester
        .pumpWidget(LoadMyApp(widgetChild: BottomNavigation(indexValue: 2)));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));

    await tester.tap(find.text("my_wallet".tr));
    print("✓ My Wallet Button Pressed");
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('my_wallet'.tr), findsOneWidget);
    print("✓ Arrived on Wallet Screen");
    expect(find.text("Polygon Chain"), findsOneWidget);
    await checkChainWalletInformation(tester);
    print("✓ Polygon Chain Copy Address Check Passed");
    expect(find.text("Beacon Chain"), findsOneWidget);
    isPolygon = false;
    await checkChainWalletInformation(tester);
    print("✓ Beacon Chain Copy Address Check Passed");
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
  }

  Future<void> testStoreScreenInformation(WidgetTester tester) async {
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));
    await tester
        .pumpWidget(LoadMyApp(widgetChild: BottomNavigation(indexValue: 2)));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));

    await tester.tap(find.text("Stores"));
    print("✓ Stores Button Pressed");
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    print("✓ Arrived on Store Screen Check Passed");
    expect(find.byType(GoogleMap), findsOneWidget);
    print("✓ Google Maps Loaded Check Passed");
    expect(find.byIcon(Icons.my_location), findsOneWidget);
    print("✓ My Location Button Check Passed");

    await getBack(tester);
  }

  Future<void> testPrivacyPolicyScreen(WidgetTester tester) async {
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));
    await tester
        .pumpWidget(LoadMyApp(widgetChild: BottomNavigation(indexValue: 2)));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));

    await tester.scrollUntilVisible(find.text("privacy_policy".tr), 10);
    await tester.tap(find.text("privacy_policy".tr));
    print("✓ Privacy Policy Button Pressed");

    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));
    expect(find.text("privacy_policy".tr), findsOneWidget);
    expect(find.text("https://dev-p2u-api.msq.market/privacy-policy"),
        findsOneWidget);
    print("✓ Arrived on Privacy Policy WebView Check Passed");
    expect(find.byType(WebView), findsOneWidget);
    print("✓ Content Loaded in WebView Check Passed");

    await getBack(tester);
  }

  Future<void> testTNCScreen(WidgetTester tester) async {
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));
    await tester
        .pumpWidget(LoadMyApp(widgetChild: BottomNavigation(indexValue: 2)));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));

    await tester.scrollUntilVisible(find.text("terms_and_conditions".tr), 10);
    await tester.tap(find.text("terms_and_conditions".tr));
    print("✓ T&C Button Pressed");
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text("terms_and_conditions".tr), findsOneWidget);
    expect(find.text("https://dev-p2u-api.msq.market/terms-and-conditions"),
        findsOneWidget);
    print("✓ Arrived on T&C WebView Check Passed");
    expect(find.byType(WebView), findsOneWidget);
    print("✓ Content Loaded in WebView Check Passed");

    await getBack(tester);
  }

  Future<void> testContactScreen(WidgetTester tester) async {
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));
    await tester
        .pumpWidget(LoadMyApp(widgetChild: BottomNavigation(indexValue: 2)));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));

    await tester.scrollUntilVisible(find.text("contact_us".tr), 5);
    await tester.tap(find.text("contact_us".tr));

    print("✓ Contact Us Button Pressed");
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));
    expect(find.text("contact_us_title".tr), findsOneWidget);
    print("✓ Arrived on Contact Us Screen Check Passed");
    expect(find.byType(CustomTextInputField), findsNWidgets(3));
    print("✓ Text Input Fields Check Passed");
    await tester.enterText(
        find.byType(CustomTextInputField).at(0), "Error in Settings Screen");
    await tester.enterText(
        find.byType(CustomTextInputField).at(1), "test@gmail.com");
    await tester.enterText(find.byType(CustomTextInputField).at(2),
        "Simple Test to check whether the contact screen is working or not");
    await tester.tap(find.text("Send"));
    print("✓ Contact Screen Response Sent Check Passed");
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text("contact_us_error_1".tr), findsOneWidget);
    print("✓ Contact Screen Response Success Check Passed");

    await getBack(tester);
    await getBack(tester);
    expect(find.text('settings'.tr), findsNWidgets(2));
  }

  Future<void> testLogout(WidgetTester tester) async {
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));
    await tester
        .pumpWidget(LoadMyApp(widgetChild: BottomNavigation(indexValue: 2)));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));

    await tester.scrollUntilVisible(find.text("logout".tr), 5);
    await tester.tap(find.text("logout".tr));

    print("✓ Logout Button Pressed");
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));

    expect(
        find.byWidgetPredicate(
            (widget) => extractFromRichText(widget) == "Sign in with Google"),
        findsOneWidget);
    print("✓ After Logout Landed on Login Screen Check Passed");
  }

  Future<void> testEnableFingerprintAuthentication(WidgetTester tester) async {
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));
    await tester
        .pumpWidget(LoadMyApp(widgetChild: BottomNavigation(indexValue: 2)));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));

    await tester.tap(find.byType(CupertinoSwitch));
    print("✓ FingerPrint Button Pressed");
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));

    await tester.enterText(find.byType(CustomTextInputField), "asdf1234#S");
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));

    await tester.tap(find.text('ok'.tr));
    print("✓ OK Button Pressed");
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 2));

    expect(find.text("Password Authenticated and Fingerprint Enabled"),
        findsOneWidget);
    await tester.pumpAndSettle();
    Get.closeAllSnackbars();
    print("✓ Fingerprint Enable Check Passed");
  }

  Future<void> testDisableFingerprintAuthentication(WidgetTester tester) async {
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));
    await tester
        .pumpWidget(LoadMyApp(widgetChild: BottomNavigation(indexValue: 2)));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));

    await tester.tap(find.byType(CupertinoSwitch));
    print("✓ FingerPrint Button Pressed");
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text("Fingerprint Disable Successful"), findsOneWidget);
    await tester.pumpAndSettle();
    Get.closeAllSnackbars();
    print("✓ Fingerprint Disable Check Passed");
  }

  Future<void> testLanguageChange(WidgetTester tester) async {
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));
    await tester
        .pumpWidget(LoadMyApp(widgetChild: BottomNavigation(indexValue: 2)));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));

    await checkLanguageChange(tester, "Chinese", "应用语言");
    await checkLanguageChange(tester, "Japanese", "アプリの言語");
    await checkLanguageChange(tester, "Korean", "앱 언어");
    await checkLanguageChange(tester, "English", "My Language");
  }

  Future<void> testWalletTermination(WidgetTester tester) async {
    await LoginTest().socialSignInWithGoogle(tester);
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));

    await tester.tap(find.text('settings'.tr));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));

    await tester.scrollUntilVisible(find.text("wallet_termination".tr), 5);
    await tester.tap(find.text("wallet_termination".tr));
    print("✓ Wallet Termination Button Pressed");
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text("wallet_termination_screen".tr), findsOneWidget);
    print("✓ Arrived on Wallet Termination Screen");

    await tester.enterText(find.byType(CustomTextInputField), "asdf1234#S");
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));

    await tester.tap(find.text('ok'.tr));
    print("✓ OK Button Pressed");
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('wallet_successfully_terminated'.tr), findsOneWidget);
    print("✓ Wallet Termination Check Passed");
  }

  Future<void> checkLanguageChange(
      WidgetTester tester, String language, String compare) async {
    await tester.tap(find.text('app_language'.tr));
    print("✓ My Language Button Pressed");
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));
    await tester.tap(find.text(language));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));
    expect(find.text(compare), findsOneWidget);
    print("✓ $language Language Change Check Passed");
  }

  Future<void> checkSettingsScreenDetails(WidgetTester tester) async {
    expect(find.text('Settings'), findsNWidgets(2));
    print("✓ Settings Screen Render Check Passed");
    expect(find.text("user_name".tr), findsOneWidget);
    print("✓ Username Label Check Passed");
    expect(find.text(locator<AuthServices>().myAppUser.name!), findsOneWidget);
    print("✓ Username Check Passed");
    expect(find.text("my_wallet".tr), findsOneWidget);
    print("✓ My Wallet Check Passed");
    expect(find.text("app_language".tr), findsOneWidget);
    print("✓ My Language Check Passed");
    expect(find.text("Stores".tr), findsOneWidget);
    print("✓ Stores Check Passed");
    expect(find.text("privacy_settings".tr), findsOneWidget);
    print("✓ Privacy Settings Check Passed");
    expect(find.text("fingerprint_authentication".tr), findsOneWidget);
    print("✓ Fingerprint Authentication Check Passed");
    expect(find.text("fingerprint_text".tr), findsOneWidget);
    print("✓ Fingerprint Label Check Passed");
    expect(find.text("privacy_policy".tr), findsOneWidget);
    print("✓ Privacy Policy Check Passed");
    expect(find.text("wallet_termination".tr), findsOneWidget);
    print("✓ Wallet Termination Check Passed");
    expect(find.text("terms_and_conditions".tr), findsOneWidget);
    print("✓ Terms and Conditions Check Passed");
    expect(find.text("contact_us".tr), findsOneWidget);
    print("✓ Contact us Check Passed");
    expect(find.text("logout".tr), findsOneWidget);
    print("✓ Logout Check Passed");
  }

  Future<void> checkChainWalletInformation(WidgetTester tester) async {
    await tester.tap(
        isPolygon ? find.text('Scan QR').first : find.text('Scan QR').last);
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byIcon(Icons.close), findsOneWidget);
    print(
        " ✓ Arrived on Copy Address Screen for ${isPolygon ? 'Polygon Chain' : 'Beacon Chain'}");
    expect(find.byType(QrImage), findsOneWidget);
    print(" ✓ QR Image Check Passed");

    expect(
        find.text(locator<AuthServices>().myAppUser.name! +
            (isPolygon ? "'s Polygon " : "'s Beacon ") +
            "wallet_address".tr),
        findsOneWidget);
    print(" ✓ Wallet Address Check Passed");

    expect(
        find.text(isPolygon
            ? locator<AuthServices>().myAppUser.wallet!.onChainAddress!
            : locator<AuthServices>().myAppUser.wallet!.offChainAddress!),
        findsOneWidget);
    print(" ✓ Wallet Address Check Passed");
    expect(find.text("copy_address".tr), findsOneWidget);
    print(" ✓ Copy Address Label Check Passed");

    await tester.tap(find.text("copy_address".tr));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));
    expect(find.text("wallet_id_copied".tr), findsOneWidget);
    print(" ✓ Chain Wallet Address Copy Check Passed");

    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));

    await tester.tap(isPolygon
        ? find.byIcon(Icons.copy).first
        : find.byIcon(Icons.copy).last);
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text("wallet_id_copied".tr), findsOneWidget);
    print(" ✓ My Wallet Screen : Wallet Address Copy Check Passed");
  }

  Future<void> getBack(WidgetTester tester) async {
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));
  }
}
