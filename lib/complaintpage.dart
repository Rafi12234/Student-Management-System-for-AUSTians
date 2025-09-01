import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class ComplaintPage extends StatefulWidget {
  const ComplaintPage({Key? key}) : super(key: key);

  @override
  State<ComplaintPage> createState() => _ComplaintPageState();
}

class _ComplaintPageState extends State<ComplaintPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _complaintController = TextEditingController();
  bool _isSubmitting = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _submitComplaint() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final String complaintText = _complaintController.text.trim();

    if (complaintText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please describe your issue')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await _firestore
          .collection('UsersAll')
          .doc(user.email)
          .collection('Complaint')
          .add({
        'description': complaintText,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Report submitted successfully'),
          backgroundColor: Color(0xff2E7D32),
        ),
      );

      _complaintController.clear();
    } catch (e) {
      print('Error submitting complaint: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ Failed to submit report'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  void dispose() {
    _complaintController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff064a44),
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.3),
        title: Text(
          'Report Harassment',
          style: TextStyle(
            fontSize: screenWidth * 0.045,
            color: Colors.white,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
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
            stops: [0.1, 0.3, 0.5, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Complaint Submission Section
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Icon(
                        Icons.security,
                        size: 48,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Report any harassment incident you\'ve experienced',
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Your report helps us take action',
                        style: TextStyle(
                          fontSize: screenWidth * 0.035,
                          color: Colors.white.withOpacity(0.9),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: TextFormField(
                            controller: _complaintController,
                            maxLines: 4,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Describe what happened...',
                              hintStyle: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 16,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(18.0),
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                            ),
                            cursorColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isSubmitting ? null : _submitComplaint,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff064a44),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 3,
                            shadowColor: Colors.black.withOpacity(0.3),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: _isSubmitting
                              ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                              : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.send,
                                  size: 20, color: Colors.white),
                              const SizedBox(width: 10),
                              Text(
                                'SUBMIT REPORT',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.038,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Previous Complaints Section
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 15,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.history,
                                color: Colors.white70, size: 24),
                            const SizedBox(width: 10),
                            Text(
                              'Your Previous Reports',
                              style: TextStyle(
                                fontSize: screenWidth * 0.045,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'All reports are confidential and will be handled promptly',
                          style: TextStyle(
                            fontSize: screenWidth * 0.03,
                            color: Colors.white.withOpacity(0.7),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 15),
                        if (user != null)
                          Expanded(
                            child: StreamBuilder<QuerySnapshot>(
                              stream: _firestore
                                  .collection('UsersAll')
                                  .doc(user.email)
                                  .collection('Complaint')
                                  .orderBy('timestamp', descending: true)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Center(
                                    child: Text(
                                      'Error loading reports',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.8),
                                      ),
                                    ),
                                  );
                                }

                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  );
                                }

                                if (!snapshot.hasData ||
                                    snapshot.data!.docs.isEmpty) {
                                  return Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.inbox,
                                            size: 60,
                                            color: Colors.white.withOpacity(0.4)),
                                        const SizedBox(height: 10),
                                        Text(
                                          'No reports submitted yet',
                                          style: TextStyle(
                                            fontSize: screenWidth * 0.04,
                                            color: Colors.white.withOpacity(0.7),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }

                                return ListView.separated(
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: snapshot.data!.docs.length,
                                  separatorBuilder: (context, index) =>
                                  const Divider(
                                    color: Colors.white24,
                                    height: 20,
                                    thickness: 0.5,
                                  ),
                                  itemBuilder: (context, index) {
                                    var doc = snapshot.data!.docs[index];
                                    var data = doc.data() as Map<String, dynamic>;
                                    String description = data['description'] ?? '';
                                    Timestamp? timestamp = data['timestamp'] as Timestamp?;
                                    DateTime date = timestamp?.toDate() ?? DateTime.now();

                                    return Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.08),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                DateFormat('MMM dd, yyyy').format(date),
                                                style: TextStyle(
                                                  color: Colors.white.withOpacity(0.7),
                                                  fontSize: screenWidth * 0.032,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Text(
                                                DateFormat('hh:mm a').format(date),
                                                style: TextStyle(
                                                  color: Colors.white.withOpacity(0.7),
                                                  fontSize: screenWidth * 0.032,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            description,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: screenWidth * 0.038,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
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
      ),
    );
  }
}