import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login.dart';
import 'resultshow.dart';
import 'notice_portal.dart';
import 'calculator.dart';
import 'dropdownbuttonpage.dart';
import 'newpage2.dart';
import 'chatscreen.dart';
import 'teachersinfo.dart';
import 'routine.dart';
import 'semesterselection.dart';
import 'package:project/complaintpage.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  late Future<Map<String, dynamic>> _userDataFuture;
  late String _profileImage;
  final User? _user = FirebaseAuth.instance.currentUser;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<DashboardItem> _menuItems = [
    DashboardItem('My Profile', Icons.person_outline, NewPage()),
    DashboardItem('Results', Icons.assessment_outlined, SemesterSelection()),
    DashboardItem('Notices', Icons.notifications_none_outlined, NoticePortal()),
    DashboardItem('Routine', Icons.schedule_outlined, ClassRoutinePage()),
    DashboardItem('Course Teachers', Icons.school_outlined, TeacherDataPage()),
    DashboardItem('Support', Icons.chat_outlined, ChatScreen()),
    DashboardItem('CGPA Calculator', Icons.calculate_outlined, CgpaCalculatorPage()),
    DashboardItem('Report Complaint', Icons.report_outlined, ComplaintPage()),
  ];

  @override
  void initState() {
    super.initState();
    _userDataFuture = _fetchUserData();
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
      begin: const Offset(0, 0.5),
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

  Future<Map<String, dynamic>> _fetchUserData() async {
    if (_user?.email == null) return {};

    try {
      final DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('UsersAll')
          .doc(_user!.email)
          .collection('Extra')
          .doc('extra')
          .get();

      return doc.data() as Map<String, dynamic>? ?? {};
    } catch (e) {
      print('Error fetching user data: $e');
      return {};
    }
  }
  String _getProfileImage() {
    final email = _user?.email ?? '';
    switch (email) {
      case 'shajedul.cse.20230104091@aust.edu':
        return 'assets/images/rafi.jpeg';
      case 'samanta.cse.20230104082@aust.edu':
        return 'assets/images/samanta.jpeg';
      case 'nusrat.cse.20230104089@aust.edu':
        return 'assets/images/shanti.jpg';
      case 'sazid.cse.20230104062@aust.edu':
        return 'assets/images/Sazid.jfif';
      case 'rabbie.cse.20230104057@aust.edu':
        return 'assets/images/Rabbie.jfif';
      default:
        return 'assets/images/default_avatar.png';
    }
  }

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(Icons.logout, color: Colors.red[600]),
            const SizedBox(width: 10),
            const Text('Confirm Logout', style: TextStyle(fontSize: 20)),
          ],
        ),
        content: const Text(
          'Are you sure you want to log out?',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => Login()),
                    (route) => false,
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(
                  colors: [Colors.red, Colors.redAccent],
                ),
              ),
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Student Dashboard',
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Font5",
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: const Icon(Icons.logout, size: 20),
              ),
              onPressed: () => _handleLogout(context),
            ),
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF075E57),
                    Color(0xFF048C76),
                    Color(0xFF54998E),
                  ],
                ),
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            );
          }

          final userData = snapshot.data ?? {};

          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF075E57),
                  Color(0xFF048C76),
                  Color(0xFF54998E),
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: _buildProfileHeader(size, userData),
                  ),
                  Expanded(
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: _buildDashboardGrid(),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(Size size, Map<String, dynamic> userData) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.5), width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: size.width * 0.12,
              backgroundImage: AssetImage(_profileImage),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userData['Name'] ?? 'Student Name',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Font5",
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        userData['ID'] ?? 'Student ID',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: "Font5",
                          fontWeight: FontWeight.w500,
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
    );
  }

  Widget _buildDashboardGrid() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.1,
        ),
        itemCount: _menuItems.length,
        itemBuilder: (context, index) => AnimatedContainer(
          duration: Duration(milliseconds: 300 + (index * 100)),
          child: _DashboardCard(
            item: _menuItems[index],
            index: index,
          ),
        ),
      ),
    );
  }
}

class _DashboardCard extends StatefulWidget {
  final DashboardItem item;
  final int index;

  const _DashboardCard({required this.item, required this.index});

  @override
  State<_DashboardCard> createState() => _DashboardCardState();
}

class _DashboardCardState extends State<_DashboardCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                  widget.item.destination,
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
              );
            },
            onTapDown: (_) {
              setState(() => _isHovered = true);
              _hoverController.forward();
            },
            onTapUp: (_) {
              setState(() => _isHovered = false);
              _hoverController.reverse();
            },
            onTapCancel: () {
              setState(() => _isHovered = false);
              _hoverController.reverse();
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: _isHovered
                      ? [const Color(0xFF0D9A8A), const Color(0xFF0A736B)]
                      : [const Color(0xFF0A736B), const Color(0xFF0D9A8A)],
                ),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: -20,
                    right: -20,
                    child: Container(
                      width: 65,
                      height: 65,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.15),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            widget.item.icon,
                            size: 32,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          widget.item.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DashboardItem {
  final String title;
  final IconData icon;
  final Widget destination;

  DashboardItem(this.title, this.icon, this.destination);
}