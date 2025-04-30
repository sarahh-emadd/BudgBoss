// lib/data/models/expense.dart
import '../../logging/budget_boss_logger.dart';

class Expense {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final String category;
  final String? note;
  
  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    this.note,
  });
  
  // Convert to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category,
      'note': note,
    };
  }
  
  // Create from Map from database
  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      title: map['title'],
      amount: map['amount'],
      date: DateTime.parse(map['date']),
      category: map['category'],
      note: map['note'],
    );
  }
}

// Observer interface
abstract class ExpenseObserver {
  void onExpenseAdded(Expense expense);
  void onExpenseUpdated(Expense expense);
  void onExpenseDeleted(String expenseId);
}

// Subject (Observable)
class ExpenseManager {
  static final ExpenseManager _instance = ExpenseManager._internal();
  
  factory ExpenseManager() {
    return _instance;
  }
  
  ExpenseManager._internal();
  
  final List<ExpenseObserver> _observers = [];
  final List<Expense> _expenses = [];
  
  // Observer pattern methods
  void addObserver(ExpenseObserver observer) {
    _observers.add(observer);
    BudgetBossLogger.log('Observer added to ExpenseManager');
  }
  
  void removeObserver(ExpenseObserver observer) {
    _observers.remove(observer);
    BudgetBossLogger.log('Observer removed from ExpenseManager');
  }
  
  // Expense management methods
  Future<void> addExpense(Expense expense) async {
    _expenses.add(expense);
    
    // Notify all observers
    for (var observer in _observers) {
      observer.onExpenseAdded(expense);
    }
    
    BudgetBossLogger.log('Expense added: ${expense.title}');
  }
  
  Future<void> updateExpense(Expense updatedExpense) async {
    final index = _expenses.indexWhere((e) => e.id == updatedExpense.id);
    if (index != -1) {
      _expenses[index] = updatedExpense;
      
      // Notify all observers
      for (var observer in _observers) {
        observer.onExpenseUpdated(updatedExpense);
      }
      
      BudgetBossLogger.log('Expense updated: ${updatedExpense.title}');
    }
  }
  
  Future<void> deleteExpense(String expenseId) async {
    _expenses.removeWhere((e) => e.id == expenseId);
    
    // Notify all observers
    for (var observer in _observers) {
      observer.onExpenseDeleted(expenseId);
    }
    
    BudgetBossLogger.log('Expense deleted: $expenseId');
  }
  
  // Get all expenses
  List<Expense> getAllExpenses() {
    return List.unmodifiable(_expenses);
  }
  
  // Get expenses by category
  List<Expense> getExpensesByCategory(String category) {
    return _expenses.where((e) => e.category == category).toList();
  }
  
  // Get expenses by date range
  List<Expense> getExpensesByDateRange(DateTime start, DateTime end) {
    return _expenses.where((e) => e.date.isAfter(start) && e.date.isBefore(end)).toList();
  }
}