import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leaderboard_app/models/app_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// StreamProvider to monitor authentication state
final authProvider = StreamProvider.autoDispose<AppUser?>((ref) async* {
  final authStream = FirebaseAuth.instance.authStateChanges().map((user) {
    return user != null ? AppUser(uid: user.uid, email: user.email!) : null;
  });
  await for (final user in authStream) {
    yield user;
  }
});

final boundProfileProvider = FutureProvider.autoDispose<String?>((ref) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return null;

  final doc =
      await FirebaseFirestore.instance
          .collection('user_profiles')
          .doc(user.uid)
          .get();

  return doc.exists && doc.data() != null
      ? doc.data()!['profileId'] as String?
      : null;
});
