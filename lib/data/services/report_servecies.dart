// lib/data/services/report_service.dart
import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../../logging/budget_boss_logger.dart';

// Strategy interface
abstract class ReportStrategy {
  Widget generateReport(List<Expense> expenses);
  String getReportName();
}

// Pie Chart Report Strategy
class PieChartReportStrategy implements ReportStrategy {
  @override
  String getReportName() {
    return 'Category Distribution';
  }
  
  @override
  Widget generateReport(List<Expense> expenses) {
    BudgetBossLogger.log('Generating pie chart report');
    // In a real implementation, this would return a pie chart widget
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
    BudgetBossLogger.log('Generating bar chart report');
    // In a real implementation, this would return a bar chart widget
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
    BudgetBossLogger.log('Generating line chart report');
    // In a real implementation, this would return a line chart widget
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
    BudgetBossLogger.log('Report strategy changed to: ${strategy.getReportName()}');
  }
  
  Widget generateReport(List<Expense> expenses) {
    return _strategy.generateReport(expenses);
  }
  
  String getReportName() {
    return _strategy.getReportName();
  }
}