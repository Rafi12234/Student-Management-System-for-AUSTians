import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project/calculator.dart';
import 'package:project/chatscreen.dart';
import 'package:project/login.dart';
import 'package:project/newpage2.dart';
import 'package:project/notice_portal.dart';
import 'package:project/routine.dart';
import 'package:project/semesterselection.dart';

class TeacherDataPage extends StatefulWidget {
  @override
  _TeacherDataPageState createState() => _TeacherDataPageState();
}

class _TeacherDataPageState extends State<TeacherDataPage>
    with TickerProviderStateMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Future<Map<String, dynamic>> _extraData;
  late String _profileImage;
  final Color _primaryColor = const Color(0xff064a44);
  final Color _accentColor = const Color(0xff54998e);
  final Color _backgroundColor = const Color(0xffe0f0ee);

  late String currentSemester;
  late String currentSection;

  bool _isLoading = true;
  List<Map<String, String>> teacherList = [];

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
    _loadUserAcademicInfoAndTeachers();
    _extraData = _fetchExtraData();
    _profileImage = _getProfileImage();
  }

  void _setupAnimation() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  Future<Map<String, dynamic>> _fetchExtraData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return {};

    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('UsersAll')
          .doc(user.email)
          .collection('Extra')
          .doc('extra')
          .get();

      return doc.exists ? doc.data() as Map<String, dynamic> : {};
    } catch (e) {
      print('Error fetching extra data: $e');
      return {};
    }
  }
  String _getProfileImage() {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? '';
    return switch (email) {
      'shajedul.cse.20230104091@aust.edu' => 'assets/images/rafi.jpeg',
      'samanta.cse.20230104082@aust.edu' => 'assets/images/samanta.jpeg',
      'nusrat.cse.20230104089@aust.edu' => 'assets/images/shanti.jpg',
      'sazid.cse.20230104062@aust.edu' => 'assets/images/Sazid.jfif',
      _ => 'assets/images/default_avatar.png',
    };
  }
  Future<void> _loadUserAcademicInfoAndTeachers() async {
    try {
      final userEmail = _auth.currentUser?.email;
      if (userEmail == null) return;

      // Fetch academic details (CurrentY & Sec)
      final academicSnapshot = await _firestore
          .collection('UsersAll')
          .doc(userEmail)
          .collection('AcademicInfo')
          .doc('academicDetails')
          .get();

      currentSemester = academicSnapshot['CurrentY'];
      currentSection = academicSnapshot['Sec'];

      // Fetch teacher data based on semester and section
      final teacherDoc = await _firestore
          .collection('UsersAll')
          .doc(userEmail)
          .collection('TeachersInfo')
          .doc(currentSemester)
          .collection('Section')
          .doc(currentSection)
          .get();

      final data = teacherDoc.data() ?? {};

      // Extract multiple teachers dynamically
      int index = 1;
      while (data.containsKey('Teacher_${index}_Name')) {
        teacherList.add({
          'Name': data['Teacher_${index}_Name'] ?? '',
          'Course': data['Teacher_${index}_Course'] ?? '',
          'Room': data['Teacher_${index}_Room'] ?? '',
          'Designation': data['Teacher_${index}_Dsignation'] ?? '',
          'Email': data['Teacher_${index}_EduMail'] ?? '',
        });
        index++;
      }

      // Start animation after data is loaded
      _animationController.forward();
    } catch (e) {
      print("Error fetching teacher info: $e");
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Course Teacher Info",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xff075e57),
        foregroundColor: Colors.white,
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.3),
      ),
      drawer: _buildDrawer(screenWidth),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff075e57),
              Color(0xff048c76),
              Color(0xff268b73),
              Color(0xff328f79),
              Color(0xff54998e),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _isLoading
            ? _buildLoadingWidget()
            : teacherList.isEmpty
            ? _buildEmptyState()
            : _buildTeacherList(screenWidth, screenHeight),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Loading Teacher Information...',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.school_outlined,
                  size: 80,
                  color: Colors.white.withOpacity(0.7),
                ),
                const SizedBox(height: 20),
                const Text(
                  'No Teacher Data Found',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Teacher information is not available for your current semester and section.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeacherList(double screenWidth, double screenHeight) {
    return Column(
      children: [
        // Header Section
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.15),
                Colors.white.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.group_outlined,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your Teachers',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${teacherList.length} teachers found',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Teacher List
        Expanded(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              physics: const BouncingScrollPhysics(),
              itemCount: teacherList.length,
              itemBuilder: (context, index) {
                final teacher = teacherList[index];
                return TweenAnimationBuilder<double>(
                  duration: Duration(milliseconds: 300 + (index * 100)),
                  tween: Tween<double>(begin: 0, end: 1),
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(0, 50 * (1 - value)),
                      child: Opacity(
                        opacity: value,
                        child: _buildTeacherCard(teacher, index),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTeacherCard(Map<String, String> teacher, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.95),
            Colors.white.withOpacity(0.85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Teacher Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xff075e57).withOpacity(0.8),
                  const Color(0xff048c76).withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(
                    Icons.person_outline,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        teacher['Name'] ?? '',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        teacher['Designation'] ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Teacher Details
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildInfoRow(
                  Icons.book_outlined,
                  "Course",
                  teacher['Course'],
                  const Color(0xff075e57),
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  Icons.room_outlined,
                  "Room",
                  teacher['Room'],
                  const Color(0xff048c76),
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  Icons.email_outlined,
                  "Email",
                  teacher['Email'],
                  const Color(0xff268b73),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String? value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: color.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value ?? 'Not specified',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(double screenWidth) {
    return Drawer(
      width: screenWidth * 0.8,
      child: FutureBuilder<Map<String, dynamic>>(
        future: _extraData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xff075e57),
                    Color(0xff048c76),
                    Color(0xff54998e),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            );
          }

          final data = snapshot.data ?? {};
          return Container(
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
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(left: 20, top: 60, bottom: 20, right: 20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.only(
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
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: screenWidth * 0.1,
                          backgroundImage: AssetImage(_profileImage),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        data['Name'] ?? 'Loading...',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Font5',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          data['Email'] ?? 'Loading...',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Font4',
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    children: [
                      _buildDrawerItem(
                        icon: Icons.person_outline,
                        title: 'My Profile',
                        page: NewPage(),
                        screenWidth: screenWidth,
                      ),
                      _buildDrawerItem(
                        icon: Icons.assessment_outlined,
                        title: 'Result',
                        page: SemesterSelection(),
                        screenWidth: screenWidth,
                      ),
                      _buildDrawerItem(
                        icon: Icons.schedule_outlined,
                        title: 'Class Schedule',
                        page: ClassRoutinePage(),
                        screenWidth: screenWidth,
                      ),
                      _buildDrawerItem(
                        icon: Icons.school_outlined,
                        title: "Course Teacher's Info",
                        page: TeacherDataPage(),
                        screenWidth: screenWidth,
                        isActive: true,
                      ),
                      _buildDrawerItem(
                        icon: Icons.chat_outlined,
                        title: "Support Chat",
                        page: ChatScreen(),
                        screenWidth: screenWidth,
                      ),
                      _buildDrawerItem(
                        icon: Icons.calculate_outlined,
                        title: 'CGPA Calculator',
                        page: CgpaCalculatorPage(),
                        screenWidth: screenWidth,
                      ),
                      _buildDrawerItem(
                        icon: Icons.notifications_outlined,
                        title: 'Notice Headlines',
                        page: NoticePortal(),
                        screenWidth: screenWidth,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Divider(
                          color: Colors.white.withOpacity(0.3),
                          thickness: 1,
                        ),
                      ),
                      _buildLogoutItem(screenWidth),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
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
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: isActive ? Colors.white.withOpacity(0.2) : Colors.transparent,
      ),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
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
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
          ),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  Widget _buildLogoutItem(double screenWidth) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.logout_outlined, color: Colors.white, size: 20),
        ),
        title: Text(
          'Sign Out',
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Font6',
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: _confirmLogout,
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(Icons.logout_outlined, color: Colors.red[600]),
            SizedBox(width: 12),
            Text(
              "Confirm Logout",
              style: TextStyle(
                color: _primaryColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          "Are you sure you want to sign out?",
          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
        ),
        actions: [
          TextButton(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  colors: [Colors.red, Colors.redAccent],
                ),
              ),
              child: Text(
                "Logout",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
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