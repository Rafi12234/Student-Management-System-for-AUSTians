import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PersonalInfoPage extends StatelessWidget {
  final String userEmail;
  final String infoType;

  const PersonalInfoPage({
    Key? key,
    required this.userEmail,
    required this.infoType,
  }) : super(key: key);

  // Mapping user emails to Firestore document IDs
  String? _getDocumentId(String email) {
    switch (email) {
      case 'shajedul.cse.20230104091@aust.edu':
        return 'QRKncWFsIfVrY40QXjEC';
      case 'samanta.cse.20230104082@aust.edu':
        return 'tE32NlfvTMZwwEqc4sZw';
      case 'nusrat.cse.20230104089@aust.edu':
        return '4HnOHkGC8xKTmBU1crxr';
      default:
        return null;
    }
  }

  Future<Map<String, dynamic>> _fetchUserInfo() async {
    String? documentId = _getDocumentId(userEmail);
    if (documentId == null) return {};

    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(documentId)
          .get();

      if (!snapshot.exists || snapshot.data() == null) return {};

      return snapshot.data() as Map<String, dynamic>;
    } catch (e) {
      return {};
    }
  }

  Column _buildUserInfo(Map<String, dynamic> userData) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (userEmail == 'shajedul.cse.20230104091@aust.edu') ...[
          if (infoType == 'Personal') ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Father's Name:",style: TextStyle(fontSize: 18,fontFamily: 'Font5'),),
                SizedBox(
                  height: 7,
                ),
                Container(
                  width: 430,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                    color: Color(0xffc3c4c7),
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
                    padding: const EdgeInsets.only(left: 15.0,top: 11),
                    child: Text(
                        '${userData['FName'] ?? 'N/A'}', style: TextStyle(fontSize: 20,fontFamily: 'Font5')
                    ),
                  ),
                ),
                SizedBox(
                  height: 7,
                ),
                Text("Mother's Name:",style: TextStyle(fontSize: 18,fontFamily: 'Font5'),),
                SizedBox(
                  height: 7,
                ),
                Container(
                  width: 430,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                    color: Color(0xffc3c4c7),
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
                    padding: const EdgeInsets.only(left: 15.0,top: 11),
                    child: Text(
                        '${userData['MName'] ?? 'N/A'}', style: TextStyle(fontSize: 20,fontFamily: 'Font5')
                    ),
                  ),
                ),
                SizedBox(
                  height: 7,
                ),
                Text("Date of Birth:",style: TextStyle(fontSize: 18,fontFamily: 'Font5'),),
                SizedBox(
                  height: 7,
                ),
                Container(
                  width: 430,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                    color: Color(0xffc3c4c7),
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
                    padding: const EdgeInsets.only(left: 15.0,top: 11),
                    child: Text(
                        '${userData['Birth'] ?? 'N/A'}', style: TextStyle(fontSize: 20,fontFamily: 'Font5')
                    ),
                  ),
                ),
                SizedBox(
                  height: 7,
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Nationality:",style: TextStyle(fontSize: 18,fontFamily: 'Font5'),),
                        SizedBox(
                          height: 7,
                        ),
                        Container(
                          width: 213,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13),
                            color: Color(0xffc3c4c7),
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
                            padding: const EdgeInsets.only(left: 15.0,top: 11),
                            child: Text(
                                '${userData['Nationality'] ?? 'N/A'}', style: TextStyle(fontSize: 20,fontFamily: 'Font5')
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 7,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Gender:",style: TextStyle(fontSize: 18,fontFamily: 'Font5'),),
                        SizedBox(
                          height: 7,
                        ),
                        Container(
                          width: 195,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13),
                            color: Color(0xffc3c4c7),
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
                            padding: const EdgeInsets.only(left: 15.0,top: 11),
                            child: Text(
                                '${userData['Gender'] ?? 'N/A'}', style: TextStyle(fontSize: 20,fontFamily: 'Font5')
                            ),
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
                SizedBox(
                  height: 7,
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Religion:",style: TextStyle(fontSize: 18,fontFamily: 'Font5'),),
                        SizedBox(
                          height: 7,
                        ),
                        Container(
                          width: 213,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13),
                            color: Color(0xffc3c4c7),
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
                            padding: const EdgeInsets.only(left: 15.0,top: 11),
                            child: Text(
                                '${userData['Religion'] ?? 'N/A'}', style: TextStyle(fontSize: 20,fontFamily: 'Font5')
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 7,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Blood Group:",style: TextStyle(fontSize: 18,fontFamily: 'Font5'),),
                        SizedBox(
                          height: 7,
                        ),
                        Container(
                          width: 195,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13),
                            color: Color(0xffc3c4c7),
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
                            padding: const EdgeInsets.only(left: 15.0,top: 11),
                            child: Text(
                                '${userData['Blood'] ?? 'N/A'}', style: TextStyle(fontSize: 20,fontFamily: 'Font5')
                            ),
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
              ],
            ),
          ]
          else if (infoType == 'Academic') ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Department Name:",style: TextStyle(fontSize: 18,fontFamily: 'Font5'),),
                SizedBox(
                  height: 7,
                ),
                Container(
                  width: 430,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                    color: Color(0xffc3c4c7),
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
                    padding: const EdgeInsets.only(left: 15.0,top: 11),
                    child: Text(
                        '${userData['Department'] ?? 'N/A'}', style: TextStyle(fontSize: 20,fontFamily: 'Font5')
                    ),
                  ),
                ),
                SizedBox(
                  height: 7,
                ),
                Text("Program:",style: TextStyle(fontSize: 18,fontFamily: 'Font5'),),
                SizedBox(
                  height: 7,
                ),
                Container(
                  width: 430,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                    color: Color(0xffc3c4c7),
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
                    padding: const EdgeInsets.only(left: 15.0,top: 11),
                    child: Text(
                        '${userData['Program'] ?? 'N/A'}', style: TextStyle(fontSize: 20,fontFamily: 'Font5')
                    ),
                  ),
                ),
                SizedBox(
                  height: 7,
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Current Year:",style: TextStyle(fontSize: 18,fontFamily: 'Font5'),),
                        SizedBox(
                          height: 7,
                        ),
                        Container(
                          width: 213,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13),
                            color: Color(0xffc3c4c7),
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
                            padding: const EdgeInsets.only(left: 15.0,top: 11),
                            child: Text(
                                '${userData['CurrentY'] ?? 'N/A'}', style: TextStyle(fontSize: 20,fontFamily: 'Font5')
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 7,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Section:",style: TextStyle(fontSize: 18,fontFamily: 'Font5'),),
                        SizedBox(
                          height: 7,
                        ),
                        Container(
                          width: 195,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13),
                            color: Color(0xffc3c4c7),
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
                            padding: const EdgeInsets.only(left: 15.0,top: 11),
                            child: Text(
                                '${userData['Sec'] ?? 'N/A'}', style: TextStyle(fontSize: 20,fontFamily: 'Font5')
                            ),
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
              ],
            ),
          ]
        ]
      ],
    );
  }
  static const textStyle = TextStyle(fontSize: 24, fontFamily: 'Font5', color: Colors.black);
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff064a44),
        foregroundColor: Colors.white,
        title: Text(infoType+' '+'Information',style: TextStyle(color: Colors.white,fontFamily: 'Font5'),),
        centerTitle: true,
      ),
      body: Container(
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
        child: FutureBuilder<Map<String, dynamic>>(
          future: _fetchUserInfo(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
              return const Center(child: Text('No Data Found'));
            }
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildUserInfo(snapshot.data!),
            );
          },
        ),
      ),
    );
  }
}
