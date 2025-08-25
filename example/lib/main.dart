import 'package:firebase_core/firebase_core.dart';
import 'package:firehub/firehub.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Firehub firehub = Firehub(options: DefaultFirebaseOptions.currentPlatform);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await firehub.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: ElevatedButton(
            // onPressed: () => FirebaseCrashlytics.instance.crash(),
            onPressed: () async {
              await firehub.crashlyticsHub?.recordError('This is my Description', reason: 'errorReason');
              await firehub.analyticsHub?.logEvent(name: 'CHECK_AUG_25', eventParameters: {'OO': ' TT'});
              throw Exception();
            },
            child: const Text("Crash App"),
          ),
        ),
      ),
    );
  }
}

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
      default:
        throw UnsupportedError('DefaultFirebaseOptions are not supported for this platform.');
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBkJOm6jShS0_p9fn_70euwb3B8EebwhMo',
    appId: '1:967823757192:web:1ddd00beb7f9dbda02343d',
    messagingSenderId: '967823757192',
    projectId: 'asdfas-app',
    authDomain: 'asdfas-app.firebaseapp.com',
    databaseURL: 'https://asdfas-app.firebaseio.com',
    storageBucket: 'asdfas-app.appspot.com',
    measurementId: 'G-1FDV687K4N',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBEAu8_Dkv4bNjt3Pbn-EddkD_d8zd4KHk',
    appId: '1:974781681172:android:0d03a92505f3bcaf6fe101',
    messagingSenderId: '974781681172',
    projectId: 'nepcrashlytics',
    storageBucket: 'nepcrashlytics.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBbdxu_8WoBA2vFNt8b74ElgGFHQsoPs6Q',
    appId: '1:967823757192:ios:3ecc8514b5e40759',
    messagingSenderId: '967823757192',
    projectId: 'asdfas-app',
    databaseURL: 'https://asdfas-app.firebaseio.com',
    storageBucket: 'asdfas-app.appspot.com',
    androidClientId: '967823757192-ankgo1fglr2vogi8d1i6hdpdm7ho0moh.apps.googleusercontent.com',
    iosClientId: '967823757192-hjrcf93ic08a6t3rbc877gpr1o45f155.apps.googleusercontent.com',
    iosBundleId: 'com.asdfas',
  );
}
