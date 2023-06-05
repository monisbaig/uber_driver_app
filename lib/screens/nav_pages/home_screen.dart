// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_driver_app/assistants/assistant_methods.dart';
import 'package:uber_driver_app/global_variables/global_variables.dart';
import 'package:uber_driver_app/notifications/push_notifications.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Completer<GoogleMapController> _googleMapController =
      Completer<GoogleMapController>();

  GoogleMapController? newGoogleMapController;
  LocationPermission? _locationPermission;

  // Request Location Permission Step 1
  allowLocationPermission() async {
    _locationPermission = await Geolocator.requestPermission();
    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  // Update Users Location Method Step 1
  userLocation() async {
    Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    driverCurrentPosition = currentPosition;

    LatLng latLng = LatLng(
      driverCurrentPosition!.latitude,
      driverCurrentPosition!.longitude,
    );

    CameraPosition cameraPosition = CameraPosition(target: latLng, zoom: 14);

    newGoogleMapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        cameraPosition,
      ),
    );

    await AssistantMethods.reverseGeocoding(driverCurrentPosition!, context);

    AssistantMethods.readDriverRatings(context);
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  void mapDarkTheme() {
    newGoogleMapController!.setMapStyle('''
                    [
                      {
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#242f3e"
                          }
                        ]
                      },
                      {
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#746855"
                          }
                        ]
                      },
                      {
                        "elementType": "labels.text.stroke",
                        "stylers": [
                          {
                            "color": "#242f3e"
                          }
                        ]
                      },
                      {
                        "featureType": "administrative.locality",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "poi",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "poi.park",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#263c3f"
                          }
                        ]
                      },
                      {
                        "featureType": "poi.park",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#6b9a76"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#38414e"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "geometry.stroke",
                        "stylers": [
                          {
                            "color": "#212a37"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#9ca5b3"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#746855"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "geometry.stroke",
                        "stylers": [
                          {
                            "color": "#1f2835"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#f3d19c"
                          }
                        ]
                      },
                      {
                        "featureType": "transit",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#2f3948"
                          }
                        ]
                      },
                      {
                        "featureType": "transit.station",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#17263c"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#515c6d"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "labels.text.stroke",
                        "stylers": [
                          {
                            "color": "#17263c"
                          }
                        ]
                      }
                    ]
                ''');
  }

  driverOnline() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    driverCurrentPosition = position;

    Geofire.initialize('activeDrivers');

    Geofire.setLocation(
      firebaseAuth.currentUser!.uid,
      driverCurrentPosition!.latitude,
      driverCurrentPosition!.longitude,
    );

    DatabaseReference ref = FirebaseDatabase.instance
        .ref()
        .child('drivers')
        .child(firebaseAuth.currentUser!.uid)
        .child('driverStatus');

    ref.set('idle');
    ref.onValue.listen((event) {});
  }

  getStreamLocation() {
    streamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      driverCurrentPosition = position;

      if (isDriverActive == true) {
        Geofire.setLocation(
          firebaseAuth.currentUser!.uid,
          driverCurrentPosition!.latitude,
          driverCurrentPosition!.longitude,
        );

        LatLng latLng = LatLng(
          driverCurrentPosition!.latitude,
          driverCurrentPosition!.longitude,
        );

        newGoogleMapController!.animateCamera(CameraUpdate.newLatLng(latLng));
      }
    });
  }

  driverOffline() {
    Geofire.removeLocation(firebaseAuth.currentUser!.uid);

    DatabaseReference? ref = FirebaseDatabase.instance
        .ref()
        .child('drivers')
        .child(firebaseAuth.currentUser!.uid)
        .child('driverStatus');
    ref.remove();
    ref.onDisconnect();
    ref = null;

    SystemNavigator.pop();
  }

  readDriverInfo() async {
    currentUser = firebaseAuth.currentUser;

    FirebaseDatabase.instance
        .ref()
        .child('drivers')
        .child(currentUser!.uid)
        .once()
        .then((driverData) {
      if (driverData.snapshot.value != null) {
        driverDataModel!.id = (driverData.snapshot.value as Map)['id'];
        driverDataModel!.name = (driverData.snapshot.value as Map)['name'];
        driverDataModel!.email = (driverData.snapshot.value as Map)['email'];
        driverDataModel!.phone = (driverData.snapshot.value as Map)['phone'];

        driverDataModel!.carColor =
            (driverData.snapshot.value as Map)['car_details']['car_color'];
        driverDataModel!.carModel =
            (driverData.snapshot.value as Map)['car_details']['car_model'];
        driverDataModel!.carNumber =
            (driverData.snapshot.value as Map)['car_details']['car_number'];
        driverCarType =
            (driverData.snapshot.value as Map)['car_details']['car_type'];
      }
    });

    PushNotifications pushNotifications = PushNotifications();
    pushNotifications.initializeCloudMessaging(context);
    pushNotifications.generateToken();

    AssistantMethods.readDriverEarnings(context);
  }

  @override
  void initState() {
    super.initState();
    allowLocationPermission();
    readDriverInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            padding: const EdgeInsets.only(top: 20),
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (controller) {
              _googleMapController.complete(controller);
              newGoogleMapController = controller;

              userLocation();
              //for Dark Theme
              mapDarkTheme();
            },
          ),
          statusText != 'Online'
              ? Container(
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  color: Colors.white70,
                )
              : Container(),
          Positioned(
            top: statusText != 'Online'
                ? MediaQuery.of(context).size.height * 0.46
                : 32,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (isDriverActive != true) {
                      driverOnline();
                      getStreamLocation();

                      setState(() {
                        statusText = 'Online';
                        isDriverActive = true;
                      });

                      Fluttertoast.showToast(msg: 'You are online now');
                    } else {
                      driverOffline();
                      setState(() {
                        statusText = 'Offline';
                        isDriverActive = false;
                      });
                      Fluttertoast.showToast(msg: 'You are offline now');
                    }
                  },
                  child: statusText != 'Online'
                      ? const Text('Active Now')
                      : const Icon(Icons.phonelink_ring),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
