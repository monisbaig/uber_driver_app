import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_driver_app/global_variables/global_variables.dart';
import 'package:uber_driver_app/models/ride_request_model.dart';
import 'package:uber_driver_app/notifications/notification_dialog_box.dart';

class PushNotifications {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future initializeCloudMessaging(context) async {
    //  1. Terminated
    messaging.getInitialMessage().then((RemoteMessage? remoteMessage) {
      if (remoteMessage != null) {
        readRideRequestInfo(remoteMessage.data['rideRequestId'], context);
      }
    });

    //  2. Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage? remoteMessage) {
      readRideRequestInfo(remoteMessage!.data['rideRequestId'], context);
    });

    //  3. Background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? remoteMessage) {
      readRideRequestInfo(remoteMessage!.data['rideRequestId'], context);
    });
  }

  readRideRequestInfo(String requestId, context) {
    FirebaseDatabase.instance
        .ref()
        .child('All Ride Requests')
        .child(requestId)
        .once()
        .then((rideData) {
      if (rideData.snapshot.value != null) {
        assetsAudioPlayer.open(
          Audio('assets/notifications/music_notification.mp3'),
        );
        assetsAudioPlayer.play();

        double originLat = double.parse(
            (rideData.snapshot.value as Map)['origin']['latitude'].toString());
        double originLng = double.parse(
            (rideData.snapshot.value as Map)['origin']['longitude'].toString());
        String originAddress =
            (rideData.snapshot.value as Map)['originAddress'];

        double destinationLat = double.parse(
            (rideData.snapshot.value as Map)['destination']['latitude']
                .toString());
        double destinationLng = double.parse(
            (rideData.snapshot.value as Map)['destination']['longitude']
                .toString());
        String destinationAddress =
            (rideData.snapshot.value as Map)['destinationAddress'];

        String userName = (rideData.snapshot.value as Map)['userName'];
        String userPhone = (rideData.snapshot.value as Map)['userPhone'];
        String userId = rideData.snapshot.key!;

        RideRequestModel rideRequestModel = RideRequestModel();

        rideRequestModel.originLatLng = LatLng(originLat, originLng);
        rideRequestModel.originAddress = originAddress;
        rideRequestModel.destinationLatLng =
            LatLng(destinationLat, destinationLng);
        rideRequestModel.destinationAddress = destinationAddress;

        rideRequestModel.userName = userName;
        rideRequestModel.userPhone = userPhone;
        rideRequestModel.rideRequestId = userId;

        showDialog(
          context: context,
          builder: (context) => NotificationDialogBox(
            rideRequestModel: rideRequestModel,
          ),
        );
      } else {
        Fluttertoast.showToast(msg: 'Invalid Request Id');
      }
    });
  }

  Future generateToken() async {
    final fcmToken = await messaging.getToken();

    FirebaseDatabase.instance
        .ref()
        .child('drivers')
        .child(currentDriver!.user!.uid)
        .child('fcmToken')
        .set(fcmToken);

    // subscribe to topic on each app start-up
    await messaging.subscribeToTopic('allDrivers');
    await messaging.subscribeToTopic('allUsers');
  }
}
