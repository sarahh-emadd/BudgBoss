// lib/presentation/screens/onboarding/widgets/onboarding_page.dart
import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';

class OnboardingPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  
  const OnboardingPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
  });
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top curved container with title
        Container(
          height: MediaQuery.of(context).size.height * 0.4,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                title,
                style: AppTextStyles.heading1,
              ),
            ),
          ),
        ),
        
        // Image
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain,
            ),
          ),
        ),
        
        // Subtitle
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Text(
            subtitle,
            style: AppTextStyles.heading2,
            textAlign: TextAlign.center,
          ),
        ),
        
        // Bottom spacer for indicators
        const SizedBox(height: 100),
      ],
    );
  }
}