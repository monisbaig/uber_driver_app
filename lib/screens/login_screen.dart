// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uber_driver_app/global_variables/global_variables.dart';
import 'package:uber_driver_app/screens/signup_screen.dart';
import 'package:uber_driver_app/screens/splash_screen.dart';

import '../widgets/custom_textfield.dart';
import '../widgets/progress_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void validateForm() {
    if (!emailController.text.contains('@')) {
      Fluttertoast.showToast(msg: 'Email address not valid.');
    } else if (passwordController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter your correct Password.');
    } else {
      login();
    }
  }

  void login() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const ProgressDialog(
        message: 'Processing, Please wait...',
      ),
    );
    try {
      final UserCredential driver =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (driver.user != null) {
        DatabaseReference driversRef =
            FirebaseDatabase.instance.ref().child('drivers');
        driversRef
            .child(firebaseAuth.currentUser!.uid)
            .once()
            .then((driverKey) {
          final snapshot = driverKey.snapshot;
          if (snapshot.value != null) {
            currentDriver = driver;
            Fluttertoast.showToast(msg: 'Login Successfully');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MySplashScreen(),
              ),
            );
          } else {
            Fluttertoast.showToast(msg: 'No record exist with this email');
            firebaseAuth.signOut();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MySplashScreen(),
              ),
            );
          }
        });
      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: 'Login Failed, Check your credentials.');
      }
    } catch (e) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Image.asset(
                    'assets/images/uber_driver_logo.png',
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Login as a Driver',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: emailController,
                    type: TextInputType.emailAddress,
                    text: 'Email',
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: passwordController,
                    type: TextInputType.visiblePassword,
                    obscureText: true,
                    text: 'Password',
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignupScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Don't have any Account? SignUp Now",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: validateForm,
                    child: const Text(
                      'Login',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
