import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'dart:io' show Platform; // For platform-specific checks if needed, though not strictly for Apple Sign In button visibility here.
import 'dart:convert'; // For base64UrlEncode
import 'dart:math'; // For Random
import 'package:crypto/crypto.dart'; // For sha256

class AuthOptionsScreen extends StatelessWidget {
  const AuthOptionsScreen({super.key});

  Future<void> _showErrorDialog(BuildContext context, String title, String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button!
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Retry'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss the dialog
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // The user canceled the sign-in
        print('Google sign-in canceled by user.');
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        print('Successfully signed in with Google:');
        print('User ID: ${user.uid}');
        print('Display Name: ${user.displayName}');
        print('Email: ${user.email}');
        // TODO: Navigate to the next screen
      }
    } catch (e) {
      print('Error during Google sign-in: $e');
      // It's good practice to check if the widget is still mounted before showing a dialog
      if (context.mounted) {
        _showErrorDialog(context, 'Google Sign-In Error', e.toString());
      }
    }
  }

  // Helper function to generate a random nonce for Apple Sign In
  String _generateNonce([int length = 32]) {
    final random = Random.secure();
    final values = List<int>.generate(length, (i) => random.nextInt(256));
    return base64Url.encode(values).substring(0, length);
  }


  Future<void> signInWithApple(BuildContext context) async {
    try {
      final rawNonce = _generateNonce();
      final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: hashedNonce, // For web, use the hashed nonce
      );

      final oAuthProvider = OAuthProvider("apple.com");
      final credential = oAuthProvider.credential(
        idToken: appleCredential.identityToken, // This is the JWT token
        rawNonce: rawNonce, // The original raw nonce
        // accessToken is not directly available/needed here for Firebase with idToken
      );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        print('Successfully signed in with Apple:');
        print('User ID: ${user.uid}');
        print('Display Name: ${user.displayName ?? "N/A (Apple Sign In)"}');
        print('Email: ${user.email ?? "N/A (Apple Sign In)"}');
        // Note: Apple may not always provide email/name if user chooses to hide it or if it's not the first sign-in.
        // TODO: Navigate to the next screen
      }
    } catch (e) {
      print('Error during Apple sign-in: $e');
      if (context.mounted) {
        _showErrorDialog(context, 'Apple Sign-In Error', e.toString());
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Continue Your Journey'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Choose how you want to sign in',
              style: TextStyle(fontSize: 18.0),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () => signInWithGoogle(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/icons/google_logo.png',
                    height: 24.0,
                    width: 24.0,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error);
                    },
                  ),
                  const SizedBox(width: 10),
                  const Text('Sign in with Google'),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => signInWithApple(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/icons/apple_logo.png',
                    height: 24.0,
                    width: 24.0,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error);
                    },
                  ),
                  const SizedBox(width: 10),
                  const Text('Sign in with Apple'),
                ],
              ),
            ),
            const SizedBox(height: 24.0),
            const Row(
              children: <Widget>[
                Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('or'),
                ),
                Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 24.0),
            TextButton(
              onPressed: () {
                // TODO: Navigate to Log In screen (or Email sign-in/sign-up)
              },
              child: const Text('Already have an account? Log In'),
            ),
          ],
        ),
      ),
    );
  }
}
