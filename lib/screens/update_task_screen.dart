import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UpdateScreen extends StatefulWidget {
  static const routeName = '/new-task';
  int currentIndex;
  UpdateScreen(this.currentIndex);

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  final TextEditingController _textEditingControllerTask =
      TextEditingController();
  final user = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();

  void addTask() async {
    final _isValid = _formKey.currentState!.validate();
    if (_isValid) {
      _formKey.currentState!.save();
      final user = await FirebaseAuth.instance.currentUser;
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .collection('tasks')
            .add({'task': _textEditingControllerTask.text});
        _textEditingControllerTask.clear();
        Navigator.of(context).pop();
      } catch (error) {
        print(error);
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _textEditingControllerTask.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final args = ModalRoute.of(context)!.settings.arguments as int;

    return Scaffold(
      backgroundColor: Color(0xff2B2B2B),
      body: SingleChildScrollView(
        child: StreamBuilder<Object>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(user!.uid)
                .collection('tasks')
                .snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              return Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      width: 250,
                      height: 65,
                      margin: const EdgeInsets.only(top: 30.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Form(
                        child: TextFormField(
                          initialValue: snapshot
                                      .data!.docs[widget.currentIndex]['task']
                                      .toString() ==
                                  null
                              ? ""
                              : snapshot.data!.docs[widget.currentIndex]
                                  ['task'],
                          key: const ValueKey("title"),
                          onChanged: (value) {
                            setState(() {
                              _textEditingControllerTask.text = value;
                            });
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Task found to be null";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            label: Text("Title"),
                            fillColor: Colors.white,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(left: 15),
                          ),
                        ),
                        key: _formKey,
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        // onPressed: null,
                        onPressed: () async {
                          print(
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(user!.uid)
                                .collection('tasks')
                                .snapshots(),
                          );
                          print(snapshot.data!.docs.length);
                          (snapshot.data.docs[widget.currentIndex]['task']);
                          if (_textEditingControllerTask.text.isNotEmpty) {
                            try {
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(user!.uid)
                                  .collection('tasks')
                                  .doc(snapshot
                                      .data!.docs[widget.currentIndex].id)
                                  .update({
                                'task': _textEditingControllerTask.text
                              }).then((_) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text("Task Updated Sucessfully"),
                                ));
                              }).then((value) {
                                Navigator.of(context).pop();
                              });
                            } catch (error) {
                              print(error);
                            }
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Error !"),
                            ));
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Text(
                            "UPDATE TASK",
                            style: GoogleFonts.lato(
                              textStyle: const TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
