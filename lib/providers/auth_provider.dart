import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthState {
  final bool isLoggedIn;
  final String? userName;
  final String? userEmail;

  AuthState({this.isLoggedIn = false, this.userName, this.userEmail});
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    _loadState();
    return AuthState();
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final userName = prefs.getString('userName');
    final userEmail = prefs.getString('userEmail');
    state = AuthState(isLoggedIn: isLoggedIn, userName: userName, userEmail: userEmail);
  }

  Future<void> signInWithGoogle() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userName', 'Guest User');
    await prefs.setString('userEmail', 'guest@example.com');
    state = AuthState(isLoggedIn: true, userName: 'Guest User', userEmail: 'guest@example.com');
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('userName');
    await prefs.remove('userEmail');
    state = AuthState();
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});
