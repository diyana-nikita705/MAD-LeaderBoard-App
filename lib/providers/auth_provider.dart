import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leaderboard_app/models/app_user.dart';

final authProvider = StreamProvider.autoDispose<AppUser?>((ref) async* {
  final Stream<AppUser?> userStream = FirebaseAuth.instance
      .authStateChanges()
      .map((user) {
        if (user != null) {
          return AppUser(uid: user.uid, email: user.email!);
        } else {
          return null;
        }
      });
  await for (final user in userStream) {
    yield user;
  }
});
