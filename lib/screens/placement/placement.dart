import 'package:flutter/material.dart';
import 'package:leaderboard_app/shared/colors.dart';

class Placement extends StatelessWidget {
  const Placement({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBgColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'Check your\n',
                style: const TextStyle(
                  fontSize: 40, // Increased font size
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: 'Placement',
                    style: TextStyle(
                      fontSize: 40, // Increased font size
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondaryAccentColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48, // Set consistent height
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Enter Student ID',
                          hintStyle: const TextStyle(color: Colors.grey),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ), // Added padding
                          border: OutlineInputBorder(
                            // Added rounded border
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none, // No visible border
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 48, // Set consistent height
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondaryAccentColor,
                        foregroundColor: AppColors.primaryBgColor,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        // Add your search logic here
                      },
                      child: const Icon(Icons.search, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
