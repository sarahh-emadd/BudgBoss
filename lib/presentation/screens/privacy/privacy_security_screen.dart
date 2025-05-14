import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PrivacySecurityScreen extends StatelessWidget {
  const PrivacySecurityScreen({super.key});

  Future<void> _sendPasswordResetEmail(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.email != null) {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: user.email!);
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password reset email sent')),
        );
      } catch (e) {
        ScaffoldMessenger.of(
          // ignore: use_build_context_synchronously
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _sendEmailVerification(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && !user.emailVerified) {
      try {
        await user.sendEmailVerification();
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Verification email sent')),
        );
      } catch (e) {
        ScaffoldMessenger.of(
          // ignore: use_build_context_synchronously
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy & Security'),
        backgroundColor: const Color(0xFF3737CD),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ListTile(
            title: const Text('Email Address'),
            subtitle: Text(user?.email ?? 'Not available'),
            leading: const Icon(Icons.email_outlined),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.lock_reset),
            title: const Text('Reset Password'),
            subtitle: const Text('Send a reset link to your email'),
            onTap: () => _sendPasswordResetEmail(context),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.verified_user_outlined),
            title: const Text('Verify Email'),
            subtitle: const Text('Send a verification email'),
            onTap: () => _sendEmailVerification(context),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text('Account Protection'),
            subtitle: const Text('Enable 2-step verification (coming soon)'),
            trailing: const Icon(Icons.lock_outline),
            onTap: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Coming soon...')));
            },
          ),
        ],
      ),
    );
  }
}
