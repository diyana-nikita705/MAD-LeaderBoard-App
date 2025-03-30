import 'package:flutter/material.dart';
import 'package:leaderboard_app/colors.dart';
import 'package:leaderboard_app/about.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.6,
      child: Drawer(
        backgroundColor: AppColors.primaryBgColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: AppColors.tertiaryBgColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'LeaderBoard',
                    style: TextStyle(
                      color: AppColors.secondaryAccentColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Menu',
                    style: TextStyle(
                      color: AppColors.primaryTextColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              tileColor: AppColors.primaryBgColor,
              leading: Icon(Icons.info, color: AppColors.secondaryAccentColor),
              title: Text('About'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const About()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
