import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project/dashboard.dart';
import 'package:project/forgotpass.dart';
import 'package:project/Info.dart';
import 'package:project/animationpage.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _Login();
}

class _Login extends State<Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';
  bool _obscurePassword = true;

  // Automatically check if the user is already logged in
  @override
  void initState() {
    super.initState();
    _checkLoggedInState();
  }

  void _checkLoggedInState() async {
    User? user = _auth.currentUser;
    if (user != null) {
      // Navigate directly to Dashboard if user is already logged in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Dashboard()),
      );
    }
  }
  bool _isLoading = false;

  Future<void> _login() async {  // Change return type to Future<void>
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginSuccessAnimation(),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _errorMessage = 'Login failed. Please Check Your Edu Mail & Password Again');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff075e57),
        foregroundColor: Colors.white,
        centerTitle: true,
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
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Image.asset(
                  'assets/images/logo.png',
                  width: screenWidth * 0.2,
                  height: screenHeight * 0.15,
                ),
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [
                    Color(0xff064a44),
                    Color(0xff064a44)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: Text(
                  'AUSTElevate',
                  style: TextStyle(
                    fontSize: screenWidth * 0.085,
                    color: Colors.white,
                    fontFamily: 'Font2',
                    shadows: [
                      Shadow(
                        offset: Offset(2.0, 2.0),
                        blurRadius: 20.0,
                        color: Colors.grey.withOpacity(0.5),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.06,
              ),
              Container(
                padding: EdgeInsets.all(20),
                width: screenWidth * 0.8,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xff075e57),
                      Color(0xff048c76),
                      Color(0xff075e57)
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 15,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [
                          Color(0xff048c76),
                          Color(0xff048c76),
                          Color(0xff048c76),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: Text(
                        'User Edu Mail',
                        style: TextStyle(
                          fontSize: screenWidth * 0.06,
                          color: Colors.white,
                          fontFamily: 'Font1',
                          fontWeight: FontWeight.w600,
                          shadows: [
                            Shadow(
                              offset: Offset(2.0, 2.0),
                              blurRadius: 10.0,
                              color: Colors.black.withOpacity(0.4),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Enter Email',
                        prefixIcon: Icon(Icons.email, color: Colors.white54), // Added mail icon
                        labelStyle: TextStyle(
                          color: Colors.white54,
                          fontSize: screenWidth * 0.04,
                        ),
                        hintText: 'Enter Your Edu Mail',
                        hintStyle: TextStyle(color: Colors.white54),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 2.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: Colors.white10,
                            width: 1.5,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: Colors.white12,
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [
                          Color(0xff075e57),
                          Color(0xff075e57),
                          Color(0xff075e57),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: Text(
                        'Password',
                        style: TextStyle(
                          fontSize: screenWidth * 0.06,
                          color: Colors.white,
                          fontFamily: 'Font1',
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              offset: Offset(2.0, 2.0),
                              blurRadius: 10.0,
                              color: Colors.black.withOpacity(0.2),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword, // Add this state variable: bool _obscurePassword = true;
                      decoration: InputDecoration(
                        labelText: 'Enter Password',
                        prefixIcon: Icon(Icons.lock, color: Colors.white54), // Added lock icon
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                            color: Colors.white54,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        labelStyle: TextStyle(
                          color: Colors.white54,
                          fontSize: screenWidth * 0.04,
                        ),
                        hintText: 'Enter Your Password',
                        hintStyle: TextStyle(color: Colors.white54),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 2.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: Colors.white10,
                            width: 1.5,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 1.5,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: Colors.redAccent,
                            width: 2.0,
                          ),
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.018),
                    ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () {
                        // Remove async from here and handle in _login
                        _login();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff075e57),
                        foregroundColor: const Color(0xffe8ede8),
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 5,
                        shadowColor: const Color(0xff054b4a),
                      ),
                      child: _isLoading
                          ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                          : Text(
                        'Sign In',
                        style: TextStyle(fontSize: screenWidth * 0.04),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.019),
                    Text(
                      _errorMessage,
                      style: TextStyle(color: Colors.red),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PasswordResetPage()),
                        );
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                            fontSize: screenWidth * 0.03, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
