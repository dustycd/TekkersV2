import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tekkers/screens/login_form_screen.dart';
import 'package:tekkers/screens/account_settings_screen.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({}); // Mock shared preferences
  });

  testWidgets('Displays email and password input fields',
      (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(MaterialApp(home: LoginPage()));

    // Assert
    expect(find.byType(TextField).at(0),
        findsOneWidget); // First TextField is email
    expect(find.byType(TextField).at(1),
        findsOneWidget); // Second TextField is password
  });

  testWidgets('Valid login credentials navigate to AccountSettingsScreen',
      (WidgetTester tester) async {
    // Arrange
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', 'test@example.com');
    await prefs.setString('password', 'password123');

    await tester.pumpWidget(MaterialApp(home: LoginPage()));

    // Act
    await tester.enterText(
        find.byType(TextField).at(0), 'test@example.com'); // Email
    await tester.enterText(
        find.byType(TextField).at(1), 'password123'); // Password
    await tester.tap(find.text('Sign In')); // Tap the sign-in button
    await tester.pumpAndSettle();

    // Assert
    expect(
        find.byType(AccountSettingsScreen), findsOneWidget); // Check navigation
  });

  testWidgets('Invalid login credentials show error dialog',
      (WidgetTester tester) async {
    // Arrange
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', 'test@example.com');
    await prefs.setString('password', 'password123');

    await tester.pumpWidget(MaterialApp(home: LoginPage()));

    // Act
    await tester.enterText(
        find.byType(TextField).at(0), 'wrong@example.com'); // Invalid Email
    await tester.enterText(
        find.byType(TextField).at(1), 'wrongpassword'); // Invalid Password
    await tester.tap(find.text('Sign In')); // Tap the sign-in button
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Error'), findsOneWidget); // Check for error dialog title
    expect(find.text('Invalid email or password'),
        findsOneWidget); // Error message
  });
}
