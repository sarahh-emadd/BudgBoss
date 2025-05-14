import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../data/services/firebase_auth_service.dart';

// Provider Pattern
class AuthProvider with ChangeNotifier {
  final FirebaseAuthService _authService = FirebaseAuthService();

  User? _user;

  User? get user => _user;

  // Listen to auth changes
  void listenToAuthChanges() {
    _authService.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  // Sign Up or Login
  Future<void> signUp({required String email, required String password}) async {
    try {
      await _authService.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Reset Password
  Future<void> resetPassword(String email) async {
    try {
      await _authService.sendPasswordResetEmail(email: email);
    } catch (e) {
      rethrow;
    }
  }
}
