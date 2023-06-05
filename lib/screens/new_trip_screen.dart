// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_driver_app/global_variables/global_variables.dart';
import 'package:uber_driver_app/models/ride_request_model.dart';
import 'package:uber_driver_app/widgets/fare_amount_dialog.dart';

import '../assistants/assistant_methods.dart';
import '../widgets/progress_dialog.dart';

class NewTripScreen extends StatefulWidget {
  final RideRequestModel rideRequestModel;

  const NewTripScreen({super.key, required this.rideRequestModel});

  @override
  State<NewTripScreen> createState() => _NewTripScreenState();
}

class _NewTripScreenState extends State<NewTripScreen> {
  final Completer<GoogleMapController> _googleMapController =
      Completer<GoogleMapController>();

  GoogleMapController? newTripGoogleMapController;
  String? buttonTitle = 'Arrived';

  double mapPadding = 0;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  void mapDarkTheme() {
    newTripGoogleMapController!.setMapStyle('''
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

  Set<Marker> setOfMarker = {};
  Set<Circle> setOfCircle = {};
  Set<Polyline> setOfPolyline = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  BitmapDescriptor? iconAnimatedMarker;
  var geoLocator = Geolocator();

  void activeDriversCustomMarker() async {
    if (iconAnimatedMarker == null) {
      ImageConfiguration imageConfiguration =
          const ImageConfiguration(size: Size(2, 2));

      var newMarker = await BitmapDescriptor.fromAssetImage(
          imageConfiguration, 'assets/images/car.png');

      iconAnimatedMarker = newMarker;
    }
  }

  Future<void> drawPolyLines(
      LatLng originDirection, LatLng destinationDirection) async {
    showDialog(
      context: context,
      builder: (context) {
        return const ProgressDialog(
          message: 'Please wait...',
        );
      },
    );

    var directionDetails = await AssistantMethods.getDirectionDetail(
        originDirection, destinationDirection);

    Navigator.pop(context);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolyLineList =
        polylinePoints.decodePolyline(directionDetails!.points!);

    polylineCoordinates.clear();

    if (decodedPolyLineList.isNotEmpty) {
      for (PointLatLng pointLatLng in decodedPolyLineList) {
        polylineCoordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      }
    }
    setOfPolyline.clear();

    setState(() {
      Polyline polyline = Polyline(
        polylineId: const PolylineId('polyLineId'),
        points: polylineCoordinates,
        color: Colors.blue,
        width: 2,
        jointType: JointType.round,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );
      setOfPolyline.add(polyline);
    });

    LatLngBounds latLngBounds;

    if (originDirection.latitude > destinationDirection.latitude &&
        originDirection.longitude > destinationDirection.longitude) {
      latLngBounds = LatLngBounds(
        southwest: destinationDirection,
        northeast: originDirection,
      );
    } else if (originDirection.longitude > destinationDirection.longitude) {
      latLngBounds = LatLngBounds(
        southwest: LatLng(
          originDirection.latitude,
          destinationDirection.longitude,
        ),
        northeast: LatLng(
          destinationDirection.latitude,
          originDirection.longitude,
        ),
      );
    } else if (originDirection.latitude > destinationDirection.latitude) {
      latLngBounds = LatLngBounds(
        southwest: LatLng(
          destinationDirection.latitude,
          originDirection.longitude,
        ),
        northeast: LatLng(
          originDirection.latitude,
          destinationDirection.longitude,
        ),
      );
    } else {
      latLngBounds = LatLngBounds(
        southwest: originDirection,
        northeast: destinationDirection,
      );
    }

    newTripGoogleMapController!.animateCamera(
      CameraUpdate.newLatLngBounds(latLngBounds, 65),
    );

    Marker originMarker = Marker(
      markerId: const MarkerId('originId'),
      position: originDirection,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    );

    Marker destinationMarker = Marker(
      markerId: const MarkerId('destinationId'),
      position: destinationDirection,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    setState(() {
      setOfMarker.add(originMarker);
      setOfMarker.add(destinationMarker);
    });

    Circle originCircle = Circle(
      circleId: const CircleId('originId'),
      fillColor: Colors.blue,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: originDirection,
    );
    Circle destinationCircle = Circle(
      circleId: const CircleId('destinationId'),
      fillColor: Colors.red,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: destinationDirection,
    );

    setState(() {
      setOfCircle.add(originCircle);
      setOfCircle.add(destinationCircle);
    });
  }

  saveDriverInfoToRideRequest() {
    DatabaseReference ref = FirebaseDatabase.instance
        .ref()
        .child('All Ride Requests')
        .child(widget.rideRequestModel.rideRequestId!);

    Map driverLocationMap = {
      'latitude': driverCurrentPosition!.latitude,
      'longitude': driverCurrentPosition!.longitude,
    };

    ref.child('driverLocation').set(driverLocationMap);

    ref.child('status').set('accepted');
    ref.child('driverId').set(driverDataModel!.id);
    ref.child('driverName').set(driverDataModel!.name);
    ref.child('driverPhone').set(driverDataModel!.phone);
    ref.child('car_details').set(
        '${driverDataModel!.carColor!} ${driverDataModel!.carModel} ${driverDataModel!.carNumber}');
  }

  @override
  void initState() {
    super.initState();
    saveDriverInfoToRideRequest();
  }

  Position? selectedDriverCurrentPosition;

  getDriverStreamLocation() {
    LatLng oldPosition = const LatLng(0, 0);

    driverStreamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      driverCurrentPosition = position;
      selectedDriverCurrentPosition = position;

      LatLng latLng = LatLng(
        selectedDriverCurrentPosition!.latitude,
        selectedDriverCurrentPosition!.longitude,
      );

      Marker animateMarker = Marker(
        markerId: const MarkerId('animateMarker'),
        position: latLng,
        icon: iconAnimatedMarker!,
        infoWindow: const InfoWindow(title: 'Current Position'),
      );

      setState(() {
        CameraPosition cameraPosition =
            CameraPosition(target: latLng, zoom: 16);

        newTripGoogleMapController!
            .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

        setOfMarker.removeWhere(
            (element) => element.markerId.value == 'animateMarker');
        setOfMarker.add(animateMarker);
      });

      oldPosition = latLng;
      updateDurationTime();

      Map driverLatLngMap = {
        'latitude': selectedDriverCurrentPosition!.latitude.toString(),
        'longitude': selectedDriverCurrentPosition!.longitude.toString(),
      };

      FirebaseDatabase.instance
          .ref()
          .child('All Ride Requests')
          .child(widget.rideRequestModel.rideRequestId!)
          .child('driverLocation')
          .set(driverLatLngMap);
    });
  }

  bool isRequestDirectionDetails = false;
  String rideRequestStatus = 'accepted';
  String rideDuration = '';

  updateDurationTime() async {
    if (isRequestDirectionDetails == false) {
      isRequestDirectionDetails = true;

      if (selectedDriverCurrentPosition == null) {
        return;
      }

      var driverCurrentLatLng = LatLng(
        selectedDriverCurrentPosition!.latitude,
        selectedDriverCurrentPosition!.longitude,
      );

      LatLng? destinationLatLng;

      if (rideRequestStatus == 'accepted') {
        destinationLatLng = widget.rideRequestModel.originLatLng;
      } else {
        destinationLatLng = widget.rideRequestModel.destinationLatLng;
      }
      var directionInfo = await AssistantMethods.getDirectionDetail(
        driverCurrentLatLng,
        destinationLatLng!,
      );
      if (directionInfo != null) {
        setState(() {
          rideDuration = directionInfo.durationText!;
        });
      }
      isRequestDirectionDetails = false;
    }
  }

  endTripNow() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const ProgressDialog(message: 'Please wait...'),
    );

    var driverCurrentLatLng = LatLng(
      driverCurrentPosition!.latitude,
      driverCurrentPosition!.longitude,
    );

    var tripDirectionInfo = await AssistantMethods.getDirectionDetail(
      driverCurrentLatLng,
      widget.rideRequestModel.originLatLng!,
    );

    double totalFareAmount =
        AssistantMethods.calculateTripFee(tripDirectionInfo!);

    FirebaseDatabase.instance
        .ref()
        .child('All Ride Requests')
        .child(widget.rideRequestModel.rideRequestId!)
        .child('fareAmount')
        .set(totalFareAmount.toString());

    FirebaseDatabase.instance
        .ref()
        .child('All Ride Requests')
        .child(widget.rideRequestModel.rideRequestId!)
        .child('status')
        .set('ended');

    driverStreamSubscription!.cancel();
    Navigator.pop(context);

    showDialog(
      context: context,
      builder: (context) => FareAmountDialog(
        totalFareAmount: totalFareAmount,
      ),
    );

    saveDriverEarnings(totalFareAmount);
  }

  saveDriverEarnings(double totalFareAmount) {
    FirebaseDatabase.instance
        .ref()
        .child('drivers')
        .child(currentUser!.uid)
        .child('earnings')
        .once()
        .then((snapshot) {
      if (snapshot.snapshot.value != null) {
        double oldEarnings = double.parse(snapshot.snapshot.value.toString());

        double driverTotalEarnings = totalFareAmount + oldEarnings;
        FirebaseDatabase.instance
            .ref()
            .child('drivers')
            .child(currentUser!.uid)
            .child('earnings')
            .set(driverTotalEarnings.toString());
      } else {
        FirebaseDatabase.instance
            .ref()
            .child('drivers')
            .child(currentUser!.uid)
            .child('earnings')
            .set(totalFareAmount.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    activeDriversCustomMarker();

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            markers: setOfMarker,
            circles: setOfCircle,
            polylines: setOfPolyline,
            padding: EdgeInsets.only(top: 20, bottom: mapPadding),
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (controller) {
              _googleMapController.complete(controller);
              newTripGoogleMapController = controller;

              setState(() {
                mapPadding = 320;
              });

              //for Dark Theme
              mapDarkTheme();

              var driverCurrentLatLng = LatLng(
                driverCurrentPosition!.latitude,
                driverCurrentPosition!.longitude,
              );

              var userPickupLatLng = widget.rideRequestModel.originLatLng;

              drawPolyLines(driverCurrentLatLng, userPickupLatLng!);

              getDriverStreamLocation();
            },
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white30,
                    blurRadius: 18,
                    spreadRadius: .5,
                    offset: Offset(0.6, 0.6),
                  ),
                ],
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                child: Column(
                  children: [
                    Text(
                      rideDuration,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Divider(
                      thickness: 1,
                      color: Colors.blue,
                      height: 1,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text(
                          widget.rideRequestModel.userName!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.blue,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(
                            Icons.phone_android,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
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
                    const SizedBox(height: 12),
                    const Divider(
                      thickness: 1,
                      color: Colors.blue,
                      height: 1,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () async {
                        if (rideRequestStatus == 'accepted') {
                          rideRequestStatus = 'arrived';

                          FirebaseDatabase.instance
                              .ref()
                              .child('All Ride Requests')
                              .child(widget.rideRequestModel.rideRequestId!)
                              .child('status')
                              .set(rideRequestStatus);

                          setState(() {
                            buttonTitle = 'Lets Go';
                          });

                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) =>
                                const ProgressDialog(message: 'Please wait...'),
                          );

                          await drawPolyLines(
                            widget.rideRequestModel.originLatLng!,
                            widget.rideRequestModel.destinationLatLng!,
                          );
                          Navigator.pop(context);
                        } else if (rideRequestStatus == 'arrived') {
                          rideRequestStatus = 'onTrip';

                          FirebaseDatabase.instance
                              .ref()
                              .child('All Ride Requests')
                              .child(widget.rideRequestModel.rideRequestId!)
                              .child('status')
                              .set(rideRequestStatus);

                          setState(() {
                            buttonTitle = 'End Trip';
                          });
                        } else if (rideRequestStatus == 'onTrip') {
                          endTripNow();
                        }
                      },
                      icon: const Icon(
                        Icons.directions_car,
                        color: Colors.blue,
                        size: 25,
                      ),
                      label: Text(buttonTitle!),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
