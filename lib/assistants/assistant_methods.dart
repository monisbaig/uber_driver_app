import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uber_driver_app/assistants/request_assistant.dart';
import 'package:uber_driver_app/global_variables/global_variables.dart';
import 'package:uber_driver_app/global_variables/map_keys.dart';
import 'package:uber_driver_app/models/direction_details_model.dart';
import 'package:uber_driver_app/models/directions_model.dart';
import 'package:uber_driver_app/models/driver_model.dart';
import 'package:uber_driver_app/providers/app_info_provider.dart';

import '../models/history_model.dart';

class AssistantMethods {
  static Future<String> reverseGeocoding(Position position, context) async {
    String url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey';
    String readableAddress = '';
    var response = await RequestAssistant.receiveRequest(url);
    if (response != 'Error Occurred') {
      readableAddress = response['results'][0]['formatted_address'];

      DirectionsModel? directionsModel = DirectionsModel();

      directionsModel.locationName = readableAddress;
      directionsModel.locationLatitude = position.latitude;
      directionsModel.locationLongitude = position.longitude;

      Provider.of<AppInfoProvider>(context, listen: false)
          .updatePickUpLocation(directionsModel);
    }
    return readableAddress;
  }

  static void readCurrentOnlineDriverInfo() async {
    DatabaseReference driverRef = FirebaseDatabase.instance
        .ref()
        .child('drivers')
        .child(firebaseAuth.currentUser!.uid);

    driverRef.once().then((snap) {
      if (snap.snapshot.value != null) {
        driverModel = DriverModel.fromSnapshot(snap.snapshot);
      }
    });
  }

  static Future<DirectionDetailsModel?> getDirectionDetail(
      LatLng origin, LatLng destination) async {
    String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$mapKey';
    var directionResponse = await RequestAssistant.receiveRequest(url);

    if (directionResponse == 'Error Occurred') {
      return null;
    }
    DirectionDetailsModel directionDetailsModel = DirectionDetailsModel();

    directionDetailsModel.points =
        directionResponse['routes'][0]['overview_polyline']['points'];

    directionDetailsModel.distanceText =
        directionResponse['routes'][0]['legs'][0]['distance']['text'];

    directionDetailsModel.distanceValue =
        directionResponse['routes'][0]['legs'][0]['distance']['value'];

    directionDetailsModel.durationText =
        directionResponse['routes'][0]['legs'][0]['duration']['text'];

    directionDetailsModel.durationValue =
        directionResponse['routes'][0]['legs'][0]['duration']['value'];

    return directionDetailsModel;
  }

  static pauseLiveLocationUpdates() {
    streamSubscription!.pause();
    Geofire.removeLocation(currentUser!.uid);
  }

  static resumeLiveLocationUpdates() {
    streamSubscription!.resume();
    Geofire.setLocation(
      currentUser!.uid,
      driverCurrentPosition!.latitude,
      driverCurrentPosition!.longitude,
    );
  }

  static double calculateTripFee(DirectionDetailsModel directionDetailsModel) {
    double amountPerMin = (directionDetailsModel.durationValue! / 60) * 0.1;
    double amountPerKM = (directionDetailsModel.distanceValue! / 1000) * 0.1;

    double totalAmount = amountPerMin + amountPerKM;

    double totalInPKR = totalAmount * 120;

    if (driverCarType == 'bike') {
      double finalAmount = (totalInPKR.truncate()) / 2.0;
      return finalAmount;
    } else if (driverCarType == 'uber-go') {
      return totalInPKR.truncateToDouble();
    } else if (driverCarType == 'uber-x') {
      double finalAmount = (totalInPKR.truncate()) * 2.0;
      return finalAmount;
    } else {
      return totalInPKR.truncateToDouble();
    }
  }

  static void readTripKeys(context) {
    FirebaseDatabase.instance
        .ref()
        .child('All Ride Requests')
        .orderByChild('driverId')
        .equalTo(firebaseAuth.currentUser!.uid)
        .once()
        .then((driverKeyData) {
      if (driverKeyData.snapshot.value != null) {
        Map tripKeys = driverKeyData.snapshot.value as Map;

        int tripCounter = tripKeys.length;

        Provider.of<AppInfoProvider>(context, listen: false)
            .updateTripCounter(tripCounter);

        List<String> tripKeysList = [];

        tripKeys.forEach((key, value) {
          tripKeysList.add(key);
        });

        Provider.of<AppInfoProvider>(context, listen: false)
            .updateTripKeys(tripKeysList);

        readTripHistoryInfo(context);
      }
    });
  }

  static void readTripHistoryInfo(context) {
    var allTripKeys = Provider.of<AppInfoProvider>(context, listen: false)
        .tripHistoryKeysList;

    for (String getKey in allTripKeys) {
      FirebaseDatabase.instance
          .ref()
          .child('All Ride Requests')
          .child(getKey)
          .once()
          .then((key) {
        var tripHistory = HistoryModel.fromSnapshot(key.snapshot);

        if ((key.snapshot.value as Map)['status'] == 'ended') {
          Provider.of<AppInfoProvider>(context, listen: false)
              .updateTripHistoryInfo(tripHistory);
        }
      });
    }
  }

  static void readDriverEarnings(context) {
    FirebaseDatabase.instance
        .ref()
        .child('drivers')
        .child(firebaseAuth.currentUser!.uid)
        .child('earnings')
        .once()
        .then((earningData) {
      if (earningData.snapshot.value != null) {
        String driverEarnings = earningData.snapshot.value.toString();
        Provider.of<AppInfoProvider>(context, listen: false)
            .updateDriverEarnings(driverEarnings);
      }
    });

    readTripKeys(context);
  }

  static void readDriverRatings(context) {
    FirebaseDatabase.instance
        .ref()
        .child('drivers')
        .child(firebaseAuth.currentUser!.uid)
        .child('ratings')
        .once()
        .then((ratingData) {
      if (ratingData.snapshot.value != null) {
        String driverRatings = ratingData.snapshot.value.toString();
        Provider.of<AppInfoProvider>(context, listen: false)
            .updateDriverRatings(driverRatings);
      }
    });
  }
}
