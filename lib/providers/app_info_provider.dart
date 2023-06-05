import 'package:flutter/material.dart';
import 'package:uber_driver_app/models/directions_model.dart';

import '../models/history_model.dart';

class AppInfoProvider extends ChangeNotifier {
  DirectionsModel? driverPickUpLocation, driverDropOffLocation;
  int countTotalTrips = 0;
  String driverTotalEarnings = '0';
  String driverAverageRatings = '0';
  List<String> tripHistoryKeysList = [];
  List<HistoryModel> tripHistoryInfoList = [];

  void updatePickUpLocation(DirectionsModel driverPickUpAddress) {
    driverPickUpLocation = driverPickUpAddress;
    notifyListeners();
  }

  void updateDropOffLocation(DirectionsModel dropOffAddress) {
    driverDropOffLocation = dropOffAddress;
    notifyListeners();
  }

  void updateTripCounter(int tripCounter) {
    countTotalTrips = tripCounter;
    notifyListeners();
  }

  void updateTripKeys(List<String> tripKeysList) {
    tripHistoryKeysList = tripKeysList;
    notifyListeners();
  }

  void updateTripHistoryInfo(HistoryModel tripHistory) {
    tripHistoryInfoList.add(tripHistory);
    notifyListeners();
  }

  void updateDriverEarnings(String driverEarnings) {
    driverTotalEarnings = driverEarnings;
    notifyListeners();
  }

  void updateDriverRatings(String driverRatings) {
    driverAverageRatings = driverRatings;
    notifyListeners();
  }
}
