import 'package:flutter/material.dart';

class CgpaCalculatorPage extends StatefulWidget {
  @override
  _CgpaCalculatorPageState createState() => _CgpaCalculatorPageState();
}

class _CgpaCalculatorPageState extends State<CgpaCalculatorPage> {
  final List<Course> courses = [];
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _creditController = TextEditingController();
  String _selectedGrade = 'A+';
  int? _editingIndex;

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
    setState(() {
      courses.removeAt(index);
    });
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('CGPA Calculator', style: TextStyle(fontFamily: 'Font5')),
        backgroundColor: Color(0xff064a44),
        foregroundColor: Colors.white,
      ),
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Course Name',
                        labelStyle: TextStyle(color: Colors.white),
                        floatingLabelStyle: TextStyle(color: Colors.white),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the course name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: _creditController,
                      decoration: InputDecoration(
                        labelText: 'Course Credit',
                        labelStyle: TextStyle(color: Colors.white),
                        floatingLabelStyle: TextStyle(color: Colors.white),
                      ),
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
                    SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedGrade,
                      decoration: InputDecoration(
                        labelText: 'Obtained Grade',
                        labelStyle: TextStyle(color: Colors.white),
                        floatingLabelStyle: TextStyle(color: Colors.white),
                      ),
                      items: [
                        'A+', 'A', 'A-', 'B+', 'B', 'B-', 'C+', 'C', 'D', 'F'
                      ].map((String grade) {
                        return DropdownMenuItem<String>(
                          value: grade,
                          child: Text(grade),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedGrade = newValue!;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _addOrUpdateCourse,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff064a44),
                        foregroundColor: Color(0xffe8ede8),
                      ),
                      child: Text(_editingIndex == null ? 'Add Course' : 'Update Course'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    final course = courses[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xff469587),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: ListTile(
                          title: Text(course.name, style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(
                            'Credit: ${course.credit}, Grade: ${course.grade}',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.black),
                                onPressed: () => _editCourse(index),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteCourse(index),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xff278c74),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    'Calculated CGPA: ${_calculateCgpa().toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Font5',
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
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
