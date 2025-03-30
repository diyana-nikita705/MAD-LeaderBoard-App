import 'package:flutter/material.dart';
import 'package:leaderboard_app/colors.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'About',
          style: TextStyle(
            color: AppColors.secondaryAccentColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.tertiaryBgColor,
        iconTheme: const IconThemeData(color: AppColors.secondaryAccentColor),
      ),
      backgroundColor: AppColors.primaryBgColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'About LeaderBoard App',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'This app helps you track and manage leaderboards efficiently.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            SizedBox(height: 40), // Add spacing before contributions section
            Text(
              'Contributions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Developed by: Anzir Rahman Khan and Team',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            Text(
              'UI Design: Anzir Rahman Khan',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
