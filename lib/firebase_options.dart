// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBe8TUx5N_ffzSyA9_tgKbeaithwqg6YSk',
    appId: '1:380370204581:web:4ae7912045948d07ab5a4c',
    messagingSenderId: '380370204581',
    projectId: 'planner-192ee',
    authDomain: 'planner-192ee.firebaseapp.com',
    storageBucket: 'planner-192ee.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAoW1e3UdHuGUvRbQy6IuaFBk4jz2spX98',
    appId: '1:380370204581:android:f2248125580f70a0ab5a4c',
    messagingSenderId: '380370204581',
    projectId: 'planner-192ee',
    storageBucket: 'planner-192ee.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBH8syUdTMCc_UkHVwlFMNfK5uC89YvC9I',
    appId: '1:380370204581:ios:df552ede94a3b9baab5a4c',
    messagingSenderId: '380370204581',
    projectId: 'planner-192ee',
    storageBucket: 'planner-192ee.appspot.com',
    iosBundleId: 'com.example.todoListWithGetx',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBH8syUdTMCc_UkHVwlFMNfK5uC89YvC9I',
    appId: '1:380370204581:ios:df552ede94a3b9baab5a4c',
    messagingSenderId: '380370204581',
    projectId: 'planner-192ee',
    storageBucket: 'planner-192ee.appspot.com',
    iosBundleId: 'com.example.todoListWithGetx',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBe8TUx5N_ffzSyA9_tgKbeaithwqg6YSk',
    appId: '1:380370204581:web:1200c2dae9184282ab5a4c',
    messagingSenderId: '380370204581',
    projectId: 'planner-192ee',
    authDomain: 'planner-192ee.firebaseapp.com',
    storageBucket: 'planner-192ee.appspot.com',
  );
}
