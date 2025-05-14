import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:budget_boss_new/data/expense_data.dart';

class FirebaseExpenseService {
  final String uid;

  FirebaseExpenseService({String? uid})
    : uid = uid ?? FirebaseAuth.instance.currentUser?.uid ?? '';

  Future<void> addExpense({
    required double amount,
    required String category,
    required String description,
    required DateTime date,
  }) async {
    if (uid.isEmpty) throw Exception("User not logged in");

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('expenses')
        .add({
          'amount': amount,
          'category': category,
          'description': description,
          'date': date.toIso8601String(),
        });
  }

  Future<void> deleteExpense(String id) async {
    if (uid.isEmpty) throw Exception("User not logged in");

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('expenses')
        .doc(id)
        .delete();
  }

  Future<void> updateExpense({
    required String id,
    required String title,
    required double amount,
    required String category,
  }) async {
    if (uid.isEmpty) throw Exception("User not logged in");

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('expenses')
        .doc(id)
        .update({'description': title, 'amount': amount, 'category': category});
  }

  Future<List<Expense>> getExpenses() async {
    if (uid.isEmpty) throw Exception("User not logged in");

    final snapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('expenses')
            .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Expense(
        id: doc.id,
        title: data['description'] ?? '',
        amount: (data['amount'] ?? 0).toDouble(),
        category: data['category'] ?? '',
      );
    }).toList();
  }
}
