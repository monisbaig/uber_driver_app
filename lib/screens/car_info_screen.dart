import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uber_driver_app/global_variables/global_variables.dart';
import 'package:uber_driver_app/screens/splash_screen.dart';

import '../widgets/custom_textfield.dart';

class CarInfoScreen extends StatefulWidget {
  const CarInfoScreen({Key? key}) : super(key: key);

  @override
  State<CarInfoScreen> createState() => _CarInfoScreenState();
}

class _CarInfoScreenState extends State<CarInfoScreen> {
  TextEditingController carModelController = TextEditingController();
  TextEditingController carNumberController = TextEditingController();
  TextEditingController carColorController = TextEditingController();

  List<String> carTypes = [
    'uber-x',
    'uber-go',
    'uber-bike',
  ];

  String? selectedCarType;

  void saveCarInfo() {
    Map carData = {
      'car_color': carColorController.text.trim(),
      'car_number': carNumberController.text.trim(),
      'car_model': carModelController.text.trim(),
      'car_type': selectedCarType,
    };
    DatabaseReference driversRef =
        FirebaseDatabase.instance.ref().child('drivers');
    driversRef
        .child(currentDriver!.user!.uid)
        .child('car_details')
        .set(carData);

    Fluttertoast.showToast(msg: 'Car Data saved successfully');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MySplashScreen(),
      ),
    );
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
                    'Enter your Car Details',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: carModelController,
                    text: 'Car Model',
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: carNumberController,
                    text: 'Car Number',
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: carColorController,
                    text: 'Car Color',
                  ),
                  const SizedBox(height: 10),
                  DropdownButton(
                    isExpanded: true,
                    borderRadius: BorderRadius.circular(12),
                    underline: Container(),
                    hint: const Text(
                      'Please choose Car Type',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    value: selectedCarType,
                    items: carTypes.map((item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(
                          item,
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCarType = value.toString();
                      });
                    },
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      if (carColorController.text.isNotEmpty &&
                          carModelController.text.isNotEmpty &&
                          carNumberController.text.isNotEmpty &&
                          selectedCarType != null) {
                        saveCarInfo();
                      }
                    },
                    child: const Text(
                      'Save Now',
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
