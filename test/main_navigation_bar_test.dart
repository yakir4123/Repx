import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:repx/main_navigation_bar.dart';
import 'package:repx/home_page.dart';
import 'package:repx/path_page.dart';
import 'package:repx/workout_page.dart';
import 'package:repx/rewards_page.dart';
import 'package:repx/profile_page.dart';

void main() {
  // Helper function to build the MainNavigationBar within a MaterialApp
  Widget makeTestableWidget() {
    return const MaterialApp(
      home: MainNavigationBar(),
    );
  }

  testWidgets('MainNavigationBar displays and has all items', (WidgetTester tester) async {
    await tester.pumpWidget(makeTestableWidget());

    // Verify the BottomNavigationBar is present
    expect(find.byType(BottomNavigationBar), findsOneWidget);

    // Verify all five items are present by their labels
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Path'), findsOneWidget);
    expect(find.text('Workout'), findsOneWidget);
    expect(find.text('Rewards'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);

    // Verify all five icons are present
    expect(find.byIcon(Icons.home), findsOneWidget);
    expect(find.byIcon(Icons.explore), findsOneWidget); // Path icon
    expect(find.byIcon(Icons.fitness_center), findsOneWidget); // Workout icon
    expect(find.byIcon(Icons.star), findsOneWidget); // Rewards icon
    expect(find.byIcon(Icons.person), findsOneWidget); // Profile icon
  });

  testWidgets('Tapping navigation items changes pages and selection', (WidgetTester tester) async {
    await tester.pumpWidget(makeTestableWidget());

    // Initial state: Home page should be visible
    expect(find.byType(HomePage), findsOneWidget);
    expect(find.byType(PathPage), findsNothing);

    // Tap on 'Path'
    await tester.tap(find.text('Path'));
    await tester.pumpAndSettle(); // pumpAndSettle to allow animations and state changes

    // Verify PathPage is visible and HomePage is not
    expect(find.byType(HomePage), findsNothing);
    expect(find.byType(PathPage), findsOneWidget);
    // Check if 'Path' tab is selected (highlighted)
    // We can check the currentIndex of the BottomNavigationBar
    BottomNavigationBar navBar = tester.widget(find.byType(BottomNavigationBar));
    expect(navBar.currentIndex, 1);

    // Tap on 'Workout'
    await tester.tap(find.text('Workout'));
    await tester.pumpAndSettle();
    expect(find.byType(PathPage), findsNothing);
    expect(find.byType(WorkoutPage), findsOneWidget);
    navBar = tester.widget(find.byType(BottomNavigationBar));
    expect(navBar.currentIndex, 2);

    // Tap on 'Rewards'
    await tester.tap(find.text('Rewards'));
    await tester.pumpAndSettle();
    expect(find.byType(WorkoutPage), findsNothing);
    expect(find.byType(RewardsPage), findsOneWidget);
    navBar = tester.widget(find.byType(BottomNavigationBar));
    expect(navBar.currentIndex, 3);

    // Tap on 'Profile'
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.byType(RewardsPage), findsNothing);
    expect(find.byType(ProfilePage), findsOneWidget);
    navBar = tester.widget(find.byType(BottomNavigationBar));
    expect(navBar.currentIndex, 4);

    // Tap back on 'Home'
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.byType(ProfilePage), findsNothing);
    expect(find.byType(HomePage), findsOneWidget);
    navBar = tester.widget(find.byType(BottomNavigationBar));
    expect(navBar.currentIndex, 0);
  });

  testWidgets('Selected tab is highlighted', (WidgetTester tester) async {
    await tester.pumpWidget(makeTestableWidget());

    // Helper to check highlighted state (based on currentIndex)
    BottomNavigationBar getNavBar() => tester.widget(find.byType(BottomNavigationBar));

    // Initially Home is selected
    expect(getNavBar().currentIndex, 0);

    // Tap Path
    await tester.tap(find.text('Path'));
    await tester.pumpAndSettle();
    expect(getNavBar().currentIndex, 1);

    // Tap Workout
    await tester.tap(find.text('Workout'));
    await tester.pumpAndSettle();
    expect(getNavBar().currentIndex, 2);
  });
}
