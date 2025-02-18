import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';

class ResultPage extends StatefulWidget {
  final String semester;

  const ResultPage({required this.semester});

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  String? userEmail;
  late String documentId;

  @override
  void initState() {
    super.initState();
    userEmail = FirebaseAuth.instance.currentUser?.email;
    _setDocumentId();
  }

  void _setDocumentId() {
    if (userEmail == 'shajedul.cse.20230104091@aust.edu') {
      documentId = widget.semester == 'Spring 23'
          ? 'AsrcOt5cB0SwfK7DLaVH'
          : 'OZ1fO90iDygaZGoV6x9o';
    } else if (userEmail == 'samanta.cse.20230104082@aust.edu') {
      documentId = widget.semester == 'Spring 23'
          ? 'iTogBhiWSdN0La8GFHRQ'
          : 'y6DbjIwjWbBqI9ZGQD8E';
    } else if (userEmail == 'nusrat.cse.20230104089@aust.edu') {
      documentId = widget.semester == 'Spring 23'
          ? 'oXK2K3v4oot5mXPvrfFr'
          : 'NMrvGtnHFtzqpHQuq2TG';
    } else {
      documentId = ''; // If no match, leave it empty.
    }
  }

  Future<Map<String, dynamic>> fetchDocumentFields() async {
    if (documentId.isEmpty) return {};

    var doc = await FirebaseFirestore.instance
        .collection('User1')
        .doc(documentId)
        .get();
    return doc.data() ?? {};
  }

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar:AppBar(
        title: Text('Results' ),
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<Map<String, dynamic>>(
            future: fetchDocumentFields(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No data found for ${widget.semester}.'));
              }
              var userData = snapshot.data!;
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Results for ${widget.semester}:',
                      style: TextStyle(fontSize: screenWidth*0.04, fontWeight: FontWeight.bold,fontFamily: 'Font5'),
                    ),
                    SizedBox(height: screenHeight*0.02),
                    if (userEmail == 'shajedul.cse.20230104091@aust.edu') ...[
                      if (widget.semester == 'Fall 23') ...[
                        Column(
                          children: [
                            Text('CGPA OF THIS SEMESTER:',style: TextStyle(fontSize: screenWidth*0.045, fontFamily: 'Font1',fontWeight: FontWeight.bold),),
                            Text(
                              '${userData['CG'] ?? 'N/A'}',
                              style: TextStyle(fontSize: screenWidth*0.05, fontFamily: 'Font5',color: Colors.white),
                            ),
                            SizedBox(
                              height: screenHeight*0.02,
                            ),
                            Container(
                              width: screenWidth,
                              height: screenHeight*0.07,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2), // Shadow color with opacity
                                    spreadRadius: 3, // How much the shadow spreads
                                    blurRadius: 2, // Softness of the shadow
                                    offset: Offset(2, 4), // Position of the shadow (x, y)
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${userData['CSE 1203 CN'] ?? 'N/A'}',
                                      style: TextStyle(fontSize: screenWidth*0.037, fontFamily: 'Font5'),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          '${userData['CSE 1203 G'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.035, fontFamily: 'Font5'),
                                        ),
                                        Text(
                                          '${userData['CSE 1203 N'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.033, fontFamily: 'Font5'),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight*0.02,
                            ),
                            Container(
                              width: screenWidth,
                              height: screenHeight*0.07,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2), // Shadow color with opacity
                                    spreadRadius: 3, // How much the shadow spreads
                                    blurRadius: 2, // Softness of the shadow
                                    offset: Offset(2, 4), // Position of the shadow (x, y)
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${userData['CSE 1205 CN'] ?? 'N/A'}',
                                      style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          '${userData['CSE 1205 G'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                        ),
                                        Text(
                                          '${userData['CSE 1205 N'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.035,fontFamily: 'Font5'),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight*0.02,
                            ),
                            Container(
                              width: screenWidth,
                              height: screenHeight*0.07,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2), // Shadow color with opacity
                                    spreadRadius: 3, // How much the shadow spreads
                                    blurRadius: 2, // Softness of the shadow
                                    offset: Offset(2, 4), // Position of the shadow (x, y)
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${userData['EEE 1241 CN'] ?? 'N/A'}',
                                      style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          '${userData['EEE 1241 G'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                        ),
                                        Text(
                                          '${userData['EEE 1241 N'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.035,fontFamily: 'Font5'),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight*0.02,
                            ),
                            Container(
                              width: screenWidth,
                              height: screenHeight*0.07,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2), // Shadow color with opacity
                                    spreadRadius: 3, // How much the shadow spreads
                                    blurRadius: 2, // Softness of the shadow
                                    offset: Offset(2, 4), // Position of the shadow (x, y)
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${userData['MATH 1219 CN'] ?? 'N/A'}',
                                      style: TextStyle(fontSize: screenWidth*0.031,fontFamily: 'Font5'),
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          '${userData['MATH 1219 G'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.032,fontFamily: 'Font5'),
                                        ),
                                        Text(
                                          '${userData['MATH 1219 N'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.032,fontFamily: 'Font5'),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight*0.02,
                            ),
                            Container(
                              width: screenWidth,
                              height: screenHeight*0.07,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2), // Shadow color with opacity
                                    spreadRadius: 3, // How much the shadow spreads
                                    blurRadius: 2, // Softness of the shadow
                                    offset: Offset(2, 4), // Position of the shadow (x, y)
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${userData['ME 1211 CN'] ?? 'N/A'}',
                                      style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          '${userData['ME 1211 G'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                        ),
                                        Text(
                                          '${userData['ME 1211 N'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.035,fontFamily: 'Font5'),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight*0.02,
                            ),
                            Container(
                              width: screenWidth,
                              height: screenHeight*0.07,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2), // Shadow color with opacity
                                    spreadRadius: 3, // How much the shadow spreads
                                    blurRadius: 2, // Softness of the shadow
                                    offset: Offset(2, 4), // Position of the shadow (x, y)
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${userData['CSE 1200 CN'] ?? 'N/A'}',
                                      style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          '${userData['CSE 1200 G'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                        ),
                                        Text(
                                          '${userData['CSE 1200 N'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.035,fontFamily: 'Font5'),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight*0.02,
                            ),
                            Container(
                              width: screenWidth,
                              height: screenHeight*0.07,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2), // Shadow color with opacity
                                    spreadRadius: 3, // How much the shadow spreads
                                    blurRadius: 2, // Softness of the shadow
                                    offset: Offset(2, 4), // Position of the shadow (x, y)
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${userData['CSE 1206 CN'] ?? 'N/A'}',
                                      style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          '${userData['CSE 1206 G'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                        ),
                                        Text(
                                          '${userData['CSE 1206 N'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.035,fontFamily: 'Font5'),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight*0.02,
                            ),
                            Container(
                              width: screenWidth,
                              height: screenHeight*0.07,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2), // Shadow color with opacity
                                    spreadRadius: 3, // How much the shadow spreads
                                    blurRadius: 2, // Softness of the shadow
                                    offset: Offset(2, 4), // Position of the shadow (x, y)
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${userData['EEE 1242 CN'] ?? 'N/A'}',
                                      style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          '${userData['EEE 1242 G'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                        ),
                                        Text(
                                          '${userData['EEE 1242 N'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.035,fontFamily: 'Font5'),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight*0.02,
                            ),
                            Container(
                              width: screenWidth,
                              height: screenHeight*0.07,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2), // Shadow color with opacity
                                    spreadRadius: 3, // How much the shadow spreads
                                    blurRadius: 2, // Softness of the shadow
                                    offset: Offset(2, 4), // Position of the shadow (x, y)
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${userData['ME 1214 CN'] ?? 'N/A'}',
                                      style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          '${userData['ME 1214 G'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                        ),
                                        Text(
                                          '${userData['ME 1214 N'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.035,fontFamily: 'Font5'),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ] else if (widget.semester == 'Spring 23') ...[
                        Column(
                          children: [
                              Text('CGPA of this SEMESTER:',style: TextStyle(fontSize: screenWidth*0.045, fontFamily: 'Font1',fontWeight: FontWeight.bold),),
                            Text(
                              '${userData['CG'] ?? 'N/A'}',
                              style: TextStyle(fontSize: screenWidth*0.05, fontFamily: 'Font5',color: Colors.white),
                            ),
                            SizedBox(
                              height: screenHeight*0.02,
                            ),
                            Container(
                                width: screenWidth,
                                height: screenHeight*0.07,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2), // Shadow color with opacity
                                    spreadRadius: 3, // How much the shadow spreads
                                    blurRadius: 2, // Softness of the shadow
                                    offset: Offset(2, 4), // Position of the shadow (x, y)
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${userData['CHEM 1115 CN'] ?? 'N/A'}',
                                      style: TextStyle(fontSize: screenWidth*0.037, fontFamily: 'Font5'),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          '${userData['CHEM 1115 G'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.037, fontFamily: 'Font5'),
                                        ),
                                        Text(
                                          '${userData['CHEM 1115 N'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.035, fontFamily: 'Font5'),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight*0.02,
                            ),
                            Container(
                              width: screenWidth,
                              height: screenHeight*0.07,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2), // Shadow color with opacity
                                    spreadRadius: 3, // How much the shadow spreads
                                    blurRadius: 2, // Softness of the shadow
                                    offset: Offset(2, 4), // Position of the shadow (x, y)
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${userData['CSE 1101 CN'] ?? 'N/A'}',
                                      style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          '${userData['CSE 1101 G'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                        ),
                                        Text(
                                          '${userData['CSE 1101 N'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.035,fontFamily: 'Font5'),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight*0.02,
                            ),
                            Container(
                              width: screenWidth,
                              height: screenHeight*0.07,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2), // Shadow color with opacity
                                    spreadRadius: 3, // How much the shadow spreads
                                    blurRadius: 2, // Softness of the shadow
                                    offset: Offset(2, 4), // Position of the shadow (x, y)
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${userData['HUM 1107 CN'] ?? 'N/A'}',
                                      style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          '${userData['HUM 1107 G'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                        ),
                                        Text(
                                          '${userData['HUM 1107 N'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.035,fontFamily: 'Font5'),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight*0.02,
                            ),
                            Container(
                              width: screenWidth,
                              height: screenHeight*0.07,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2), // Shadow color with opacity
                                    spreadRadius: 3, // How much the shadow spreads
                                    blurRadius: 2, // Softness of the shadow
                                    offset: Offset(2, 4), // Position of the shadow (x, y)
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${userData['MATH 1115 CN'] ?? 'N/A'}',
                                      style: TextStyle(fontSize: screenWidth*0.030,fontFamily: 'Font5'),
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          '${userData['MATH 1115 G'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.029,fontFamily: 'Font5'),
                                        ),
                                        Text(
                                          '${userData['MATH 1115 N'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.030,fontFamily: 'Font5'),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight*0.02,
                            ),
                            Container(
                              width: screenWidth,
                              height: screenHeight*0.07,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2), // Shadow color with opacity
                                    spreadRadius: 3, // How much the shadow spreads
                                    blurRadius: 2, // Softness of the shadow
                                    offset: Offset(2, 4), // Position of the shadow (x, y)
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${userData['PHY 1115 CN'] ?? 'N/A'}',
                                      style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          '${userData['PHY 1115 G'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                        ),
                                        Text(
                                          '${userData['PHY 1115 N'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.035,fontFamily: 'Font5'),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight*0.02,
                            ),
                            Container(
                              width: screenWidth,
                              height: screenHeight*0.07,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2), // Shadow color with opacity
                                    spreadRadius: 3, // How much the shadow spreads
                                    blurRadius: 2, // Softness of the shadow
                                    offset: Offset(2, 4), // Position of the shadow (x, y)
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${userData['CSE 1102 CN'] ?? 'N/A'}',
                                      style: TextStyle(fontSize: screenWidth*0.034,fontFamily: 'Font5'),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          '${userData['CSE 1102 G'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                        ),
                                        Text(
                                          '${userData['CSE 1102 N'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.035,fontFamily: 'Font5'),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight*0.02,
                            ),
                            Container(
                              width: screenWidth,
                              height: screenHeight*0.07,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2), // Shadow color with opacity
                                    spreadRadius: 3, // How much the shadow spreads
                                    blurRadius: 2, // Softness of the shadow
                                    offset: Offset(2, 4), // Position of the shadow (x, y)
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${userData['CSE 1108 CN'] ?? 'N/A'}',
                                      style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          '${userData['CSE 1108 G'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                        ),
                                        Text(
                                          '${userData['CSE 1108 N'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.035,fontFamily: 'Font5'),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight*0.02,
                            ),
                            Container(
                              width: screenWidth,
                              height: screenHeight*0.07,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2), // Shadow color with opacity
                                    spreadRadius: 3, // How much the shadow spreads
                                    blurRadius: 2, // Softness of the shadow
                                    offset: Offset(2, 4), // Position of the shadow (x, y)
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${userData['HUM 1108 CN'] ?? 'N/A'}',
                                      style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          '${userData['HUM 1108 G'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                        ),
                                        Text(
                                          '${userData['HUM 1108 N'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.035,fontFamily: 'Font5'),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight*0.02,
                            ),
                            Container(
                              width: screenWidth,
                              height: screenHeight*0.07,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2), // Shadow color with opacity
                                    spreadRadius: 3, // How much the shadow spreads
                                    blurRadius: 2, // Softness of the shadow
                                    offset: Offset(2, 4), // Position of the shadow (x, y)
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${userData['PHY 1116 CN'] ?? 'N/A'}',
                                      style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          '${userData['PHY 1116 G'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                        ),
                                        Text(
                                          '${userData['PHY 1116 N'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.035,fontFamily: 'Font5'),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ] else if (userEmail == 'samanta.cse.20230104082@aust.edu') ...[
                      if (widget.semester == 'Fall 23') ...[
                        Column(
                          children: [
                            Text('CGPA OF THIS SEMESTER:',style: TextStyle(fontSize: screenWidth*0.045, fontFamily: 'Font1',fontWeight: FontWeight.bold),),
                            Text(
                              '${userData['CG'] ?? 'N/A'}',
                              style: TextStyle(fontSize: screenWidth*0.05, fontFamily: 'Font5',color: Colors.white),
                            ),
                            SizedBox(
                              height: screenHeight*0.02,
                            ),
                            Container(
                              width: screenWidth*0.93,
                              height: screenHeight*0.07,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2), // Shadow color with opacity
                                    spreadRadius: 3, // How much the shadow spreads
                                    blurRadius: 2, // Softness of the shadow
                                    offset: Offset(2, 4), // Position of the shadow (x, y)
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${userData['CSE 1203 CN'] ?? 'N/A'}',
                                      style: TextStyle(fontSize: screenWidth*0.037, fontFamily: 'Font5'),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          '${userData['CSE 1203 G'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.035, fontFamily: 'Font5'),
                                        ),
                                        Text(
                                          '${userData['CSE 1203 N'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.033, fontFamily: 'Font5'),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight*0.02,
                            ),
                            Container(
                              width: screenWidth*0.93,
                              height: screenHeight*0.07,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2), // Shadow color with opacity
                                    spreadRadius: 3, // How much the shadow spreads
                                    blurRadius: 2, // Softness of the shadow
                                    offset: Offset(2, 4), // Position of the shadow (x, y)
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${userData['CSE 1205 CN'] ?? 'N/A'}',
                                      style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          '${userData['CSE 1205 G'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                        ),
                                        Text(
                                          '${userData['CSE 1205 N'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.035,fontFamily: 'Font5'),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight*0.02,
                            ),
                            Container(
                              width: screenWidth*0.93,
                              height: screenHeight*0.07,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2), // Shadow color with opacity
                                    spreadRadius: 3, // How much the shadow spreads
                                    blurRadius: 2, // Softness of the shadow
                                    offset: Offset(2, 4), // Position of the shadow (x, y)
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${userData['EEE 1241 CN'] ?? 'N/A'}',
                                      style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          '${userData['EEE 1241 G'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                        ),
                                        Text(
                                          '${userData['EEE 1241 N'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.035,fontFamily: 'Font5'),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight*0.02,
                            ),
                            Container(
                              width: screenWidth*0.93,
                              height: screenHeight*0.07,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2), // Shadow color with opacity
                                    spreadRadius: 3, // How much the shadow spreads
                                    blurRadius: 2, // Softness of the shadow
                                    offset: Offset(2, 4), // Position of the shadow (x, y)
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${userData['MATH 1219 CN'] ?? 'N/A'}',
                                      style: TextStyle(fontSize: screenWidth*0.031,fontFamily: 'Font5'),
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          '${userData['MATH 1219 G'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.032,fontFamily: 'Font5'),
                                        ),
                                        Text(
                                          '${userData['MATH 1219 N'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.032,fontFamily: 'Font5'),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight*0.02,
                            ),
                            Container(
                              width: screenWidth*0.93,
                              height: screenHeight*0.07,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2), // Shadow color with opacity
                                    spreadRadius: 3, // How much the shadow spreads
                                    blurRadius: 2, // Softness of the shadow
                                    offset: Offset(2, 4), // Position of the shadow (x, y)
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${userData['ME 1211 CN'] ?? 'N/A'}',
                                      style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          '${userData['ME 1211 G'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                        ),
                                        Text(
                                          '${userData['ME 1211 N'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.035,fontFamily: 'Font5'),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight*0.02,
                            ),
                            Container(
                              width: screenWidth*0.93,
                              height: screenHeight*0.07,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2), // Shadow color with opacity
                                    spreadRadius: 3, // How much the shadow spreads
                                    blurRadius: 2, // Softness of the shadow
                                    offset: Offset(2, 4), // Position of the shadow (x, y)
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${userData['CSE 1200 CN'] ?? 'N/A'}',
                                      style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          '${userData['CSE 1200 G'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                        ),
                                        Text(
                                          '${userData['CSE 1200 N'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.035,fontFamily: 'Font5'),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight*0.02,
                            ),
                            Container(
                              width: screenWidth*0.93,
                              height: screenHeight*0.07,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2), // Shadow color with opacity
                                    spreadRadius: 3, // How much the shadow spreads
                                    blurRadius: 2, // Softness of the shadow
                                    offset: Offset(2, 4), // Position of the shadow (x, y)
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${userData['CSE 1206 CN'] ?? 'N/A'}',
                                      style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          '${userData['CSE 1206 G'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                        ),
                                        Text(
                                          '${userData['CSE 1206 N'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.035,fontFamily: 'Font5'),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight*0.02,
                            ),
                            Container(
                              width: screenWidth*0.93,
                              height: screenHeight*0.07,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2), // Shadow color with opacity
                                    spreadRadius: 3, // How much the shadow spreads
                                    blurRadius: 2, // Softness of the shadow
                                    offset: Offset(2, 4), // Position of the shadow (x, y)
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${userData['EEE 1242 CN'] ?? 'N/A'}',
                                      style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          '${userData['EEE 1242 G'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                        ),
                                        Text(
                                          '${userData['EEE 1242 N'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.035,fontFamily: 'Font5'),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight*0.02,
                            ),
                            Container(
                              width: screenWidth*0.93,
                              height: screenHeight*0.07,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2), // Shadow color with opacity
                                    spreadRadius: 3, // How much the shadow spreads
                                    blurRadius: 2, // Softness of the shadow
                                    offset: Offset(2, 4), // Position of the shadow (x, y)
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${userData['ME 1214 CN'] ?? 'N/A'}',
                                      style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          '${userData['ME 1214 G'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                        ),
                                        Text(
                                          '${userData['ME 1214 N'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.035,fontFamily: 'Font5'),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      ] else if (widget.semester == 'Spring 23') ...[
                        Column(
                          children: [
                            Text('CGPA of this SEMESTER:',style: TextStyle(fontSize: screenWidth*0.045, fontFamily: 'Font1',fontWeight: FontWeight.bold),),
                            Text(
                              '${userData['CG'] ?? 'N/A'}',
                              style: TextStyle(fontSize: screenWidth*0.05, fontFamily: 'Font5',color: Colors.white),
                            ),
                            SizedBox(
                              height: screenHeight*0.02,
                            ),
                            Container(
                              width: screenWidth*0.93,
                              height: screenHeight*0.07,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2), // Shadow color with opacity
                                    spreadRadius: 3, // How much the shadow spreads
                                    blurRadius: 2, // Softness of the shadow
                                    offset: Offset(2, 4), // Position of the shadow (x, y)
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${userData['CHEM 1115 CN'] ?? 'N/A'}',
                                      style: TextStyle(fontSize: screenWidth*0.037, fontFamily: 'Font5'),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          '${userData['CHEM 1115 G'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.037, fontFamily: 'Font5'),
                                        ),
                                        Text(
                                          '${userData['CHEM 1115 N'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.035, fontFamily: 'Font5'),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight*0.02,
                            ),
                            Container(
                              width: screenWidth*0.93,
                              height: screenHeight*0.07,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2), // Shadow color with opacity
                                    spreadRadius: 3, // How much the shadow spreads
                                    blurRadius: 2, // Softness of the shadow
                                    offset: Offset(2, 4), // Position of the shadow (x, y)
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${userData['CSE 1101 CN'] ?? 'N/A'}',
                                      style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          '${userData['CSE 1101 G'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                        ),
                                        Text(
                                          '${userData['CSE 1101 N'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.035,fontFamily: 'Font5'),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight*0.02,
                            ),
                            Container(
                              width: screenWidth*0.93,
                              height: screenHeight*0.07,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2), // Shadow color with opacity
                                    spreadRadius: 3, // How much the shadow spreads
                                    blurRadius: 2, // Softness of the shadow
                                    offset: Offset(2, 4), // Position of the shadow (x, y)
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${userData['HUM 1107 CN'] ?? 'N/A'}',
                                      style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          '${userData['HUM 1107 G'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                        ),
                                        Text(
                                          '${userData['HUM 1107 N'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.035,fontFamily: 'Font5'),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight*0.02,
                            ),
                            Container(
                              width: screenWidth*0.93,
                              height: screenHeight*0.07,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2), // Shadow color with opacity
                                    spreadRadius: 3, // How much the shadow spreads
                                    blurRadius: 2, // Softness of the shadow
                                    offset: Offset(2, 4), // Position of the shadow (x, y)
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${userData['MATH 1115 CN'] ?? 'N/A'}',
                                      style: TextStyle(fontSize: screenWidth*0.030,fontFamily: 'Font5'),
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          '${userData['MATH 1115 G'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.028,fontFamily: 'Font5'),
                                        ),
                                        Text(
                                          '${userData['MATH 1115 N'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.028,fontFamily: 'Font5'),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight*0.02,
                            ),
                            Container(
                              width: screenWidth*0.93,
                              height: screenHeight*0.07,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2), // Shadow color with opacity
                                    spreadRadius: 3, // How much the shadow spreads
                                    blurRadius: 2, // Softness of the shadow
                                    offset: Offset(2, 4), // Position of the shadow (x, y)
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${userData['PHY 1115 CN'] ?? 'N/A'}',
                                      style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          '${userData['PHY 1115 G'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                        ),
                                        Text(
                                          '${userData['PHY 1115 N'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.035,fontFamily: 'Font5'),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight*0.02,
                            ),
                            Container(
                              width: screenWidth*0.93,
                              height: screenHeight*0.07,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2), // Shadow color with opacity
                                    spreadRadius: 3, // How much the shadow spreads
                                    blurRadius: 2, // Softness of the shadow
                                    offset: Offset(2, 4), // Position of the shadow (x, y)
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${userData['CSE 1102 CN'] ?? 'N/A'}',
                                      style: TextStyle(fontSize: screenWidth*0.033,fontFamily: 'Font5'),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          '${userData['CSE 1102 G'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                        ),
                                        Text(
                                          '${userData['CSE 1102 N'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.035,fontFamily: 'Font5'),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight*0.02,
                            ),
                            Container(
                              width: screenWidth*0.93,
                              height: screenHeight*0.07,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2), // Shadow color with opacity
                                    spreadRadius: 3, // How much the shadow spreads
                                    blurRadius: 2, // Softness of the shadow
                                    offset: Offset(2, 4), // Position of the shadow (x, y)
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${userData['CSE 1108 CN'] ?? 'N/A'}',
                                      style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          '${userData['CSE 1108 G'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                        ),
                                        Text(
                                          '${userData['CSE 1108 N'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.035,fontFamily: 'Font5'),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight*0.02,
                            ),
                            Container(
                              width: screenWidth*0.93,
                              height: screenHeight*0.07,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2), // Shadow color with opacity
                                    spreadRadius: 3, // How much the shadow spreads
                                    blurRadius: 2, // Softness of the shadow
                                    offset: Offset(2, 4), // Position of the shadow (x, y)
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${userData['HUM 1108 CN'] ?? 'N/A'}',
                                      style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          '${userData['HUM 1108 G'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                        ),
                                        Text(
                                          '${userData['HUM 1108 N'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.035,fontFamily: 'Font5'),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight*0.02,
                            ),
                            Container(
                              width: screenWidth*0.93,
                              height: screenHeight*0.07,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2), // Shadow color with opacity
                                    spreadRadius: 3, // How much the shadow spreads
                                    blurRadius: 2, // Softness of the shadow
                                    offset: Offset(2, 4), // Position of the shadow (x, y)
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${userData['PHY 1116 CN'] ?? 'N/A'}',
                                      style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          '${userData['PHY 1116 G'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                        ),
                                        Text(
                                          '${userData['PHY 1116 N'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.035,fontFamily: 'Font5'),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ] else if (userEmail == 'nusrat.cse.20230104089@aust.edu') ...[
                      if (widget.semester == 'Fall 23') ...[
                        Column(
                          children: [
                            Text('CGPA OF THIS SEMESTER:',style: TextStyle(fontSize: screenWidth*0.045, fontFamily: 'Font1',fontWeight: FontWeight.bold),),
                            Text(
                              '${userData['CG'] ?? 'N/A'}',
                              style: TextStyle(fontSize: screenWidth*0.05, fontFamily: 'Font5',color: Colors.white),
                            ),
                            SizedBox(
                              height: screenHeight*0.02,
                            ),
                            Container(
                              width: screenWidth*0.93,
                              height: screenHeight*0.07,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2), // Shadow color with opacity
                                    spreadRadius: 3, // How much the shadow spreads
                                    blurRadius: 2, // Softness of the shadow
                                    offset: Offset(2, 4), // Position of the shadow (x, y)
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${userData['CSE 1203 CN'] ?? 'N/A'}',
                                      style: TextStyle(fontSize: screenWidth*0.037, fontFamily: 'Font5'),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          '${userData['CSE 1203 G'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.035, fontFamily: 'Font5'),
                                        ),
                                        Text(
                                          '${userData['CSE 1203 N'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.033, fontFamily: 'Font5'),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight*0.02,
                            ),
                            Container(
                              width: screenWidth*0.93,
                              height: screenHeight*0.07,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2), // Shadow color with opacity
                                    spreadRadius: 3, // How much the shadow spreads
                                    blurRadius: 2, // Softness of the shadow
                                    offset: Offset(2, 4), // Position of the shadow (x, y)
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${userData['CSE 1205 CN'] ?? 'N/A'}',
                                      style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          '${userData['CSE 1205 G'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                        ),
                                        Text(
                                          '${userData['CSE 1205 N'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.035,fontFamily: 'Font5'),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight*0.02,
                            ),
                            Container(
                              width: screenWidth*0.93,
                              height: screenHeight*0.07,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2), // Shadow color with opacity
                                    spreadRadius: 3, // How much the shadow spreads
                                    blurRadius: 2, // Softness of the shadow
                                    offset: Offset(2, 4), // Position of the shadow (x, y)
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${userData['EEE 1241 CN'] ?? 'N/A'}',
                                      style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          '${userData['EEE 1241 G'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                        ),
                                        Text(
                                          '${userData['EEE 1241 N'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.035,fontFamily: 'Font5'),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight*0.02,
                            ),
                            Container(
                              width: screenWidth*0.93,
                              height: screenHeight*0.07,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2), // Shadow color with opacity
                                    spreadRadius: 3, // How much the shadow spreads
                                    blurRadius: 2, // Softness of the shadow
                                    offset: Offset(2, 4), // Position of the shadow (x, y)
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${userData['MATH 1219 CN'] ?? 'N/A'}',
                                      style: TextStyle(fontSize: screenWidth*0.031,fontFamily: 'Font5'),
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          '${userData['MATH 1219 G'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.032,fontFamily: 'Font5'),
                                        ),
                                        Text(
                                          '${userData['MATH 1219 N'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.032,fontFamily: 'Font5'),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight*0.02,
                            ),
                            Container(
                              width: screenWidth*0.93,
                              height: screenHeight*0.07,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2), // Shadow color with opacity
                                    spreadRadius: 3, // How much the shadow spreads
                                    blurRadius: 2, // Softness of the shadow
                                    offset: Offset(2, 4), // Position of the shadow (x, y)
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${userData['ME 1211 CN'] ?? 'N/A'}',
                                      style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          '${userData['ME 1211 G'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                        ),
                                        Text(
                                          '${userData['ME 1211 N'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.035,fontFamily: 'Font5'),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight*0.02,
                            ),
                            Container(
                              width: screenWidth*0.93,
                              height: screenHeight*0.07,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2), // Shadow color with opacity
                                    spreadRadius: 3, // How much the shadow spreads
                                    blurRadius: 2, // Softness of the shadow
                                    offset: Offset(2, 4), // Position of the shadow (x, y)
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${userData['CSE 1200 CN'] ?? 'N/A'}',
                                      style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          '${userData['CSE 1200 G'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                        ),
                                        Text(
                                          '${userData['CSE 1200 N'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.035,fontFamily: 'Font5'),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight*0.02,
                            ),
                            Container(
                              width: screenWidth*0.93,
                              height: screenHeight*0.07,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2), // Shadow color with opacity
                                    spreadRadius: 3, // How much the shadow spreads
                                    blurRadius: 2, // Softness of the shadow
                                    offset: Offset(2, 4), // Position of the shadow (x, y)
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${userData['CSE 1206 CN'] ?? 'N/A'}',
                                      style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          '${userData['CSE 1206 G'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                        ),
                                        Text(
                                          '${userData['CSE 1206 N'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.035,fontFamily: 'Font5'),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight*0.02,
                            ),
                            Container(
                              width: screenWidth*0.93,
                              height: screenHeight*0.07,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2), // Shadow color with opacity
                                    spreadRadius: 3, // How much the shadow spreads
                                    blurRadius: 2, // Softness of the shadow
                                    offset: Offset(2, 4), // Position of the shadow (x, y)
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${userData['EEE 1242 CN'] ?? 'N/A'}',
                                      style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          '${userData['EEE 1242 G'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                        ),
                                        Text(
                                          '${userData['EEE 1242 N'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.035,fontFamily: 'Font5'),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight*0.02,
                            ),
                            Container(
                              width: screenWidth*0.93,
                              height: screenHeight*0.07,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2), // Shadow color with opacity
                                    spreadRadius: 3, // How much the shadow spreads
                                    blurRadius: 2, // Softness of the shadow
                                    offset: Offset(2, 4), // Position of the shadow (x, y)
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${userData['ME 1214 CN'] ?? 'N/A'}',
                                      style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          '${userData['ME 1214 G'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                        ),
                                        Text(
                                          '${userData['ME 1214 N'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.035,fontFamily: 'Font5'),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      ] else if (widget.semester == 'Spring 23') ...[
                        Column(
                          children: [
                            Text('CGPA of this SEMESTER:',style: TextStyle(fontSize: screenWidth*0.045, fontFamily: 'Font1',fontWeight: FontWeight.bold),),
                            Text(
                              '${userData['CG'] ?? 'N/A'}',
                              style: TextStyle(fontSize: screenWidth*0.05, fontFamily: 'Font5',color: Colors.white),
                            ),
                            SizedBox(
                              height: screenHeight*0.02,
                            ),
                            Container(
                              width: screenWidth*0.93,
                              height: screenHeight*0.07,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2), // Shadow color with opacity
                                    spreadRadius: 3, // How much the shadow spreads
                                    blurRadius: 2, // Softness of the shadow
                                    offset: Offset(2, 4), // Position of the shadow (x, y)
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${userData['CHEM 1115 CN'] ?? 'N/A'}',
                                      style: TextStyle(fontSize: screenWidth*0.037, fontFamily: 'Font5'),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          '${userData['CHEM 1115 G'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.037, fontFamily: 'Font5'),
                                        ),
                                         Text(
                                          '${userData['CHEM 1115 N'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.035, fontFamily: 'Font5'),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight*0.02,
                            ),
                            Container(
                              width: screenWidth*0.93,
                              height: screenHeight*0.07,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2), // Shadow color with opacity
                                    spreadRadius: 3, // How much the shadow spreads
                                    blurRadius: 2, // Softness of the shadow
                                    offset: Offset(2, 4), // Position of the shadow (x, y)
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${userData['CSE 1101 CN'] ?? 'N/A'}',
                                      style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          '${userData['CSE 1101 G'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                        ),
                                        Text(
                                          '${userData['CSE 1101 N'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.035,fontFamily: 'Font5'),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight*0.02,
                            ),
                            Container(
                              width: screenWidth*0.93,
                              height: screenHeight*0.07,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2), // Shadow color with opacity
                                    spreadRadius: 3, // How much the shadow spreads
                                    blurRadius: 2, // Softness of the shadow
                                    offset: Offset(2, 4), // Position of the shadow (x, y)
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${userData['HUM 1107 CN'] ?? 'N/A'}',
                                      style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          '${userData['HUM 1107 G'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                        ),
                                        Text(
                                          '${userData['HUM 1107 N'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.035,fontFamily: 'Font5'),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight*0.02,
                            ),
                            Container(
                              width: screenWidth*0.93,
                              height: screenHeight*0.07,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2), // Shadow color with opacity
                                    spreadRadius: 3, // How much the shadow spreads
                                    blurRadius: 2, // Softness of the shadow
                                    offset: Offset(2, 4), // Position of the shadow (x, y)
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${userData['MATH 1115 CN'] ?? 'N/A'}',
                                      style: TextStyle(fontSize: screenWidth*0.029,fontFamily: 'Font5'),
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          '${userData['MATH 1115 G'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.029,fontFamily: 'Font5'),
                                        ),
                                        Text(
                                          '${userData['MATH 1115 N'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.030,fontFamily: 'Font5'),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight*0.02,
                            ),
                            Container(
                              width: screenWidth*0.93,
                              height: screenHeight*0.07,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2), // Shadow color with opacity
                                    spreadRadius: 3, // How much the shadow spreads
                                    blurRadius: 2, // Softness of the shadow
                                    offset: Offset(2, 4), // Position of the shadow (x, y)
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${userData['PHY 1115 CN'] ?? 'N/A'}',
                                      style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          '${userData['PHY 1115 G'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                        ),
                                        Text(
                                          '${userData['PHY 1115 N'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.035,fontFamily: 'Font5'),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight*0.02,
                            ),
                            Container(
                              width: screenWidth*0.93,
                              height: screenHeight*0.07,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2), // Shadow color with opacity
                                    spreadRadius: 3, // How much the shadow spreads
                                    blurRadius: 2, // Softness of the shadow
                                    offset: Offset(2, 4), // Position of the shadow (x, y)
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${userData['CSE 1102 CN'] ?? 'N/A'}',
                                      style: TextStyle(fontSize: screenWidth*0.030,fontFamily: 'Font5'),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          '${userData['CSE 1102 G'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.034,fontFamily: 'Font5'),
                                        ),
                                        Text(
                                          '${userData['CSE 1102 N'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.034,fontFamily: 'Font5'),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight*0.02,
                            ),
                            Container(
                              width: screenWidth*0.93,
                              height: screenHeight*0.07,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2), // Shadow color with opacity
                                    spreadRadius: 3, // How much the shadow spreads
                                    blurRadius: 2, // Softness of the shadow
                                    offset: Offset(2, 4), // Position of the shadow (x, y)
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${userData['CSE 1108 CN'] ?? 'N/A'}',
                                      style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          '${userData['CSE 1108 G'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                        ),
                                        Text(
                                          '${userData['CSE 1108 N'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.035,fontFamily: 'Font5'),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight*0.02,
                            ),
                            Container(
                              width: screenWidth*0.93,
                              height: screenHeight*0.07,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2), // Shadow color with opacity
                                    spreadRadius: 3, // How much the shadow spreads
                                    blurRadius: 2, // Softness of the shadow
                                    offset: Offset(2, 4), // Position of the shadow (x, y)
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${userData['HUM 1108 CN'] ?? 'N/A'}',
                                      style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          '${userData['HUM 1108 G'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                        ),
                                        Text(
                                          '${userData['HUM 1108 N'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.035,fontFamily: 'Font5'),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight*0.02,
                            ),
                            Container(
                              width: screenWidth*0.93,
                              height: screenHeight*0.07,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2), // Shadow color with opacity
                                    spreadRadius: 3, // How much the shadow spreads
                                    blurRadius: 2, // Softness of the shadow
                                    offset: Offset(2, 4), // Position of the shadow (x, y)
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${userData['PHY 1116 CN'] ?? 'N/A'}',
                                      style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          '${userData['PHY 1116 G'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.037,fontFamily: 'Font5'),
                                        ),
                                        Text(
                                          '${userData['PHY 1116 N'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: screenWidth*0.035,fontFamily: 'Font5'),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ],
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
