import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authUserProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

final liveGameCodeProvider = StateProvider<String?>((ref) => null);

Future<void> signInWithGoogle() async {
  final provider = GoogleAuthProvider();
  if (kIsWeb) {
    // GitHub Pages sends COOP: same-origin which blocks popups.
    // Use redirect on any non-localhost host; popup on localhost (no COOP).
    final host = Uri.base.host;
    final isLocalhost = host == 'localhost' || host == '127.0.0.1';
    if (isLocalhost) {
      await FirebaseAuth.instance.signInWithPopup(provider);
    } else {
      await FirebaseAuth.instance.signInWithRedirect(provider);
    }
  } else {
    await FirebaseAuth.instance.signInWithPopup(provider);
  }
}

Future<void> signOut() async {
  await FirebaseAuth.instance.signOut();
}
