import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uber_driver_app/models/driver_model.dart';

import '../models/driver_data_model.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
UserCredential? currentDriver;
User? currentUser;
DriverModel? driverModel;
StreamSubscription<Position>? streamSubscription;
StreamSubscription<Position>? driverStreamSubscription;
AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();
Position? driverCurrentPosition;
DriverDataModel? driverDataModel = DriverDataModel();
String? driverCarType = '';
String starRatingTitle = 'Good';
bool isDriverActive = false;
String statusText = 'Offline';
