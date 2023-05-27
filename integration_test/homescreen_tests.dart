import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:p2u_wallet/v2/ui/screens/homescreen/base_screen.dart';
import 'package:p2u_wallet/v2/ui/widgets/home_screen_widgets/crypto_widget.dart';

import 'parent_wrapper.dart';
import 'package:flutter/material.dart';

import 'utils.dart';

class HomeScreenTest {
  Future<void> testHomeScreenDetails(WidgetTester tester) async {
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));
    await tester
        .pumpWidget(LoadMyApp(widgetChild: BottomNavigation(indexValue: 0)));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));

    // App Bar Title Check
    expect(find.byWidgetPredicate((widget) {
      return extractFromRichText(widget) == "P2U Wallet";
    }), findsOneWidget);
    print("✓ P2U Wallet AppBar Check Passed");

    // Total Balance Label Check
    expect(find.byWidgetPredicate((widget) {
      return extractFromRichText(widget) == "Total balance in";
    }), findsOneWidget);
    print("✓ Total Balance Check Passed");

    // Points Label Check
    expect(find.byWidgetPredicate((widget) {
      return extractFromRichText(widget) == " Points";
    }), findsOneWidget);
    print("✓ Points Label Check Passed");

    // User Balance Check
    expect(find.byWidgetPredicate((widget) {
      String text = extractFromRichText(widget) ?? " ";
      if (text.contains('.') && text.contains('P')) {
        print("   User Balance : " + text);
        return true;
      }
      return false;
    }), findsOneWidget);
    print("✓ User Balance Check Passed");

    // Tokens Label Check
    expect(find.byWidgetPredicate((widget) {
      return extractFromRichText(widget) == "Tokens";
    }), findsOneWidget);
    print("✓ Tokens Label Check Passed");

    // Tokens Detail Check
    expect(find.byWidgetPredicate((element) {
      if (element is CryptoWidget) {
        print(
            "   Token Name : ${element.token}, Token Balance : ${element.tokenBalance}");
        return true;
      }
      return false;
    }), findsOneWidget);
    print("✓ Tokens Details Check Passed");
  }

  Future<void> testHomeScreenNavigation(WidgetTester tester) async {
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));
    await tester
        .pumpWidget(LoadMyApp(widgetChild: BottomNavigation(indexValue: 0)));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));

    // Bottom Navigation Items Check
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('History'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
    print("✓ BottomNavigation Items Check Passed");
    // Navigate to History Screen
    await tester.tap(find.text('History'));
    print("✓ History Icon Tap Check Passed");
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Transaction History'), findsOneWidget);
    print("✓ Navigating to History Screen Check Passed");

    // Navigate to Settings Screen
    await tester.tap(find.text('Settings'));
    print("✓ Settings Icon Tap Check Passed");
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Username'), findsOneWidget);
    print("✓ Navigating to Settings Screen Check Passed");

    // Navigate to Home Screen
    await tester.tap(find.text('Home'));
    print("✓ Home Icon Tap Check Passed");
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('P2U Wallet'), findsOneWidget);
    print("✓ Navigating to Home Screen Check Passed");
  }
}
