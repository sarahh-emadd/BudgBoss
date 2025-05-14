import 'expense_observer.dart';

class Expense {
  final String id;
  final String title;
  final double amount;
  final String category;
  final DateTime date;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    DateTime? date,
  }) : date = date ?? DateTime.now();
}

class ExpenseData with Observable<ExpenseObserver> {
  // Private singleton instance
  static final ExpenseData _instance = ExpenseData._internal();

  // Factory constructor to return the same instance
  factory ExpenseData() => _instance;

  // Private constructor
  ExpenseData._internal();

  // Private list of expenses
  final List<Expense> _expenses = [];

  // Add an expense and notify observers
  void addExpense(Expense expense) {
    _expenses.add(expense);
    _notifyObservers();
  }

  // Remove an expense and notify observers
  void removeExpense(Expense expense) {
    _expenses.remove(expense);
    _notifyObservers();
  }

  // Get an unmodifiable copy of the expenses list
  List<Expense> get expenses => List.unmodifiable(_expenses);

  // Calculate the total of all expenses
  double get total => _expenses.fold(0.0, (sum, item) => sum + item.amount);

  // Notify all observers about the change
  void _notifyObservers() {
    for (var observer in observers) {
      observer.onExpenseListChanged();
    }
  }

  void clearExpenses() {
    _expenses.clear();
    notifyListeners(); // optional if you're using a UI that listens
  }

  // Get expenses by category
  Map<String, double> getCategoryTotals() {
    Map<String, double> categoryTotals = {};
    for (var expense in _expenses) {
      categoryTotals[expense.category] =
          (categoryTotals[expense.category] ?? 0) + expense.amount;
    }
    return categoryTotals;
  }

  void notifyListeners() {}
}
