// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:signup_ui/widgets/authform.dart';

// ignore: use_key_in_widget_constructors
class LoginPage extends StatefulWidget {
  static const routeName = 'login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    var _isLoading = false;

    void _submitAuthForm(String email, String userName, String password,
        bool isLogin, ctx) async {
      UserCredential userCredential;
      try {
        setState(() {
          _isLoading = true;
        });
        if (isLogin) {
          print(email);
          print(userName);
          print(password);
          userCredential = await _auth.signInWithEmailAndPassword(
              email: email, password: password);
        } else {
          print(email);
          print(userName);
          print(password);
          userCredential = await _auth.createUserWithEmailAndPassword(
              email: email, password: password);
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user!.uid)
              .set({'email': email, 'userName': userName});
        }
        setState(() {
          _isLoading = false;
        });
      } on FirebaseAuthException catch (error) {
        var message = "An error occured Check your credentials";
        if (error.message != null) {
          message = error.message!;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
          ),
        );
        setState(() {
          _isLoading = false;
        });
      } catch (error) {
        print(error);
        setState(() {
          _isLoading = false;
        });
      }
    }

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/login.png"), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 35, top: 130),
              child: const Text(
                "Welcome\nBack",
                style: TextStyle(color: Colors.white, fontSize: 33),
              ),
            ),
            SingleChildScrollView(
              child: AuthForm(_submitAuthForm, _isLoading),
            )
          ],
        ),
      ),
    );
  }
}
