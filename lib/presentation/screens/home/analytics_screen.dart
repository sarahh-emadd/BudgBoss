import 'package:flutter/material.dart';
import 'package:budget_boss_new/data/expense_data.dart';
import 'package:budget_boss_new/data/expense_observer.dart';
import 'package:budget_boss_new/presentation/widgets/bottom_navigation_bar.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen>
    implements ExpenseObserver {
  // Reference to the singleton ExpenseData
  final ExpenseData _expenseData = ExpenseData();

  @override
  void initState() {
    super.initState();
    // Register as an observer
    _expenseData.addObserver(this);
  }

  @override
  void dispose() {
    // Unregister when the widget is disposed
    _expenseData.removeObserver(this);
    super.dispose();
  }

  @override
  void onExpenseListChanged() {
    // When expenses change, update the UI
    setState(() {});
  }

  // Get color for each category
  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return const Color.fromARGB(255, 221, 12, 12);
      case 'transport':
        return const Color.fromARGB(255, 125, 127, 97);
      case 'entertainment':
        return const Color.fromARGB(255, 109, 66, 88);
      case 'bills':
        return const Color.fromARGB(255, 225, 171, 91);
      default:
        return Colors.blue;
    }
  }

  // Get icon for each category
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

  @override
  Widget build(BuildContext context) {
    final expenses = _expenseData.expenses;
    final total = _expenseData.total;

    // Get category totals
    final categoryTotals = _expenseData.getCategoryTotals();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Budget Analytics'),
        centerTitle: true,
        backgroundColor: const Color(0xFF3737CD),
        foregroundColor: Colors.white,
      ),
      body:
          expenses.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.bar_chart, size: 80, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'No expense data available',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Add some expenses to view analytics',
                      style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    ),
                  ],
                ),
              )
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Total spending card
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Total Spending',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF3737CD),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '\$${total.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Based on all expenses',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                    // Pie Chart for category breakdown
                    if (categoryTotals.isNotEmpty)
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Category Breakdown',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF3737CD),
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                height: 300,
                                child: PieChart(
                                  PieChartData(
                                    sectionsSpace: 2,
                                    centerSpaceRadius: 40,
                                    sections:
                                        categoryTotals.entries.map((entry) {
                                          return PieChartSectionData(
                                            color: _getCategoryColor(entry.key),
                                            value: entry.value,
                                            title:
                                                '${(entry.value / total * 100).toStringAsFixed(0)}%',
                                            radius: 100,
                                            titleStyle: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          );
                                        }).toList(),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Legend
                              Wrap(
                                spacing: 16,
                                runSpacing: 8,
                                children:
                                    categoryTotals.entries.map((entry) {
                                      return Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 14,
                                            height: 14,
                                            decoration: BoxDecoration(
                                              color: _getCategoryColor(
                                                entry.key,
                                              ),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            entry.key,
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      );
                                    }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ),

                    const SizedBox(height: 24),
                    const Text(
                      'Spending by Category',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Category breakdown
                    ...categoryTotals.entries.map((entry) {
                      final percentage = (entry.value / total * 100)
                          .toStringAsFixed(1);

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color:
                                          _getCategoryColor(
                                            entry.key,
                                          ).withValues(),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      _getCategoryIcon(entry.key),
                                      color: _getCategoryColor(entry.key),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          entry.key,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          '$percentage% of total',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '\$${entry.value.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: _getCategoryColor(entry.key),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: LinearProgressIndicator(
                                  value: entry.value / total,
                                  backgroundColor: Colors.grey[200],
                                  color: _getCategoryColor(entry.key),
                                  minHeight: 8,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
      bottomNavigationBar: const BudgetBossNavBar(currentIndex: 2),
    );
  }
}
