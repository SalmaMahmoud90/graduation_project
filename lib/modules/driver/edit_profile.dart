import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project/shared/network/remote/Service.dart';

import '../../shared/components/components.dart';

class EditProfile extends StatefulWidget {
  String name;
  int phone;
  String email;
  String lang1;
  String lang2;
  String color;
  int number;
  String car_name;
  String license_number;
  String end_date;

  EditProfile(
      {required this.name,
      required this.phone,
      required this.email,
      required this.lang1,
      required this.lang2,
      required this.color,
      required this.number,
      required this.car_name,
      required this.license_number,
      required this.end_date});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool isLoading = false;
  final String a = "Your name:";
  var nameController = TextEditingController();

  final String x = 'Contact Informations:';

  final String y = 'phone number :';

  var phoneController = TextEditingController();

  final String z = "Email :";

  var emailController = TextEditingController();

  final String d = "Preferred Language:";

  var lang1Controller = TextEditingController();

  var lang2Controller = TextEditingController();
  final String e = "Vehicle Information:";

  final String f = "color:";

  final String g = "number:";

  final String h = "name:";

  var colorController = TextEditingController();

  var numberController = TextEditingController();

  var carNameController = TextEditingController();

  final String i = "Driver License:";

  final String j = "number:";

  final String k = "end date";

  var licenseNumberController = TextEditingController();

