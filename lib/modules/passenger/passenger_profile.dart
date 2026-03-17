import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../shared/components/components.dart';
import 'edit_profill.dart';

class PassengerProfile extends StatefulWidget {
  Map<String, dynamic> data;

  PassengerProfile({super.key, required this.data});
  @override
  State<PassengerProfile> createState() => _PassengerProfileState();
}

class _PassengerProfileState extends State<PassengerProfile> {
  File? _image;
  bool press1 = false;
  bool press2 = false;
  bool press3 = false;
  bool press4 = false;
  bool press5 = false;
  late String name;
  late int phone;
  late String email;
  late String lang1;
  late String lang2;

  @override
  void initState() {
    super.initState();
    name = widget.data['name'] ?? "not set";
    email = widget.data['email'] ?? "not set";
    phone = widget.data['phone'] ?? 0;
    lang1 = widget.data['language1'] ?? "not set";
    lang2 = widget.data['language2'] ?? "not set";
  }

  Future<void> _pickImaage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _image = File(picked.path);
      });
    }
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
                const SizedBox(width: 10.0),
                const Text(
                  'HopOn',
                  style: TextStyle(
                    fontFamily: 'MyFonttt',
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Text(
              "rider's profile",
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
        child: SingleChildScrollView(
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
                            ? Icon(Icons.account_circle,
                                size: 200, color: Colors.grey[700])
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
                              icon: Icon(Icons.add_a_photo_outlined),
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                    Text(name,
                        style: const TextStyle(
                            fontSize: 30.0, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 10.0),
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
              const SizedBox(height: 10.0),
              Text(
                'joined at 23 April 2025 ',
                style: TextStyle(
                  color: Colors.indigo[900],
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10.0),
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(color: Colors.green),
                  color: Colors.greenAccent[100],
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.teal, blurRadius: 5.0, spreadRadius: 5.0)
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // HEADER
                    Row(
                      children: [
                        const Text(
                          'About me',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            fontSize: 30.0,
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        CircleAvatar(
                          backgroundColor: Colors.blue[700],
                          radius: 25,
                          child: IconButton(
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditProfill(
                                    name: name,
                                    phone: phone,
                                    email: email,
                                    lang1: lang1,
                                    lang2: lang2,
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
                                });
                              }
                            },
                            icon: const Icon(Icons.edit,
                                color: Colors.white, size: 30.0),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.teal[200],
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.green),
                        boxShadow: const [
                          BoxShadow(color: Colors.grey, blurRadius: 5.0)
                        ],
                      ),
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Contact Informations:',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                  color: Colors.teal)),
                          Row(
                            children: [
                              const Text('phone number :',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                      color: Colors.blueAccent)),
                              Text(phone.toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                      color: Colors.blueAccent)),
                            ],
                          ),
                          Row(
                            children: [
                              const Text('Email :',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                      color: Colors.blueAccent)),
                              Text(email,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                      color: Colors.blueAccent)),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20.0),

                    // ========================== ACTIVITY LOG ==========================
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.teal[200],
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(color: Colors.green),
                            boxShadow: const [
                              BoxShadow(color: Colors.grey, blurRadius: 5.0)
                            ],
                          ),
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('Activity Log:',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                      color: Colors.teal)),
                              Text('Upcoming trips',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                      color: Colors.blueAccent)),
                              Text('Past trips',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                      color: Colors.blueAccent)),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.teal[200],
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(color: Colors.green),
                            boxShadow: const [
                              BoxShadow(color: Colors.grey, blurRadius: 5.0)
                            ],
                          ),
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Preferred \nLanguages:',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                      color: Colors.teal)),
                              Text(lang1,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                      color: Colors.blueAccent)),
                              Text(lang2,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                      color: Colors.blueAccent)),
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
