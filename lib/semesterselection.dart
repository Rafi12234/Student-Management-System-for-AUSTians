import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'resultshow.dart';

class SemesterSelection extends StatelessWidget {
  const SemesterSelection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final User? user = FirebaseAuth.instance.currentUser;
    final String? userEmail = user?.email;

    void _navigateToResult(String semester) {
      if (userEmail != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultPage(
              selectedSemester: semester,
              userEmail: userEmail!,
            ),
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff064a44),
        title: Text(
          'Select Semester',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Font5',
            fontSize: screenWidth * 0.06,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 10,
        shadowColor: Colors.black54,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xff075e57),
              Color(0xff048c76),
              Color(0xff268b73),
              Color(0xff54998e),
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.05),
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: screenWidth * 0.06,
              crossAxisSpacing: screenWidth * 0.06,
              childAspectRatio: 1.2,
              children: [
                _buildSemesterCard(context, '1.1', Icons.code, _navigateToResult),
                _buildSemesterCard(context, '1.2', Icons.storage, _navigateToResult),
                _buildSemesterCard(context, '2.1', Icons.lan, _navigateToResult),
                _buildSemesterCard(context, '2.2', Icons.settings_input_component, _navigateToResult),
                _buildSemesterCard(context, '3.1', Icons.memory, _navigateToResult),
                _buildSemesterCard(context, '3.2', Icons.security, _navigateToResult),
                _buildSemesterCard(context, '4.1', Icons.cloud, _navigateToResult),
                _buildSemesterCard(context, '4.2', Icons.computer, _navigateToResult),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSemesterCard(BuildContext context, String semester, IconData icon, Function(String) onPressed) {
    final screenWidth = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () => onPressed(semester),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xff0a736b),
              Color(0xff0d9a8a),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: screenWidth * 0.12,
              color: Colors.white,
            ),
            SizedBox(height: screenWidth * 0.03),
            Text(
              semester,
              style: TextStyle(
                fontSize: screenWidth * 0.07,
                fontFamily: 'Font3',
                color: Colors.white,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    blurRadius: 4,
                    color: Colors.black26,
                    offset: Offset(2, 2),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}