import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project/calculator.dart';
import 'package:project/chatscreen.dart';
import 'package:project/login.dart';
import 'package:project/newpage.dart';
import 'package:project/notice_portal.dart';
import 'package:project/teachersinfo.dart';
import 'package:project/semesterselection.dart';

class ClassRoutinePage extends StatefulWidget {
  @override
  _ClassRoutinePageState createState() => _ClassRoutinePageState();
}

class _ClassRoutinePageState extends State<ClassRoutinePage> with TickerProviderStateMixin {
  final List<String> days = ["Sun", "Mon", "Tues", "Wed", "Thurs"];
  String selectedDay = "Sun";
  Map<String, List<Map<String, String>>> routinesMap = {};
  bool isLoading = true;
  String errorMessage = '';
  late Future<Map<String, dynamic>> _extraData;
  late String _profileImage;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final Color _primaryColor = const Color(0xff064a44);
  final Color _accentColor = const Color(0xff54998e);
  final Color _backgroundColor = const Color(0xffe0f0ee);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Future<Map<String, dynamic>> extraData;
  late String profileImage;

  @override
  void initState() {
    super.initState();
    _fetchUserRoutine();
    _extraData = fetchExtraData();
    _profileImage = getProfileImage();

    // Initialize animations
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: Duration(milliseconds: 800),
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
      begin: Offset(0, 0.3),
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

  Future<Map<String, dynamic>> fetchExtraData() async {
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

  String getProfileImage() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return 'assets/images/default_avatar.png';

    switch (user.email) {
      case 'shajedul.cse.20230104091@aust.edu':
        return 'assets/images/rafi.jpeg';
      case 'samanta.cse.20230104082@aust.edu':
        return 'assets/images/samanta.jpeg';
      case 'nusrat.cse.20230104089@aust.edu':
        return 'assets/images/shanti.jpg';
      default:
        return 'assets/images/default_avatar.png';
    }
  }

  Future<void> _fetchUserRoutine() async {
    setState(() => isLoading = true);
    try {
      final user = _auth.currentUser;
      if (user == null) {
        setState(() {
          errorMessage = "No user is currently signed in.";
          isLoading = false;
        });
        return;
      }

      final userEmail = user.email;
      if (userEmail == null) {
        setState(() {
          errorMessage = "User email is not available.";
          isLoading = false;
        });
        return;
      }

      DocumentSnapshot doc = await _firestore.collection('routines').doc(userEmail).get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        _parseRoutineData(data);
      } else {
        setState(() {
          errorMessage = "No routine found for the user.";
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Error fetching data: ${e.toString()}";
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _parseRoutineData(Map<String, dynamic> data) {
    Map<String, List<Map<String, String>>> tempMap = {};

    for (String day in days) {
      List<Map<String, String>> classes = [];

      for (int i = 1; i <= 5; i++) {
        final suffix = _getOrdinalSuffix(i);
        final subField = "${day}_${i}${_getOrdinalSuffix(i)}_Sub";
        final timeField = "${day}_${i}${_getOrdinalSuffix(i)}_time";

        if (data.containsKey(subField) && data.containsKey(timeField)) {
          classes.add({
            'subject': data[subField]?.toString() ?? 'Subject not found',
            'time': data[timeField]?.toString() ?? 'Time not specified'
          });
        }
      }

      tempMap[day] = classes;
    }

    setState(() => routinesMap = tempMap);
  }

  String _getOrdinalSuffix(int i) {
    if (i >= 11 && i <= 13) return 'th';
    switch (i % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    if (errorMessage.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Class Routine', style: TextStyle(fontFamily: 'Font5')),
          backgroundColor: Color(0xff064a44),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Column(
                  children: [
                    Icon(Icons.error_outline, size: 48, color: Colors.red.shade400),
                    SizedBox(height: 16),
                    Text(
                      errorMessage,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.red.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: Text(
          'Class Routine',
          style: TextStyle(
            fontFamily: 'Font5',
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Color(0xff064a44),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.menu, color: Colors.white),
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: _buildDrawer(screenWidth),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff064a44).withOpacity(0.05),
              _backgroundColor,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // Modern Day Selector
            Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: days.map((day) {
                    final isSelected = selectedDay == day;
                    return GestureDetector(
                      onTap: () {
                        setState(() => selectedDay = day);
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                        decoration: BoxDecoration(
                          gradient: isSelected
                              ? LinearGradient(
                            colors: [Color(0xff075e57), Color(0xff048c76)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                              : null,
                          color: isSelected ? null : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? Colors.transparent : Colors.grey.shade300,
                            width: 1.5,
                          ),
                          boxShadow: isSelected
                              ? [
                            BoxShadow(
                              color: Color(0xff075e57).withOpacity(0.3),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ]
                              : null,
                        ),
                        child: Text(
                          day,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Color(0xff075e57),
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // Enhanced Class List
            Expanded(
              child: isLoading
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xff075e57)),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Loading your schedule...',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
                  : (routinesMap[selectedDay]?.isEmpty ?? true)
                  ? Center(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    padding: EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Color(0xff075e57).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.free_breakfast_outlined,
                            size: 48,
                            color: Color(0xff075e57),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "No classes on $selectedDay",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Enjoy your free day!",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
                  : SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemCount: routinesMap[selectedDay]!.length,
                    itemBuilder: (context, index) {
                      final classInfo = routinesMap[selectedDay]![index];
                      return Container(
                        margin: EdgeInsets.only(bottom: 12),
                        child: Card(
                          elevation: 0,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                              color: Colors.grey.shade200,
                              width: 1,
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white,
                                  Color(0xff075e57).withOpacity(0.02),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.all(16),
                              leading: Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xff075e57),
                                      Color(0xff048c76),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xff075e57).withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.school_outlined,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              title: Text(
                                classInfo['subject']!,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff064a44),
                                ),
                              ),
                              subtitle: Container(
                                margin: EdgeInsets.only(top: 8),
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Color(0xff075e57).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      size: 16,
                                      color: Color(0xff075e57),
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      classInfo['time']!,
                                      style: TextStyle(
                                        color: Color(0xff075e57),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              trailing: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
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
                        isActive: true,
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