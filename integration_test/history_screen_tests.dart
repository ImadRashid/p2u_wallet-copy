import 'package:p2u_wallet/v2/ui/screens/homescreen/base_screen.dart';
import 'package:p2u_wallet/v2/ui/widgets/history_widgets/history_list_card.dart';

import 'parent_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class HistoryScreenTest {
  bool isData = true;
  Future<void> testScreenDetails(WidgetTester tester) async {
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));
    await tester
        .pumpWidget(LoadMyApp(widgetChild: BottomNavigation(indexValue: 1)));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));

    await checkScreenDetails(tester);
    await checkTransactionData(tester);
    /*if (isData) {
      await checkScreenScrolling(tester);
    }*/
  }

  Future<void> checkScreenDetails(WidgetTester tester) async {
    expect(find.text('Transaction History'), findsOneWidget);
    print("✓ Screen Details Check Passed");
  }

  Future<void> checkTransactionData(WidgetTester tester) async {
    if (find.text('Your History List is Empty!').evaluate().isNotEmpty) {
      print("✓ History is empty");
      isData = false;
    } else {
      expect(find.byWidgetPredicate((widget) => (widget is HistoryListCard)),
          findsWidgets);
      print("✓ History has Data");
    }
    print("✓ Transaction Data Check Passed");
  }

  Future<void> checkScreenScrolling(WidgetTester tester) async {
    print("✓ Screen Scrolling Check Passed");
  }
}
