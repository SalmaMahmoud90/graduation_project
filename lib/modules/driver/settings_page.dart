import 'package:flutter/material.dart';

import '../../shared/components/components.dart';

class SettingsPage extends StatelessWidget {
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
              "driver's settings",
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
            Row(
              children: [
                Text(
                  'Notifications management',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 5.0,
                ),
                Icon(Icons.edit_notifications_outlined),
                SizedBox(
                  width: 20.0,
                ),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.arrow_forward,
                      color: Colors.greenAccent[700],
                      size: 30.0,
                    ))
              ],
            ),
            Row(
              children: [
                Text(
                  'Payment details',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 5.0,
                ),
                Icon(Icons.payment),
                SizedBox(
                  width: 115.0,
                ),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.arrow_forward,
                      color: Colors.greenAccent[700],
                      size: 30.0,
                    ))
              ],
            ),
            Row(
              children: [
                Text(
                  'Security',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 5.0,
                ),
                Icon(Icons.security),
                SizedBox(
                  width: 188.0,
                ),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.arrow_forward,
                      color: Colors.greenAccent[700],
                      size: 30.0,
                    ))
              ],
            ),
            Row(
              children: [
                Text(
                  'Submit a complaint',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 5.0,
                ),
                Icon(Icons.report_problem_outlined),
                SizedBox(
                  width: 82.0,
                ),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.arrow_forward,
                      color: Colors.greenAccent[700],
                      size: 30.0,
                    ))
              ],
            ),
            Row(
              children: [
                Text(
                  'Archive',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 5.0,
                ),
                Icon(Icons.archive_outlined),
                SizedBox(
                  width: 190.0,
                ),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.arrow_forward,
                      color: Colors.greenAccent[700],
                      size: 30.0,
                    ))
              ],
            ),
            Row(
              children: [
                Text(
                  'Language',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 5.0,
                ),
                Icon(Icons.language),
                SizedBox(
                  width: 168.0,
                ),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.arrow_forward,
                      color: Colors.greenAccent[700],
                      size: 30.0,
                    ))
              ],
            ),
            Row(
              children: [
                Text(
                  'Profile lock',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 5.0,
                ),
                Icon(Icons.lock_open_outlined),
                SizedBox(
                  width: 152.0,
                ),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.arrow_forward,
                      color: Colors.greenAccent[700],
                      size: 30.0,
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
