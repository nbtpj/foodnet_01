// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    // ignore: missing_enum_constant_in_switch
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
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA4B-sv8siqR6xUNFXlYcdxQmAA60mouwA',
    appId: '1:798946241723:android:fa39ec3ddcf33233020d9e',
    messagingSenderId: '798946241723',
    projectId: 'mobile-foodnet',
    databaseURL: 'https://mobile-foodnet-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'mobile-foodnet.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAAQFsAAHaGVaqeSvmMVelkxq_ND1n6wRA',
    appId: '1:798946241723:ios:c9683a59d7f46258020d9e',
    messagingSenderId: '798946241723',
    projectId: 'mobile-foodnet',
    databaseURL: 'https://mobile-foodnet-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'mobile-foodnet.appspot.com',
    iosClientId: '798946241723-d29otnq3sq0r4rufnhig262g3a276v6o.apps.googleusercontent.com',
    iosBundleId: 'com.example.app',
  );
}
