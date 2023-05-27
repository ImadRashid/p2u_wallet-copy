import 'package:flutter_test/flutter_test.dart';
import 'package:p2u_wallet/locator.dart';
import 'package:p2u_wallet/v2/core/services/auth_services.dart';
import 'package:p2u_wallet/v2/ui/screens/homescreen/base_screen.dart';
import 'package:p2u_wallet/v2/ui/widgets/custom_text_input_field.dart';
import 'package:p2u_wallet/v2/ui/widgets/home_screen_widgets/crypto_widget.dart';
import 'package:p2u_wallet/v2/ui/widgets/swap_screen_widgets/small_button.dart';
import 'utils.dart';
import 'package:get/get.dart';

class TokenTransferTest {
  Future<void> testTokenTransferDetails(WidgetTester tester) async {
    await loadWidget(tester, BottomNavigation(indexValue: 0));
    expect(find.text('Tokens'.tr), findsOneWidget);
    print("✓ Arrived On Home Screen");
    await genericOnTap(
        tester, find.byType(CryptoWidget), "P2UPB Widget Pressed");
    expect(find.text('P2UPB'), findsOneWidget);
    print("✓ Arrived On Main Swap Screen");

    await genericOnTap(
        tester, find.text("transfer_credit".tr), "P2UPB Widget Pressed");
    expect(find.text('transfer'.tr), findsOneWidget);
    print("✓ Arrived On Transfer Screen");

    expect(find.text('email'.tr), findsOneWidget);
    expect(find.text('Amount'.tr), findsOneWidget);
    expect(find.byType(CustomTextInputField), findsNWidgets(2));
    expect(find.byType(SwapScreenSmallButton), findsNWidgets(2));
    expect(find.text('send'.tr), findsOneWidget);

    print("✓ Screen Details Test Passed");
  }

  Future<void> testTokenTransfer(WidgetTester tester) async {
    await loadWidget(tester, BottomNavigation(indexValue: 0));
    expect(find.text('Tokens'.tr), findsOneWidget);
    print("✓ Arrived On Home Screen");
    await genericOnTap(
        tester, find.byType(CryptoWidget), "P2UPB Widget Pressed");
    expect(find.text('P2UPB'), findsOneWidget);
    print("✓ Arrived On Main Swap Screen");

    await genericOnTap(
        tester, find.text("transfer_credit".tr), "P2UPB Widget Pressed");
    expect(find.text('transfer'.tr), findsOneWidget);
    print("✓ Arrived On Transfer Screen");

    await genericEnterText(tester, find.byType(CustomTextInputField).first,
        "imadrashid789@gmail.com");
    await genericEnterText(
        tester, find.byType(CustomTextInputField).last, "12.7");

    await genericOnTap(
        tester, find.text('send'.tr), "Transfer Token Button Pressed");

    await genericEnterText(
        tester, find.byType(CustomTextInputField).last, "asdf1234");
    await genericOnTap(
        tester, find.text('ok'.tr), "Password Verification Button Pressed");

    assert(find.text('transaction_request'.tr).evaluate().isNotEmpty,
        "Token Transfer Failure");
    print("✓ Token Transfer Test Passed");
  }

  Future<void> testResetAndMaxButtons(WidgetTester tester) async {
    await loadWidget(tester, BottomNavigation(indexValue: 0));
    expect(find.text('Tokens'.tr), findsOneWidget);
    print("✓ Arrived On Home Screen");
    await genericOnTap(
        tester, find.byType(CryptoWidget), "P2UPB Widget Pressed");
    expect(find.text('P2UPB'), findsOneWidget);
    print("✓ Arrived On Main Swap Screen");

    await genericOnTap(
        tester, find.text("transfer_credit".tr), "Transfer Credit Pressed");
    expect(find.text('transfer'.tr), findsOneWidget);
    print("✓ Arrived On Transfer Screen");

    await genericOnTap(tester, find.text("max".tr), "Max Pressed");
    var value =
        locator<AuthServices>().myAppUser.wallet!.tokens![0].balance.toString();
    expect(find.widgetWithText(CustomTextInputField, value), findsOneWidget);
    expect(find.text(value), findsOneWidget);
    await genericOnTap(tester, find.text("reset".tr), "Reset Pressed");
    expect(
        find.widgetWithText(CustomTextInputField, ""), findsAtLeastNWidgets(2));
    print("✓ Reset And Max Test Passed");
  }
}
