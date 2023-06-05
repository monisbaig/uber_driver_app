import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uber_driver_app/global_variables/global_variables.dart';

import '../../widgets/custom_design.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              driverDataModel!.name!,
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              'Rating: $starRatingTitle',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 20,
              width: 100,
              child: Divider(
                color: Colors.white,
                height: 2,
                thickness: 2,
              ),
            ),
            const SizedBox(height: 30),
            CustomDesign(
              textInfo: driverDataModel!.email!,
              iconData: Icons.email,
            ),
            CustomDesign(
              textInfo: driverDataModel!.phone!,
              iconData: Icons.phone_iphone,
            ),
            CustomDesign(
              textInfo:
                  '${driverDataModel!.carColor!} ${driverDataModel!.carModel!} ${driverDataModel!.carNumber!}',
              iconData: Icons.car_repair,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                firebaseAuth.signOut();
                SystemNavigator.pop();
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
