// lib/data/services/report_service.dart
import 'package:budget_boss_new/data/expense_data.dart';
import 'package:flutter/material.dart';
import 'package:budget_boss_new/logging/budget_boss_logger.dart';

// Strategy interface
abstract class ReportStrategy {
  Widget generateReport(List<Expense> expenses);
  String getReportName();
}

// Shared logger instance
final logger = BudgetBossLogger();

// Pie Chart Report Strategy
class PieChartReportStrategy implements ReportStrategy {
  @override
  String getReportName() {
    return 'Category Distribution';
  }

  @override
  Widget generateReport(List<Expense> expenses) {
    logger.log('Generating pie chart report');
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Pie Chart Report'),
          const SizedBox(height: 20),
          Text('Total Expenses: ${_calculateTotalExpenses(expenses)}'),
        ],
      ),
    );
  }

  double _calculateTotalExpenses(List<Expense> expenses) {
    return expenses.fold(0, (sum, expense) => sum + expense.amount);
  }
}

// Bar Chart Report Strategy
class BarChartReportStrategy implements ReportStrategy {
  @override
  String getReportName() {
    return 'Monthly Spending';
  }

  @override
  Widget generateReport(List<Expense> expenses) {
    logger.log('Generating bar chart report');
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Bar Chart Report'),
          const SizedBox(height: 20),
          Text('Number of Expenses: ${expenses.length}'),
        ],
      ),
    );
  }
}

// Line Chart Report Strategy
class LineChartReportStrategy implements ReportStrategy {
  @override
  String getReportName() {
    return 'Spending Trends';
  }

  @override
  Widget generateReport(List<Expense> expenses) {
    logger.log('Generating line chart report');
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Line Chart Report'),
          const SizedBox(height: 20),
          Text('Data Points: ${expenses.length}'),
        ],
      ),
    );
  }
}

// Report Context
class ReportContext {
  ReportStrategy _strategy;

  ReportContext(this._strategy);

  void setStrategy(ReportStrategy strategy) {
    _strategy = strategy;
    logger.log('Report strategy changed to: ${strategy.getReportName()}');
  }

  Widget generateReport(List<Expense> expenses) {
    return _strategy.generateReport(expenses);
  }

  String getReportName() {
    return _strategy.getReportName();
  }
}
