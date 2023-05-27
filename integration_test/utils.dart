import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'parent_wrapper.dart';

String? extractFromRichText(widget) {
  if (widget is RichText) {
    if (widget.text is TextSpan) {
      var buffer = StringBuffer();
      (widget.text as TextSpan).computeToPlainText(buffer);
      return buffer.toString();
    }
  }
  return null;
}

Future<void> loadWidget(WidgetTester tester, Widget child) async {
  await tester.pumpAndSettle();
  await tester.pump(const Duration(seconds: 1));
  await tester.pumpWidget(LoadMyApp(widgetChild: child));
  await tester.pumpAndSettle();
  await tester.pump(const Duration(seconds: 1));
}

Future<void> genericOnTap(
    WidgetTester tester, Finder finder, String statement) async {
  await tester.tap(finder);
  print("✓ $statement");
  await tester.pumpAndSettle();

  await tester.pump(const Duration(seconds: 1));
}

Future<void> genericScroll(WidgetTester tester, Finder finder) async {
  await tester.scrollUntilVisible(finder, 500,
      scrollable: find.byType(Scrollable));
  print("✓ Screen Scrolling");
  await tester.pumpAndSettle();

  await tester.pump(const Duration(seconds: 1));
}

Future<void> genericFling(WidgetTester tester) async {
  await tester.flingFrom(Offset(0, 500), Offset(0, -400), 300);
  print("✓ Screen Scrolling");
  await tester.pumpAndSettle();
  await tester.pump(Duration(seconds: 1));
}

Future<void> genericRandomOnTap(WidgetTester tester) async {
  await tester.tapAt(Offset(100, 100));
  await tester.pumpAndSettle();
  await tester.pump(const Duration(seconds: 1));
}

Future<void> genericEnterText(
    WidgetTester tester, Finder finder, String text) async {
  await tester.enterText(finder, text);
  print("✓ Text Entered into TextInputField");
  FocusManager.instance.primaryFocus?.unfocus();
  await tester.pumpAndSettle();
  await tester.pump(const Duration(seconds: 1));
}
