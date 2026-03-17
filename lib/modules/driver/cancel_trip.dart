import 'package:flutter/material.dart';
import 'package:project/shared/network/local/ride_list.dart';
import 'package:project/shared/network/remote/Service.dart';

class CancelTrip extends StatefulWidget {
  @override
  State<CancelTrip> createState() => _CancelTripState();
}

class _CancelTripState extends State<CancelTrip> {
  Service api = Service();

  @override
  Widget build(BuildContext context) {
    return RideListPage(
      title: "Cancel Trip",
      onRideAction: (context, ride, reload) async {
        final ok = await api.deleteRide(ride.id);
        if (ok) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("A trip cancelled successfully")));
          setState(() {
            reload();
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Error in cancelling trip")));
        }
      },
    );
  }
}
