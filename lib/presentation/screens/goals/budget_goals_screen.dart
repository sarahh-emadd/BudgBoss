import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BudgetGoalsScreen extends StatefulWidget {
  const BudgetGoalsScreen({super.key});

  @override
  State<BudgetGoalsScreen> createState() => _BudgetGoalsScreenState();
}

class _BudgetGoalsScreenState extends State<BudgetGoalsScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _goalController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  bool _isSaving = false;
  List<Map<String, dynamic>> _goals = [];

  @override
  void initState() {
    super.initState();
    _fetchGoals();
  }

  Future<void> _fetchGoals() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final snapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('goals')
            .get();

    setState(() {
      _goals = snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  Future<void> _saveGoal() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final goal = {
      'category': _categoryController.text.trim(),
      'amount': double.parse(_goalController.text.trim()),
      'createdAt': Timestamp.now(),
    };

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('goals')
        .add(goal);

    _goalController.clear();
    _categoryController.clear();

    _fetchGoals();
    setState(() => _isSaving = false);
  }

  @override
  void dispose() {
    _goalController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget Goals'),
        backgroundColor: const Color(0xFF3737CD),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _categoryController,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? 'Enter category'
                                : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _goalController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Goal Amount',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Enter amount';
                      final parsed = double.tryParse(value);
                      if (parsed == null || parsed <= 0) {
                        return 'Enter a valid amount';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _isSaving ? null : _saveGoal,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3737CD),
                    ),
                    child:
                        _isSaving
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : const Text('Add Goal'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Your Goals:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child:
                  _goals.isEmpty
                      ? const Center(child: Text('No goals yet.'))
                      : ListView.builder(
                        itemCount: _goals.length,
                        itemBuilder: (context, index) {
                          final goal = _goals[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            child: ListTile(
                              title: Text(goal['category']),
                              trailing: Text(
                                '\$${goal['amount'].toStringAsFixed(2)}',
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
