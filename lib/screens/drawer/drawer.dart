import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leaderboard_app/shared/colors.dart';
import 'package:leaderboard_app/screens/drawer/about.dart';
import 'package:leaderboard_app/screens/drawer/signinoptions.dart';
import 'package:leaderboard_app/screens/drawer/loggedout.dart';
import 'package:leaderboard_app/services/auth_service.dart';
import 'package:leaderboard_app/providers/auth_provider.dart';

class CustomDrawer extends ConsumerWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return authState.when(
      data: (user) {
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
                  leading: Icon(
                    Icons.person,
                    color: AppColors.secondaryAccentColor,
                  ),
                  title: Text('Sign In Options'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignInOptions(),
                      ),
                    );
                  },
                ),
                if (user != null)
                  ListTile(
                    tileColor: AppColors.primaryBgColor,
                    leading: Icon(
                      Icons.logout,
                      color: AppColors.secondaryAccentColor,
                    ),
                    title: Text('Log Out'),
                    onTap: () async {
                      final navigator = Navigator.of(context);
                      await AuthService.signOut();
                      navigator.pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const LoggedOutScreen(),
                        ),
                      );
                    },
                  ),
                ListTile(
                  tileColor: AppColors.primaryBgColor,
                  leading: Icon(
                    Icons.info,
                    color: AppColors.secondaryAccentColor,
                  ),
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
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error: $error')),
    );
  }
}
