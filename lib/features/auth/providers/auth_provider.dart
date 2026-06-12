import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authUserProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

final liveGameCodeProvider = StateProvider<String?>((ref) => null);

Future<void> signInWithGoogle() async {
  await FirebaseAuth.instance.signInWithPopup(GoogleAuthProvider());
}

Future<void> signOut() async {
  await FirebaseAuth.instance.signOut();
}
