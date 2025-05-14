import 'package:flutter/material.dart';
import 'package:budget_boss_new/data/services/firebase_expense_service.dart';
import 'package:budget_boss_new/data/expense_data.dart';
import 'package:budget_boss_new/data/expense_observer.dart';
import 'package:budget_boss_new/presentation/widgets/bottom_navigation_bar.dart';

class ExpensesListScreen extends StatefulWidget {
  const ExpensesListScreen({super.key});

  @override
  State<ExpensesListScreen> createState() => _ExpensesListScreenState();
}

class _ExpensesListScreenState extends State<ExpensesListScreen>
    implements ExpenseObserver {
  final ExpenseData _expenseData = ExpenseData();

  @override
  void initState() {
    super.initState();
    _expenseData.addObserver(this);
    _loadExpensesFromFirebase();
  }

  Future<void> _loadExpensesFromFirebase() async {
    try {
      _expenseData.clearExpenses();
      final expenses = await FirebaseExpenseService().getExpenses();
      for (var expense in expenses) {
        _expenseData.addExpense(expense);
      }
    } catch (e) {
      debugPrint("Failed to load expenses: $e");
    }
  }

  @override
  void dispose() {
    _expenseData.removeObserver(this);
    super.dispose();
  }

  @override
  void onExpenseListChanged() {
    setState(() {});
  }

  void _editExpenseDialog(BuildContext context, Expense expense) {
    final titleController = TextEditingController(text: expense.title);
    final amountController = TextEditingController(
      text: expense.amount.toString(),
    );

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Edit Expense'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: amountController,
                  decoration: const InputDecoration(labelText: 'Amount'),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final newTitle = titleController.text;
                  final newAmount =
                      double.tryParse(amountController.text) ?? expense.amount;

                  await FirebaseExpenseService().updateExpense(
                    id: expense.id,
                    title: newTitle,
                    amount: newAmount,
                    category: expense.category,
                  );

                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                  _loadExpensesFromFirebase();
                },
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Icons.restaurant;
      case 'transport':
        return Icons.directions_car;
      case 'entertainment':
        return Icons.movie;
      case 'bills':
        return Icons.receipt_long;
      default:
        return Icons.category;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Colors.blue[700]!;
      case 'transport':
        return Colors.blue[600]!;
      case 'entertainment':
        return Colors.blue[500]!;
      case 'bills':
        return Colors.blue[800]!;
      default:
        return Colors.blue;
    }
  }

  Color _getTotalColor(double total) {
    if (total < 11000) return Colors.green;
    if (total < 15000) return Colors.blue[600]!;
    return Colors.blue[900]!;
  }

  String _getMotivationalMessage(double total) {
    if (total == 0) return "Start tracking your expenses today!";
    if (total < 50) return "Great job keeping expenses low!";
    if (total < 100) return "You're doing well with your budget!";
    if (total < 200) return "Keep an eye on your spending!";
    return "Time to review your budget!";
  }

  @override
  Widget build(BuildContext context) {
    final expenses = _expenseData.expenses;
    final total = _expenseData.total;
    final motivationalMessage = _getMotivationalMessage(total);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Your Expenses',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black45,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Color(0xFF3737CD), Color(0xFF3737CD)],
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Icon(
                      Icons.account_balance_wallet,
                      size: 45,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.add_circle_outline, color: Colors.white),
                tooltip: 'Add New Expense',
                onPressed: () {
                  Navigator.pushNamed(context, '/add_expense');
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF3737CD),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.lightbulb_outline,
                          color: Color(0xFF3737CD),
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            motivationalMessage,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF3737CD),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF3737CD), Color(0xFF3737CD)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total Expenses',
                          style: TextStyle(fontSize: 16, color: Colors.white70),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '\$${total.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: _getTotalColor(total),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                total < 100
                                    ? 'Good'
                                    : (total < 200 ? 'Moderate' : 'High'),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recent Expenses',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        Text(
                          '${expenses.length} items',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          expenses.isEmpty
              ? SliverToBoxAdapter(
                child: SizedBox(
                  height: 300,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No expenses yet',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap the + button to add your first expense',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              : SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final expense = expenses[index];
                  final isLastItem = index == expenses.length - 1;
                  return Padding(
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: isLastItem ? 80 : 8,
                    ),
                    child: Dismissible(
                      key: Key(expense.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        color: Colors.red,
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) async {
                        await FirebaseExpenseService().deleteExpense(
                          expense.id,
                        );
                        _expenseData.removeExpense(expense);
                      },
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          leading: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color:
                                  _getCategoryColor(
                                    expense.category,
                                  ).withValues(),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              _getCategoryIcon(expense.category),
                              color: _getCategoryColor(expense.category),
                            ),
                          ),
                          title: Text(
                            expense.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            expense.category,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '\$${expense.amount.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: _getCategoryColor(expense.category),
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Today',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          onTap: () => _editExpenseDialog(context, expense),
                        ),
                      ),
                    ),
                  );
                }, childCount: expenses.length),
              ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add_expense');
        },
        backgroundColor: const Color(0xFF3737CD),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: const BudgetBossNavBar(currentIndex: 0),
    );
  }
}
