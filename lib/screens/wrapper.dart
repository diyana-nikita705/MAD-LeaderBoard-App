import 'package:flutter/material.dart';
import 'package:leaderboard_app/shared/colors.dart';
import 'package:leaderboard_app/screens/home/home.dart';
import 'package:leaderboard_app/screens/placement/placement.dart';
import 'package:leaderboard_app/screens/leaderboard/leaderboard.dart';
import 'package:leaderboard_app/screens/profile/profile.dart';
import 'package:leaderboard_app/screens/appbar.dart';
import 'package:leaderboard_app/screens/navbar.dart';
import 'package:leaderboard_app/screens/drawer/drawer.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  static const String routeName = '/wrapper';

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  late NavBarItem _currentItem;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as NavBarItem?;
      setState(() {
        _currentItem =
            args ?? NavBarItem.home; // Default to Home if no arguments
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void navigateTo(NavBarItem item) {
    if (_currentItem != item) {
      setState(() => _currentItem = item);
    }
  }

  Map<NavBarItem, Widget> _buildScreens() {
    return {
      NavBarItem.home: Home(onCheckNow: () => navigateTo(NavBarItem.placement)),
      NavBarItem.placement: const Placement(),
      NavBarItem.leaderboard: const Leaderboard(),
      NavBarItem.profile: const Profile(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBgColor,
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(),
      body: _buildScreens()[_currentItem],
      bottomNavigationBar: CustomBottomNavBar(
        currentItem: _currentItem,
        onTap: navigateTo,
      ),
    );
  }
}
