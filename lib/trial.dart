import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/calculator.dart';
import 'package:project/chatscreen.dart';
import 'package:project/login.dart';
import 'package:project/newpage2.dart';
import 'package:project/notice_portal.dart';
import 'package:project/routine.dart';
import 'semesterselection.dart';

class TeacherDataPage extends StatefulWidget {
  const TeacherDataPage({super.key});

  @override
  State<TeacherDataPage> createState() => _TeacherDataPageState();
}

class _TeacherDataPageState extends State<TeacherDataPage> {
  late Future<Map<String, dynamic>> teacherData;
  late Future<Map<String, dynamic>> extraData;
  late String profileImage;

  // Color Theme
  final Color _primaryColor = const Color(0xff075e57);
  final Color _accentColor = const Color(0xff54998e);
  final Color _backgroundColor = const Color(0xffe0f0ee);
  final Color _cardColor = const Color(0xffc8e6e1);
  final Color _textColor = const Color(0xff233735);
  final Color _dividerColor = const Color(0xff268b73);

  @override
  void initState() {
    super.initState();
    teacherData = fetchTeacherData();
    extraData = fetchExtraData();
    profileImage = getProfileImage();
  }

  Future<Map<String, dynamic>> fetchTeacherData() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('Teachers')
          .doc('p99UrcnFsFsMZ7Tbtpvo')
          .get();
      return doc.exists ? doc.data() as Map<String, dynamic> : {};
    } catch (e) {
      print('Error fetching teacher data: $e');
      return {};
    }
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
    final email = user?.email ?? '';
    return switch (email) {
      'shajedul.cse.20230104091@aust.edu' => 'assets/images/rafi.jpeg',
      'samanta.cse.20230104082@aust.edu' => 'assets/images/samanta.jpeg',
      'nusrat.cse.20230104089@aust.edu' => 'assets/images/shanti.jpg',
      'sazid.cse.20230104062@aust.edu' => 'assets/images/Sazid.jfif',
      _ => 'assets/images/default_avatar.png',
    };
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        title: Text(
          "Faculty Information",
          style: TextStyle(
              fontSize: screenSize.width * 0.045,
              fontWeight: FontWeight.w600,
              fontFamily: 'Font5'
          ),
        ),
        centerTitle: true,
        elevation: 4,
      ),
      drawer: _buildDrawer(screenSize.width),
      body: FutureBuilder<Map<String, dynamic>>(
        future: teacherData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: _primaryColor),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error Loading Data',
                style: TextStyle(
                  color: Colors.red[700],
                  fontSize: 18,
                ),
              ),
            );
          }

          final data = snapshot.data ?? {};
          return _buildTeacherContent(data, screenSize);
        },
      ),
    );
  }

  Widget _buildTeacherContent(Map<String, dynamic> data, Size screenSize) {
    return Container(
      color: _backgroundColor,
      child: ListView.separated(
        padding: EdgeInsets.all(screenSize.width * 0.04),
        itemCount: _teacherSections.length,
        separatorBuilder: (context, index) => Divider(
          color: _dividerColor.withOpacity(0.3),
          height: screenSize.width * 0.08,
        ),
        itemBuilder: (context, index) {
          final section = _teacherSections[index];
          return TeacherInfoCard(
            primaryColor: _primaryColor,
            accentColor: _accentColor,
            backgroundColor: _cardColor,
            textColor: _textColor,
            title: data[section.titleKey] ?? 'N/A',
            teacherName: data[section.nameKey] ?? 'N/A',
            designation: data[section.designationKey] ?? 'N/A',
            email: data[section.emailKey] ?? 'N/A',
            room: data[section.roomKey] ?? 'N/A',
            avatar: section.avatarPath,
          );
        },
      ),
    );
  }

  final List<TeacherSection> _teacherSections = [
    TeacherSection(
      titleKey: 'Ds CN',
      nameKey: 'Ds TN',
      designationKey: 'Ds Deg',
      emailKey: 'Ds Email',
      roomKey: 'Ds room',
      avatarPath: 'assets/images/rabMadam.png',
    ),
    TeacherSection(
      titleKey: 'Dld CN',
      nameKey: 'Dld TN',
      designationKey: 'Dld Deg',
      emailKey: 'Dld Email',
      roomKey: 'Dld room',
      avatarPath: 'assets/images/dldMadam.png',
    ),
    TeacherSection(
      titleKey: 'Eee CN',
      nameKey: 'Eee TN',
      designationKey: 'Eee Deg',
      emailKey: 'Eee Email',
      roomKey: 'Eee room',
      avatarPath: 'assets/images/eeeSir.png',
    ),
    TeacherSection(
      titleKey: 'Math CN',
      nameKey: 'Math TN 1',
      designationKey: 'Math Deg 1',
      emailKey: 'Math Email 1',
      roomKey: 'Math room 1',
      avatarPath: 'assets/images/mathMadam.png',
    ),
    TeacherSection(
      titleKey: 'Math CN',
      nameKey: 'Math TN 2',
      designationKey: 'Math Deg 2',
      emailKey: 'Math Email 2',
      roomKey: 'Math room 2',
      avatarPath: 'assets/images/mathSir.png',
    ),
    TeacherSection(
      titleKey: 'Hum CN',
      nameKey: 'Hum TN',
      designationKey: 'Hum Deg',
      emailKey: 'Hum Email',
      roomKey: 'Hum room',
      avatarPath: 'assets/images/humMadam.png',
    ),
    TeacherSection(
      titleKey: 'Ds Lab CN',
      nameKey: 'Ds Lab TN 1',
      designationKey: 'Ds Lab Deg 1',
      emailKey: 'Ds Lab Email 1',
      roomKey: 'Ds Lab room 1',
      avatarPath: 'assets/images/dslabSir.png',
    ),
    TeacherSection(
      titleKey: 'Ds Lab CN',
      nameKey: 'Ds Lab TN 2',
      designationKey: 'Ds Lab Deg 2',
      emailKey: 'Ds Lab Email 2',
      roomKey: 'Ds Lab room 2',
      avatarPath: 'assets/images/default_avatar.png',
    ),
    TeacherSection(
      titleKey: 'Dld Lab CN',
      nameKey: 'Dld Lab TN 1',
      designationKey: 'Dld Lab Deg 1',
      emailKey: 'Dld Lab Email 1',
      roomKey: 'Dld Lab room 1',
      avatarPath: 'assets/images/dldlabSir.png',
    ),
    TeacherSection(
      titleKey: 'Dld Lab CN',
      nameKey: 'Dld Lab TN 2',
      designationKey: 'Dld Lab Deg 2',
      emailKey: 'Dld Lab Email 2',
      roomKey: 'Dld Lab room 2',
      avatarPath: 'assets/images/dldlabMadam.png',
    ),
    TeacherSection(
      titleKey: 'Eee Lab CN',
      nameKey: 'Eee Lab TN 1',
      designationKey: 'Eee Lab Deg 1',
      emailKey: 'Eee Lab Email 1',
      roomKey: 'Eee Lab room 1',
      avatarPath: 'assets/images/eeelabSir.png',
    ),
    TeacherSection(
      titleKey: 'Sd Lab CN',
      nameKey: 'Sd Lab TN 1',
      designationKey: 'Sd Lab Deg 1',
      emailKey: 'Sd Lab Email 1',
      roomKey: 'Sd Lab room 1',
      avatarPath: 'assets/images/sdlabSir.png',
    ),
    TeacherSection(
      titleKey: 'Sd Lab CN',
      nameKey: 'Sd Lab TN 2',
      designationKey: 'Sd Lab Deg 2',
      emailKey: 'Sd Lab Email 2',
      roomKey: 'Sd Lab room 2',
      avatarPath: 'assets/images/sdlabMadam.png',
    ),
  ];

  Widget _buildDrawer(double screenWidth) {
    return Drawer(
      width: screenWidth * 0.75,
      child: FutureBuilder<Map<String, dynamic>>(
        future: extraData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: _primaryColor));
          }
          final data = snapshot.data ?? {};
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: screenWidth,
                  color: const Color(0xff075e57),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12, top: 80),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 2, bottom: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: screenWidth * 0.16,
                            height: screenWidth * 0.16,
                            child: CircleAvatar(
                              backgroundImage: AssetImage(profileImage),
                            ),
                          ),
                          Text(
                            data['Name'] ?? 'Loading...',
                            style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                fontFamily: 'Font5'
                            ),
                          ),
                          Text(
                            data['Email'] ?? 'Loading...',
                            style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                fontFamily: 'Font4',
                                fontWeight: FontWeight.w600,
                                color: Colors.white54
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                _buildDrawerItem(
                    icon: Icons.person,
                    title: 'My Profile',
                    page: NewPage(),
                    screenWidth: screenWidth
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 12, right: 12),
                  child: Divider(
                    thickness: 1.3,
                    color: Color(0xff54998e),
                  ),
                ),
                _buildDrawerItem(
                    icon: Icons.newspaper_rounded,
                    title: 'Result',
                    page: SemesterSelection(),
                    screenWidth: screenWidth
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 12, right: 12),
                  child: Divider(
                    thickness: 1.3,
                    color: Color(0xff54998e),
                  ),
                ),
                _buildDrawerItem(
                    icon: Icons.timelapse,
                    title: 'Class Schedule',
                    page: ClassRoutinePage(),
                    screenWidth: screenWidth
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 12, right: 12),
                  child: Divider(
                    thickness: 1.3,
                    color: Color(0xff54998e),
                  ),
                ),
                _buildDrawerItem(
                    icon: Icons.personal_injury,
                    title: "Course Teacher's Info",
                    page: TeacherDataPage(),
                    screenWidth: screenWidth
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 12, right: 12),
                  child: Divider(
                    thickness: 1.3,
                    color: Color(0xff54998e),
                  ),
                ),
                _buildDrawerItem(
                    icon: Icons.chat_outlined,
                    title: "Support Chat",
                    page: ChatScreen(),
                    screenWidth: screenWidth
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 12, right: 12),
                  child: Divider(
                    thickness: 1.3,
                    color: Color(0xff54998e),
                  ),
                ),
                _buildDrawerItem(
                    icon: Icons.calculate_outlined,
                    title: 'CGPA Calculator',
                    page: CgpaCalculatorPage(),
                    screenWidth: screenWidth
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 12, right: 12),
                  child: Divider(
                    thickness: 1.3,
                    color: Color(0xff54998e),
                  ),
                ),
                _buildDrawerItem(
                    icon: Icons.notifications_active,
                    title: 'Notice Headlines',
                    page: NoticePortal(),
                    screenWidth: screenWidth
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 12, right: 12),
                  child: Divider(
                    thickness: 1.3,
                    color: Color(0xff54998e),
                  ),
                ),
                InkWell(
                  onTap: _confirmLogout,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Icon(Icons.logout_sharp, color: Colors.black),
                        SizedBox(width: screenWidth * 0.03),
                        Text(
                          'Sign Out',
                          style: TextStyle(
                              fontSize: screenWidth * 0.045,
                              fontFamily: 'Font6',
                              color: Colors.black
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 12, right: 12),
                  child: Divider(
                    thickness: 1.3,
                    color: Color(0xff54998e),
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
  }) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.black),
            SizedBox(width: screenWidth * 0.03),
            Text(
              title,
              style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  fontFamily: 'Font6',
                  color: Colors.black
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Logout"),
        content: const Text("Are you sure you want to sign out?"),
        actions: [
          TextButton(
            child: const Text("No"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text("Yes"),
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

class TeacherInfoCard extends StatelessWidget {
  final Color primaryColor;
  final Color accentColor;
  final Color backgroundColor;
  final String title;
  final Color textColor;
  final String teacherName;
  final String designation;
  final String email;
  final String room;
  final String avatar;

  const TeacherInfoCard({
    required this.primaryColor,
    required this.accentColor,
    required this.backgroundColor,
    required this.title,
    required this.textColor,
    required this.teacherName,
    required this.designation,
    required this.email,
    required this.room,
    required this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: primaryColor.withOpacity(0.2), width: 1),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: accentColor.withOpacity(0.2),
                  child: CircleAvatar(
                    radius: 46,
                    backgroundImage: AssetImage(avatar),
                    onBackgroundImageError: (_, __) => Icon(
                      Icons.person,
                      size: 40,
                      color: primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildInfoRow('Faculty Member', teacherName),
                _buildInfoRow('Designation', designation),
                _buildInfoRow('Institutional Mail', email),
                _buildInfoRow('Room No', room),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TeacherSection {
  final String titleKey;
  final String nameKey;
  final String designationKey;
  final String emailKey;
  final String roomKey;
  final String avatarPath;

  TeacherSection({
    required this.titleKey,
    required this.nameKey,
    required this.designationKey,
    required this.emailKey,
    required this.roomKey,
    required this.avatarPath,
  });
}