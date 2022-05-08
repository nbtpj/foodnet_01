import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:foodnet_01/AuthWrapperHome.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FoodNet 01',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AuthWrapperHome(),
      // const Friends(),
    );
  }
}

