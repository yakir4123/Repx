// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fitness_app/main.dart'; // Assuming your main.dart is in lib and app name is fitness_app
// If main.dart is directly in lib, it might be: import 'package:fitness_app/main.dart';
// The import path depends on your project name defined in pubspec.yaml

void main() {
  testWidgets('MainScreen UI elements test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp()); // MyApp is the root widget

    // Verify Title is present
    expect(find.text("Level Up Your Calisthenics Journey"), findsOneWidget);

    // Verify Description is present
    expect(find.text("Embark on a gamified calisthenics adventure where your progress fuels your character’s growth and unlocks exciting stories."), findsOneWidget);

    // Verify "Get Started" button text is present
    expect(find.widgetWithText(ElevatedButton, "Get Started"), findsOneWidget);

    // Verify "Log In" link text is present
    expect(find.widgetWithText(TextButton, "Already have an account? Log In"), findsOneWidget);

    // Verify that an image or its fallback icon is present
    // We check for the presence of the Image widget itself, or the fallback icon.
    // This is a bit tricky because Image.asset might load asynchronously or fail if the asset isn't truly there in test.
    // The errorBuilder provides a fallback Icon, so we can check for that type as well.
    final imageFinder = find.byType(Image);
    final iconFinder = find.byIcon(Icons.person_outline);

    // Pump a bit to allow image loading or errorBuilder to kick in
    await tester.pumpAndSettle();

    final imageWidgets = tester.widgetList(imageFinder);
    bool foundImage = false;
    for (final widget in imageWidgets) {
      if (widget is Image && widget.image is AssetImage) {
        if ((widget.image as AssetImage).assetName == 'assets/images/character.png') {
          foundImage = true;
          break;
        }
      }
    }
    // If the actual image isn't found (e.g., error in test setup or asset not loading)
    // check if the fallback icon from errorBuilder is present.
    if (!foundImage) {
        expect(iconFinder, findsOneWidget, reason: "Expected to find character image or its fallback icon");
    } else {
        expect(foundImage, isTrue, reason: "Expected to find character image asset");
    }

  });

  testWidgets('Navigation test: Get Started button to SignUpScreen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Find the "Get Started" button.
    final getStartedButton = find.widgetWithText(ElevatedButton, "Get Started");
    expect(getStartedButton, findsOneWidget);

    // Tap the "Get Started" button.
    await tester.tap(getStartedButton);
    await tester.pumpAndSettle(); // Wait for navigation to complete

    // Verify that SignUpScreen is pushed (by checking for its title or unique content)
    expect(find.text('Sign Up'), findsOneWidget); // AppBar title of SignUpScreen
    expect(find.text('Sign-Up Screen'), findsOneWidget); // Body text of SignUpScreen
  });

  testWidgets('Navigation test: Log In link to LoginScreen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Find the "Log In" link.
    final loginLink = find.widgetWithText(TextButton, "Already have an account? Log In");
    expect(loginLink, findsOneWidget);

    // Tap the "Log In" link.
    await tester.tap(loginLink);
    await tester.pumpAndSettle(); // Wait for navigation to complete

    // Verify that LoginScreen is pushed (by checking for its title or unique content)
    expect(find.text('Log In'), findsOneWidget); // AppBar title of LoginScreen
    expect(find.text('Login Screen'), findsOneWidget); // Body text of LoginScreen
  });
}
