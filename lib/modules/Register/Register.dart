import 'package:flutter/material.dart';
import 'package:project/modules/log_in/log_in_screen.dart';
import 'package:project/shared/components/components.dart';

import '../../shared/network/remote/Service.dart';

class Register extends StatefulWidget {
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  var formKey = GlobalKey<FormState>();
  String? selectedRole;
  bool isPassword = true;
  bool isLoading = false;
  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  get floatingActionButton => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Text(
                      'welcome to',
                      style: TextStyle(fontSize: 30, fontFamily: 'MyFont'),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'HopON',
                      style: TextStyle(
                        fontSize: 40,
                        fontFamily: 'MyFonttt',
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'create account : ',
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    formFeild(
                        controller: emailController,
                        keyboard: TextInputType.emailAddress,
                        label: 'Email Address',
                        prefix: Icon(Icons.email),
                        validate: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email must not be empty';
                          }
                          return null;
                        }),
                    SizedBox(
                      height: 10,
                    ),
                    formFeild(
                        controller: passwordController,
                        keyboard: TextInputType.visiblePassword,
                        label: 'Password',
                        prefix: Icon(Icons.lock),
                        isPassword: isPassword,
                        suffix: isPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        suffixPressed: () {
                          setState(() {
                            isPassword = !isPassword;
                          });
                        },
                        validate: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password must not be empty';
                          } else if (value.length < 8) {
                            return 'Password must not be less than 8 characters';
                          }
                          return null;
                        }),
                    SizedBox(
                      height: 10,
                    ),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: ' role',
                        border: OutlineInputBorder(),
                        prefix: Icon(Icons.person),
                      ),
                      value: selectedRole,
                      items: ['driver', 'rider', 'admin'].map((role) {
                        return DropdownMenuItem(
                          value: role,
                          child: Text(role),
                        );
                      }).toList(),
                      onChanged: (value) {
                        selectedRole = value;
                        print('selected role : $selectedRole');
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'please select your role';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    button(
                        width: 80,
                        text: 'Sign Up',
                        pressed: () async {
                          setState(() {
                            isLoading = true;
                          });
                          if (formKey.currentState?.validate() ?? false) {
                            print('ok');
                            Service api = Service();
                            final result = await api.signUp(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                                userType: selectedRole);
                            setState(() {
                              isLoading = false;
                            });
                            if (result['success']) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      "your account is created successfully")));
                              api.navigateBy_user_type(
                                  context: context,
                                  data: result['data']['user']);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text("Error in creating account")));
                              print(
                                  "********************\n********************\n******************\nerror ${result['error']}\n********************\n********************\n******************\n");
                            }
                          }
                        }),
                    SizedBox(
                      height: 25,
                    ),
                    Row(
                      children: [
                        Text('or sign up with : '),
                        SizedBox(
                          width: 20,
                        ),
                        IconButton(
                            onPressed: () {
                              print('Google sign up pressed');
                            },
                            icon: image(
                              path: 'assets/images/google logo.png',
                              width: 40,
                              height: 40,
                            )),
                        SizedBox(
                          width: 30,
                        ),
                        IconButton(
                            onPressed: () {
                              print('Facebook sign up pressed');
                            },
                            icon: image(
                              path: 'assets/images/facebook logo.png',
                              width: 40,
                              height: 40,
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('you have an account ?'),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Log_In()));
                          },
                          child: Text(
                            'Log In',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                      ],
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
}
