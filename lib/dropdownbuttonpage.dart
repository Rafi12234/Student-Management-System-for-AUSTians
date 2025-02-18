import 'package:flutter/material.dart';
import 'resultpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';

class SemesterButtonPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Semester',style: TextStyle(fontFamily: 'Font5')),
        backgroundColor: Color(0xff064a44),
        foregroundColor: Colors.white,
      ),
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff075e57),
              Color(0xff048c76),
              Color(0xff268b73),
              Color(0xff328f79),
              Color(0xff54998e)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Container(
            width: screenWidth * 0.8,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                Color(0xff075e57),
            Color(0xff057360),
            Color(0xff075e57)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 15,
                  spreadRadius: 2,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Available Semesters for Result',
                  style: TextStyle(fontSize: screenWidth*0.055,fontFamily: 'Font3'),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenHeight*0.02),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResultPage(semester: 'Spring 23'),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff075e57),
                    foregroundColor: Color(0xffe8ede8),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    textStyle: TextStyle(fontSize: screenWidth*0.038, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text('Spring 23'),
                ),
                SizedBox(height: screenHeight*0.02),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResultPage(semester: 'Fall 23'),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff075e57),
                    foregroundColor: Color(0xffe8ede8),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    textStyle: TextStyle(fontSize: screenWidth*0.038, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text('Fall 23'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
