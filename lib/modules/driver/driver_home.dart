import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:project/modules/driver/cancel_trip.dart';
import 'package:project/modules/driver/menu_page.dart';
import 'package:project/modules/driver/select_trip.dart';
import 'package:project/shared/network/remote/Service.dart';

import '../../shared/components/components.dart';
import '../search_page/search_page.dart';

//import 'package:video_player/video_player.dart';
class Driver_Home extends StatefulWidget {
  @override
  State<Driver_Home> createState() => _Driver_HomeState();
}

class _Driver_HomeState extends State<Driver_Home> {
  Service api = Service();
  var controller1 = TextEditingController();
  var controller2 = TextEditingController();
  var controller3 = TextEditingController();
  var controller4 = TextEditingController();
  var controller5 = TextEditingController();
  var controller6 = TextEditingController();

  LatLng? userLocation;
  bool isLocationSelect = false;
  var formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    controller5.addListener(() {
      String text = controller5.text.replaceAll("\$", "");
      if (text.isNotEmpty) {
        controller5.value = TextEditingValue(
          text: "$text\$",
          selection: TextSelection.collapsed(offset: text.length),
        );
      }
    });
  }

  @override
  void dispose() {
    controller5.dispose();
    super.dispose();
  }

  Future<void> _getPermission() async {
    print("getting permission");
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      await Geolocator.requestPermission();
    }
  }

  Future<void> _getLocation() async {
    await _getPermission();
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        userLocation = LatLng(position.latitude, position.longitude);
        isLocationSelect = true;
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
      resizeToAvoidBottomInset: true,
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
              'driver',
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
                                builder: (context) => MenuPage()));
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
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  button(
                      width: 150,
                      text: 'publish a trip',
                      pressed: () {
                        showDialog(
                            context: context,
                            barrierDismissible: true,
                            barrierColor: Colors.transparent,
                            builder: (BuildContext context) {
                              return BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                child: Dialog(
                                  insetPadding: EdgeInsets.zero,
                                  backgroundColor: Colors.blueGrey[200],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Form(
                                            key: formKey,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                formFeild(
                                                    controller: controller1,
                                                    keyboard:
                                                        TextInputType.name,
                                                    label:
                                                        'enter your current location: ',
                                                    prefix:
                                                        Icon(Icons.location_on),
                                                    validate: (value) {
                                                      if (value == null ||
                                                          value.trim().isEmpty)
                                                        return 'this is required';
                                                      return null;
                                                    }),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                formFeild(
                                                    controller: controller2,
                                                    keyboard:
                                                        TextInputType.name,
                                                    label:
                                                        'enter your destination: ',
                                                    prefix:
                                                        Icon(Icons.location_on),
                                                    validate: (value) {
                                                      if (value == null ||
                                                          value.trim().isEmpty)
                                                        return 'this is required';
                                                      return null;
                                                    }),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                formFeild(
                                                    controller: controller3,
                                                    keyboard:
                                                        TextInputType.datetime,
                                                    label:
                                                        'enter departure time: ',
                                                    prefix: Icon(Icons
                                                        .watch_later_outlined),
                                                    validate: (value) {
                                                      print(value);
                                                    }),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                formFeild(
                                                    controller: controller4,
                                                    keyboard:
                                                        TextInputType.datetime,
                                                    label:
                                                        'enter Estimated time of arrival: ',
                                                    prefix: Icon(Icons
                                                        .watch_later_outlined),
                                                    validate: (value) {
                                                      print(value);
                                                    }),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                formFeild(
                                                    controller: controller5,
                                                    keyboard:
                                                        TextInputType.number,
                                                    label: 'enter cost: ',
                                                    prefix: Icon(Icons.money),
                                                    validate: (value) {
                                                      print(value);
                                                    }),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                formFeild(
                                                    controller: controller6,
                                                    keyboard:
                                                        TextInputType.number,
                                                    label: 'enter capacity: ',
                                                    prefix: Icon(Icons.people),
                                                    validate: (value) {
                                                      if (value == null ||
                                                          value.trim().isEmpty)
                                                        return 'this is required';
                                                      return null;
                                                    }),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                button(
                                                    start_end_padding: 10,
                                                    width: 90,
                                                    text: 'Publish',
                                                    pressed: () async {
                                                      final result =
                                                          await api.createRide(
                                                        location: controller1
                                                            .text
                                                            .trim(),
                                                        destination: controller2
                                                            .text
                                                            .trim(),
                                                        depature_time:
                                                            controller3.text
                                                                .trim(),
                                                        arrival_time:
                                                            controller4.text
                                                                .trim(),
                                                        cost: controller5.text
                                                            .trim(),
                                                        capacity: controller6
                                                            .text
                                                            .trim(),
                                                      );
                                                      if (Navigator.canPop(
                                                          context)) {
                                                        Navigator.of(context)
                                                            .pop();
                                                      }
                                                      if (result['success']) {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(SnackBar(
                                                                content: Text(
                                                                    "A ride published successfully")));
                                                      } else {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(SnackBar(
                                                                content: Text(
                                                                    "Error in publishing ride")));
                                                        print(
                                                            "****************************\n**********************\nerror ${result['error']}\n************************\n*************************\n");
                                                      }
                                                    })
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            });
                      },
                      start_end_padding: 15.0),
                  SizedBox(
                    height: 40.0,
                  ),
                  button(
                      width: 150,
                      text: 'edit a trip',
                      pressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SelectTrip()));
                      },
                      start_end_padding: 30.0),
                  SizedBox(
                    height: 40.0,
                  ),
                  button(
                      width: 150,
                      text: 'cancel a trip',
                      pressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CancelTrip()));
                      },
                      start_end_padding: 20.0),
                  SizedBox(
                    height: 40.0,
                  ),
                  Column(
                    children: [
                      if (!isLocationSelect)
                        Text(
                          'press here to add your location :',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                      if (!isLocationSelect)
                        SizedBox(
                          height: 20.0,
                        ),
                      if (!isLocationSelect)
                        Center(
                          child: IconButton(
                            onPressed: _getLocation,
                            icon: Icon(Icons.add_location),
                            color: Colors.red,
                            iconSize: 40.0,
                          ),
                        ),
                      if (isLocationSelect && userLocation != null)
                        SizedBox(
                          height: 300,
                          child: Stack(
                            children: [
                              FlutterMap(
                                options: MapOptions(
                                    initialCenter: userLocation!,
                                    initialZoom: 15),
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
