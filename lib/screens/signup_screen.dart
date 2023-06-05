// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uber_driver_app/global_variables/global_variables.dart';
import 'package:uber_driver_app/screens/car_info_screen.dart';
import 'package:uber_driver_app/screens/login_screen.dart';
import 'package:uber_driver_app/widgets/custom_textfield.dart';
import 'package:uber_driver_app/widgets/progress_dialog.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void validateForm() {
    if (nameController.text.length < 3) {
      Fluttertoast.showToast(msg: 'Name must be at least 3 Characters.');
    } else if (!emailController.text.contains('@')) {
      Fluttertoast.showToast(msg: 'Email address not valid.');
    } else if (phoneController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Phone Number required.');
    } else if (passwordController.text.length < 6) {
      Fluttertoast.showToast(
          msg: 'Password must be at least 6 characters long.');
    } else {
      saveFormData();
    }
  }

  saveFormData() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const ProgressDialog(
        message: 'Processing, Please wait...',
      ),
    );
    try {
      final UserCredential driver =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (driver != null) {
        Map driversData = {
          'id': driver.user!.uid,
          'name': nameController.text.trim(),
          'email': emailController.text.trim(),
          'phone': phoneController.text.trim(),
        };
        DatabaseReference driversRef =
            FirebaseDatabase.instance.ref().child('drivers');
        driversRef.child(driver.user!.uid).set(driversData);

        currentDriver = driver;
        Fluttertoast.showToast(msg: 'Account has been Created.');

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CarInfoScreen(),
          ),
        );
      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: 'Account has not been Created.');
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Image.asset(
                    'assets/images/uber_driver_logo.png',
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Register as a Driver',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: nameController,
                    type: TextInputType.text,
                    text: 'Name',
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: emailController,
                    type: TextInputType.emailAddress,
                    text: 'Email',
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: phoneController,
                    type: TextInputType.phone,
                    text: 'Phone',
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
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Already have an Account? Login Now",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: validateForm,
                    child: const Text(
                      'Create Account',
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
