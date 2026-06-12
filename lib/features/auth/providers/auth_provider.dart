import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authUserProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

final liveGameCodeProvider = StateProvider<String?>((ref) => null);

Future<void> signInWithGoogle() async {
  // signInWithRedirect avoids COOP header issues on GitHub Pages
  await FirebaseAuth.instance.signInWithRedirect(GoogleAuthProvider());
}

Future<void> signOut() async {
  await FirebaseAuth.instance.signOut();
}
