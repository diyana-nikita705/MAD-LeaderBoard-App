import 'package:flutter/material.dart';
import 'package:leaderboard_app/shared/colors.dart';

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
      body: Container(
        margin: const EdgeInsets.all(
          16.0,
        ), // Use margin for spacing around the content
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align texts to the left
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
              'This app helps you track and manage leaderboards efficiently. '
              'It provides features like real-time updates, user-friendly UI, '
              'and customizable leaderboard settings.',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            SizedBox(height: 40),
            Text(
              'About the MAD Project',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'The Mobile Application Development (MAD) project is an initiative '
              'to create innovative and user-friendly mobile applications. '
              'This project focuses on enhancing development skills and delivering '
              'practical solutions to real-world problems.',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            Spacer(), // Push contributions section to the bottom
            Divider(
              color: Colors.black54,
            ), // Add a divider for better separation
            SizedBox(height: 10),
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
              'Developed by:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              'Anzir Rahman Khan and Team',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            SizedBox(height: 10),
            Text(
              'UI Design:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              'Anzir Rahman Khan',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
