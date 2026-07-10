import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../core/api/api_client.dart';

class AuthState {
  final bool isLoggedIn;
  final String? userName;
  final String? userEmail;

  AuthState({this.isLoggedIn = false, this.userName, this.userEmail});
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    _initAuthListener();
    return AuthState();
  }

  void _initAuthListener() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        state = AuthState(
          isLoggedIn: true,
          userName: user.displayName ?? 'User',
          userEmail: user.email ?? '',
        );
      } else {
        state = AuthState(isLoggedIn: false);
      }
    });
  }

  Future<void> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        // On web: use Firebase's native popup (no OAuth client ID needed)
        final GoogleAuthProvider googleProvider = GoogleAuthProvider();
        googleProvider.addScope('email');
        googleProvider.addScope('profile');
        await FirebaseAuth.instance.signInWithPopup(googleProvider);
      } else {
        // On Android/iOS: use google_sign_in package
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        if (googleUser == null) return; // User canceled

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await FirebaseAuth.instance.signInWithCredential(credential);
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      // Register the user as a customer in MongoDB
      try {
        await ApiClient.post('/auth/login', {'role': 'customer'}).timeout(const Duration(seconds: 5));
      } catch (e) {
        print('Warning: Failed to register user in MongoDB backend: $e');
      }
    } catch (e) {
      print('Error during Google Sign-In: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    state = AuthState();
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});
