// lib/logging/budget_boss_logger.dart
import 'package:flutter/foundation.dart';

class BudgetBossLogger {
  static final BudgetBossLogger _instance = BudgetBossLogger._internal();
  
  factory BudgetBossLogger() {
    return _instance;
  }
  
  BudgetBossLogger._internal();
  
  static void log(String message) {
    if (kDebugMode) {
      print('BudgetBoss Log: $message');
    }
  }
  
  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      print('BudgetBoss Error: $message');
      if (error != null) {
        print(error);
      }
      if (stackTrace != null) {
        print(stackTrace);
      }
    }
  }
  
  static void info(String message) {
    if (kDebugMode) {
      print('BudgetBoss Info: $message');
    }
  }
  
  static void warning(String message) {
    if (kDebugMode) {
      print('BudgetBoss Warning: $message');
    }
  }
}