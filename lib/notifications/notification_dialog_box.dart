import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uber_driver_app/assistants/assistant_methods.dart';
import 'package:uber_driver_app/global_variables/global_variables.dart';
import 'package:uber_driver_app/models/ride_request_model.dart';
import 'package:uber_driver_app/screens/new_trip_screen.dart';

class NotificationDialogBox extends StatefulWidget {
  final RideRequestModel rideRequestModel;

  const NotificationDialogBox({super.key, required this.rideRequestModel});

  @override
  State<NotificationDialogBox> createState() => _NotificationDialogBoxState();
}

class _NotificationDialogBoxState extends State<NotificationDialogBox> {
  acceptRideRequest(context) {
    String? getRequestId;

    FirebaseDatabase.instance
        .ref()
        .child('drivers')
        .child(currentUser!.uid)
        .child('driverStatus')
        .once()
        .then((snapshot) {
      if (snapshot.snapshot.value != null) {
        getRequestId = snapshot.snapshot.value.toString();
      } else {
        Fluttertoast.showToast(msg: 'This ride request do not exists.');
      }

      if (getRequestId == widget.rideRequestModel.rideRequestId) {
        FirebaseDatabase.instance
            .ref()
            .child('drivers')
            .child(currentUser!.uid)
            .child('driverStatus')
            .set('accepted');

        AssistantMethods.pauseLiveLocationUpdates();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewTripScreen(
              rideRequestModel: widget.rideRequestModel,
            ),
          ),
        );
      } else {
        Fluttertoast.showToast(msg: 'Invalid Ride Request.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      elevation: 2,
      backgroundColor: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.all(8),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 15),
            Image.asset(
              'assets/images/car_logo.png',
              width: 160,
            ),
            const SizedBox(height: 2),
            const Text(
              'New Ride',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/origin.png',
                        width: 40,
                      ),
                      const SizedBox(width: 14),
                      Flexible(
                        child: Text(
                          widget.rideRequestModel.originAddress!,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/destination.png',
                        width: 30,
                      ),
                      const SizedBox(width: 14),
                      Flexible(
                        child: Text(
                          widget.rideRequestModel.destinationAddress!,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    assetsAudioPlayer.pause();
                    assetsAudioPlayer.stop();
                    assetsAudioPlayer = AssetsAudioPlayer();

                    FirebaseDatabase.instance
                        .ref()
                        .child('All Ride Requests')
                        .child(widget.rideRequestModel.rideRequestId!)
                        .remove()
                        .then((rideData) {
                      FirebaseDatabase.instance
                          .ref()
                          .child('drivers')
                          .child(currentUser!.uid)
                          .child('driverStatus')
                          .set('idle');
                    }).then((driver) {
                      FirebaseDatabase.instance
                          .ref()
                          .child('drivers')
                          .child(currentUser!.uid)
                          .child('tripsHistory')
                          .child(widget.rideRequestModel.rideRequestId!)
                          .remove();
                    }).then((message) {
                      Fluttertoast.showToast(
                          msg: 'You cancelled the ride request.');
                    });
                    Future.delayed(const Duration(seconds: 3), () {
                      SystemNavigator.pop();
                    });
                  },
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 15),
                ElevatedButton(
                  onPressed: () {
                    assetsAudioPlayer.pause();
                    assetsAudioPlayer.stop();
                    assetsAudioPlayer = AssetsAudioPlayer();
                    acceptRideRequest(context);
                  },
                  child: const Text('Accept'),
                ),
              ],
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
