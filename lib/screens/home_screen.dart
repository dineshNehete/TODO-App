import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

// ignore: use_key_in_widget_constructors
class HomePage extends StatelessWidget {
  static const routeName = 'home';
  final _googleSignIn = GoogleSignIn();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.blue,
          child: TextButton(
            child: const Text(
              "Signout",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              await _googleSignIn.signOut();
            },
          ),
        ),
      ),
    );
  }
}
