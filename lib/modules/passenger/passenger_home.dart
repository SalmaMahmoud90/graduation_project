import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart' hide Marker;
import 'package:project/modules/passenger/passenger_menu.dart';
import 'package:project/modules/search_page/search_page.dart';

import '../../shared/components/components.dart';

class PassengerHome extends StatefulWidget {
  late final Function(String) onLocationPressed;
  @override
  State<PassengerHome> createState() => _PassengerHomeState();
}

class _PassengerHomeState extends State<PassengerHome> {
  LatLng? _pressedLatlng;
  var controller1 = TextEditingController();
  var controller2 = TextEditingController();
  LatLng? userLocation;
  bool isLocationSelect = false;
  var formKey = GlobalKey<FormState>();

  Future<void> _getPermission() async {
    print("getting permission");
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      await Geolocator.requestPermission();
    }
    print("permission ok");
  }

  Future<void> _getLocation() async {
    await _getPermission();
    try {
      print("getting location");
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      print("get current state ok");
      setState(() {
        userLocation = LatLng(position.latitude, position.longitude);
        isLocationSelect = true;
        print("set state ok");
      });
      print("success");
    } catch (e) {
      setState(() {
        isLocationSelect = false;
      });
      print("error $e \n");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                image(
                    path: 'assets/images/HopOn logo.jpg',
                    width: 40,
                    height: 40),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  'HopOn',
                  style: TextStyle(
                    fontFamily: 'MyFonttt',
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Text(
              'rider',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                ),
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.only(start: 10.0, end: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.home),
                      iconSize: 40.0,
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchPage()));
                      },
                      icon: Icon(Icons.search),
                      iconSize: 40.0,
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.chat),
                      iconSize: 40.0,
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.notifications),
                      iconSize: 40.0,
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PassengerMenu()));
                      },
                      icon: Icon(Icons.menu),
                      iconSize: 40.0,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 40.0,
            ),
            button(
                width: 150,
                text: 'request a ride',
                pressed: () {
                  showDialog(
                      context: context,
                      barrierDismissible: true,
                      barrierColor: Colors.transparent,
                      builder: (BuildContext context) {
                        return BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Dialog(
                            backgroundColor: Colors.blueGrey[200],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Form(
                                key: formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    formFeild(
                                        controller: controller1,
                                        keyboard: TextInputType.name,
                                        label: 'enter your current location: ',
                                        prefix: Icon(Icons.location_on),
                                        validate: (value) {
                                          if (value == null ||
                                              value.trim().isEmpty)
                                            return 'this is required';
                                          return null;
                                        }),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    formFeild(
                                        controller: controller2,
                                        keyboard: TextInputType.name,
                                        label: 'enter your destination: ',
                                        prefix: Icon(Icons.location_on),
                                        validate: (value) {
                                          if (value == null ||
                                              value.trim().isEmpty)
                                            return 'this is required';
                                          return null;
                                        }),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          if (formKey.currentState
                                                  ?.validate() ??
                                              false) {
                                            print("ok");
                                          }
                                        },
                                        icon: Icon(
                                          Icons.search,
                                          size: 50,
                                          color: Colors.black,
                                        ))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                },
                start_end_padding: 10.0),
            SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  if (!isLocationSelect)
                    Text(
                      'press here to add your location :',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: Colors.black,
                      ),
                    ),
                  if (!isLocationSelect)
                    SizedBox(
                      height: 20.0,
                    ),
                  if (!isLocationSelect)
                    IconButton(
                        onPressed: _getLocation,
                        icon: Icon(
                          Icons.add_location,
                          color: Colors.red,
                          size: 40.0,
                        )),
                  if (!isLocationSelect)
                    SizedBox(
                      height: 20.0,
                    ),
                  if (isLocationSelect && userLocation != null)
                    SizedBox(
                      height: 300,
                      child: Stack(
                        children: [
                          FlutterMap(
                            options: MapOptions(
                                initialCenter: userLocation!, initialZoom: 15),
                            children: [
                              TileLayer(
                                urlTemplate:
                                    "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                                userAgentPackageName:
                                    "com.example.bmi_calculator",
                              ),
                              MarkerLayer(
                                markers: [
                                  Marker(
                                    point: userLocation!,
                                    width: 80,
                                    height: 80,
                                    child: Icon(
                                      Icons.location_on,
                                      color: Colors.red,
                                      size: 40,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Positioned(
                              top: 8,
                              right: 8,
                              child: IconButton(
                                  onPressed: _getLocation,
                                  icon: Icon(
                                    Icons.edit_location_alt,
                                    color: Colors.red,
                                  )))
                        ],
                      ),
                    ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Available trips :',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      trip(
                        path: 'assets/images/car 2.jpg',
                        from: 'Tartous',
                        to: 'Latakia',
                        depature_time: '02:00 pm',
                        arrival_time: '04:00 pm',
                        capacity: 10,
                        price: '4',
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      trip(
                        path: 'assets/images/car1.jpg',
                        from: 'Banias',
                        to: 'Latakia',
                        depature_time: '12:00 pm',
                        arrival_time: '01:00 pm',
                        capacity: 2,
                        price: '2.5',
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      trip(
                          path: 'assets/images/car3.png',
                          from: 'Homs',
                          to: 'Damascus',
                          depature_time: '02:00 pm',
                          arrival_time: '04:00 pm',
                          capacity: 12,
                          price: '7.0'),
                      SizedBox(
                        height: 20.0,
                      ),
                      trip(
                          path: 'assets/images/bus.jpg',
                          from: 'Tartous',
                          to: 'Latakia',
                          depature_time: '01:00 pm',
                          arrival_time: '03:00 pm',
                          capacity: 3,
                          price: ' 3.0'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
