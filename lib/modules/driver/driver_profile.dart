import 'dart:core';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project/modules/driver/edit_profile.dart';

import '../../shared/components/components.dart';
import '../../shared/network/remote/Service.dart';

class DriverProfile extends StatefulWidget {
  Map<String, dynamic> data;
  DriverProfile({super.key, required this.data});
  @override
  State<DriverProfile> createState() => _DriverProfileState();
}

class _DriverProfileState extends State<DriverProfile> {
  bool isLoading = true; // مشان تعمل لودينغ بالأول

  Future<void> loadProfile() async {
    try {
      Service api = Service();
      final result = await api.viewProfile(); // استدعاء API
      setState(() {
        name = result['name'] ?? "not set";
        email = result['email'] ?? "not set";
        phone = result['phone'] ?? 0;
        lang1 = result['language1'] ?? "not set";
        lang2 = result['language2'] ?? "not set";
        color = result['car_color'] ?? "not set";
        number = result['car_number'] ?? 0;
        car_name = result['car_model'] ?? "not set";
        license_number = result['license_number'] ?? "not set";
        end_date = result['license_expiry_date'] ?? "not set";
        isLoading = false;
      });
    } catch (e) {
      print("Error loading profile: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  File? _image;
  bool press1 = false;
  bool press2 = false;
  bool press3 = false;
  bool press4 = false;
  bool press5 = false;
  Future<void> _pickImaage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _image = File(picked.path);
      });
    }
  }

  late String name;
  final String x = 'Contact Informations:';
  final String y = 'phone number :';
  late int phone;
  final String z = "Email :";
  late String email;
  final String d = "Preferred Language:";
  late String lang1;
  late String lang2;
  final String e = "Vehicle Information:";
  final String f = "color:";
  final String g = "number:";
  final String h = "name:";
  late String color;
  late int number;
  late String car_name;
  final String i = "Driver License:";
  final String j = "number:";
  final String k = "end date";
  late bool isChecked = true;
  late String license_number;
  late String end_date;
  @override
  void initState() {
    super.initState();
    loadProfile();
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
              "driver's profile",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
              ),
            ),
          ],
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.teal))
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              (_image == null)
                                  ? Icon(
                                      Icons.account_circle,
                                      size: 200,
                                      color: Colors.grey[700],
                                    )
                                  : CircleAvatar(
                                      radius: 120,
                                      backgroundColor: Colors.teal[50],
                                      child: Image.file(_image!)),
                              Positioned(
                                bottom: 40.0,
                                right: 10.0,
                                child: CircleAvatar(
                                  radius: 20.0,
                                  backgroundColor: Colors.blue[700],
                                  child: IconButton(
                                    onPressed: _pickImaage,
                                    icon: Icon(
                                      Icons.add_a_photo_outlined,
                                    ),
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ],
                          ),
                          Text(
                            '$name',
                            style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.black),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 5.0,
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(10.0),
                      child: Row(children: [
                        Text(
                          'Rating:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            color: Colors.teal[900],
                          ),
                        ),
                        IconButton(
                            icon: Icon(
                              Icons.star_border,
                              color: press1 ? Colors.amber : Colors.black,
                              size: 35,
                              fill: 1,
                            ),
                            onPressed: () {
                              setState(() {
                                press1 = !press1;
                                press2 = false;
                                press3 = false;
                                press4 = false;
                                press5 = false;
                              });
                            }),
                        IconButton(
                            icon: Icon(
                              Icons.star_border,
                              color: press2 ? Colors.amber : Colors.black,
                              size: 35,
                              fill: 1,
                            ),
                            onPressed: () {
                              setState(() {
                                press2 = !press2;
                                press1 = press2;
                                press3 = false;
                                press4 = false;
                                press5 = false;
                              });
                            }),
                        IconButton(
                            icon: Icon(
                              Icons.star_border,
                              color: press3 ? Colors.amber : Colors.black,
                              size: 35,
                              fill: 1,
                            ),
                            onPressed: () {
                              setState(() {
                                press3 = !press3;
                                press2 = press3;
                                press1 = press3;
                                press4 = false;
                                press5 = false;
                              });
                            }),
                        IconButton(
                            icon: Icon(
                              Icons.star_border,
                              color: press4 ? Colors.amber : Colors.black,
                              size: 35,
                              fill: 1,
                            ),
                            onPressed: () {
                              setState(() {
                                press4 = !press4;
                                press3 = press4;
                                press2 = press4;
                                press1 = press4;
                                press5 = false;
                              });
                            }),
                        IconButton(
                            icon: Icon(
                              Icons.star_border,
                              color: press5 ? Colors.amber : Colors.black,
                              size: 35,
                              fill: 1,
                            ),
                            onPressed: () {
                              setState(() {
                                press5 = !press5;
                                press4 = press5;
                                press3 = press5;
                                press2 = press5;
                                press1 = press5;
                              });
                            }),
                      ]),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      'joined at 23 April 2025 ',
                      style: TextStyle(
                        color: Colors.indigo[900],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      padding: EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(color: Colors.green),
                        color: Colors.greenAccent[100],
                        boxShadow: [
                          BoxShadow(
                            color: Colors.teal,
                            blurRadius: 5.0,
                            spreadRadius: 5.0,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'About me',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 20.0,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                width: 150.0,
                              ),
                              CircleAvatar(
                                backgroundColor: Colors.blue[700],
                                radius: 25.0,
                                child: IconButton(
                                  onPressed: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditProfile(
                                          name: name,
                                          phone: phone,
                                          email: email,
                                          lang1: lang1,
                                          lang2: lang2,
                                          color: color,
                                          car_name: car_name,
                                          license_number: license_number,
                                          number: number,
                                          end_date: end_date,
                                        ),
                                      ),
                                    );
                                    if (result != null &&
                                        result is Map<String, dynamic>) {
                                      setState(() {
                                        name = result['name'];
                                        phone = result['phone'];
                                        email = result['email'];
                                        lang1 = result['lang1'];
                                        lang2 = result['lang2'];
                                        color = result['color'];
                                        car_name = result['car_name'];
                                        license_number =
                                            result['license_number'];
                                        number = result['number'];
                                        end_date = result['end_date'];
                                      });
                                    }
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 20.0,
                                  ),
                                ),
                              ), // edit button
                            ],
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.teal[200],
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(color: Colors.green),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 5.0,
                                    ),
                                  ],
                                ),
                                padding: EdgeInsets.all(5.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      '$x',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.0,
                                        color: Colors.teal[900],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '$y',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10.0,
                                            color: Colors.blueAccent,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 1,
                                        ),
                                        Text(
                                          '$phone',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10.0,
                                            color: Colors.blueAccent,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '$z',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10.0,
                                            color: Colors.blueAccent,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 1,
                                        ),
                                        Text(
                                          '$email',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10.0,
                                            color: Colors.blueAccent,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.teal[200],
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(color: Colors.green),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 5.0,
                                    ),
                                  ],
                                ),
                                padding: EdgeInsets.all(5.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      'Activity log',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.0,
                                        color: Colors.teal[900],
                                      ),
                                    ),
                                    Text(
                                      'Upcoming trips',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10.0,
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                    Text(
                                      'past trips',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10.0,
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 50.0,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.teal[200],
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(color: Colors.green),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 5.0,
                                    ),
                                  ],
                                ),
                                padding: EdgeInsets.all(5.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      '$d',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.0,
                                        color: Colors.teal[900],
                                      ),
                                    ),
                                    Text(
                                      '$lang1',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10.0,
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                    Text(
                                      '$lang2',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10.0,
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.teal[200],
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(color: Colors.green),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 5.0,
                                    ),
                                  ],
                                ),
                                padding: EdgeInsets.all(5.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      '$e',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.0,
                                        color: Colors.teal[900],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '$f',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10.0,
                                            color: Colors.blueAccent,
                                          ),
                                        ),
                                        Text(
                                          '$color',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10.0,
                                            color: Colors.blueAccent,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '$g',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10.0,
                                            color: Colors.blueAccent,
                                          ),
                                        ),
                                        Text(
                                          '$number',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10.0,
                                            color: Colors.blueAccent,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '$h',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10.0,
                                            color: Colors.blueAccent,
                                          ),
                                        ),
                                        Text(
                                          '$car_name',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10.0,
                                            color: Colors.blueAccent,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 30.0,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.teal[200],
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(color: Colors.green),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 5.0,
                                    ),
                                  ],
                                ),
                                padding: EdgeInsets.all(5.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      '$i',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.0,
                                        color: Colors.teal[900],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '$j',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10.0,
                                            color: Colors.blueAccent,
                                          ),
                                        ),
                                        Text(
                                          '$license_number',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10.0,
                                            color: Colors.blueAccent,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '$k',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10.0,
                                            color: Colors.blueAccent,
                                          ),
                                        ),
                                        Text(
                                          '$end_date',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10.0,
                                            color: Colors.blueAccent,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      isChecked ? 'checked' : 'not checked',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10.0,
                                        color: Colors.blueAccent,
                                      ),
                                    ),
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
            ),
    );
  }
}
