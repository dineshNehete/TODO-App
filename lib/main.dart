import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:signup_ui/screens/home.dart';
import 'package:signup_ui/screens/new_task_screen.dart';
import 'package:signup_ui/screens/todolist_screen.dart';
import 'screens/login.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return TodoScreen();
            }
            return LoginPage();
          }),
      // home: TodoScreen(),
      routes: {
        LoginPage.routeName: (ctx) => LoginPage(),
        HomePage.routeName: (ctx) => HomePage(),
        NewTaskScreen.routeName: (ctx) => NewTaskScreen(),
      },
    );
  }
}
