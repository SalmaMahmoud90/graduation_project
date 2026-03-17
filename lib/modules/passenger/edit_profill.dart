import 'package:flutter/material.dart';
import 'package:project/shared/network/remote/Service.dart';

import '../../shared/components/components.dart';

class EditProfill extends StatefulWidget {
  String name;
  int phone;
  String email;
  String lang1;
  String lang2;

  EditProfill({
    required this.name,
    required this.phone,
    required this.email,
    required this.lang1,
    required this.lang2,
  });

  @override
  State<EditProfill> createState() => _EditProfillState();
}

class _EditProfillState extends State<EditProfill> {
  final String a = "Your name:";
  var nameController = TextEditingController();
  bool isLoading = false;
  final String x = 'Contact Informations:';
  final String y = 'phone number :';
  var phoneController = TextEditingController();

  final String z = "Email :";
  var emailController = TextEditingController();

  final String d = "Preferred Language:";
  var lang1Controller = TextEditingController();
  var lang2Controller = TextEditingController();
  var formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
    phoneController = TextEditingController(text: widget.phone.toString());
    emailController = TextEditingController(text: widget.email);
    lang1Controller = TextEditingController(text: widget.lang1);
    lang2Controller = TextEditingController(text: widget.lang2);
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
              "Editing profile /passenger",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
              ),
            ),
          ],
        ),
      ),
      body: Stack(children: [
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
                      title: a,
                      value: widget.name,
                      controller: nameController,
                      onSave: (val) => widget.name = val,
                      validate: (val) {
                        if (val.toString().isEmpty || val == null)
                          return "name must not be empty";
                      }),
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
                      title: y,
                      value: widget.phone.toString(),
                      controller: phoneController,
                      onSave: (val) {
                        widget.phone = int.tryParse(val) ?? widget.phone;
                      },
                      validate: (value) {
                        if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                          return "the phone number must contain only digits";
                        }
                        if (value.toString().length != 10) {
                          return "the phone number must be 10 digits";
                        }
                      }),
                  buildEditableField(
                      keyBoard: TextInputType.emailAddress,
                      formKey: formKey,
                      title: z,
                      value: widget.email,
                      controller: emailController,
                      onSave: (val) => widget.email = val,
                      validate: (val) {
                        if (val.toString().isEmpty || val == null)
                          return "email must not be empty";
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(val)) {
                          return "email is invalid";
                        }
                      }),
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
                      title: "Language 1:",
                      value: widget.lang1,
                      controller: lang1Controller,
                      onSave: (val) => widget.lang1 = val,
                      validate: (val) {
                        if (val.toString().isEmpty || val == null)
                          return "lang1 must not be empty";
                      }),
                  buildEditableField(
                      keyBoard: TextInputType.text,
                      formKey: formKey,
                      title: "Language 2:",
                      value: widget.lang2,
                      controller: lang2Controller,
                      onSave: (val) => widget.lang2 = val,
                      validate: (val) {
                        if (val.toString().isEmpty || val == null)
                          return "lang2 must not be empty";
                      }),
                  const SizedBox(height: 30),
                  Center(
                    child: button(
                      pressed: () async {
                        Service api = Service();
                        if (formKey.currentState?.validate() ?? false) {
                          setState(() {
                            isLoading = true;
                          });
                          final result = await api.editRiderProfile(
                              name: widget.name,
                              email: widget.email,
                              phone: widget.phone,
                              language2: widget.lang2,
                              language1: widget.lang1);
                          setState(() {
                            isLoading = false;
                          });
                          if (result['success']) {
                            Navigator.pop(context, {
                              'name': widget.name,
                              'phone': widget.phone,
                              'email': widget.email,
                              'lang1': widget.lang1,
                              'lang2': widget.lang2,
                            });
                          } else {
                            print("error : ${result['error']}");
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Error in editing profile")));
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
      ]),
    );
  }
}
