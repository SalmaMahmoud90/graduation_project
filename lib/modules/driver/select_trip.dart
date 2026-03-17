import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:project/shared/network/local/ride_list.dart';
import 'package:project/shared/network/remote/Service.dart';

import '../../shared/components/components.dart';

class SelectTrip extends StatefulWidget {
  @override
  State<SelectTrip> createState() => _SelectTripState();
}

class _SelectTripState extends State<SelectTrip> {
  Service api = Service();

  List<Ride> myRides = [];

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return RideListPage(
        title: 'Select Trip',
        onRideAction: (context, ride, reload) {
          openEditingDialog(context, ride, reload);
        });
  }

  void openEditingDialog(BuildContext context, Ride ride, VoidCallback reload) {
    showDialog(
        context: context,
        barrierDismissible: true,
        barrierColor: Colors.transparent,
        builder: (context) {
          var controller1 = TextEditingController(text: ride.location);

          var controller2 = TextEditingController(text: ride.destination);

          var controller3 = TextEditingController(text: ride.departureTime);

          var controller4 = TextEditingController(text: ride.arrivalTime);

          var controller5 = TextEditingController(text: ride.cost);

          var controller6 =
              TextEditingController(text: ride.capacity.toString());
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
                          children: [
                            formFeild(
                                controller: controller1,
                                keyboard: TextInputType.name,
                                label: 'edit your current location: ',
                                prefix: Icon(Icons.location_on),
                                validate: (value) {
                                  if (value == null || value.trim().isEmpty)
                                    return 'this is required';
                                  return null;
                                }),
                            SizedBox(
                              height: 10,
                            ),
                            formFeild(
                                controller: controller2,
                                keyboard: TextInputType.name,
                                label: 'edit your destination: ',
                                prefix: Icon(Icons.location_on),
                                validate: (value) {
                                  if (value == null || value.trim().isEmpty)
                                    return 'this is required';
                                  return null;
                                }),
                            SizedBox(
                              height: 10,
                            ),
                            formFeild(
                                controller: controller3,
                                keyboard: TextInputType.datetime,
                                label: 'edit depature time: ',
                                prefix: Icon(Icons.watch_later_outlined),
                                validate: (value) {
                                  print(value);
                                }),
                            SizedBox(
                              height: 10,
                            ),
                            formFeild(
                                controller: controller4,
                                keyboard: TextInputType.datetime,
                                label: 'edit Estimated time of arrival: ',
                                prefix: Icon(Icons.watch_later_outlined),
                                validate: (value) {
                                  print(value);
                                }),
                            SizedBox(
                              height: 10,
                            ),
                            formFeild(
                                controller: controller5,
                                keyboard: TextInputType.number,
                                label: 'edit cost: ',
                                prefix: Icon(Icons.money),
                                validate: (value) {
                                  print(value);
                                }),
                            SizedBox(
                              height: 10,
                            ),
                            formFeild(
                                controller: controller6,
                                keyboard: TextInputType.number,
                                label: 'edit capacity: ',
                                prefix: Icon(Icons.people),
                                validate: (value) {
                                  if (value == null || value.trim().isEmpty)
                                    return 'this is required';
                                  return null;
                                }),
                            SizedBox(
                              height: 15,
                            ),
                            button(
                                start_end_padding: 25,
                                width: 90,
                                text: 'Edit',
                                pressed: () async {
                                  Service api = Service();
                                  final result = await api.updateRide(
                                      rideId: ride.id,
                                      location: controller1.text.trim(),
                                      destination: controller2.text.trim(),
                                      departure_time: controller3.text.trim(),
                                      arrival_time: controller4.text.trim(),
                                      cost: controller5.text.trim(),
                                      capacity: controller6.text.trim());
                                  if (Navigator.canPop(context)) {
                                    Navigator.of(context).pop();
                                  }
                                  if (result['success']) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "A ride edited successfully")));
                                    setState(() {
                                      reload();
                                    });
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "Error in editinging ride")));
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
  }
}