  var endDateController = TextEditingController();
  bool isEditing = false;
  var formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
    phoneController = TextEditingController(text: widget.phone.toString());
    emailController = TextEditingController(text: widget.email);
    lang1Controller = TextEditingController(text: widget.lang1);
    lang2Controller = TextEditingController(text: widget.lang2);
    colorController = TextEditingController(text: widget.color);
    numberController = TextEditingController(text: widget.number.toString());
    carNameController = TextEditingController(text: widget.car_name);
    licenseNumberController =
        TextEditingController(text: widget.license_number);
    endDateController = TextEditingController(text: widget.end_date);
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
              "Editing profile /driver",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildEditableField(
                      keyBoard: TextInputType.text,
                      formKey: formKey,
                      validate: (val) {
                        if (val.toString().isEmpty || val == null)
                          return "name must not be empty";
                      },
                      title: a,
                      value: widget.name,
                      controller: nameController,
                      onSave: (val) => widget.name = val,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      x,
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    buildEditableField(
                      keyBoard: TextInputType.number,
                      formKey: formKey,
                      validate: (value) {
                        if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                          return "the phone number must contain only digits";
                        }
                        if (value.toString().length != 10) {
                          return "the phone number must be 10 digits";
                        }
                      },
                      title: y,
                      value: widget.phone.toString(),
                      controller: phoneController,
                      onSave: (val) =>
                          widget.phone = int.tryParse(val) ?? widget.phone,
                    ),
                    buildEditableField(
                      keyBoard: TextInputType.emailAddress,
                      formKey: formKey,
                      validate: (val) {
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(val)) {
                          return "email is invalid";
                        }
                        if (val.toString().isEmpty || val == null)
                          return "email must not be empty";
                      },
                      title: z,
                      value: widget.email,
                      controller: emailController,
                      onSave: (val) => widget.email = val,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      d,
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    buildEditableField(
                      keyBoard: TextInputType.text,
                      formKey: formKey,
                      validate: (val) {
                        if (val.toString().isEmpty || val == null)
                          return "lang1 must not be empty";
                      },
                      title: "Lang1",
                      value: widget.lang1,
                      controller: lang1Controller,
                      onSave: (val) => widget.lang1 = val,
                    ),
                    buildEditableField(
                      keyBoard: TextInputType.text,
                      formKey: formKey,
                      validate: (val) {
                        if (val.toString().isEmpty || val == null)
                          return "lang2 must not be empty";
                      },
                      title: "Lang2",
                      value: widget.lang2,
                      controller: lang2Controller,
                      onSave: (val) => widget.lang2 = val,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      e,
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    buildEditableField(
                      keyBoard: TextInputType.text,
                      formKey: formKey,
                      validate: (val) {
                        if (val.toString().isEmpty || val == null)
                          return "color must not be empty";
                      },
                      title: f,
                      value: widget.color,
                      controller: colorController,
                      onSave: (val) => widget.color = val,
                    ),
                    buildEditableField(
                      keyBoard: TextInputType.number,
                      formKey: formKey,
                      validate: (val) {
                        if (!RegExp(r'^[0-9]+$').hasMatch(val)) {
                          return "the  number must contain only digits";
                        }
                        if (val.toString().isEmpty || val == null)
                          return "number must not be empty";
                      },
                      title: g,
                      value: widget.number.toString(),
                      controller: numberController,
                      onSave: (val) =>
                          widget.number = int.tryParse(val) ?? widget.number,
                    ),
                    buildEditableField(
                      keyBoard: TextInputType.text,
                      formKey: formKey,
                      validate: (val) {
                        if (val.toString().isEmpty || val == null)
                          return "the car name must not be empty";
                      },
                      title: h,
                      value: widget.car_name,
                      controller: carNameController,
                      onSave: (val) => widget.car_name = val,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      i,
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    buildEditableField(
                      keyBoard: TextInputType.number,
                      formKey: formKey,
                      validate: (val) {
                        if (!RegExp(r'^[0-9]+$').hasMatch(val)) {
                          return "the license number must contain only digits";
                        }
                        if (val.toString().isEmpty || val == null)
                          return "license number must not be empty";
                      },
                      title: j,
                      value: widget.license_number.toString(),
                      controller: licenseNumberController,
                      onSave: (val) => widget.license_number = val,
                    ),
                    buildEditableField(
                      keyBoard: TextInputType.datetime,
                      formKey: formKey,
                      validate: (val) {
                        if (val.toString().isEmpty || val == null)
                          return "end_date must not be empty";
                        if (!isDateCorrected(val)) {
                          return "date is invalid";
                        }
                      },
                      title: k,
                      value: widget.end_date,
                      controller: endDateController,
                      onSave: (val) {
                        if (isDateCorrected(val)) {
                          setState(() {
                            widget.end_date = val;
                          });
                        }
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')),
                        LengthLimitingTextInputFormatter(10),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: button(
                        pressed: () async {
                          Service api = Service();
                          if (formKey.currentState?.validate() ?? false) {
                            setState(() {
                              isLoading = true;
                            });
                            final result = await api.editDriverProfile(
                                name: nameController.text,
                                email: emailController.text,
                                phone: int.tryParse(phoneController.text),
                                language1: lang1Controller.text,
                                language2: lang2Controller.text,
                                car_color: colorController.text,
                                license_number: licenseNumberController.text,
                                license_expiry_date:
                                    formatDate(endDateController.text),
                                car_model: carNameController.text,
                                car_number:
                                    int.tryParse(numberController.text));
                            setState(() {
                              isLoading = false;
                            });
                            if (result['success']) {
                              Navigator.pop(context, {
                                'name': nameController.text,
                                'phone': int.tryParse(phoneController.text) ??
                                    widget.phone,
                                'email': emailController.text,
                                'lang1': lang1Controller.text,
                                'lang2': lang2Controller.text,
                                'color': colorController.text,
                                'car_name': carNameController.text,
                                'license_number': licenseNumberController.text,
                                'number': int.tryParse(numberController.text) ??
                                    widget.number,
                                'end_date': endDateController.text,
                              });
                            } else {
                              print(
                                  "******************\n**************\nresult ${result}\n*******************\n***********************\n");
                              print("error : ${result['error']}");
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text("Error in editing profile")));
                            }
                          }
                        },
                        text: "save changes",
                        width: 150,
                        start_end_padding: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.teal,
                ),
              ),
            ),
        ],
      ),
    );
  }

  bool isDateCorrected(String value) {
    try {
      final parts = value.split('/');
      if (parts.length != 3) return false;
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      final date = DateTime(year, month, day);
      return date.year == year && date.month == month && date.day == day;
    } catch (_) {
      return false;
    }
  }

  String formatDate(String input) {
    try {
      final parts = input.split('/');
      if (parts.length == 3) {
        final day = parts[0].padLeft(2, '0');
        final month = parts[1].padLeft(2, '0');
        final year = parts[2];
        return "$year-$month-$day";
      }
    } catch (e) {
      print("Date format error: $e");
    }
    return input;
  }
}
