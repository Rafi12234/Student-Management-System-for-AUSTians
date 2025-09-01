import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'login.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _blurAnimation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _blurAnimation = Tween<double>(begin: 1, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward().then((_) {
      Future.delayed(Duration(milliseconds: 200), () {
        _controller.reverse().then((_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Login()),
          );
        });
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _opacityAnimation.value,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: _blurAnimation.value, sigmaY: _blurAnimation.value),
                child: Image.asset(
                  'assets/images/app_logo.png',
                  width: 500,
                  height: 500,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
