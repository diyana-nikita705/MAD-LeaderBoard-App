import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leaderboard_app/screens/profile/profileupdate.dart';
import 'package:leaderboard_app/screens/signin/signin.dart';
import 'package:leaderboard_app/shared/colors.dart';
import 'package:leaderboard_app/providers/auth_provider.dart';

class Profile extends ConsumerWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          return const SignIn(); // Redirect to SignIn if user is not logged in
        }

        // Placeholder for dynamic data
        final String profilePicture = 'assets/profile_picture.png';
        final String name = 'John Doe'; // Replace with actual name
        final String studentId = '123456'; // Replace with actual student ID
        final double cgpa = 3.8; // Replace with actual CGPA
        final String email = user.email; // Use email from the user object
        final String department = 'Computer Science';
        final String section = 'A';
        final List<String> achievements = [
          'Winner of Coding Competition 2023',
          'Published Research Paper on AI',
        ];

        return Scaffold(
          backgroundColor: AppColors.primaryBgColor,
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Hi, $email',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryAccentColor,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(profilePicture),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    'Student ID: $studentId',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    'CGPA: $cgpa',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryAccentColor,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileUpdate()),
                    );
                  },
                  child: Text(
                    'Update Profile',
                    style: TextStyle(color: AppColors.secondaryTextColor),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Email: $email',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.primaryTextColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Department: $department',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.primaryTextColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Section: $section',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.primaryTextColor,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Achievements:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryTextColor,
                  ),
                ),
                const SizedBox(height: 8),
                ...achievements.map(
                  (achievement) => Text(
                    '- $achievement',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error: $error')),
    );
  }
}
