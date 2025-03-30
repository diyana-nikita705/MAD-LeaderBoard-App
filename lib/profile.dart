import 'package:flutter/material.dart';
import 'package:leaderboard_app/colors.dart';

class Profile extends StatelessWidget {
  final bool isLoggedIn;

  const Profile({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    if (!isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/signin');
      });
      return const SizedBox.shrink(); // Empty widget while redirecting
    }

    return Scaffold(
      backgroundColor: AppColors.primaryBgColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Welcome Anzir!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Editable Profile Picture
              GestureDetector(
                onTap: () {
                  // Logic to edit profile picture
                },
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(
                    'assets/default_profile.png',
                  ), // Replace with actual image logic
                ),
              ),
              const SizedBox(height: 16),

              // Name (Non-editable)
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                enabled: false,
              ),
              const SizedBox(height: 16),

              // Student ID (Non-editable)
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Student ID',
                  border: OutlineInputBorder(),
                ),
                enabled: false,
              ),
              const SizedBox(height: 16),

              // Editable Email
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Current Password
              TextField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Current Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // New Password
              TextField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Save Button
              ElevatedButton(
                onPressed: () {
                  // Logic to save changes
                },
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
