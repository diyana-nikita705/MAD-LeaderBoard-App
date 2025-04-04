import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leaderboard_app/screens/signin/sign_in.dart';
import 'package:leaderboard_app/screens/wrapper.dart'; // Import Wrapper

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter binding is initialized

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LeaderBoard App',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: Wrapper.routeName, // Set the initial route
      routes: {
        Wrapper.routeName:
            (context) => const Wrapper(), // Register the wrapper route
        '/signin': (context) => const SignIn(), // Register the sign-in route
      },
    );
  }
}
