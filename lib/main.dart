import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:foodnet_01/AuthWrapperHome.dart';
import 'package:foodnet_01/ui/screens/friend/friend_invitations.dart';
import 'package:foodnet_01/ui/screens/friend/friend_list.dart';
import 'package:foodnet_01/ui/screens/profile/profile.dart';
import 'package:foodnet_01/util/data.dart';
import 'package:foodnet_01/util/entities.dart';

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
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: /*const AuthWrapperHome()*/const ProfilePage(type: "me", id: "1",)
      // const Friends(),
    );
  }
}

