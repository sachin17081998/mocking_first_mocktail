import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocking_first_mocktail/main.dart';

void main() {
  Widget createLoginScreen() => MaterialApp(home: LoginScreen());

  group('Testcases for login screen title', () {
    testWidgets('testing title- "Welcome User" exist or not', (tester) async {
      await tester.pumpWidget(createLoginScreen());
      final titleFinder = find.text('Welcome User');
      expect(titleFinder, findsOneWidget);
    });
  });

  group('Test Cases for User Name and password TextField', () {
    testWidgets('testing if userName textField exist', (tester) async {
      await tester.pumpWidget(createLoginScreen());
      final textFiledFinder = find.byKey(const ValueKey('userName'));
      expect(textFiledFinder, findsOneWidget);
    });

    testWidgets('testing if password textField exist', (tester) async {
      await tester.pumpWidget(createLoginScreen());
      final passwordFiledFinder = find.byKey(const ValueKey('password'));
      expect(passwordFiledFinder, findsOneWidget);
    });
  });

  group('Testcases for login sButton', () {
    testWidgets('testing if login button exist', (tester) async {
      await tester.pumpWidget(createLoginScreen());
      final buttonFinder = find.byType(ElevatedButton);
      expect(buttonFinder, findsOneWidget);
    });

    testWidgets('testing  login button with  label', (tester) async {
      await tester.pumpWidget(createLoginScreen());
      final buttonFinder = find.descendant(
          of: find.byType(ElevatedButton),
          matching: find.text('Press to Log In'));

      expect(buttonFinder, findsOneWidget);
    });

    testWidgets('testing if login button can has max 2 line label ',
        (tester) async {
      await tester.pumpWidget(createLoginScreen());
      final buttonFinder = find.byWidgetPredicate(
          (widget) => widget is Text && widget.maxLines == 2);

      expect(buttonFinder, findsOneWidget);
    });
  });

  group('Test for Column Widget', () {
    testWidgets('testing  Column widget exist or not ', (tester) async {
      await tester.pumpWidget(createLoginScreen());
      final buttonFinder = find.ancestor(
          of: find.byType(ElevatedButton), matching: find.byType(Column));

      expect(buttonFinder, findsOneWidget);
    });

    testWidgets('Testing  Column widget has one SizedBox(height 20) and other SizedBox(height 40)',
        (tester) async {
      await tester.pumpWidget(createLoginScreen());
      final buttonFinder = find.byElementPredicate((element) =>
          element.widget is SizedBox && element.size!.height == 20 ||
          element.size!.height == 40);

      expect(buttonFinder, findsNWidgets(2));
    });
  });
}
