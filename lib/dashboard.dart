import 'package:flutter/material.dart';
import 'package:project/homepage.dart';
import 'package:project/notice_portal.dart';
import 'calculator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';
import 'package:project/dropdownbuttonpage.dart';
import 'package:project/newpage.dart';
import 'package:project/chatscreen.dart';
import 'package:project/teachersinfo.dart';
import 'package:project/routine.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Get the current user
    final User? user = FirebaseAuth.instance.currentUser;
    String profileImage = 'assets/images/default_avatar.png'; // Default image
    String TextName='';
    String TextRoll='';
    // Check the email and set the corresponding image
    if (user != null) {
      if (user.email == 'shajedul.cse.20230104091@aust.edu') {
        profileImage = 'assets/images/rafi.jpeg';
      } else if (user.email == 'samanta.cse.20230104082@aust.edu') {
        profileImage = 'assets/images/samanta.jpeg';
      } else if (user.email == 'nusrat.cse.20230104089@aust.edu') {
        profileImage = 'assets/images/shanti.jpg';
      }
    }
    if (user != null) {
      if (user.email == 'shajedul.cse.20230104091@aust.edu') {
        TextName = 'Shajedul Kabir Rafi';
      } else if (user.email == 'samanta.cse.20230104082@aust.edu') {
        TextName = 'Samanta Islam';
      } else if (user.email == 'nusrat.cse.20230104089@aust.edu') {
        TextName = 'Nusrat Jahan Shanti';
      }
    }
    if (user != null) {
      if (user.email == 'shajedul.cse.20230104091@aust.edu') {
        TextRoll = 'ID: 20230104091';
      } else if (user.email == 'samanta.cse.20230104082@aust.edu') {
        TextRoll = 'ID: 20230104082';
      } else if (user.email == 'nusrat.cse.20230104089@aust.edu') {
        TextRoll = 'ID: 20230104089';
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Dashboard',style: TextStyle(fontFamily: 'Font5')),
        backgroundColor: Color(0xff064a44),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            },
          ),
        ],
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 35,top: 20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: screenWidth*0.12,
                    backgroundImage: AssetImage(profileImage),
                  ),
                  SizedBox(
                    width:  screenWidth*0.05,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(TextName,style: TextStyle(fontSize: screenWidth*0.05,fontFamily: 'Font5')),
                      Text(TextRoll,style: TextStyle(fontSize: screenWidth*0.04,fontFamily: 'Font1',color: Colors.grey,fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: screenHeight*0.06,
            ),
            Container(
              width: screenWidth,
              height: screenHeight*0.65,
              decoration: BoxDecoration(
                  color: Color(0xff075e57),
                  borderRadius: BorderRadius.circular(45)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NewPage()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Center(
                              child: Image.asset(
                                'assets/images/info.png',
                                width: screenWidth*0.35,
                                height: screenWidth*0.20,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SemesterButtonPage()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Center(
                              child: Image.asset(
                                'assets/images/result.png',
                                width: screenWidth*0.35,
                                height: screenWidth*0.23,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        NoticePortal()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Center(
                              child: Image.asset(
                                'assets/images/notice.png',
                                width: screenWidth*0.35,
                                height: screenWidth*0.23,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ClassRoutinePage()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Center(
                              child: Image.asset(
                                'assets/images/routine.png',
                                width: screenWidth*0.35,
                                height: screenWidth*0.23,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        TeacherDataPage()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Center(
                              child: Image.asset(
                                'assets/images/teacher.png',
                                width: screenWidth*0.35,
                                height: screenWidth*0.23,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ChatScreen()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Center(
                              child: Image.asset(
                                'assets/images/support.png',
                                width: screenWidth*0.35,
                                height: screenWidth*0.23,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CgpaCalculatorPage()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Center(
                              child: Image.asset(
                                'assets/images/bar.png',
                                width: screenWidth*0.35,
                                height: screenWidth*0.23,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
