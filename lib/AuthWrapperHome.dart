import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/screens/login.dart';

import 'ui/screens/nav_bar.dart';

class AuthWrapperHome extends StatelessWidget {
  const AuthWrapperHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? u = snapshot.data;
          if (u == null) {
            return const Login();
          } else {
            return MyHomePage();
          }
        } else {
          return const Scaffold(
              body: Center(
                  child: CircularProgressIndicator()
              )
          );
        }
      },
    );
  }
}
