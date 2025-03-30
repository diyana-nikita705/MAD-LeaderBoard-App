import 'package:flutter/material.dart';
import 'package:leaderboard_app/colors.dart';
import 'package:leaderboard_app/placement.dart';
import 'package:leaderboard_app/navbar.dart';
import 'package:leaderboard_app/appbar.dart';
import 'package:leaderboard_app/signin.dart';
import 'package:leaderboard_app/profile.dart';
import 'package:leaderboard_app/drawer.dart'; // Import CustomDrawer
import 'package:leaderboard_app/leaderboard.dart'; // Import Leaderboard

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBgColor,
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(), // Use CustomDrawer here
      body: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  List<Widget> get screens => [
    WelcomeWidget(
      onCheckNow: () {
        setState(() {
          currentIndex = 1; // Update to Placement screen
        });
      },
    ),
    const Placement(),
    const Leaderboard(), // Use Leaderboard screen here
    const Profile(isLoggedIn: true), // Add Profile widget here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBgColor,
      body: screens[currentIndex], // Use the screens list
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index; // Update currentIndex to switch screens
          });
        },
      ),
    );
  }
}

class WelcomeWidget extends StatelessWidget {
  final VoidCallback onCheckNow; // Callback for "Check Now" button

  const WelcomeWidget({super.key, required this.onCheckNow});

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
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondaryAccentColor,
                    foregroundColor: AppColors.primaryBgColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ), // Increase button size
                  ),
                  onPressed: onCheckNow, // Use the callback
                  child: const Text(
                    'Check Now',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ), // Make text bold
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 150, // Set fixed width for both buttons
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBgColor,
                    foregroundColor: AppColors.secondaryAccentColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ), // Increase button size
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignIn()),
                    );
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ), // Make text bold
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
