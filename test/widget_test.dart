import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:first_app/screens/splash_screen.dart';

void main() {
  testWidgets('SplashScreen displays CircularProgressIndicator test',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SplashScreen(),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Flutter Chat'), findsOneWidget);
  });
}
