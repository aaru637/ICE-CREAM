// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyDlD22yMqyGZrJ5CVX6eoy21LDpisU5P-E',
    appId: '1:1052335859680:web:e4ae0295993f398d3ced85',
    messagingSenderId: '1052335859680',
    projectId: 'ice-cream-8838',
    authDomain: 'ice-cream-8838.firebaseapp.com',
    storageBucket: 'ice-cream-8838.appspot.com',
    measurementId: 'G-4TDEGPRQD0',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDasHdpvYZ5v3r2GBGM41l2tFcokphyLlQ',
    appId: '1:1052335859680:android:366dddd2b7baa0823ced85',
    messagingSenderId: '1052335859680',
    projectId: 'ice-cream-8838',
    storageBucket: 'ice-cream-8838.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBDuBRxz0YOn3vwXS7ZYcZwFxnPXTxyLOo',
    appId: '1:1052335859680:ios:e2ab32b7ab72e4853ced85',
    messagingSenderId: '1052335859680',
    projectId: 'ice-cream-8838',
    storageBucket: 'ice-cream-8838.appspot.com',
    iosClientId: '1052335859680-pm4n0ttjga154eju1ok8bjidjaunkrdj.apps.googleusercontent.com',
    iosBundleId: 'com.ik.ik',
  );
}
