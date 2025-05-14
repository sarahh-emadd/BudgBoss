import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final helpItems = [
      {
        'question': 'How do I add a new expense?',
        'answer':
            'Go to the home screen and tap the + button. Fill in the details and save.',
      },
      {
        'question': 'How can I change my password?',
        'answer':
            'Go to Profile > Privacy & Security and tap "Reset Password" to receive a reset email.',
      },
      {
        'question': 'Is my data backed up?',
        'answer':
            'Yes, all your data is stored securely in Firebase Cloud Firestore.',
      },
      {
        'question': 'How do I enable dark mode?',
        'answer': 'Go to Profile > Settings and toggle the "Dark Mode" switch.',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        backgroundColor: const Color(0xFF3737CD),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: helpItems.length,
        itemBuilder: (context, index) {
          final item = helpItems[index];
          return ExpansionTile(
            leading: const Icon(Icons.help_outline, color: Color(0xFF3737CD)),
            title: Text(
              item['question']!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Text(
                  item['answer']!,
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
