import 'package:flutter/material.dart';

import '../../shared/components/components.dart';

class BrowseUsers extends StatelessWidget {
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
              'there are 20 users registered in this app',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Row(
              children: [
                Icon(
                  Icons.person,
                  size: 70,
                ),
                SizedBox(
                  width: 20.0,
                ),
                Text(
                  'user1  admin',
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
                  Icons.person,
                  size: 70,
                ),
                SizedBox(
                  width: 20.0,
                ),
                Text(
                  'user2  driver',
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
                  Icons.person,
                  size: 70,
                ),
                SizedBox(
                  width: 20.0,
                ),
                Text(
                  'user3 driver',
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
                  Icons.person,
                  size: 70,
                ),
                SizedBox(
                  width: 20.0,
                ),
                Text(
                  'user4   passenger',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 40.0,
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
                  Icons.person,
                  size: 70,
                ),
                SizedBox(
                  width: 20.0,
                ),
                Text(
                  'user5   passenger',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 40.0,
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
