import 'package:flutter/material.dart';
import 'package:leaderboard_app/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LeaderBoard App',
      home: const Home(), // Use Home from home.dart
    );
  }
}
