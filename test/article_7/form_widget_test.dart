import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocking_first_mocktail/article_7/form_widget.dart';
import 'package:mocking_first_mocktail/auth/auth.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockAuthentication extends Mock implements Authentication {}

void main() {
  late MockAuthentication mockAuth = MockAuthentication();
  Widget createLoginScreen() => MaterialApp(
          home: LoginScreenNew(
        auth: mockAuth,
      ));

  group("Test for Name and Password Field", () {
    testWidgets(
        'Error message must be shown when text fileds are empty and user hits the login button',
        (tester) async {
      //stub the validator methods
      when(() => mockAuth.validateUserName(any()))
          .thenReturn('Enter user name');
      when(() => mockAuth.validatePassword(any())).thenReturn('Enter Password');

      //Arrange
      await tester.pumpWidget(createLoginScreen());

      // Act
      Finder loginBtn = find.byType(ElevatedButton);
      await tester.tap(loginBtn);
      await tester.pump();

      // Assert
      // Find the error messages for empty username and password
      final nameError = find.text('Enter user name');
      final passwordError = find.text('Enter Password');
      expect(nameError, findsOneWidget);
      expect(passwordError, findsOneWidget);
    });
  });

  group('Test for Login Button', () {
    testWidgets('Button label must be "Press to Logout" once login is done ',
        (tester) async {
      when(() => mockAuth.validateUserName(any())).thenReturn(null);
      when(() => mockAuth.validatePassword(any())).thenReturn(null);

      //Arrange
      await tester.pumpWidget(createLoginScreen());

      // Act
      await tester.enterText(find.byKey(ValueKey('userName')), 'gandalf');
      await tester.enterText(find.byKey(ValueKey('password')), 'gandalf123');
      Finder loginBtn = find.byType(ElevatedButton);
      await tester.tap(loginBtn);
      // after the tap loader will be shown for 2-seconds, so if we assert without rebuilding the widget then the assertion will fail
      await tester.pump(Duration(seconds: 2));
      // await tester.pumpAndSettle();

      // Assert
      // Find the error messages for empty username and password
      final buttonLabel = find.text('Press to Logout');
      expect(buttonLabel, findsOneWidget);
    });
  });
}
