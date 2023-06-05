import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uber_driver_app/providers/app_info_provider.dart';
import 'package:uber_driver_app/screens/trip_history_screen.dart';

class EarningScreen extends StatefulWidget {
  const EarningScreen({Key? key}) : super(key: key);

  @override
  State<EarningScreen> createState() => _EarningScreenState();
}

class _EarningScreenState extends State<EarningScreen> {
  @override
  Widget build(BuildContext context) {
    var totalEarnings = Provider.of<AppInfoProvider>(context, listen: false)
        .driverTotalEarnings;
    var totalTrips = Provider.of<AppInfoProvider>(context, listen: false)
        .tripHistoryInfoList;

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            color: Colors.blue,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 80),
              child: Column(
                children: [
                  const Text(
                    'Your Earnings',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    totalEarnings,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TripHistoryScreen(),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/car_logo.png',
                    width: 100,
                  ),
                  const SizedBox(width: 20),
                  const Text(
                    'Trips Completed',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  Expanded(child: Container()),
                  Text(
                    totalTrips.length.toString(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
