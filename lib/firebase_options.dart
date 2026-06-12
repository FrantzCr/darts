import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform => web;

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC-eXxVbftU6I1Sq6SYk9wpIvOp1Ii-wWo',
    authDomain: 'dart-8a4d6.firebaseapp.com',
    projectId: 'dart-8a4d6',
    storageBucket: 'dart-8a4d6.firebasestorage.app',
    messagingSenderId: '1071524825322',
    appId: '1:1071524825322:web:19d4db90e9106adcecaf93',
  );
}
