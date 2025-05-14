import 'package:budget_boss_new/presentation/screens/goals/budget_goals_screen.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'presentation/screens/onboarding/onboarding_screen.dart';
import 'presentation/screens/auth/auth_screen.dart';
import 'presentation/screens/home/add_expense_screen.dart';
import 'presentation/screens/home/expenses_list_screen.dart';
import 'presentation/screens/home/analytics_screen.dart';
import 'presentation/screens/home/profile_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:universal_platform/universal_platform.dart';
import 'dart:developer' as developer;
import 'package:budget_boss_new/presentation/screens/privacy/privacy_security_screen.dart';
import 'package:budget_boss_new/presentation/screens/support/help_support_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (UniversalPlatform.isAndroid ||
      UniversalPlatform.isIOS ||
      UniversalPlatform.isWeb) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } else {
    developer.log('⚠️ Firebase not supported on this platform.');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budget Boss',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Poppins',
        // Add additional theme settings
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Color(0xFF3737CD),
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      initialRoute: '/onboarding',
      routes: {
        '/': (context) => const OnboardingScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/auth': (context) => const FirebaseAuthScreen(),
        '/add_expense': (context) => const AddExpenseScreen(userName: 'User'),
        '/home': (context) => const ExpensesListScreen(),
        '/analytics': (context) => const AnalyticsScreen(),
        '/profile': (context) => const ProfileScreen(userName: 'User'),
        '/goals': (context) => const BudgetGoalsScreen(),
        '/privacy': (context) => const PrivacySecurityScreen(),
        '/help': (context) => const HelpSupportScreen(),
      },
    );
  }
}
