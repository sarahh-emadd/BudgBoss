import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'firebase_expense_service_test.mock_generator.mocks.dart';
import 'package:budget_boss_new/data/expense_data.dart'; // For Expense model

// You must generate this file (shown in Step 2)

void main() {
  late MockFirebaseExpenseService mockService;

  setUp(() {
    mockService = MockFirebaseExpenseService();
  });

  test('addExpense is called with correct data', () async {
    when(
      mockService.addExpense(
        amount: 12.0,
        category: 'Food',
        description: 'Burger',
        date: anyNamed('date'),
      ),
    ).thenAnswer((_) async => Future.value());

    await mockService.addExpense(
      amount: 12.0,
      category: 'Food',
      description: 'Burger',
      date: DateTime.now(),
    );

    verify(
      mockService.addExpense(
        amount: 12.0,
        category: 'Food',
        description: 'Burger',
        date: anyNamed('date'),
      ),
    ).called(1);
  });

  test('getExpenses returns mocked list', () async {
    // Create mock data
    final mockExpenses = [
      Expense(id: '1', title: 'Coffee', amount: 3.5, category: 'Food'),
      Expense(id: '2', title: 'Bus', amount: 2.5, category: 'Transport'),
    ];

    when(mockService.getExpenses()).thenAnswer((_) async => mockExpenses);

    final result = await mockService.getExpenses();

    expect(result.length, 2);
    expect(result[0].title, 'Coffee');
    expect(result[1].amount, 2.5);
  });

  test('updateExpense is called with correct data', () async {
    when(
      mockService.updateExpense(
        id: 'abc123',
        title: 'Updated',
        amount: 99.9,
        category: 'Bills',
      ),
    ).thenAnswer((_) async => Future.value());

    await mockService.updateExpense(
      id: 'abc123',
      title: 'Updated',
      amount: 99.9,
      category: 'Bills',
    );

    verify(
      mockService.updateExpense(
        id: 'abc123',
        title: 'Updated',
        amount: 99.9,
        category: 'Bills',
      ),
    ).called(1);
  });

  test('deleteExpense is called with correct ID', () async {
    when(
      mockService.deleteExpense('test-id'),
    ).thenAnswer((_) async => Future.value());

    await mockService.deleteExpense('test-id');

    verify(mockService.deleteExpense('test-id')).called(1);
  });
}
