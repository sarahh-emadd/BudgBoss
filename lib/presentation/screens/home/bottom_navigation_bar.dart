import 'package:flutter/material.dart';

class BudgetBossNavBar extends StatelessWidget {
  final int currentIndex;

  const BudgetBossNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        // Handle navigation based on index
        switch (index) {
          case 0:
            if (currentIndex != 0) {
              Navigator.pushReplacementNamed(context, '/home');
            }
            break;
          case 1:
            if (currentIndex != 1) {
              Navigator.pushReplacementNamed(context, '/add_expense');
            }
            break;
          case 2:
            if (currentIndex != 2) {
              Navigator.pushReplacementNamed(context, '/analytics');
            }
            break;
          case 3:
            if (currentIndex != 3) {
              Navigator.pushReplacementNamed(context, '/profile');
            }
            break;
        }
      },
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: const Color(0xFF3737CD),
      unselectedItemColor: Colors.grey[600],
      selectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
      elevation: 8,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_outline),
          activeIcon: Icon(Icons.add_circle),
          label: 'Add',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart_outlined),
          activeIcon: Icon(Icons.bar_chart),
          label: 'Analytics',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}
