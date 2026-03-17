import 'package:flutter/material.dart';

import '../../shared/components/components.dart';

class BrowseTrips extends StatelessWidget {
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
              "admin",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'there are 40 trips available',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Row(
              children: [
                Icon(
                  Icons.car_repair_rounded,
                  size: 70,
                ),
                SizedBox(
                  width: 20.0,
                ),
                Text(
                  'trip1      11:00',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 80.0,
                ),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.arrow_forward,
                      color: Colors.greenAccent[700],
                      size: 50.0,
                    ))
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.car_repair_rounded,
                  size: 70,
                ),
                SizedBox(
                  width: 20.0,
                ),
                Text(
                  'trip2      12:00',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 80.0,
                ),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.arrow_forward,
                      color: Colors.greenAccent[700],
                      size: 50.0,
                    ))
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.car_repair_rounded,
                  size: 70,
                ),
                SizedBox(
                  width: 20.0,
                ),
                Text(
                  'trip3      01:00',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 80.0,
                ),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.arrow_forward,
                      color: Colors.greenAccent[700],
                      size: 50.0,
                    ))
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.car_repair_rounded,
                  size: 70,
                ),
                SizedBox(
                  width: 20.0,
                ),
                Text(
                  'trip4      04:00',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 80.0,
                ),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.arrow_forward,
                      color: Colors.greenAccent[700],
                      size: 50.0,
                    ))
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.car_repair_rounded,
                  size: 70,
                ),
                SizedBox(
                  width: 20.0,
                ),
                Text(
                  'trip5       05:00',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 80.0,
                ),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.arrow_forward,
                      color: Colors.greenAccent[700],
                      size: 50.0,
                    ))
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.car_repair_rounded,
                  size: 70,
                ),
                SizedBox(
                  width: 20.0,
                ),
                Text(
                  'trip6      06:00',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 80.0,
                ),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.arrow_forward,
                      color: Colors.greenAccent[700],
                      size: 50.0,
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
