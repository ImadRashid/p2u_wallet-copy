import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:p2u_wallet/locator.dart';
import 'package:p2u_wallet/v2/core/services/auth_services.dart';
import 'package:p2u_wallet/v2/ui/screens/authentications/login/login_screen.dart';
import 'package:p2u_wallet/v2/ui/widgets/create_screen_widget/circular_check_button.dart';
import 'package:p2u_wallet/v2/ui/widgets/custom_button.dart';
import 'package:p2u_wallet/v2/ui/widgets/custom_text_input_field.dart';
import 'parent_wrapper.dart';
import 'utils.dart';
import 'package:get/get.dart';

class CreateIDTest {
  Future<void> testCreateID(WidgetTester tester) async {
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpWidget(LoadMyApp(widgetChild: LoginScreen()));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));

    expect(
        find.byWidgetPredicate(
            (widget) => extractFromRichText(widget) == "Sign in with Google"),
        findsOneWidget);
    print("✓ Google Sign in Button Found");
    await tester.tap(find.byWidgetPredicate(
        (widget) => extractFromRichText(widget) == "Sign in with Google"));
    print("✓ Google Sign in Button Pressed");
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));

    expect(locator<AuthServices>().firebaseUser, isNotNull);
    print(
        '✓ User Logged in. Username : ${locator<AuthServices>().firebaseUser!.displayName}');
    await checkCreateIDScreen(tester);
    print("✓ User ID Created Check Passed");
    await checkCreatePasswordScreen(tester);
    print("✓ User Password Created Check Passed");

    expect(find.text(locator<AuthServices>().myAppUser.wallet!.onChainAddress!),
        findsOneWidget);
    expect(
        find.text(locator<AuthServices>().myAppUser.wallet!.offChainAddress!),
        findsOneWidget);
    print("✓ Wallet Address Check Passed");
    await tester.tap(find.text('ok'.tr));
    print("✓ User Registration Check Passed");
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byWidgetPredicate((widget) {
      return extractFromRichText(widget) == "P2U Wallet";
    }), findsOneWidget);

    print("✓ Registration Complete, Landed on Main HomeScreen");
  }

  Future<void> checkCreateIDScreen(WidgetTester tester) async {
    expect(find.text("create_id".tr), findsOneWidget);
    print("✓ Arrived on Create ID Screen");

    await tester.enterText(find.byType(CustomTextInputField), "testUser345");
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));
    /*if (Platform.isIOS) {
      await tester.enterText(
          find.byType(CustomTextInputField).last, "Test User 345");
    }*/

    expect(find.byWidgetPredicate((widget) {
      if (widget is CircularCheckButton) {
        return widget.iconColor == Colors.white;
      }
      return false;
    }), findsNWidgets(2));
    print("✓ Text Input Check Passed");

    await tester.tap(find.byType(CustomMaterialButton));
    print("✓ Next Button Pressed");
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));
  }

  Future<void> checkCreatePasswordScreen(WidgetTester tester) async {
    expect(find.text('create_pass'.tr), findsOneWidget);
    print("✓ Arrived on Create Password Screen");

    await tester.enterText(
        find.byType(CustomTextInputField).first, "asdf1234#S");
    await tester.enterText(
        find.byType(CustomTextInputField).last, "asdf1234#S");
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byWidgetPredicate((widget) {
      if (widget is CircularCheckButton) {
        return widget.iconColor == Colors.white;
      }
      return false;
    }), findsNWidgets(3));
    print("✓ Text Input Check Passed");

    await tester.tap(find.text('accept_pass_agreement'.tr));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));

    await tester.tap(find.text('ok'.tr));
    print("✓ Agreement Accepted");
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));

    await tester.tap(find.byType(CustomMaterialButton));
    print("✓ Submit Request");
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 5));

    expect(find.text('request_confirmation'.tr), findsOneWidget);
    print("✓ Arrived on Registration Complete Screen");
  }
}
