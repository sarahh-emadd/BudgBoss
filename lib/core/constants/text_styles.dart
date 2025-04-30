// lib/core/constants/text_styles.dart
import 'package:flutter/material.dart';
import 'colors.dart';

class AppTextStyles {
  static const heading1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textLight,
    height: 1.2,
  );
  
  static const heading2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );
  
  static const bodyText = TextStyle(
    fontSize: 16,
    color: AppColors.textDark,
  );
}