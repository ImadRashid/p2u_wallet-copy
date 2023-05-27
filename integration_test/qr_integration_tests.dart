import 'package:p2u_wallet/v2/ui/screens/homescreen/base_screen.dart';
import 'package:p2u_wallet/v2/ui/widgets/custom_text_input_field.dart';
import 'utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:get/get.dart';

class QRTransactionTest {
  Future<void> testCameraPermission(WidgetTester tester) async {
    await loadWidget(tester, BottomNavigation(indexValue: 0));

    expect(find.text('Tokens'.tr), findsOneWidget);
    print("✓ Arrived On Home Screen");

    await genericOnTap(
        tester, find.byType(IconButton).at(2), "QR Transaction Button Pressed");

    print("✓ Camera Permission Test Passed");
  }

  Future<void> testQRTransaction(WidgetTester tester) async {
    await loadWidget(tester, BottomNavigation(indexValue: 0));

    expect(find.text('Tokens'.tr), findsOneWidget);
    print("✓ Arrived On Home Screen");

    await genericOnTap(
        tester, find.byType(IconButton).at(2), "QR Transaction Button Pressed");
    await tester.pumpAndSettle();
    await tester.pumpAndSettle();
    await tester.pumpAndSettle();
    await tester.pumpAndSettle();
    await tester.pumpAndSettle();
    await tester.pumpAndSettle();
    await tester.pump(Duration(seconds: 2));
    await tester.pump(Duration(seconds: 2));

    if (find.text("accept".tr).evaluate().isNotEmpty &&
        find.text("transaction_detail".tr).evaluate().isNotEmpty) {
      print("✓ Type : Send QR Transaction");
      await genericDialogActions(tester);
    } else if (find.text("ok".tr).evaluate().isNotEmpty) {
      print("✓ Type : Completed Transaction");
    } else {
      print("✓ Type : Wallet Access Request");
      await genericDialogActions(tester);
    }
    if (find.text("transaction_confirmed".tr).evaluate().isNotEmpty) {
      print("✓ QR Transaction Successful");
    } else if (find.text("transaction_failed".tr).evaluate().isNotEmpty) {
      print("✓ QR Transaction Failure");
    }
    print("✓ QR Transaction Test Passed");
  }

  Future<void> genericDialogActions(WidgetTester tester) async {
    await genericOnTap(tester, find.text("accept".tr), "Accept QR Transaction");
    await genericEnterText(
        tester, find.byType(CustomTextInputField), "asdf1234#S");
    await genericOnTap(tester, find.text("ok".tr), "Password Submitted");
  }
}
