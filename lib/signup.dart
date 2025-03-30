import 'package:flutter/material.dart';
import 'package:leaderboard_app/colors.dart';
import 'package:leaderboard_app/profile.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  void _handleSignUp(BuildContext context) {
    // Add actual sign-up logic here
    bool isSignUpSuccessful = true; // Replace with actual logic

    if (isSignUpSuccessful) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Profile(isLoggedIn: true),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBgColor,
      appBar: AppBar(
        backgroundColor: AppColors.secondaryAccentColor,
        title: const Text('Sign Up'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Create an Account',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.email,
                    color: AppColors.secondaryAccentColor,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.lock,
                    color: AppColors.secondaryAccentColor,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryAccentColor,
                  foregroundColor: AppColors.primaryBgColor,
                ),
                onPressed: () => _handleSignUp(context),
                child: const Text('Sign Up'),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Navigate back to the sign-in screen
                },
                child: const Text(
                  'Already have an account? Sign In',
                  style: TextStyle(color: AppColors.secondaryAccentColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
