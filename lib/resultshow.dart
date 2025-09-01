import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project/calculator.dart';
import 'package:project/chatscreen.dart';
import 'package:project/login.dart';
import 'package:project/newpage.dart';
import 'package:project/notice_portal.dart';
import 'package:project/routine.dart';
import 'semesterselection.dart';
import 'package:project/teachersinfo.dart';

class ResultPage extends StatefulWidget {
  final String selectedSemester;
  final String userEmail;

  const ResultPage({
    required this.selectedSemester,
    required this.userEmail,
    Key? key,
  }) : super(key: key);

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  bool _dialogShown = false;
  late Future<Map<String, dynamic>> _extraDataFuture;
  late String _profileImage;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Color _primaryColor = const Color(0xff064a44);

  @override
  void initState() {
    super.initState();
    _extraDataFuture = _fetchExtraData();
    _profileImage = _getProfileImage();
  }

  Future<Map<String, dynamic>> _fetchExtraData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user?.email == null) return {};

    try {
      DocumentSnapshot doc = await _firestore
          .collection('UsersAll')
          .doc(user!.email)
          .collection('Extra')
          .doc('extra')
          .get();

      return doc.data() as Map<String, dynamic>? ?? {};
    } catch (e) {
      print('Error fetching extra data: $e');
      return {};
    }
  }

  String _getProfileImage() {
    final email = FirebaseAuth.instance.currentUser?.email ?? '';
    return switch (email) {
      'shajedul.cse.20230104091@aust.edu' => 'assets/images/rafi.jpeg',
      'samanta.cse.20230104082@aust.edu' => 'assets/images/samanta.jpeg',
      'nusrat.cse.20230104089@aust.edu' => 'assets/images/shanti.jpg',
      'sazid.cse.20230104062@aust.edu' => 'assets/images/Sazid.jfif',
      'rabbie.cse.20230104057@aust.edu' => 'assets/images/Rabbie.jfif',
      _ => 'assets/images/default_avatar.png',
    };
  }

  void _showUpcomingSemesterDialog() {
    if (!_dialogShown) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => AlertDialog(
              title: const Text('Upcoming Semester'),
              content: const Text('Data will be available soon.'),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ).then((_) {
            if (mounted) Navigator.of(context).pop();
            _dialogShown = true;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: _primaryColor,
        title: Text(
          'Semester ${widget.selectedSemester} Results',
          style: TextStyle(
              color: Colors.white, fontSize: screenWidth * 0.045, fontFamily: 'Font5'),
        ),
        centerTitle: true,
      ),
      drawer: _buildDrawer(screenWidth),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _firestore
            .collection('UsersAll')
            .doc(widget.userEmail)
            .collection('ResultInfo')
            .doc(widget.selectedSemester)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists || snapshot.data!.data() == null) {
            _showUpcomingSemesterDialog();
            return const SizedBox.shrink();
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          final Map<String, Map<String, String>> grouped = {};
          for (final entry in data.entries) {
            final key = entry.key;
            if (key == 'CG') continue;

            final parts = key.split(' ');
            if (parts.length < 2) continue;

            final courseCode = '${parts[0]} ${parts[1]}';
            final field = parts.length > 2 ? parts.sublist(2).join(' ') : '';

            grouped.putIfAbsent(courseCode, () => {});
            grouped[courseCode]![field] = entry.value.toString();
          }

          if (grouped.isEmpty) {
            _showUpcomingSemesterDialog();
            return const SizedBox.shrink();
          }

          return Container(
            decoration: const BoxDecoration(
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
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (data.containsKey('CG')) _buildCGPACard(data['CG']),
                ...grouped.entries.map(
                      (entry) => _buildCourseCard(entry.key, entry.value),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCGPACard(dynamic cgpaValue) {
    final cgpa = double.tryParse(cgpaValue.toString()) ?? 0.0;
    return Card(
      color: Colors.white.withOpacity(0.9),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text('Semester CGPA',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green[800])),
            const SizedBox(height: 10),
            Text(cgpa.toStringAsFixed(2),
                style: TextStyle(fontSize: 34, fontWeight: FontWeight.w800, color: Colors.green[900])),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: cgpa / 4.0,
              backgroundColor: Colors.green[100],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green[800]!),
              minHeight: 10,
              borderRadius: BorderRadius.circular(10),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseCard(String courseCode, Map<String, String> fields) {
    const fieldLabels = {
      'C': 'Credit',
      'CN': 'Course Name',
      'G': 'Grade',
      'N': 'Course Title',
      'CG': 'Course CGPA'
    };

    return Card(
      color: Colors.white.withOpacity(0.9),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(courseCode, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 12),
            Table(
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(3),
              },
              children: fields.entries.map((e) {
                return TableRow(children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(fieldLabels[e.key] ?? e.key, style: const TextStyle(fontWeight: FontWeight.w500)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(e.value, style: const TextStyle(color: Colors.black54)),
                  ),
                ]);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(double screenWidth) {
    return Drawer(
      width: screenWidth * 0.8,
      child: Container(
        decoration: const BoxDecoration(
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
          children: [
            FutureBuilder<Map<String, dynamic>>(
              future: _extraDataFuture,
              builder: (context, snapshot) {
                final name = snapshot.data?['Name'] ?? 'Loading...';
                final email = snapshot.data?['Email'] ?? 'Loading...';

                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(left: 20, top: 60, bottom: 20, right: 20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withOpacity(0.3), width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: screenWidth * 0.1,
                          backgroundImage: AssetImage(_profileImage),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontFamily: 'Font5',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          email,
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Font4',
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            // drawer items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 20),
                children: [
                  _buildDrawerItem(icon: Icons.person_outline, title: 'My Profile', page: NewPage(), screenWidth: screenWidth),
                  _buildDrawerItem(icon: Icons.assessment_outlined, title: 'Result', page: SemesterSelection(), screenWidth: screenWidth, isActive: true),
                  _buildDrawerItem(icon: Icons.schedule_outlined, title: 'Class Schedule', page: ClassRoutinePage(), screenWidth: screenWidth),
                  _buildDrawerItem(icon: Icons.school_outlined, title: "Course Teacher's Info", page: TeacherDataPage(), screenWidth: screenWidth),
                  _buildDrawerItem(icon: Icons.chat_outlined, title: "Support Chat", page: ChatScreen(), screenWidth: screenWidth),
                  _buildDrawerItem(icon: Icons.calculate_outlined, title: 'CGPA Calculator', page: CgpaCalculatorPage(), screenWidth: screenWidth),
                  _buildDrawerItem(icon: Icons.notifications_outlined, title: 'Notice Headlines', page: NoticePortal(), screenWidth: screenWidth),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Divider(color: Colors.white.withOpacity(0.3), thickness: 1),
                  ),
                  _buildLogoutItem(screenWidth),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required Widget page,
    required double screenWidth,
    bool isActive = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: isActive ? Colors.white.withOpacity(0.2) : Colors.transparent,
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Font6',
            color: Colors.white,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
        onTap: () => Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => page,
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero).animate(animation),
                child: child,
              );
            },
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  Widget _buildLogoutItem(double screenWidth) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.logout_outlined, color: Colors.white, size: 20),
        ),
        title: const Text(
          'Sign Out',
          style: TextStyle(fontSize: 16, fontFamily: 'Font6', color: Colors.white, fontWeight: FontWeight.w500),
        ),
        onTap: _confirmLogout,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.logout_outlined, color: Colors.red[600]),
            const SizedBox(width: 12),
            Text("Confirm Logout",
                style: TextStyle(color: _primaryColor, fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text("Are you sure you want to sign out?", style: TextStyle(fontSize: 16, color: Colors.grey[700])),
        actions: [
          TextButton(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey, fontSize: 16)),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(colors: [Colors.red, Colors.redAccent]),
              ),
              child: const Text("Logout", style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
            onPressed: () async {
              Navigator.of(context).pop();
              await FirebaseAuth.instance.signOut();
              if (mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const Login()),
                      (Route<dynamic> route) => false,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
