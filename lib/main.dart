import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project/login.dart';
import 'splashScreen.dart';
import 'package:project/routine.dart';
import 'animationpage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IUMS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(), // Your existing splash screen
    );
  }
}