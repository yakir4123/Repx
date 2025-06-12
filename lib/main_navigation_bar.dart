import 'package:flutter/material.dart';
import 'home_page.dart';
import 'path_page.dart';
import 'workout_page.dart';
import 'rewards_page.dart';
import 'profile_page.dart';

class MainNavigationBar extends StatefulWidget {
  const MainNavigationBar({super.key});

  @override
  State<MainNavigationBar> createState() => _MainNavigationBarState();
}

class _MainNavigationBarState extends State<MainNavigationBar> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    PathPage(),
    WorkoutPage(),
    RewardsPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore), // Placeholder icon for Path
            label: 'Path',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center), // Placeholder icon for Workout
            label: 'Workout',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star), // Placeholder icon for Rewards
            label: 'Rewards',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        // selectedItemColor, unselectedItemColor, type, backgroundColor
        // should be inherited from ThemeData's bottomNavigationBarTheme
      ),
    );
  }
}
