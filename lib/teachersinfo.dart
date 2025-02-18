import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TeacherDataPage extends StatefulWidget {
  const TeacherDataPage({super.key});

  @override
  State<TeacherDataPage> createState() => _TeacherDataPageState();
}

class _TeacherDataPageState extends State<TeacherDataPage> {
  final List<String> authorizedEmails = [
    'shajedul.cse.20230104091@aust.edu',
    'samanta.cse.20230104082@aust.edu',
    'nusrat.cse.20230104089@aust.edu',
  ];

  late Future<Map<String, dynamic>> teacherData;

  @override
  void initState() {
    super.initState();
    teacherData = fetchTeacherData();
  }

  Future<Map<String, dynamic>> fetchTeacherData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null && authorizedEmails.contains(user.email)) {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('Teachers')
          .doc('p99UrcnFsFsMZ7Tbtpvo')
          .get();

      return doc.data() as Map<String, dynamic>? ?? {};
    }
    return {};
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff064a44),
        foregroundColor: Colors.white,
        title: Text("Teachers' Informations",style: TextStyle(color: Colors.white,fontFamily: 'Font5',fontSize: screenWidth*0.050),),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: teacherData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final user = FirebaseAuth.instance.currentUser;
          if (!authorizedEmails.contains(user?.email)) {
            return const Center(
              child: Text('You are not authorized to view this information'),
            );
          }

          final data = snapshot.data!;
          if (data.isEmpty) {
            return const Center(child: Text('No data found'));
          }

          return Container(
            width: screenHeight,
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
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: EdgeInsets.all(screenWidth * 0.04),
                child: Column(
                  
                  children: [
                    Container(
                      width: screenWidth,
                      height: screenHeight*0.4,
                      decoration: BoxDecoration(
                        color: Color(0xff54998e),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: screenWidth*0.89,
                              height: screenHeight*0.05,
                              decoration: BoxDecoration(
                                color: Color(0xff08857a),
                                borderRadius: BorderRadius.circular(20)
                              ),
                              child: Center(
                                child: Text(
                                  data['Ds CN'] ?? 'N/A',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.07,
                                    fontFamily: 'Font6',
                                    color: Color(0xff5accc2),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          CircleAvatar(
                            radius: screenWidth*0.14,
                            backgroundImage: AssetImage('assets/images/rabMadam.png'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Teacher Name:',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontFamily: 'Font5',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Text(
                                        data['Ds TN'] ?? 'N/A',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          fontFamily: 'Font5',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: screenWidth * 0.04),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Designation:',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontFamily: 'Font5',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Text(
                                        data['Ds Deg'] ?? 'N/A',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          fontFamily: 'Font5',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: screenWidth * 0.04),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Teacher's Email:",
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontFamily: 'Font5',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Text(
                                        data['Ds Email'] ?? 'N/A',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          fontFamily: 'Font5',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: screenWidth * 0.04),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Room No:',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontFamily: 'Font5',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8 ),
                                      child: Text(
                                        data['Ds room'] ?? 'N/A',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          fontFamily: 'Font5',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenWidth * 0.04),
                    Container(
                      width: screenWidth,
                      height: screenHeight*0.4,
                      decoration: BoxDecoration(
                        color: Color(0xff54998e),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: screenWidth*0.89,
                              height: screenHeight*0.05,
                              decoration: BoxDecoration(
                                  color: Color(0xff08857a),
                                  borderRadius: BorderRadius.circular(20)
                              ),
                              child: Center(
                                child: Text(
                                  data['Dld CN'] ?? 'N/A',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.07,
                                    fontFamily: 'Font6',
                                    color: Color(0xff5accc2),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          CircleAvatar(
                            radius: screenWidth*0.14,
                            backgroundImage: AssetImage('assets/images/dldMadam.png'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Teacher Name:',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontFamily: 'Font5',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Text(
                                        data['Dld TN'] ?? 'N/A',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          fontFamily: 'Font5',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: screenWidth * 0.04),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Designation:',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontFamily: 'Font5',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Text(
                                        data['Dld Deg'] ?? 'N/A',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          fontFamily: 'Font5',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: screenWidth * 0.04),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Teacher's Email:",
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontFamily: 'Font5',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Text(
                                        data['Dld Email'] ?? 'N/A',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          fontFamily: 'Font5',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: screenWidth * 0.04),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Room No:',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontFamily: 'Font5',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8 ),
                                      child: Text(
                                        data['Dld room'] ?? 'N/A',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          fontFamily: 'Font5',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenWidth * 0.04),
                    Container(
                      width: screenWidth,
                      height: screenHeight*0.4,
                      decoration: BoxDecoration(
                        color: Color(0xff54998e),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: screenWidth*0.89,
                              height: screenHeight*0.05,
                              decoration: BoxDecoration(
                                  color: Color(0xff08857a),
                                  borderRadius: BorderRadius.circular(20)
                              ),
                              child: Center(
                                child: Text(
                                  data['Eee CN'] ?? 'N/A',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.055,
                                    fontFamily: 'Font6',
                                    color: Color(0xff5accc2),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          CircleAvatar(
                            radius: screenWidth*0.14,
                            backgroundImage: AssetImage('assets/images/eeeSir.png'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Teacher Name:',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontFamily: 'Font5',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Text(
                                        data['Eee TN'] ?? 'N/A',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.038,
                                          fontFamily: 'Font5',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: screenWidth * 0.038),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Designation:',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontFamily: 'Font5',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Text(
                                        data['Eee Deg'] ?? 'N/A',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          fontFamily: 'Font5',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: screenWidth * 0.04),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Teacher's Email:",
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontFamily: 'Font5',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Text(
                                        data['Eee Email'] ?? 'N/A',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.034,
                                          fontFamily: 'Font5',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: screenWidth * 0.04),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Room No:',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontFamily: 'Font5',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8 ),
                                      child: Text(
                                        data['Eee room'] ?? 'N/A',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          fontFamily: 'Font5',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenWidth * 0.04),
                    Container(
                      width: screenWidth,
                      height: screenHeight*0.4,
                      decoration: BoxDecoration(
                        color: Color(0xff54998e),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: screenWidth*0.89,
                              height: screenHeight*0.05,
                              decoration: BoxDecoration(
                                  color: Color(0xff08857a),
                                  borderRadius: BorderRadius.circular(20)
                              ),
                              child: Center(
                                child: Text(
                                  data['Math CN'] ?? 'N/A',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.032,
                                    fontFamily: 'Font6',
                                    color: Color(0xff5accc2),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          CircleAvatar(
                            radius: screenWidth*0.14,
                            backgroundImage: AssetImage('assets/images/mathMadam.png'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Teacher Name:',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontFamily: 'Font5',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Text(
                                        data['Math TN 1'] ?? 'N/A',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          fontFamily: 'Font5',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: screenWidth * 0.038),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Designation:',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontFamily: 'Font5',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Text(
                                        data['Math Deg 1'] ?? 'N/A',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          fontFamily: 'Font5',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: screenWidth * 0.04),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Teacher's Email:",
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontFamily: 'Font5',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Text(
                                        data['Math Email 1'] ?? 'N/A',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          fontFamily: 'Font5',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: screenWidth * 0.04),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Room No:',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontFamily: 'Font5',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8 ),
                                      child: Text(
                                        data['Math room 1'] ?? 'N/A',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          fontFamily: 'Font5',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenWidth * 0.04),
                    Container(
                      width: screenWidth,
                      height: screenHeight*0.4,
                      decoration: BoxDecoration(
                        color: Color(0xff54998e),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: screenWidth*0.89,
                              height: screenHeight*0.05,
                              decoration: BoxDecoration(
                                  color: Color(0xff08857a),
                                  borderRadius: BorderRadius.circular(20)
                              ),
                              child: Center(
                                child: Text(
                                  data['Math CN'] ?? 'N/A',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.032,
                                    fontFamily: 'Font6',
                                    color: Color(0xff5accc2),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          CircleAvatar(
                            radius: screenWidth*0.14,
                            backgroundImage: AssetImage('assets/images/mathSir.png'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Teacher Name:',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontFamily: 'Font5',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Text(
                                        data['Math TN 2'] ?? 'N/A',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          fontFamily: 'Font5',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: screenWidth * 0.038),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Designation:',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontFamily: 'Font5',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Text(
                                        data['Math Deg 2'] ?? 'N/A',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          fontFamily: 'Font5',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: screenWidth * 0.04),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Teacher's Email:",
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontFamily: 'Font5',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Text(
                                        data['Math Email 2'] ?? 'N/A',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          fontFamily: 'Font5',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: screenWidth * 0.04),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Room No:',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontFamily: 'Font5',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8 ),
                                      child: Text(
                                        data['Math room 2'] ?? 'N/A',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          fontFamily: 'Font5',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenWidth * 0.04),
                    Container(
                      width: screenWidth,
                      height: screenHeight*0.4,
                      decoration: BoxDecoration(
                        color: Color(0xff54998e),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: screenWidth*0.89,
                              height: screenHeight*0.05,
                              decoration: BoxDecoration(
                                  color: Color(0xff08857a),
                                  borderRadius: BorderRadius.circular(20)
                              ),
                              child: Center(
                                child: Text(
                                  data['Hum CN'] ?? 'N/A',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.06,
                                    fontFamily: 'Font6',
                                    color: Color(0xff5accc2),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          CircleAvatar(
                            radius: screenWidth*0.14,
                            backgroundImage: AssetImage('assets/images/humMadam.png'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Teacher Name:',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontFamily: 'Font5',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Text(
                                        data['Hum TN'] ?? 'N/A',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.0326,
                                          fontFamily: 'Font5',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: screenWidth * 0.04),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Designation:',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontFamily: 'Font5',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Text(
                                        data['Hum Deg'] ?? 'N/A',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          fontFamily: 'Font5',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: screenWidth * 0.04),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Teacher's Email:",
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontFamily: 'Font5',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Text(
                                        data['Hum Email'] ?? 'N/A',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          fontFamily: 'Font5',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: screenWidth * 0.04),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Room No:',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontFamily: 'Font5',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8 ),
                                      child: Text(
                                        data['Hum room'] ?? 'N/A',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          fontFamily: 'Font5',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenWidth * 0.04),
                    Container(
                      width: screenWidth,
                      height: screenHeight*0.4,
                      decoration: BoxDecoration(
                        color: Color(0xff54998e),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: screenWidth*0.89,
                              height: screenHeight*0.05,
                              decoration: BoxDecoration(
                                  color: Color(0xff08857a),
                                  borderRadius: BorderRadius.circular(20)
                              ),
                              child: Center(
                                child: Text(
                                  data['Ds Lab CN'] ?? 'N/A',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.07,
                                    fontFamily: 'Font6',
                                    color: Color(0xff5accc2),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          CircleAvatar(
                            radius: screenWidth*0.14,
                            backgroundImage: AssetImage('assets/images/dslabSir.png'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Teacher Name:',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontFamily: 'Font5',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Text(
                                        data['Ds Lab TN 1'] ?? 'N/A',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          fontFamily: 'Font5',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: screenWidth * 0.038),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Designation:',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontFamily: 'Font5',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Text(
                                        data['Ds Lab Deg 1'] ?? 'N/A',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          fontFamily: 'Font5',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: screenWidth * 0.04),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Teacher's Email:",
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontFamily: 'Font5',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Text(
                                        data['Ds Lab Email 1'] ?? 'N/A',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          fontFamily: 'Font5',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: screenWidth * 0.04),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Room No:',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontFamily: 'Font5',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8 ),
                                      child: Text(
                                        data['Ds Lab room 1'] ?? 'N/A',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          fontFamily: 'Font5',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenWidth * 0.04),
                    Container(
                      width: screenWidth,
                      height: screenHeight*0.4,
                      decoration: BoxDecoration(
                        color: Color(0xff54998e),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: screenWidth*0.89,
                              height: screenHeight*0.05,
                              decoration: BoxDecoration(
                                  color: Color(0xff08857a),
                                  borderRadius: BorderRadius.circular(20)
                              ),
                              child: Center(
                                child: Text(
                                  data['Ds Lab CN'] ?? 'N/A',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.07,
                                    fontFamily: 'Font6',
                                    color: Color(0xff5accc2),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          CircleAvatar(
                            radius: screenWidth * 0.14,
                            child: Icon(
                              Icons.person,
                              size: screenWidth * 0.2, // Match avatar size
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Teacher Name:',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontFamily: 'Font5',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Text(
                                        data['Ds Lab TN 2'] ?? 'N/A',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          fontFamily: 'Font5',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: screenWidth * 0.038),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Designation:',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontFamily: 'Font5',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Text(
                                        data['Ds Lab Deg 2'] ?? 'N/A',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          fontFamily: 'Font5',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: screenWidth * 0.04),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Teacher's Email:",
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontFamily: 'Font5',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Text(
                                        data['Ds Lab Email 2'] ?? 'N/A',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          fontFamily: 'Font5',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: screenWidth * 0.04),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Room No:',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontFamily: 'Font5',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8 ),
                                      child: Text(
                                        data['Ds Lab room 2'] ?? 'N/A',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          fontFamily: 'Font5',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenWidth * 0.04),
                    Container(
                      width: screenWidth,
                      height: screenHeight*0.4,
                      decoration: BoxDecoration(
                        color: Color(0xff54998e),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: screenWidth*0.89,
                              height: screenHeight*0.05,
                              decoration: BoxDecoration(
                                  color: Color(0xff08857a),
                                  borderRadius: BorderRadius.circular(20)
                              ),
                              child: Center(
                                child: Text(
                                  data['Dld Lab CN'] ?? 'N/A',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.06,
                                    fontFamily: 'Font6',
                                    color: Color(0xff5accc2),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          CircleAvatar(
                            radius: screenWidth*0.14,
                            backgroundImage: AssetImage('assets/images/dldlabSir.png'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Teacher Name:',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontFamily: 'Font5',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Text(
                                        data['Dld Lab TN 1'] ?? 'N/A',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.035,
                                          fontFamily: 'Font5',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: screenWidth * 0.038),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Designation:',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontFamily: 'Font5',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Text(
                                        data['Dld Lab Deg 1'] ?? 'N/A',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          fontFamily: 'Font5',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: screenWidth * 0.04),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Teacher's Email:",
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontFamily: 'Font5',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Text(
                                        data['Dld Lab Email 1'] ?? 'N/A',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          fontFamily: 'Font5',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: screenWidth * 0.04),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Room No:',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontFamily: 'Font5',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8 ),
                                      child: Text(
                                        data['Dld Lab room 1'] ?? 'N/A',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          fontFamily: 'Font5',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenWidth * 0.04),
                    Container(
                      width: screenWidth,
                      height: screenHeight*0.4,
                      decoration: BoxDecoration(
                        color: Color(0xff54998e),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: screenWidth*0.89,
                              height: screenHeight*0.05,
                              decoration: BoxDecoration(
                                  color: Color(0xff08857a),
                                  borderRadius: BorderRadius.circular(20)
                              ),
                              child: Center(
                                child: Text(
                                  data['Dld Lab CN'] ?? 'N/A',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.06,
                                    fontFamily: 'Font6',
                                    color: Color(0xff5accc2),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          CircleAvatar(
                            radius: screenWidth * 0.14,
                            child: Icon(
                              Icons.person,
                              size: screenWidth * 0.2, // Match avatar size
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Teacher Name:',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontFamily: 'Font5',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Text(
                                        data['Dld Lab TN 2'] ?? 'N/A',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          fontFamily: 'Font5',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: screenWidth * 0.038),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Designation:',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontFamily: 'Font5',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Text(
                                        data['Dld Lab Deg 2'] ?? 'N/A',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          fontFamily: 'Font5',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: screenWidth * 0.04),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Teacher's Email:",
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontFamily: 'Font5',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Text(
                                        data['Dld Lab Email 2'] ?? 'N/A',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          fontFamily: 'Font5',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: screenWidth * 0.04),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Room No:',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontFamily: 'Font5',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8 ),
                                      child: Text(
                                        data['Dld Lab room 2'] ?? 'N/A',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          fontFamily: 'Font5',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenWidth * 0.04),
                    Container(
                      width: screenWidth,
                      height: screenHeight*0.4,
                      decoration: BoxDecoration(
                        color: Color(0xff54998e),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: screenWidth*0.89,
                              height: screenHeight*0.05,
                              decoration: BoxDecoration(
                                  color: Color(0xff08857a),
                                  borderRadius: BorderRadius.circular(20)
                              ),
                              child: Center(
                                child: Text(
                                  data['Eee Lab CN'] ?? 'N/A',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.05,
                                    fontFamily: 'Font6',
                                    color: Color(0xff5accc2),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          CircleAvatar(
                            radius: screenWidth*0.14,
                            backgroundImage: AssetImage('assets/images/eeelabSir.png'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Teacher Name:',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontFamily: 'Font5',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Text(
                                        data['Eee Lab TN 1'] ?? 'N/A',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          fontFamily: 'Font5',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: screenWidth * 0.038),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Designation:',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontFamily: 'Font5',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Text(
                                        data['Eee Lab Deg 1'] ?? 'N/A',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          fontFamily: 'Font5',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: screenWidth * 0.04),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Teacher's Email:",
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.035,
                                        fontFamily: 'Font5',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Text(
                                        data['Eee Lab Email 1'] ?? 'N/A',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.033,
                                          fontFamily: 'Font5',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: screenWidth * 0.04),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Room No:',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontFamily: 'Font5',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8 ),
                                      child: Text(
                                        data['Eee Lab room 1'] ?? 'N/A',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          fontFamily: 'Font5',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenWidth * 0.04),
                    Container(
                      width: screenWidth,
                      height: screenHeight*0.4,
                      decoration: BoxDecoration(
                        color: Color(0xff54998e),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: screenWidth*0.89,
                              height: screenHeight*0.05,
                              decoration: BoxDecoration(
                                  color: Color(0xff08857a),
                                  borderRadius: BorderRadius.circular(20)
                              ),
                              child: Center(
                                child: Text(
                                  data['Sd Lab CN'] ?? 'N/A',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.07,
                                    fontFamily: 'Font6',
                                    color: Color(0xff5accc2),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          CircleAvatar(
                            radius: screenWidth*0.14,
                            backgroundImage: AssetImage('assets/images/sdlabSir.png'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Teacher Name:',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontFamily: 'Font5',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Text(
                                        data['Sd Lab TN 1'] ?? 'N/A',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          fontFamily: 'Font5',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: screenWidth * 0.038),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Designation:',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontFamily: 'Font5',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Text(
                                        data['Sd Lab Deg 1'] ?? 'N/A',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          fontFamily: 'Font5',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: screenWidth * 0.04),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Teacher's Email:",
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontFamily: 'Font5',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Text(
                                        data['Sd Lab Email 1'] ?? 'N/A',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          fontFamily: 'Font5',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: screenWidth * 0.04),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Room No:',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontFamily: 'Font5',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8 ),
                                      child: Text(
                                        data['Sd Lab room 1'] ?? 'N/A',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          fontFamily: 'Font5',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenWidth * 0.04),
                    Container(
                      width: screenWidth,
                      height: screenHeight*0.4,
                      decoration: BoxDecoration(
                        color: Color(0xff54998e),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: screenWidth*0.89,
                              height: screenHeight*0.05,
                              decoration: BoxDecoration(
                                  color: Color(0xff08857a),
                                  borderRadius: BorderRadius.circular(20)
                              ),
                              child: Center(
                                child: Text(
                                  data['Sd Lab CN'] ?? 'N/A',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.07,
                                    fontFamily: 'Font6',
                                    color: Color(0xff5accc2),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          CircleAvatar(
                            radius: screenWidth*0.14,
                            backgroundImage: AssetImage('assets/images/sdlabMadam.png'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Teacher Name:',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontFamily: 'Font5',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Text(
                                        data['Sd Lab TN 2'] ?? 'N/A',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          fontFamily: 'Font5',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: screenWidth * 0.038),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Designation:',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontFamily: 'Font5',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Text(
                                        data['Sd Lab Deg 2'] ?? 'N/A',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          fontFamily: 'Font5',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: screenWidth * 0.04),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Teacher's Email:",
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontFamily: 'Font5',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Text(
                                        data['Sd Lab Email 2'] ?? 'N/A',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          fontFamily: 'Font5',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: screenWidth * 0.04),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Room No:',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontFamily: 'Font5',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8 ),
                                      child: Text(
                                        data['Sd Lab room 2'] ?? 'N/A',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          fontFamily: 'Font5',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Add more Rows here for additional fields
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}