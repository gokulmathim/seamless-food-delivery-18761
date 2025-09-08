import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_delivery_frontend/main.dart';

void main() {
  testWidgets('App boots and shows Onboarding', (WidgetTester tester) async {
    await tester.pumpWidget(const FoodDeliveryApp());
    await tester.pumpAndSettle();

    expect(find.text('Seamless Food'), findsWidgets);
    expect(find.text('Get Started'), findsOneWidget);
  });

  testWidgets('Navigate to Login', (WidgetTester tester) async {
    await tester.pumpWidget(const FoodDeliveryApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    expect(find.text('Login'), findsOneWidget);
  });
}
