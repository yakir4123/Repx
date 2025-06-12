import 'package:flutter/material.dart';
import 'dart:math'; // For min function

import 'signup_screen.dart';
import 'login_screen.dart';
import 'auth_options_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness App',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1A1A1A),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A1A1A),
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        textTheme: const TextTheme(
          headlineSmall: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          bodyLarge: TextStyle(color: Color(0xFFEDEDED), height: 1.5),
          labelLarge: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    double textScaleFactor = screenWidth < 600 ? 0.9 : 1.1;
    textScaleFactor = min(textScaleFactor, 1.2);

    final topSectionHeight = screenHeight / 2;

    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              color: const Color(0xFFFCD2A4),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Image.asset(
                      'assets/images/character.png',
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.person_outline,
                          size: min(topSectionHeight * 0.5, screenWidth * 0.4),
                          color: const Color(0xFF1A1A1A),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              color: const Color(0xFF1A1A1A),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const SizedBox(height: 20),
                      Text(
                        "Level Up Your Calisthenics Journey",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontSize: (screenWidth < 360 ? 22.0 : 28.0) * textScaleFactor,
                            ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Embark on a gamified calisthenics adventure where your progress fuels your character’s growth and unlocks exciting stories.",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontSize: (screenWidth < 360 ? 14.0 : 16.0) * textScaleFactor,
                            ),
                      ),
                      const SizedBox(height: 32),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFC928),
                            padding: const EdgeInsets.symmetric(vertical: 16), // Ensures height
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            minimumSize: const Size(double.infinity, 50), // Ensures min height of 50
                            overlayColor: Colors.black.withOpacity(0.1),
                          ).copyWith(
                             elevation: MaterialStateProperty.all(8.0),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const AuthOptionsScreen()),
                            );
                          },
                          child: Text(
                            "Get Started",
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  fontSize: (screenWidth < 360 ? 16.0 : 18.0) * textScaleFactor,
                                ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Ensure TextButton has a sufficient tap target size
                      // One way is to set minimumSize in styleFrom, or add padding.
                      // TextButton by default has some internal padding which contributes to its tap target.
                      // Let's make it more explicit with padding for clarity and guarantee.
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Add padding
                          minimumSize: const Size(0, 44), // Ensure minimum height of 44
                          overlayColor: Colors.white.withOpacity(0.1),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AuthOptionsScreen()),
                          );
                        },
                        child: Text(
                          "Already have an account? Log In",
                          style: TextStyle(
                            color: const Color(0xFFD0B977),
                            fontSize: (screenWidth < 360 ? 12.0 : 14.0) * textScaleFactor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
