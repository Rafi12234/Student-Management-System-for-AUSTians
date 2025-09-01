import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:project/dashboard.dart';

class LoginSuccessAnimation extends StatefulWidget {
  const LoginSuccessAnimation({super.key});

  @override
  State<LoginSuccessAnimation> createState() => _LoginSuccessAnimationState();
}

class _LoginSuccessAnimationState extends State<LoginSuccessAnimation> with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    // Navigate to dashboard after animation completes
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Dashboard()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          width: screenWidth*0.6,
          height: screenHeight*0.6,
          child: Lottie.asset(
              'assets/animation/Animation3.json', // Path to your Lottie JSON file
            controller: _controller,
            onLoaded: (composition) {
              _controller
                ..duration = composition.duration
                ..forward();
            },
          ),
        ),
      ),
    );
  }
}