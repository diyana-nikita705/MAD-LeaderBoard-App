import 'package:flutter/material.dart';
import 'package:leaderboard_app/shared/colors.dart';
import 'package:leaderboard_app/screens/signin/signin.dart';
import 'package:leaderboard_app/shared/styled_button.dart';

class Home extends StatelessWidget {
  final VoidCallback onCheckNow; // Callback for "Check Now" button

  const Home({super.key, required this.onCheckNow}); // Added required parameter

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              const Text(
                'Welcome to',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'LeaderBoard',
                style: TextStyle(
                  color: AppColors.secondaryAccentColor,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 100),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 150, // Set fixed width for both buttons
                child: StyledButton(
                  backgroundColor: AppColors.secondaryAccentColor,
                  foregroundColor: AppColors.primaryBgColor,
                  onPressed: onCheckNow,
                  text: 'Check Now',
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 150, // Set fixed width for both buttons
                child: StyledButton(
                  backgroundColor: AppColors.primaryBgColor,
                  foregroundColor: AppColors.secondaryAccentColor,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignIn()),
                    );
                  },
                  text: 'Login',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
