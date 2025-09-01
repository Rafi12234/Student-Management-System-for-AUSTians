import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Info.dart';
class NewPage extends StatelessWidget {
  const NewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final User? user = FirebaseAuth.instance.currentUser;
    final String? userEmail = user?.email;

    String profileImage = 'assets/images/default_avatar.png';
    if (user != null) {
      if (user.email == 'shajedul.cse.20230104091@aust.edu') {
        profileImage = 'assets/images/rafi.jpeg';
      } else if (user.email == 'samanta.cse.20230104082@aust.edu') {
        profileImage = 'assets/images/samanta.jpeg';
      } else if (user.email == 'nusrat.cse.20230104089@aust.edu') {
        profileImage = 'assets/images/shanti.jpg';
      }
      else if (user.email == 'sazid.cse.20230104062@aust.edu') {
        profileImage = 'assets/images/Sazid.jfif';
      }
      else if (user.email == 'rabbie.cse.20230104057@aust.edu') {
        profileImage = 'assets/images/Rabbie.jfif';
      }
    }

    void _navigateToSection(String section) {
      if (userEmail != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfilePage(
              selectedSection: section,
              userEmail: userEmail,
            ),
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff064a44),
        title: Text('All About Informations',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Font5',
              fontSize: screenWidth * 0.050
          ),
        ),
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
                radius: screenWidth * 0.14,
                backgroundImage: AssetImage(profileImage),
              ), // Added missing closing parenthesis
              SizedBox(height: screenWidth * 0.03),
              _buildSectionButton(
                context: context,
                label: 'Personal Information',
                icon: Icons.person,
                onPressed: () => _navigateToSection('Personal'),
              ),
              SizedBox(height: screenWidth * 0.03),
              _buildSectionButton(
                context: context,
                label: 'Academic Information',
                icon: Icons.school,
                onPressed: () => _navigateToSection('Academic'),
              ),
              SizedBox(height: screenWidth * 0.03),
              _buildSectionButton(
                context: context,
                label: 'Guardian Information',
                icon: Icons.people_alt_rounded,
                onPressed: () => _navigateToSection('Guardian'),
              ),
              SizedBox(height: screenWidth * 0.03),
              _buildSectionButton(
                context: context,
                label: 'Contact Information',
                icon: Icons.contact_phone,
                onPressed: () => _navigateToSection('Contact'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xff075e57),
        padding: EdgeInsets.symmetric(horizontal: 23, vertical: 5),
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(27),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label,
            style: TextStyle(
                fontSize: screenWidth * 0.050,
                fontFamily: 'Font3',
                color: Colors.white
            ),
          ),
          SizedBox(width: screenWidth * 0.008),
          Icon(icon, color: Colors.white, size: screenWidth * 0.06),
        ],
      ),
    );
  }
}