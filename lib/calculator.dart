import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/calculator.dart';
import 'package:project/chatscreen.dart';
import 'package:project/dropdownbuttonpage.dart';
import 'package:project/login.dart';
import 'package:project/newpage2.dart';
import 'package:project/notice_portal.dart';
import 'package:project/routine.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project/semesterselection.dart';
import 'package:project/teachersinfo.dart';

class CgpaCalculatorPage extends StatefulWidget {
  @override
  _CgpaCalculatorPageState createState() => _CgpaCalculatorPageState();
}

class _CgpaCalculatorPageState extends State<CgpaCalculatorPage> with TickerProviderStateMixin {
  final List<Course> courses = [];
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _creditController = TextEditingController();
  String _selectedGrade = 'A+';
  int? _editingIndex;
  late Future<Map<String, dynamic>> extraData;
  late String profileImage;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  final Color _primaryColor = const Color(0xff064a44);
  final Color _accentColor = const Color(0xff54998e);
  final Color _backgroundColor = const Color(0xffe0f0ee);

  @override
  void initState() {
    super.initState();
    extraData = fetchExtraData();
    profileImage = getProfileImage();

    _fadeController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));

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
      case 'sazid.cse.20230104062@aust.edu':
        return 'assets/images/Sazid.jfif';
      default:
        return 'assets/images/default_avatar.png';
    }
  }

  void _addOrUpdateCourse() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        final course = Course(
          name: _nameController.text,
          credit: double.parse(_creditController.text),
          grade: _selectedGrade,
        );
        if (_editingIndex == null) {
          courses.add(course);
        } else {
          courses[_editingIndex!] = course;
          _editingIndex = null;
        }
        _nameController.clear();
        _creditController.clear();
        _selectedGrade = 'A+';
      });

      // Add haptic feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text(_editingIndex == null ? 'Course added successfully!' : 'Course updated successfully!'),
            ],
          ),
          backgroundColor: Color(0xff064a44),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _editCourse(int index) {
    final course = courses[index];
    _nameController.text = course.name;
    _creditController.text = course.credit.toString();
    setState(() {
      _selectedGrade = course.grade;
      _editingIndex = index;
    });
  }

  void _deleteCourse(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange),
            SizedBox(width: 12),
            Text('Delete Course'),
          ],
        ),
        content: Text('Are you sure you want to delete this course?'),
        actions: [
          TextButton(
            child: Text('Cancel', style: TextStyle(color: Colors.grey)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text('Delete', style: TextStyle(color: Colors.red)),
            onPressed: () {
              setState(() {
                courses.removeAt(index);
              });
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.white),
                      SizedBox(width: 8),
                      Text('Course deleted successfully!'),
                    ],
                  ),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  double _calculateCgpa() {
    double totalCredits = 0;
    double totalGradePoints = 0;

    for (var course in courses) {
      totalCredits += course.credit;
      totalGradePoints += course.credit * _gradeToPoint(course.grade);
    }

    return totalCredits == 0 ? 0 : totalGradePoints / totalCredits;
  }

  double _gradeToPoint(String grade) {
    switch (grade) {
      case 'A+':
        return 4.00;
      case 'A':
        return 3.75;
      case 'A-':
        return 3.50;
      case 'B+':
        return 3.25;
      case 'B':
        return 3.00;
      case 'B-':
        return 2.75;
      case 'C+':
        return 2.50;
      case 'C':
        return 2.25;
      case 'D':
        return 2.00;
      case 'F':
        return 0.00;
      default:
        return 0.00;
    }
  }

  Color _getGradeColor(String grade) {
    switch (grade) {
      case 'A+':
      case 'A':
        return Colors.green;
      case 'A-':
      case 'B+':
        return Colors.lightGreen;
      case 'B':
      case 'B-':
        return Colors.orange;
      case 'C+':
      case 'C':
        return Colors.deepOrange;
      case 'D':
        return Colors.red;
      case 'F':
        return Colors.red.shade900;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'CGPA Calculator',
          style: TextStyle(
            fontFamily: 'Font5',
            fontWeight: FontWeight.bold,
            fontSize: 22,
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
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.menu, color: Colors.white),
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.info_outline, color: Colors.white),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  title: Row(
                    children: [
                      Icon(Icons.info, color: Color(0xff064a44)),
                      SizedBox(width: 12),
                      Text('Grade Scale'),
                    ],
                  ),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        'A+: 4.00', 'A: 3.75', 'A-: 3.50', 'B+: 3.25', 'B: 3.00',
                        'B-: 2.75', 'C+: 2.50', 'C: 2.25', 'D: 2.00', 'F: 0.00'
                      ].map((grade) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(grade.split(':')[0], style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(grade.split(':')[1]),
                          ],
                        ),
                      )).toList(),
                    ),
                  ),
                  actions: [
                    TextButton(
                      child: Text('OK', style: TextStyle(color: Color(0xff064a44))),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
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
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Card
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.25),
                          Colors.white.withOpacity(0.15),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.calculate_outlined,
                          size: 40,
                          color: Colors.white,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Calculate Your CGPA',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Font5',
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Add your courses and grades to calculate your CGPA',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.8),
                            fontFamily: 'Font4',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24),

                  // Course Input Form
                  Container(
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 15,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _editingIndex == null ? 'Add New Course' : 'Edit Course',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'Font5',
                            ),
                          ),
                          SizedBox(height: 20),

                          // Course Name Field
                          _buildInputField(
                            controller: _nameController,
                            label: 'Course Name',
                            icon: Icons.book_outlined,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the course name';
                              }
                              return null;
                            },
                          ),

                          SizedBox(height: 16),

                          // Credit Field
                          _buildInputField(
                            controller: _creditController,
                            label: 'Course Credit',
                            icon: Icons.credit_score_outlined,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the course credit';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Please enter a valid number';
                              }
                              return null;
                            },
                          ),

                          SizedBox(height: 16),

                          // Grade Dropdown
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                              ),
                            ),
                            child: DropdownButtonFormField<String>(
                              value: _selectedGrade,
                              decoration: InputDecoration(
                                labelText: 'Obtained Grade',
                                labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
                                prefixIcon: Icon(Icons.grade_outlined, color: Colors.white.withOpacity(0.7)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.transparent,
                              ),
                              dropdownColor: Color(0xff064a44),
                              style: TextStyle(color: Colors.white),
                              items: [
                                'A+', 'A', 'A-', 'B+', 'B', 'B-', 'C+', 'C', 'D', 'F'
                              ].map((String grade) {
                                return DropdownMenuItem<String>(
                                  value: grade,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(grade, style: TextStyle(color: Colors.white)),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: _getGradeColor(grade).withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          _gradeToPoint(grade).toString(),
                                          style: TextStyle(
                                            color: _getGradeColor(grade),
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedGrade = newValue!;
                                });
                              },
                            ),
                          ),

                          SizedBox(height: 24),

                          // Add/Update Button
                          Container(
                            width: double.infinity,
                            height: 55,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xff064a44), Color(0xff048c76)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xff064a44).withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: _addOrUpdateCourse,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    _editingIndex == null ? Icons.add : Icons.update,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    _editingIndex == null ? 'Add Course' : 'Update Course',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 24),

                  // Courses List
                  if (courses.isNotEmpty) ...[
                    Text(
                      'Added Courses (${courses.length})',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Font5',
                      ),
                    ),
                    SizedBox(height: 16),

                    ...courses.asMap().entries.map((entry) {
                      int index = entry.key;
                      Course course = entry.value;

                      return Container(
                        margin: EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.2),
                              Colors.white.withOpacity(0.1),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16),
                          leading: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: _getGradeColor(course.grade).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              course.grade,
                              style: TextStyle(
                                color: _getGradeColor(course.grade),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          title: Text(
                            course.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'Credit: ${course.credit}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'Points: ${_gradeToPoint(course.grade)}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue.shade300, size: 20),
                                  onPressed: () => _editCourse(index),
                                ),
                              ),
                              SizedBox(width: 8),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red.shade300, size: 20),
                                  onPressed: () => _deleteCourse(index),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),

                    SizedBox(height: 24),
                  ] else ...[
                    SizedBox(height: 24),
                    Center(
                      child: Container(
                        padding: EdgeInsets.all(40),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.school_outlined,
                              size: 60,
                              color: Colors.white.withOpacity(0.5),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No Courses Added Yet',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white.withOpacity(0.7),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Add your first course to get started',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                  ],

                  // CGPA Result
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xff064a44),
                          Color(0xff048c76),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xff064a44).withOpacity(0.3),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.emoji_events_outlined,
                          size: 40,
                          color: Colors.white,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Your CGPA',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white.withOpacity(0.9),
                            fontFamily: 'Font4',
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '${_calculateCgpa().toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Font5',
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'out of 4.00',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.8),
                            fontFamily: 'Font4',
                          ),
                        ),
                        if (courses.isNotEmpty) ...[
                          SizedBox(height: 16),
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      'Total Courses',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '${courses.length}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 40,
                                  width: 1,
                                  color: Colors.white.withOpacity(0.3),
                                ),
                                Column(
                                  children: [
                                    Text(
                                      'Total Credits',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '${courses.fold(0.0, (sum, course) => sum + course.credit)}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
        ),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
          prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.7)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.transparent,
          errorStyle: TextStyle(color: Colors.red.shade300),
        ),
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
                        isActive: true,
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

class Course {
  final String name;
  final double credit;
  final String grade;

  Course({
    required this.name,
    required this.credit,
    required this.grade,
  });
}