import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ClassRoutinePage extends StatefulWidget {
  @override
  _ClassRoutinePageState createState() => _ClassRoutinePageState();
}

class _ClassRoutinePageState extends State<ClassRoutinePage> {
  final List<String> days = ["Sun", "Mon", "Tues", "Wed", "Thurs"];
  String selectedDay = "Sun";
  Map<String, List<Map<String, String>>> routinesMap = {};
  bool isLoading = true;
  String errorMessage = '';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _fetchUserRoutine();
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
        appBar: AppBar(title: Text("Class Routine",style: TextStyle(fontFamily: 'Font5'),)),
        body: Center(child: Text(errorMessage)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Class Routine"),
        backgroundColor: Color(0xff075e57),
      ),
      body: Column(
        children: [
          // Day Selector
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            color: Colors.white,
            width: screenWidth,
            height: screenHeight*0.09,
            child: Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: days.map((day) {
                    return GestureDetector(
                      onTap: () {
                        setState(() => selectedDay = day);
                      },
                      child: Container(
                        width: screenWidth*0.3,
                        height: screenHeight*0.0457,
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: selectedDay == day
                              ? Color(0xff075e57)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Color(0xff075e57)),
                        ),
                        child: Center(
                          child: Text(
                            day,
                            style: TextStyle(
                              color: selectedDay == day
                                  ? Colors.white
                                  : Color(0xff075e57),
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth*0.04
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),

          // Class List
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : (routinesMap[selectedDay]?.isEmpty ?? true)
                ? Center(child: Text("No classes on $selectedDay"))
                : ListView.builder(
                              itemCount: routinesMap[selectedDay]!.length,
                              itemBuilder: (context, index) {
                  final classInfo = routinesMap[selectedDay]![index];
                  return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: ListTile(
                    title: Text(
                      classInfo['subject']!,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      classInfo['time']!,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                );
                  },
            ),
          ),
        ],
      ),
    );
  }
}
