import 'package:flutter_test/flutter_test.dart';
import 'package:budget_boss_new/data/expense_data.dart';

void main() {
  group('ExpenseData', () {
    final data = ExpenseData();

    setUp(() {
      data.clearExpenses(); // 🚨 clear before each test
    });
    setUp(() {
      data.clearExpenses();
    });

    test('initial state is empty', () {
      expect(data.expenses, isEmpty);
      expect(data.total, 0);
    });
    setUp(() {
      data.clearExpenses();
    });

    test('addExpense increases total', () {
      final expense = Expense(
        id: 'x',
        title: 'Test',
        amount: 20,
        category: 'Food',
      );

      data.addExpense(expense);
      expect(data.expenses.length, 1);
      expect(data.total, 20);
    });
    setUp(() {
      data.clearExpenses();
    });

    test('removeExpense decreases list and total', () {
      final expense = Expense(
        id: 'x',
        title: 'Test',
        amount: 20,
        category: 'Food',
      );

      data.addExpense(expense);
      data.removeExpense(expense);

      expect(data.expenses.length, 0);
      expect(data.total, 0);
    });
  });
}
