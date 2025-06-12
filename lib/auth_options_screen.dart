import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'dart:io' show Platform;
import 'dart:convert'; // For base64UrlEncode
import 'dart:math'; // For Random
import 'package:crypto/crypto.dart'; // For sha256
import 'dashboard_screen.dart';

class AuthOptionsScreen extends StatelessWidget {
  const AuthOptionsScreen({super.key});

  Future<void> _showErrorDialog(BuildContext context, String title, String message) async {
    // Ensure the context is still valid before showing a dialog
    if (!context.mounted) return;
    showDialog<void>(
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
        print('Successfully signed in with Google: User ID: ${user.uid}, Name: ${user.displayName}, Email: ${user.email}');
        if (context.mounted) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DashboardScreen()));
        }
      }
    } catch (e) {
      print('Error during Google sign-in: $e');
      _showErrorDialog(context, 'Google Sign-In Error', e.toString());
    }
  }

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
        scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
        nonce: hashedNonce,
      );

      final oAuthProvider = OAuthProvider("apple.com");
      final credential = oAuthProvider.credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        print('Successfully signed in with Apple: User ID: ${user.uid}, Name: ${user.displayName}, Email: ${user.email}');
        if (context.mounted) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DashboardScreen()));
        }
      }
    } catch (e) {
      print('Error during Apple sign-in: $e');
      _showErrorDialog(context, 'Apple Sign-In Error', e.toString());
    }
  }

  Future<void> signInWithFacebook(BuildContext context) async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;
        final AuthCredential credential = FacebookAuthProvider.credential(accessToken.token);

        final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
        final User? user = userCredential.user;

        if (user != null) {
          print('Successfully signed in with Facebook: User ID: ${user.uid}, Name: ${user.displayName}, Email: ${user.email}');
          if (context.mounted) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DashboardScreen()));
          }
        }
      } else if (result.status == LoginStatus.cancelled) {
        print('Facebook sign-in canceled by user.');
      } else {
        print('Facebook sign-in failed: ${result.message}');
        _showErrorDialog(context, 'Facebook Sign-In Error', result.message ?? 'An unknown error occurred.');
      }
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Error during Facebook sign-in: $e');
      _showErrorDialog(context, 'Facebook Sign-In Error', e.message ?? e.toString());
    }
    catch (e) {
      print('Error during Facebook sign-in: $e');
      _showErrorDialog(context, 'Facebook Sign-In Error', e.toString());
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
                  Image.asset('assets/icons/google_logo.png', height: 24.0, width: 24.0,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.error)),
                  const SizedBox(width: 10),
                  const Text('Sign in with Google'),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            if (Platform.isIOS) ...[
              ElevatedButton(
                onPressed: () => signInWithApple(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/icons/apple_logo.png', height: 24.0, width: 24.0,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.error)),
                    const SizedBox(width: 10),
                    const Text('Sign in with Apple'),
                  ],
                ),
              ),
              const SizedBox(height: 16.0), // Space after Apple button if it's shown
            ],
            ElevatedButton(
              onPressed: () => signInWithFacebook(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/icons/facebook_logo.png', height: 24.0, width: 24.0,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.error)),
                  const SizedBox(width: 10),
                  const Text('Sign in with Facebook'),
                ],
              ),
            ),
            const SizedBox(height: 24.0), // Space before the "or" divider
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
                // TODO: Navigate to Log In screen
              },
              child: const Text('Already have an account? Log In'),
            ),
          ],
        ),
      ),
    );
  }
}
