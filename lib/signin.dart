import 'package:flutter/material.dart';
import 'package:leaderboard_app/colors.dart';
import 'package:leaderboard_app/signup.dart';
import 'package:leaderboard_app/profile.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool _isPasswordVisible = false;

  void _handleSignIn() {
    // Add actual sign-in logic here
    bool isSignInSuccessful = true; // Replace with actual logic

    if (isSignInSuccessful) {
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
        title: const Text('Sign In'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Sign In',
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
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.lock,
                    color: AppColors.secondaryAccentColor,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: AppColors.secondaryAccentColor,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryAccentColor,
                  foregroundColor: AppColors.primaryBgColor,
                ),
                onPressed: _handleSignIn,
                child: const Text('Sign In'),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUp()),
                  );
                },
                child: const Text(
                  "Don't have an account? Sign Up",
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
