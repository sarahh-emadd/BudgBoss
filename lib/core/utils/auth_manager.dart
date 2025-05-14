// lib/core/utils/auth_manager.dart
import '../../logging/budget_boss_logger.dart';

class AuthenticationManager {
  // Singleton instance
  static final AuthenticationManager _instance =
      AuthenticationManager._internal();

  // Private constructor
  AuthenticationManager._internal() {
    _logger.log('AuthenticationManager initialized');
  }

  // Factory constructor to return the singleton instance
  factory AuthenticationManager() {
    return _instance;
  }

  // Logger instance
  final BudgetBossLogger _logger = BudgetBossLogger();

  // Current user data
  String? _userId;
  bool _isAuthenticated = false;

  // Getters
  String? get userId => _userId;
  bool get isAuthenticated => _isAuthenticated;

  // Mock login method (to be replaced with actual Firebase Auth)
  Future<bool> login(String email, String password) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      // Dummy validation
      if (email.isNotEmpty && password.isNotEmpty) {
        _userId = 'user-123';
        _isAuthenticated = true;
        _logger.log('User logged in successfully');
        return true;
      }
      return false;
    } catch (e) {
      _logger.error('Login error', e);
      return false;
    }
  }

  // Mock registration method
  Future<bool> register(String email, String password) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      // Dummy validation
      if (email.isNotEmpty && password.length >= 6) {
        _userId = 'user-123';
        _isAuthenticated = true;
        _logger.log('User registered successfully');
        return true;
      }
      return false;
    } catch (e) {
      _logger.error('Registration error', e);
      return false;
    }
  }

  // Logout method
  Future<void> logout() async {
    _userId = null;
    _isAuthenticated = false;
    _logger.log('User logged out');
  }
}
