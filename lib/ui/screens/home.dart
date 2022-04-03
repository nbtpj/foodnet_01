import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodnet_01/AuthWrapperHome.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final String name = FirebaseAuth.instance.currentUser!.displayName!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () async{
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                  return const AuthWrapperHome();
                }));
              },
              icon: const Icon(Icons.logout)
          )
        ]
      ),
      body: const Text("Home")
    );
  }
}
