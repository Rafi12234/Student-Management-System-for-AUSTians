import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login.dart';

class HomePage extends StatelessWidget {
  // Map user emails to their corresponding Firestore document IDs
  final Map<String, String> emailToDocId = {
    'shajedul.cse.20230104091@aust.edu': 'QRKncWFsIfVrY40QXjEC',
    'samanta.cse.20230104082@aust.edu': 'tE32NlfvTMZwwEqc4sZw',
    'nusrat.cse.20230104089@aust.edu': '4HnOHkGC8xKTmBU1crxr',
  };

  // Map user emails to their corresponding image assets
  final Map<String, String> emailToImage = {
    'shajedul.cse.20230104091@aust.edu': 'assets/images/rafi.jpeg',
    'samanta.cse.20230104082@aust.edu': 'assets/images/samanta.jpeg',
    'nusrat.cse.20230104089@aust.edu': 'assets/images/shanti.jpg'
  };

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          // Get the logged-in user's email
          final String? userEmail = snapshot.data?.email;

          // Find the corresponding document ID
          final String? documentId = emailToDocId[userEmail];
          // Find the corresponding image asset
          final String? userImage = emailToImage[userEmail];

          if (documentId == null || userImage == null) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Color(0xff204f20),
                foregroundColor: Colors.white,
                title: Text("Student's Information"),
                centerTitle: true,
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
              body: Center(
                child: Text("No data available for this user."),
              ),
            );
          }

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Color(0xff204f20),
              foregroundColor: Colors.white,
              title: Text("Student's Information"),
              centerTitle: true,
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
            drawer: Drawer(),
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff246624), Color(0xff45bf45)],
                  begin: Alignment.topLeft,
                  end: Alignment.topRight,
                ),
              ),
              child: FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('Users')
                    .doc(documentId)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasData && snapshot.data!.exists) {
                    final userData =
                    snapshot.data!.data() as Map<String, dynamic>;

                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: CircleAvatar(
                                radius: 120,
                                backgroundImage: AssetImage(userImage),
                                backgroundColor: Color(0xff246624),
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Personal Information',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 20),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text('Full Name:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18)),
                                        Text('Father Name:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18)),
                                        Text('Mother Name:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18)),
                                        Text('Date of Birth:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18)),
                                        Text('Nationality: ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18)),
                                        Text('Gender: ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18)),
                                        Text('Religion: ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18)),
                                        Text('Blood Group: ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18)),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          userData['Name'] ?? 'N/A',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        Text(
                                          userData['FName'] ?? 'N/A',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        Text(
                                          userData['MName'] ?? 'N/A',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        Text(
                                          userData['Birth'] ?? 'N/A',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        Text(
                                          userData['Nationality'] ?? 'N/A',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        Text(
                                          userData['Gender'] ?? 'N/A',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        Text(
                                          userData['Religion'] ?? 'N/A',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        Text(
                                          userData['Blood'] ?? 'N/A',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Academic Information',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text('Department:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18)),
                                        Text('Program:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18)),
                                        Text('Current Year-Semester:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18)),
                                        Text('Theory Section:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18)),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          userData['Department'] ?? 'N/A',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        Text(
                                          userData['Program'] ?? 'N/A',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        Text(
                                          userData['CurrentY'] ?? 'N/A',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        Text(
                                          userData['Sec'] ?? 'N/A',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Guardian Information',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text('Gurdian Name:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18)),
                                        Text('Gurdian Phone:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18)),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          userData['GurdianName'] ?? 'N/A',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        Text(
                                          userData['GurdianP'] ?? 'N/A',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Contact Information',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text('Phone:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18)),
                                        Text('Personal Email:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18)),
                                        Text('Institutional Email:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18)),
                                        Text('Present Address:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18)),
                                        Text('Permanent Address:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18)),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          userData['Mobile'] ?? 'N/A',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        Text(
                                          userData['EmailP'] ?? 'N/A',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        Text(
                                          userData['EmailIN'] ?? 'N/A',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        Text(
                                          userData['PresentAd'] ?? 'N/A',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        Text(
                                          userData['PerAd'] ?? 'N/A',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text("Error: ${snapshot.error}"),
                    );
                  } else {
                    return Center(
                      child: Text("No data available for this user."),
                    );
                  }
                },
              ),
            ),
          );
        } else {
          return Login();
        }
      },
    );
  }
}
