import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitFn, this.isLoading);

  final bool isLoading;
  final void Function(String email, String username, String password,
      bool isLogin, BuildContext context) submitFn;
  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? googleUser;
  var _username = '';
  var _email = '';
  var _password = '';
  bool _isLogin = true;
  // final _controller = new TextEditingController();
  void _trySubmit() {
    final _isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (_isValid) {
      _formKey.currentState!.save();

      _formKey.currentState!.save();
      widget.submitFn(
          _email.trim(), _username.trim(), _password.trim(), _isLogin, context);
    }
  }

  Future signInWithGoogle() async {
    try {
      googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'email': googleUser!.email,
        'username': googleUser!.displayName
      });
    } catch (e) {
      print(e);
    }

    // Once signed in, return the UserCredential
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.5, left: 25, right: 25),
        child: Column(
          children: [
            // if (!_isLogin)
            TextFormField(
              key: ValueKey("email"),
              onSaved: (value) {
                _email = value!;
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return "Enter valid email";
                } else if (!value.contains('@')) {
                  return "Enter valid email id";
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                  labelText: "Enter email",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25))),
            ),
            const SizedBox(
              height: 15,
            ),
            if (!_isLogin)
              TextFormField(
                key: ValueKey("username"),
                onSaved: (value) {
                  _username = value!;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter a valid username";
                  }
                  return null;
                },
                decoration: InputDecoration(
                    labelText: "Enter username",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25))),
              ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              key: ValueKey("password"),
              onSaved: (value) {
                _password = value!;
              },
              obscureText: true,
              validator: (value) {
                if (value!.isEmpty || value.length <= 6) {
                  return "Password length must be greater than 6";
                }
                return null;
              },
              decoration: InputDecoration(
                  labelText: "Enter password",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25))),
            ),
            const SizedBox(
              height: 30,
            ),
            InkWell(
              onTap: _trySubmit,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(colors: [
                      const Color(0xffFFC069),
                      const Color(0xff7DEDFF).withOpacity(0.6),
                      const Color(0xff4B6587),
                    ])),
                child: Text(
                  _isLogin ? "Login" : 'Sign Up',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
            TextButton(
              child:
                  Text(_isLogin ? "Create a new account" : "Already a user?"),
              onPressed: () {
                setState(() {
                  _isLogin = !_isLogin;
                });
              },
            ),
            TextButton(
              onPressed: signInWithGoogle,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.grey,
                ),
                padding: EdgeInsets.all(10),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 40, maxWidth: 200),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Container(
                          height: 40,
                          width: 40,
                          child: Image.network(
                            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTqsqW3YzeBgLaVkmnmI4ocdtGjUEKgxyMSXw&usqp=CAU",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Text(
                        "Sign In with Google",
                        style: GoogleFonts.lato(
                          textStyle:
                              TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
