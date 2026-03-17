import 'package:flutter/material.dart';

import '../../components/components.dart';
import '../remote/Service.dart';

class RideListPage extends StatefulWidget {
  final String title;
  final Function(BuildContext, Ride, VoidCallback reload) onRideAction;

  RideListPage({required this.title, required this.onRideAction});

  @override
  State<RideListPage> createState() => _RideListPageState();
}

class _RideListPageState extends State<RideListPage> {
  Service api = Service();
  List<Ride> myRides = [];

  @override
  void initState() {
    super.initState();
    loadRides();
  }

  Future<void> loadRides() async {
    final rides = await api.getMyRides();
    setState(() => myRides = rides);
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
              'driver',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
              ),
            ),
          ],
        ),
      ),
      body: myRides.isEmpty
          ? Center(child: Text("No trips found"))
          : ListView.builder(
              itemCount: myRides.length,
              itemBuilder: (context, index) {
                final ride = myRides[index];
                return trip(
                  path: ride.carImage ?? "assets/images/car3.png",
                  from: ride.location,
                  to: ride.destination,
                  depature_time: ride.departureTime,
                  arrival_time: ride.arrivalTime,
                  capacity: ride.capacity,
                  price: ride.cost,
                  icon: widget.title == "Cancel Trip"
                      ? Icons.cancel_outlined
                      : Icons.arrow_circle_right_outlined,
                  width: 50,
                  moveWidth: 110,
                  iconSize: 60,
                  pressedIcon: () =>
                      widget.onRideAction(context, ride, loadRides),
                );
              },
            ),
    );
  }
}
