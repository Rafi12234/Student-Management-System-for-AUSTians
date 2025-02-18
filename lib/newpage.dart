import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project/informations.dart'; // Import PersonalInfoPage

class NewPage extends StatelessWidget {
  const NewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    // Get the current user's email
    final User? user = FirebaseAuth.instance.currentUser;
    String? userEmail = FirebaseAuth.instance.currentUser?.email;
    String profileImage = 'assets/images/default_avatar.png';
    if (user != null) {
      if (user.email == 'shajedul.cse.20230104091@aust.edu') {
        profileImage = 'assets/images/rafi.jpeg';
      } else if (user.email == 'samanta.cse.20230104082@aust.edu') {
        profileImage = 'assets/images/samanta.jpeg';
      } else if (user.email == 'nusrat.cse.20230104089@aust.edu') {
        profileImage = 'assets/images/shanti.jpg';
      }
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff064a44),
        foregroundColor: Colors.white,
        title: Text('All About Informations',style: TextStyle(color: Colors.white,fontFamily: 'Font5',fontSize: screenWidth*0.050),),
        centerTitle: true,
      ),
      body: Container(
        width: screenWidth*0.8,
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
          borderRadius: BorderRadius.only(topRight: Radius.circular(40),bottomRight: Radius.circular(40))
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: screenWidth*0.14,
                backgroundImage: AssetImage(profileImage),
              ),
              SizedBox(height: screenWidth*0.09),
              ElevatedButton(
                onPressed: () {
                  if (userEmail != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PersonalInfoPage(
                          userEmail: userEmail,
                          infoType: 'Personal',
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:Color(0xff075e57), // Change button color
                  foregroundColor: Colors.white, // Change text color
                  padding: EdgeInsets.symmetric(horizontal: 23, vertical: 5), // Set width & height
                  elevation: 8, // Button shadow
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(27), // Rounded corners
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Personal Information',style: TextStyle(color: Colors.white,fontSize: screenWidth*0.050,fontFamily:'Font3'),),
                    SizedBox(width: screenWidth*0.008),
                    Icon(
                      Icons.person, // Add an icon
                      color: Colors.white,
                      size: screenWidth*0.06, // Set icon size
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenWidth*0.03),
              ElevatedButton(
                onPressed: () {
                  if (userEmail != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PersonalInfoPage(
                          userEmail: userEmail,
                          infoType: 'Academic',
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:Color(0xff075e57), // Change button color
                  foregroundColor: Colors.white, // Change text color
                  padding: EdgeInsets.symmetric(horizontal: 23, vertical: 5),// Set width & height
                  elevation: 8, // Button shadow
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(27), // Rounded corners
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Academic Information',style: TextStyle(color: Colors.white,fontSize: screenWidth*0.050,fontFamily:'Font3'),),
                    SizedBox(width: screenWidth*0.008),
                    Icon(
                      Icons.school, // Add an icon
                      color: Colors.white,
                      size: screenWidth*0.06, // Set icon size
                    ),
                  ],
                )
              ),
              SizedBox(height: screenWidth*0.03),
              ElevatedButton(
                onPressed: () {
                  if (userEmail != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PersonalInfoPage(
                          userEmail: userEmail,
                          infoType: 'Guardian',
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:Color(0xff075e57), // Change button color
                  foregroundColor: Colors.white, // Change text color
                  padding: EdgeInsets.symmetric(horizontal: 23, vertical: 5), // Set width & height
                  elevation: 8, // Button shadow
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(27), // Rounded corners
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Guardian Information',style: TextStyle(color: Colors.white,fontSize: screenWidth*0.050,fontFamily:'Font3'),),
                    SizedBox(width: screenWidth*0.008),
                    Icon(
                      Icons.people_alt_rounded, // Add an icon
                      color: Colors.white,
                      size: screenWidth*0.06, // Set icon size
                    ),
                  ],
                )
              ),
              SizedBox(height: screenWidth*0.03),
              ElevatedButton(
                onPressed: () {
                  if (userEmail != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PersonalInfoPage(
                          userEmail: userEmail,
                          infoType: 'Contact',
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:Color(0xff075e57), // Change button color
                  foregroundColor: Colors.white, // Change text color
                  padding: EdgeInsets.symmetric(horizontal: 23, vertical: 5), // Set width & height
                  elevation: 8, // Button shadow
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(27), // Rounded corners
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Contact Information',style: TextStyle(color: Colors.white,fontSize: screenWidth*0.050,fontFamily:'Font3'),),
                    SizedBox(width: screenWidth*0.008),
                    Icon(
                      Icons.contact_phone, // Add an icon
                      color: Colors.white,
                      size: screenWidth*0.06, // Set icon size
                    ),
                  ],
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
