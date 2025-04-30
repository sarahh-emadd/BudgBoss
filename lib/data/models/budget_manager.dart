// lib/data/models/budget.dart
// Base Budget class
abstract class Budget {
  final String id;
  final String name;
  final double amount;
  final String category;
  final DateTime startDate;
  final DateTime endDate;
  
  Budget({
    required this.id,
    required this.name,
    required this.amount,
    required this.category,
    required this.startDate,
    required this.endDate,
  });
  
  // Method to check if budget is exceeded
  bool isExceeded(double spentAmount) {
    return spentAmount > amount;
  }
  
  // Method to calculate remaining budget
  double getRemainingAmount(double spentAmount) {
    return amount - spentAmount;
  }
  
  // Method to calculate budget progress percentage
  double getProgressPercentage(double spentAmount) {
    return (spentAmount / amount).clamp(0.0, 1.0);
  }
}

// Monthly Budget implementation
class MonthlyBudget extends Budget {
  MonthlyBudget({
    required super.id,
    required super.name,
    required super.amount,
    required super.category,
  }) : super(
    startDate: DateTime(DateTime.now().year, DateTime.now().month, 1),
    endDate: DateTime(
      DateTime.now().year,
      DateTime.now().month + 1,
      0,
    ), // Last day of current month
  );
}

// Weekly Budget implementation
class WeeklyBudget extends Budget {
  WeeklyBudget({
    required super.id,
    required super.name,
    required super.amount,
    required super.category,
  }) : super(
    startDate: DateTime.now().subtract(
      Duration(days: DateTime.now().weekday - 1),
    ), // First day of current week (Monday)
    endDate: DateTime.now().add(
      Duration(days: 7 - DateTime.now().weekday),
    ), // Last day of current week (Sunday)
  );
}

// Custom Budget implementation
class CustomBudget extends Budget {
  CustomBudget({
    required super.id,
    required super.name,
    required super.amount,
    required super.category,
    required super.startDate,
    required super.endDate,
  });
}

// Budget Factory
class BudgetFactory {
  static Budget createBudget({
    required String type,
    required String id,
    required String name,
    required double amount,
    required String category,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    switch (type.toLowerCase()) {
      case 'monthly':
        return MonthlyBudget(
          id: id,
          name: name,
          amount: amount,
          category: category,
        );
      case 'weekly':
        return WeeklyBudget(
          id: id,
          name: name,
          amount: amount,
          category: category,
        );
      case 'custom':
        if (startDate == null || endDate == null) {
          throw ArgumentError('Start date and end date must be provided for custom budget');
        }
        return CustomBudget(
          id: id,
          name: name,
          amount: amount,
          category: category,
          startDate: startDate,
          endDate: endDate,
        );
      default:
        throw ArgumentError('Invalid budget type: $type');
    }
  }
}