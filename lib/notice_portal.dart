import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project/calculator.dart';
import 'package:project/chatscreen.dart';
import 'package:project/dropdownbuttonpage.dart';
import 'package:project/login.dart';
import 'package:project/newpage2.dart';
import 'package:project/notice_portal.dart';
import 'package:project/routine.dart';
import 'package:project/semesterselection.dart';
import 'package:project/teachersinfo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class NoticePortal extends StatefulWidget {
  @override
  State<NoticePortal> createState() => _NoticePortalState();
}

class _NoticePortalState extends State<NoticePortal> with TickerProviderStateMixin {
  late Future<Map<String, dynamic>> _extraData;
  late String _profileImage;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final Color _primaryColor = const Color(0xff064a44);
  final Color _accentColor = const Color(0xff54998e);
  final Color _backgroundColor = const Color(0xffe0f0ee);

  @override
  void initState() {
    super.initState();
    _extraData = _fetchExtraData();
    _profileImage = _getProfileImage();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
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

  Widget _buildNoticeItem(DocumentSnapshot notice, int index) {
    final date = (notice['timestamp'] as Timestamp).toDate();
    final formattedDate = DateFormat('MMM dd, yyyy - hh:mm a').format(date);

    return AnimatedContainer(
      duration: Duration(milliseconds: 300 + (index * 100)),
      curve: Curves.easeOutCubic,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: _primaryColor.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  Colors.white.withOpacity(0.95),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: _primaryColor.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Icon(
                          Icons.campaign_rounded,
                          color: _primaryColor,
                          size: 24,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notice['title'],
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: _primaryColor,
                                height: 1.3,
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: _accentColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.access_time_rounded,
                                    size: 16,
                                    color: _accentColor,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    formattedDate,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: _accentColor,
                                      fontWeight: FontWeight.w500,
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
                  SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.grey.shade200,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      notice['description'],
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[800],
                        height: 1.5,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Notice Board',
          style: TextStyle(
            fontFamily: 'Font5',
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _primaryColor,
                _primaryColor.withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      drawer: _buildDrawer(screenWidth),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF075E57),
              Color(0xFF048C76),
              Color(0xFF54998E),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('notices')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(
                            color: _primaryColor,
                            strokeWidth: 3,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Loading notices...',
                            style: TextStyle(
                              color: _primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Container(
                      margin: EdgeInsets.all(20),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 48,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Failed to load notices',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Container(
                      margin: EdgeInsets.all(20),
                      padding: EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 15,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.notifications_off_outlined,
                            color: Colors.grey,
                            size: 64,
                          ),
                          SizedBox(height: 20),
                          Text(
                            'No notices available',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Check back later for updates',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final notices = snapshot.data!.docs;

                return SlideTransition(
                  position: _slideAnimation,
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    physics: BouncingScrollPhysics(),
                    itemCount: notices.length,
                    itemBuilder: (context, index) => _buildNoticeItem(notices[index], index),
                  ),
                );
              },
            ),
          ),
        ),
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
                        isActive: true,
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