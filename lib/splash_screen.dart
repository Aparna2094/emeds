import 'dart:async';
 // Assuming login.dart is in the same directory or correct package

import 'package:final_emeds/admin/authentication/login.dart';
import 'package:flutter/material.dart';


class Screensplash extends StatefulWidget {
  const Screensplash({super.key});

  @override
  State<Screensplash> createState() => _ScreensplashState();
}

class _ScreensplashState extends State<Screensplash> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>const LoginForm()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('asset/img/emeds.png', height: 150,), // Assuming the image is in the 'assets' folder
      ),
    );
  }
}
