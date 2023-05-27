import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:p2u_wallet/locator.dart';
import 'package:p2u_wallet/v2/ui/screens/onboarding/onboarding_screen.dart';
import 'package:get/get.dart';
import 'package:p2u_wallet/v2/ui/widgets/custom_button.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  /*setUp(() async {
    await setupLocator();
  });*/
  testWidgets('Main Onboarding Screen, Buy Product Screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: OnBoardingScreen()));
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('buy_products'.tr), findsOneWidget);
  });
  Offset left = Offset(-700, 500);
  testWidgets(
    'Swipe During Onboarding, Screen Swipes from Right to Left',
    (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: OnBoardingScreen()));
      await tester.pumpAndSettle();

      expect(find.text('buy_products'.tr), findsOneWidget);
      await tester.drag(find.byType(PageView), left);
      await tester.pump(Duration(seconds: 1));

      expect(find.text('token_transfer'.tr), findsOneWidget);
      await tester.drag(find.byType(PageView), left);
      await tester.pump(Duration(seconds: 1));

      expect(find.text('secure_layer'.tr), findsOneWidget);
      await tester.drag(find.byType(PageView), left);
      await tester.pump(Duration(seconds: 1));

      expect(find.text('discounted_products'.tr), findsOneWidget);
      expect(find.text('next'.tr), findsOneWidget);
    },
  );
}
