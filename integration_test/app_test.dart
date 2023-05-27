import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:p2u_wallet/main.dart' as app;
import 'package:flutter/material.dart';
import 'billing_method_tests.dart';
import 'create_id_tests.dart';
import 'history_screen_tests.dart';
import 'homescreen_tests.dart';
import 'onboarding_tests.dart';
import 'qr_integration_tests.dart';
import 'settings_screen_tests.dart';
import 'login_tests.dart';
import 'token_transfer_tests.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  //Get.testMode = true;
  setUpAll(() {
    app.main();
  });
  group('App OnBoarding', () {
    testWidgets('OnBoarding Screen, Screen Swipes and Next Button Works',
        OnBoardingTest().swipeTest);
  });
  group('Login Screen: Language Change and Social Logins', () {
    //testWidgets('Language Selection', LoginTest().languageChange);
    testWidgets('Google Login', LoginTest().socialSignInWithGoogle);
    //testWidgets('Facebook Login', LoginTest().socialSignInWithFacebook);
  });

  /*group('Home Screen: Home Screen Details and Navigation', () {
    testWidgets(
        'Home Screen Details Test', HomeScreenTest().testHomeScreenDetails);
    testWidgets('Home Screen Navigation Test',
        HomeScreenTest().testHomeScreenNavigation);
  });
  group('History Screen: History Screen Details, Data and Scrolling', () {
    testWidgets(
        'History Screen Details Test', HistoryScreenTest().testScreenDetails);
  });
  group('Settings Screen: Details and Actions', () {
    testWidgets('Settings Screen Details Test',
        SettingScreenTest().testSettingsScreenDetails);
    testWidgets('Username Copy', SettingScreenTest().testUsernameCopied);
    testWidgets(
        'My Wallet Screen', SettingScreenTest().testMyWalletInformation);
    testWidgets('Language Change', SettingScreenTest().testLanguageChange);

    testWidgets(
        'Stores Screen', SettingScreenTest().testStoreScreenInformation);
    testWidgets('Enable FingerPrint Authentication',
        SettingScreenTest().testEnableFingerprintAuthentication);
    testWidgets('Disable FingerPrint Authentication',
        SettingScreenTest().testDisableFingerprintAuthentication);
    testWidgets(
        'Privacy Policy Screen', SettingScreenTest().testPrivacyPolicyScreen);
    testWidgets('T&C Screen', SettingScreenTest().testTNCScreen);
    testWidgets('Contact Us Screen', SettingScreenTest().testContactScreen);
    testWidgets('Logout', SettingScreenTest().testLogout);
    testWidgets(
        'Wallet Termination', SettingScreenTest().testWalletTermination);
  });
   group('Billing Method', () {
    testWidgets('Details', BillingMethodTest().testBillingScreenDetails);
    testWidgets('Add Card', BillingMethodTest().testAddCard);
  });
  group('Create User ID', () {
    testWidgets('Create New User', CreateIDTest().testCreateID);
  });
  group('QR Code Transaction', () {
    testWidgets(
        'Camera Permission Test', QRTransactionTest().testCameraPermission);
    testWidgets('QR Transaction Test', QRTransactionTest().testQRTransaction);
  });*/

  group('Token Transfer Test', () {
    //testWidgets('Screen Details', TokenTransferTest().testTokenTransferDetails);
    //testWidgets('Transfer Transaction', TokenTransferTest().testTokenTransfer);
    testWidgets('Reset and Max', TokenTransferTest().testResetAndMaxButtons);
  });
}
