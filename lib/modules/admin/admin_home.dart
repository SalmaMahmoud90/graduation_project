import 'package:flutter/material.dart';
import 'package:project/modules/admin/browse_trips.dart';

import '../../shared/components/components.dart';
import '../driver/menu_page.dart';
import 'browse_users.dart';

class AdminHome extends StatelessWidget {
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
              'admin',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
              ),
            ),
          ],
        ),
      ),
      body: Column(
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
                    onPressed: () {},
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
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => MenuPage()));
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              button(
                  width: 165,
                  text: 'Browse users',
                  pressed: () {},
                  start_end_padding: 20.0),
              SizedBox(
                height: 40.0,
              ),
              button(
                  width: 165,
                  text: 'Browse trips',
                  pressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => BrowseTrips()));
                  },
                  start_end_padding: 20.0),
              SizedBox(
                height: 40.0,
              ),
              button(
                  width: 300,
                  text: 'Browse confirmed bookings',
                  pressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => BrowseUsers()));
                  },
                  start_end_padding: 20.0),
            ],
          ),
        ],
      ),
    );
  }
}
