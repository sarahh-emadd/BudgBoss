import 'package:budget_boss_new/data/services/firebase_expense_service.dart';
import 'package:flutter/material.dart';
import 'package:budget_boss_new/data/expense_data.dart';
import 'package:budget_boss_new/presentation/widgets/bottom_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddExpenseScreen extends StatefulWidget {
  final String userName;

  const AddExpenseScreen({super.key, required this.userName});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _amount = '';
  String _category = 'Food';
  String? _userName;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    setState(() {
      _userName = user?.displayName ?? 'User';
    });
  }

  // Removed unused _expenseData field

  final List<String> _categories = [
    'Food',
    'Transport',
    'Entertainment',
    'Bills',
    'Other',
  ];

  // Map categories to their icons
  final Map<String, IconData> _categoryIcons = {
    'Food': Icons.restaurant,
    'Transport': Icons.directions_car,
    'Entertainment': Icons.movie,
    'Bills': Icons.receipt,
    'Other': Icons.category,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.grey[100], // Changed from Colors.white.withValues()
      appBar: AppBar(
        title: const Text('Add Expense'),
        centerTitle: true,
        backgroundColor: const Color(0xFF3737CD),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User greeting
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Text(
                  'Hello, ${_userName ?? "User"}!',

                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Form card
              Card(
                color: const Color.fromARGB(255, 197, 211, 234),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Title input
                        Text(
                          'Expense Details',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3737CD),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Title',
                            hintText: 'What did you spend on?',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: const Icon(Icons.title),
                            filled: true,
                            fillColor: const Color.fromARGB(255, 254, 254, 254),
                          ),
                          validator:
                              (value) =>
                                  value == null || value.isEmpty
                                      ? 'Enter title'
                                      : null,
                          onSaved: (value) => _title = value!,
                        ),
                        const SizedBox(height: 16),

                        // Amount input
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Amount',
                            hintText: '0.00',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: const Icon(Icons.attach_money),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          keyboardType: TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter amount';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Enter a valid number';
                            }
                            return null;
                          },
                          onSaved: (value) => _amount = value!,
                        ),
                        const SizedBox(height: 24),

                        // Category selector
                        Text(
                          'Category',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Category chips
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children:
                              _categories.map((category) {
                                final isSelected = _category == category;
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _category = category;
                                    });
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          isSelected
                                              ? Color(0xFF3737CD)
                                              : Colors.grey[200],
                                      borderRadius: BorderRadius.circular(30),
                                      boxShadow:
                                          isSelected
                                              ? [
                                                BoxShadow(
                                                  color: const Color(
                                                    0xFF3737CD,
                                                  ).withAlpha(
                                                    102,
                                                  ), // Using withAlpha(102) instead of withOpacity(0.4)
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ]
                                              : null,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          _categoryIcons[category],
                                          color:
                                              isSelected
                                                  ? Colors.white
                                                  : Colors.grey[700],
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          category,
                                          style: TextStyle(
                                            color:
                                                isSelected
                                                    ? Colors.white
                                                    : Colors.grey[700],
                                            fontWeight:
                                                isSelected
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                        ),

                        const SizedBox(height: 30),

                        // Save button
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              final expense = Expense(
                                title: _title,
                                amount: double.parse(_amount),
                                category: _category,
                                id: '',
                              );

                              // Save locally

                              // 🔥 Save to Firebase
                              try {
                                await FirebaseExpenseService().addExpense(
                                  amount: expense.amount,
                                  category: expense.category,
                                  description: expense.title,
                                  date: DateTime.now(),
                                );

                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Saved \$${expense.amount.toStringAsFixed(2)} under ${expense.category}!',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    backgroundColor: Colors.green,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );

                                Navigator.pushReplacementNamed(
                                  // ignore: use_build_context_synchronously
                                  context,
                                  '/home',
                                );
                              } catch (e) {
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Failed to save to Firestore: $e",
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },

                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3737CD),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 2,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.save),
                              SizedBox(width: 10),
                              Text(
                                'Save Expense',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 15),

                        // Cancel button
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // Add the bottom navigation bar
      bottomNavigationBar: const BudgetBossNavBar(currentIndex: 1),
    );
  }
}
