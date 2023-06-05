import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uber_driver_app/assistants/assistant_methods.dart';
import 'package:uber_driver_app/global_variables/global_variables.dart';
import 'package:uber_driver_app/screens/login_screen.dart';
import 'package:uber_driver_app/screens/main_screen.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  void startTimer() {
    firebaseAuth.currentUser != null
        ? AssistantMethods.readCurrentOnlineDriverInfo()
        : null;

    Timer(
      const Duration(seconds: 3),
      () async {
        if (firebaseAuth.currentUser != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MainScreen(),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          );
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SizedBox(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/uber_driver_logo.png',
              ),
              const SizedBox(height: 10),
              const Text(
                'Uber Driver App',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
