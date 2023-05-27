import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import '../lib/v2/core/config/keys_for_testing.dart';

/// A [Test] class, that consists of test cases for OnBoarding Screen.

class OnBoardingTest {
  Future<void> swipeTest(WidgetTester tester,
      {Offset right = const Offset(200, 0),
      Offset left = const Offset(-200, 0)}) async {
    await tester.pumpAndSettle();
    // Check Buy Products Label
    expect(find.text('buy_products'.tr), findsOneWidget);
    print("✓ Buy Product Screen is there");
    await tester.dragFrom(right, left);
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));
    // Check Token Transfer Label
    expect(find.text('token_transfer'.tr), findsOneWidget);
    print("✓ Right to Left Swipe, Landed on Token Transfer Screen");
    await tester.dragFrom(right, left);
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));
    // Check Secure Layer Label
    expect(find.text('secure_layer'.tr), findsOneWidget);
    print("✓ Right to Left Swipe, Landed on Secure Layer Screen");
    await tester.dragFrom(right, left);
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));
    // Check Discounted Products Label
    expect(find.text('discounted_products'.tr), findsOneWidget);
    print("✓ Right to Left Swipe, Landed on Discounted Product Screen");
    await tester.tap(find.text('next'.tr));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));
    // Check Whether on Tap We land on Login Screen or not
    expect(find.byKey(WidgetKey.googleLoginButton), findsOneWidget);
    print("✓ Tap on Next Button, Landed on Login Screen");
  }
}
