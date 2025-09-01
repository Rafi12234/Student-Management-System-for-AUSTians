import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project/calculator.dart';
import 'package:project/chatscreen.dart';
import 'package:project/login.dart';
import 'package:project/newpage.dart';
import 'package:project/notice_portal.dart';
import 'package:project/routine.dart';
import 'package:project/semesterselection.dart';
import 'package:project/teachersinfo.dart';

class ProfilePage extends StatefulWidget {
  final String selectedSection;
  final String userEmail;
  final Color _primaryColor = const Color(0xff064a44);

  const ProfilePage({
    required this.selectedSection,
    required this.userEmail,
    Key? key,
  }) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with TickerProviderStateMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic> _data = {};
  Map<String, dynamic> _extraData = {};
  late String _profileImage;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fetchSectionData();
    _fetchExtraData();
    _profileImage = _getProfileImage();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _fetchExtraData() async {
    try {
      DocumentSnapshot extraSnapshot = await _firestore
          .collection('UsersAll')
          .doc(widget.userEmail)
          .collection('Extra')
          .doc('extra')
          .get();

      if (extraSnapshot.exists) {
        setState(() {
          _extraData = extraSnapshot.data() as Map<String, dynamic>;
        });
      }
    } catch (e) {
      print('Error fetching extra data: $e');
    }
  }

  Future<void> _fetchSectionData() async {
    try {
      final collection = _getCollectionName();
      final document = _getDocumentName();

      DocumentSnapshot snapshot = await _firestore
          .collection('UsersAll')
          .doc(widget.userEmail)
          .collection(collection)
          .doc(document)
          .get();

      if (snapshot.exists) {
        setState(() {
          _data = snapshot.data() as Map<String, dynamic>;
          _isLoading = false;
        });
        _fadeController.forward();
      }
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _getCollectionName() {
    switch (widget.selectedSection) {
      case 'Personal': return 'PersonalInfo';
      case 'Academic': return 'AcademicInfo';
      case 'Guardian': return 'GuardianInfo';
      case 'Contact': return 'ContactInfo';
      default: return 'PersonalInfo';
    }
  }

  String _getDocumentName() {
    return '${widget.selectedSection.toLowerCase()}Details';
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: Text(
          '${widget.selectedSection} Information',
          style: TextStyle(
            fontFamily: 'Font5',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xff075e57).withOpacity(0.9),
                Color(0xff048c76).withOpacity(0.8),
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
        child: _isLoading
            ? _buildLoadingWidget()
            : FadeTransition(
          opacity: _fadeAnimation,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  height: MediaQuery.of(context).padding.top + 80,
                ),
              ),
              SliverToBoxAdapter(
                child: _buildHeaderSection(screenWidth),
              ),
              SliverPadding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 30),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    _buildSectionContent(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 3,
            ),
            SizedBox(height: 16),
            Text(
              'Loading ${widget.selectedSection} Information...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'Font5',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(double screenWidth) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Colors.white.withOpacity(0.3), Colors.white.withOpacity(0.1)],
              ),
            ),
            child: Icon(
              _getSectionIcon(),
              color: Colors.white,
              size: 30,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.selectedSection} Details',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'Font5',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'View your ${widget.selectedSection.toLowerCase()} information',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                    fontFamily: 'Font4',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getSectionIcon() {
    switch (widget.selectedSection) {
      case 'Personal': return Icons.person_outline;
      case 'Academic': return Icons.school_outlined;
      case 'Guardian': return Icons.family_restroom_outlined;
      case 'Contact': return Icons.contact_phone_outlined;
      default: return Icons.info_outline;
    }
  }

  List<Widget> _buildSectionContent() {
    switch (widget.selectedSection) {
      case 'Personal':
        return [
          _buildInfoCard('Father Name', _data['FName'], Icons.person),
          _buildInfoCard('Mother Name', _data['MName'], Icons.person),
          _buildInfoCard('Date of Birth', _data['Birth'], Icons.cake),
          _buildTwoColumnCard([
            _buildCompactField('Nationality', _data['Nationality']),
            _buildCompactField('Gender', _data['Gender']),
          ]),
          _buildTwoColumnCard([
            _buildCompactField('Religion', _data['Religion']),
            _buildCompactField('Blood Group', _data['Blood']),
          ]),
        ];
      case 'Academic':
        return [
          _buildInfoCard('Department', _data['Department'], Icons.business),
          _buildInfoCard('Program', _data['Program'], Icons.school, isLarge: true),
          _buildTwoColumnCard([
            _buildCompactField('Current Semester', _data['CurrentY']),
            _buildCompactField('Section', _data['Sec']),
          ]),
        ];
      case 'Guardian':
        return [
          _buildInfoCard('Guardian Name', _data['GuardianName'], Icons.person),
          _buildInfoCard('Guardian Phone', _data['GuardianP'], Icons.phone),
        ];
      case 'Contact':
        return [
          _buildInfoCard('Institutional Email', _data['EmailIN'], Icons.email),
          _buildInfoCard('Personal Email', _data['EmailP'], Icons.alternate_email),
          _buildInfoCard('Mobile', _data['Mobile'], Icons.phone_android),
          _buildInfoCard('Present Address', _data['PresentAd'], Icons.location_on, isLarge: true),
          _buildInfoCard('Permanent Address', _data['PerAd'], Icons.home, isLarge: true),
        ];
      default:
        return [Center(child: Text('Invalid section'))];
    }
  }

  Widget _buildInfoCard(String title, dynamic value, IconData icon, {bool isLarge = false}) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Font5',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              value?.toString() ?? 'Please Wait',
              style: TextStyle(
                fontSize: isLarge ? 14 : 16,
                fontFamily: 'Font5',
                color: Color(0xff064a44),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTwoColumnCard(List<Widget> children) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: children.map((child) => Expanded(child: child)).toList(),
      ),
    );
  }

  Widget _buildCompactField(String title, dynamic value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontFamily: 'Font5',
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              value?.toString() ?? 'N/A',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Font5',
                color: Color(0xff064a44),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
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
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 20, top: 60, bottom: 20, right: 20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
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
                    _extraData['Name'] ?? 'Loading...',
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
                      _extraData['Email'] ?? 'Loading...',
                      style: const TextStyle(
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
                padding: const EdgeInsets.symmetric(vertical: 20),
                children: [
                  _buildDrawerItem(
                    icon: Icons.person_outline,
                    title: 'My Profile',
                    page: NewPage(),
                    screenWidth: screenWidth,
                    isActive: true,
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
        boxShadow: isActive ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ] : null,
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
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOut,
                )),
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

  final Color _primaryColor = const Color(0xff064a44);

  void _confirmLogout() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.logout_outlined, color: Colors.red[600], size: 24),
            ),
            SizedBox(width: 12),
            Text(
              "Confirm Logout",
              style: TextStyle(
                color: _primaryColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Font5',
              ),
            ),
          ],
        ),
        content: Text(
          "Are you sure you want to sign out?",
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[700],
            fontFamily: 'Font4',
          ),
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
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontFamily: 'Font5',
                ),
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
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Font5',
                ),
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