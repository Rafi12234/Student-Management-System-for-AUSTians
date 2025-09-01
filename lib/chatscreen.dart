import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project/calculator.dart';
import 'package:project/chatscreen.dart';
import 'package:project/dropdownbuttonpage.dart';
import 'package:project/login.dart';
import 'package:project/newpage.dart';
import 'package:project/notice_portal.dart';
import 'package:project/routine.dart';
import 'package:project/teachersinfo.dart';
import 'package:project/semesterselection.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late String userEmail;
  final String adminEmail = "admin.1234@aust.edu";
  late Future<Map<String, dynamic>> extraData;
  late String profileImage;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final Color _primaryColor = const Color(0xff064a44);
  final Color _accentColor = const Color(0xff54998e);
  final Color _backgroundColor = const Color(0xffe0f0ee);

  @override
  void initState() {
    super.initState();
    userEmail = _auth.currentUser!.email!;
    extraData = fetchExtraData();
    profileImage = getProfileImage();

    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isNotEmpty) {
      String message = _messageController.text.trim();
      _messageController.clear();

      await _firestore
          .collection('messages')
          .doc('$userEmail-$adminEmail')
          .collection('messages')
          .add({
        'sender': userEmail,
        'receiver': adminEmail,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Auto scroll to bottom
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0.0,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
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
    if (user == null) return 'assets/images/default_avatar.png';

    switch (user.email) {
      case 'shajedul.cse.20230104091@aust.edu':
        return 'assets/images/rafi.jpeg';
      case 'samanta.cse.20230104082@aust.edu':
        return 'assets/images/samanta.jpeg';
      case 'nusrat.cse.20230104089@aust.edu':
        return 'assets/images/shanti.jpg';
      case 'sazid.cse.20230104062@aust.edu':
        return 'assets/images/Sazid.jfif';
      default:
        return 'assets/images/default_avatar.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: _buildAppBar(),
      drawer: _buildDrawer(screenWidth),
      body: Container(
        width: screenWidth,
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
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              _buildChatHeader(),
              Expanded(child: _buildChatMessages()),
              _buildMessageInput(),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Color(0xff064a44),
      foregroundColor: Colors.white,
      title: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.support_agent, size: 20),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Admin Support',
                style: TextStyle(
                  fontFamily: 'Font5',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Online',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.green.shade300,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        Container(
          margin: EdgeInsets.only(right: 16),
          child: IconButton(
            icon: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.info_outline, size: 20),
            ),
            onPressed: () => _showChatInfo(),
          ),
        ),
      ],
    );
  }

  Widget _buildChatHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(Icons.chat_bubble_outline, color: Colors.white, size: 24),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Need Help?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Font5',
                  ),
                ),
                Text(
                  'Chat with our admin team for instant support',
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

  Widget _buildChatMessages() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('messages')
          .doc('$userEmail-$adminEmail')
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
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
                    'Loading messages...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Font4',
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (snapshot.data!.docs.isEmpty) {
          return Center(
            child: Container(
              padding: EdgeInsets.all(30),
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 60,
                    color: Colors.white.withOpacity(0.7),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'No messages yet',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Font5',
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Start a conversation with our admin team',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 16,
                      fontFamily: 'Font4',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          controller: _scrollController,
          reverse: true,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var message = snapshot.data!.docs[index];
            bool isMe = message['sender'] == userEmail;

            return _buildMessageBubble(
              message: message['message'],
              isMe: isMe,
              timestamp: message['timestamp'],
            );
          },
        );
      },
    );
  }

  Widget _buildMessageBubble({
    required String message,
    required bool isMe,
    required dynamic timestamp,
  }) {
    return Container(
      margin: EdgeInsets.only(
        top: 4,
        bottom: 4,
        left: isMe ? 50 : 0,
        right: isMe ? 0 : 50,
      ),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: isMe
                ? LinearGradient(
              colors: [Color(0xff4A90E2), Color(0xff357ABD)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
                : null,
            color: isMe ? null : Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: isMe ? Radius.circular(20) : Radius.circular(5),
              bottomRight: isMe ? Radius.circular(5) : Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black87,
                  fontSize: 16,
                  fontFamily: 'Font4',
                ),
              ),
              if (timestamp != null) ...[
                SizedBox(height: 6),
                Text(
                  _formatTimestamp(timestamp),
                  style: TextStyle(
                    color: isMe ? Colors.white.withOpacity(0.7) : Colors.grey.shade600,
                    fontSize: 12,
                    fontFamily: 'Font4',
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _messageController,
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: "Type your message...",
                    hintStyle: TextStyle(
                      color: Colors.grey.shade500,
                      fontFamily: 'Font4',
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.attach_file, color: Colors.grey.shade500),
                      onPressed: () {
                        // Handle attachment
                      },
                    ),
                  ),
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Font4',
                  ),
                ),
              ),
            ),
            SizedBox(width: 12),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff4A90E2), Color(0xff357ABD)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(Icons.send_rounded, color: Colors.white, size: 24),
                onPressed: _sendMessage,
                padding: EdgeInsets.all(12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return '';

    DateTime dateTime = timestamp.toDate();
    DateTime now = DateTime.now();

    if (dateTime.day == now.day &&
        dateTime.month == now.month &&
        dateTime.year == now.year) {
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else {
      return '${dateTime.day}/${dateTime.month} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
  }

  void _showChatInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.info_outline, color: _primaryColor),
            SizedBox(width: 12),
            Text('Chat Information'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• Messages are sent directly to admin'),
            SizedBox(height: 8),
            Text('• Expect a response within 24 hours'),
            SizedBox(height: 8),
            Text('• For urgent matters, contact directly'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Got it'),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(double screenWidth) {
    return Drawer(
      width: screenWidth * 0.8,
      child: FutureBuilder<Map<String, dynamic>>(
        future: extraData,
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
                _buildDrawerHeader(data, screenWidth),
                Expanded(child: _buildDrawerItems(screenWidth)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDrawerHeader(Map<String, dynamic> data, double screenWidth) {
    return Container(
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
              backgroundImage: AssetImage(profileImage),
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
    );
  }

  Widget _buildDrawerItems(double screenWidth) {
    return ListView(
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
          isActive: true,
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