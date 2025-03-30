import 'package:flutter/material.dart';
import 'package:leaderboard_app/colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: const Text(
        'LeaderBoard',
        style: TextStyle(
          color: AppColors.secondaryAccentColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: AppColors.tertiaryBgColor,
      iconTheme: const IconThemeData(color: AppColors.secondaryAccentColor),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
