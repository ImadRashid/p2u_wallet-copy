import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:p2u_wallet/v2/ui/screens/settings/store_screen.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Stores Map Screen, Google Maps loaded',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: StoreScreen()));
    await tester.pump(const Duration(seconds: 1));

    expect(find.byWidget(CircularProgressIndicator()), findsNothing);
  });
  testWidgets('Stores Map Screen, Location Button available',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: StoreScreen()));
    await tester.pump(const Duration(seconds: 1));

    expect(find.byIcon(Icons.my_location), findsOneWidget);
  });
}
