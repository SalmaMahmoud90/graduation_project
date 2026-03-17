import 'package:flutter/material.dart';
import 'package:project/modules/driver/settings_page.dart';
import 'package:project/shared/network/remote/Service.dart';

import '../../shared/components/components.dart';
import 'driver_profile.dart';

class MenuPage extends StatefulWidget {
  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  Service api = Service();

  bool isLoading = false;

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
              "driver's menu",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
              ),
            ),
          ],
        ),
      ),
      body: Stack(children: [
        Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.account_circle,
                        size: 75,
                      ),
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        final result = await api.viewProfile();
                        setState(() {
                          isLoading = false;
                        });
                        if (result['success']) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DriverProfile(
                                        data: result['data'],
                                      )));
                          print(
                              "**********\n**********\n result : ${result}\n");
                        } else {
                          print(
                              "**********\n**********\n Error result : ${result['error']}\n");
                        }
                      },
                    ),
                    TextButton(
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        final result = await api.viewProfile();
                        setState(() {
                          isLoading = false;
                        });
                        if (result['success']) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DriverProfile(
                                        data: result['data'],
                                      )));
                        }
                      },
                      child: Text(
                        'your profile',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.car_repair_sharp,
                        size: 75,
                      ),
                      onPressed: () {},
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'your trips',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.help,
                        size: 75,
                      ),
                      onPressed: () {},
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'help',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.logout,
                        size: 75,
                      ),
                      onPressed: () {},
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'log out',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.settings,
                        size: 75,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SettingsPage()));
                      },
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SettingsPage()));
                      },
                      child: Text(
                        'settings',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: Colors.teal,
              ),
            ),
          ),
      ]),
    );
  }
}
