// lib/presentation/screens/onboarding/widgets/page_indicator.dart
import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';

class PageIndicator extends StatelessWidget {
  final int pageCount;
  final int currentPage;
  
  const PageIndicator({
    super.key,
    required this.pageCount,
    required this.currentPage,
  });
  
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        pageCount,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: currentPage == index ? 24 : 8,
          decoration: BoxDecoration(
            color: currentPage == index
                ? AppColors.indicatorActive
                : AppColors.indicatorInactive,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}