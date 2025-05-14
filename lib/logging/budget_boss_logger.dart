// budget_boss_logger.dart
import 'package:flutter/foundation.dart';

/// A singleton logger class for the Budget Boss application.
/// This class provides methods to log messages, errors, and warnings.
class BudgetBossLogger {
  static final BudgetBossLogger _instance = BudgetBossLogger._internal();

  factory BudgetBossLogger() => _instance;

  BudgetBossLogger._internal();

  void log(String message) {
    if (kDebugMode) {
      print('BudgetBoss Log: $message');
    }
  }

  void error(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      print('BudgetBoss Error: $message');
      if (error != null) print(error);
      if (stackTrace != null) print(stackTrace);
    }
  }

  void info(String message) {
    if (kDebugMode) {
      print('BudgetBoss Info: $message');
    }
  }

  void warning(String message) {
    if (kDebugMode) {
      print('BudgetBoss Warning: $message');
    }
  }
}
