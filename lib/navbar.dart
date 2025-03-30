import 'package:flutter/material.dart';
import 'package:leaderboard_app/colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Placement'),
        BottomNavigationBarItem(
          icon: Icon(Icons.leaderboard),
          label: 'Leaderboard',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
      selectedItemColor: AppColors.secondaryAccentColor,
      unselectedItemColor: Colors.grey,
      backgroundColor: AppColors.tertiaryBgColor,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      onTap: (index) {
        onTap(index); // Handle all tabs, including Profile
      },
    );
  }
}
