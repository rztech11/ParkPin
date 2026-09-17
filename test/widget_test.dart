// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:parkpin/main.dart';

void main() {
  testWidgets('ParkPinApp smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ParkPinApp());
    expect(find.text('PARK PIN'), findsOneWidget);

    // Fast-forward 3 seconds to complete splash screen transition
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    // Verify Onboarding renders
    expect(find.text('Remember where you parked.'), findsOneWidget);
  });
}
