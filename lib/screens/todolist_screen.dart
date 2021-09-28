import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:signup_ui/screens/new_task_screen.dart';
import 'package:signup_ui/screens/update_task_screen.dart';
import 'package:signup_ui/widgets/appdrawer.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({Key? key}) : super(key: key);

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  double val = 0;
  bool isDrawerOpen = false;

  @override
  Widget build(BuildContext context) {
    final rightSlide = MediaQuery.of(context).size.width * 0.7;
    final user = FirebaseAuth.instance.currentUser;
    // var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterFloat,
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xffFFD369),
          onPressed: () {
            Navigator.of(context).pushNamed(NewTaskScreen.routeName);
            // Navigator.of(context)
            //     .push(MaterialPageRoute(builder: (context) => NewTaskScreen()));
          },
          child: const Icon(
            Icons.add,
            color: Colors.black,
          ),
        ),
        body: Stack(
          children: [
            const AppDrawer(),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.slowMiddle,
              transform: Matrix4.translationValues(xOffset, yOffset, 0)
                ..scale(scaleFactor),
              // color: Color(0xff0d1842),
              color: Color(0xff2B2B2B),
              // decoration: BoxDecoration(
              //   gradient: LinearGradient(
              //       colors: [Color(0xff01024E), Colors.white],
              //       stops: [0.6, 1],
              //       begin: Alignment.topCenter,
              //       end: Alignment.bottomCenter),
              // ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          // margin: const EdgeInsets.symmetric(
                          //     horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                              color: const Color(0xffEFEFEF).withOpacity(0.5),
                              borderRadius: BorderRadius.circular(50)),
                          child: isDrawerOpen
                              ? IconButton(
                                  onPressed: () {
                                    setState(() {
                                      xOffset = 0;
                                      yOffset = 0;
                                      scaleFactor = 1;
                                      isDrawerOpen = false;
                                      val = 0;
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.keyboard_arrow_left_outlined,
                                    size: 35,
                                    color: Colors.white,
                                  ),
                                )
                              : IconButton(
                                  onPressed: () {
                                    setState(() {
                                      xOffset = rightSlide;
                                      yOffset = 110;
                                      scaleFactor = 0.7;
                                      isDrawerOpen = true;
                                      val = 1;
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.menu,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                        // ClipRRect(
                        //   borderRadius: BorderRadius.circular(25),
                        //   child: CircleAvatar(
                        //     radius: 25,
                        //     child: Image.network(
                        //       user!.photoURL.toString(),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Text(
                      "TODO-LIST",
                      style: GoogleFonts.lato(
                        textStyle:
                            const TextStyle(color: Colors.white, fontSize: 28),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: StreamBuilder<Object>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(user!.uid)
                            .collection('tasks')
                            .snapshots(),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.data!.docs.length == 0) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Container(
                                      padding: const EdgeInsets.all(10),
                                      child: Image.asset(
                                        'assets/idle.png',
                                        fit: BoxFit.contain,
                                      )),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                const Text(
                                  "CLICK THE + BUTTON TO ADD YOUR FIRST TASK",
                                  style: TextStyle(color: Colors.white),
                                ),
                                const SizedBox(
                                  height: 120,
                                ),
                              ],
                            );
                          }
                          return ListView.builder(
                            // scrollDirection: Axis.horizontal,
                            itemBuilder: (context, i) {
                              final _key = UniqueKey();
                              return InkWell(
                                onTap: () async {
                                  Navigator.of(context).pushNamed(
                                    NewTaskScreen.routeName,
                                  );
                                },
                                child: Dismissible(
                                  key: _key,
                                  background: Container(
                                    child: const Icon(
                                      Icons.delete,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.only(right: 20),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 4),
                                  ),
                                  direction: DismissDirection.endToStart,
                                  onDismissed: (direction) async {
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(user.uid)
                                        .collection('tasks')
                                        .doc(snapshot.data.docs[i].id)
                                        .delete();
                                  },
                                  child: Container(
                                    // width: 220,
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(10),
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 25),
                                    decoration: BoxDecoration(
                                      gradient: i % 2 != 0
                                          ? const LinearGradient(
                                              colors: [
                                                Color(0xffEEB76B),
                                                Color(0xffE1D89F)
                                              ],
                                              stops: [0.3, 0.7],
                                              begin: Alignment(-.0, -1),
                                              end: Alignment(-1.0, 1),
                                            )
                                          : const LinearGradient(
                                              colors: [
                                                Color(0xff3EDBF0),
                                                Color(0xff3DB2FF),
                                              ],
                                              stops: [0.3, 0.7],
                                              begin: Alignment(1.0, -1),
                                              end: Alignment(-1.0, 1),
                                            ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: SingleChildScrollView(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                snapshot.data!.docs[i]
                                                    .data()['task'],
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    fontSize: 18),
                                                overflow: TextOverflow.fade,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            UpdateScreen(i)));
                                              },
                                              icon: Icon(Icons.edit),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: snapshot.data!.docs.length,
                          );
                        }),
                  ),
                  // Expanded(
                  //   flex: 1,
                  //   child: Container(
                  //     width: double.infinity,
                  //     color: Colors.white,
                  //     child: Column(
                  //       children: [
                  //         // SizedBox(
                  //         //   height: 350,
                  //         // ),
                  //         Container(
                  //           child: Text(
                  //             "HI",
                  //           ),
                  //         )
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
