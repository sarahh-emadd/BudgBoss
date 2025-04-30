// lib/main.dart
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'presentation/screens/onboarding/onboarding_screen.dart';
import 'presentation/screens/auth/auth_screen.dart';
import 'presentation/screens/home/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:universal_platform/universal_platform.dart';
import 'dart:developer' as developer;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (UniversalPlatform.isAndroid ||
      UniversalPlatform.isIOS ||
      UniversalPlatform.isWeb) {
    await Firebase.initializeApp(
      options:  DefaultFirebaseOptions.currentPlatform,
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
      ),
      initialRoute: '/onboarding',
      routes: {
        '/': (context) => const HomeScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/auth': (context) => const FirebaseAuthScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
