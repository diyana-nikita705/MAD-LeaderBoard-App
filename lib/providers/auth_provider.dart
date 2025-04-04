import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leaderboard_app/models/app_user.dart';

// StreamProvider to monitor authentication state
final authProvider = StreamProvider.autoDispose<AppUser?>((ref) async* {
  final authStream = FirebaseAuth.instance.authStateChanges().map((user) {
    return user != null ? AppUser(uid: user.uid, email: user.email!) : null;
  });
  await for (final user in authStream) {
    yield user;
  }
});
