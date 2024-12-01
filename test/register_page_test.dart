import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tekkers/screens/register_screen.dart';

void main() {
  group('RegisterPage Tests', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('Displays email and password input fields and button',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MaterialApp(home: RegisterPage()));

      // Act & Assert
      expect(find.byType(TextField), findsNWidgets(2),
          reason: "Email and Password input fields should be visible");
      expect(find.text('Sign In'), findsOneWidget,
          reason: "Sign In button should be visible");
    });

    testWidgets('User can enter email and password in the input fields',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MaterialApp(home: RegisterPage()));

      // Act
      await tester.enterText(find.byType(TextField).at(0), 'test@example.com');
      await tester.enterText(find.byType(TextField).at(1), 'password123');

      // Assert
      expect(find.text('test@example.com'), findsOneWidget);
      expect(find.text('password123'), findsOneWidget);
    });

    testWidgets('Registers a user and shows success dialog',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MaterialApp(home: RegisterPage()));

      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Act
      await tester.enterText(
          find.byType(TextField).first, 'test@example.com'); // Email field
      await tester.enterText(
          find.byType(TextField).last, 'password123'); // Password field
      await tester.tap(find.text('Sign In')); // Tap Sign In button
      await tester.pumpAndSettle(); // Wait for animations/dialogs

      // Assert
      expect(find.byType(AlertDialog), findsOneWidget,
          reason: "Success dialog should appear");
      expect(find.text('Success'), findsOneWidget,
          reason: "Dialog title should be 'Success'");
      expect(find.text('Account created successfully.'), findsOneWidget,
          reason: "Dialog should show success message");

      // Simulate user tapping "OK" to close the dialog
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Verify that the dialog is dismissed
      expect(find.byType(AlertDialog), findsNothing,
          reason: "Dialog should be dismissed after tapping OK");

      // Check if the data is saved in SharedPreferences
      expect(prefs.getString('email'), 'test@example.com',
          reason: "Email should be saved in SharedPreferences");
      expect(prefs.getString('password'), 'password123',
          reason: "Password should be saved in SharedPreferences");
    });
  });
}
