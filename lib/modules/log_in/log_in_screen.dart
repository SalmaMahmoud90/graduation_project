import 'package:flutter/material.dart';
import 'package:project/shared/network/remote/Service.dart';

import '../../shared/components/components.dart';
import '../Register/Register.dart';

//import 'package:video_player/video_player.dart';
class Log_In extends StatefulWidget {
  @override
  State<Log_In> createState() => _Log_InState();
}

class _Log_InState extends State<Log_In> {
  String? selectedRole;
  bool isLoading = false;
  var isPassword = true;
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Row(
          children: [
            image(path: 'assets/images/HopOn logo.jpg', width: 40, height: 40),
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
      ),
      body: Stack(children: [
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
                      color: Colors.greenAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'log in to your account : ',
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
                      suffix:
                          isPassword ? Icons.visibility : Icons.visibility_off,
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
                  button(
                      width: 80,
                      height: 45,
                      start_end_padding: 10,
                      top_buttom_padding: 10,
                      text: 'Log in',
                      pressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        if (formKey.currentState?.validate() ?? false) {
                          print("ok");
                          Service api = Service();
                          final result = await api.logIn(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim());
                          setState(() {
                            isLoading = false;
                          });
                          if (result['success']) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("welcome back to HopOn")));
                            api.navigateBy_user_type(
                                context: context, data: result['data']['user']);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content:
                                    Text("Error in log in to your account")));
                            print(
                                "********************\n********************\n******************\nerror ${result['error']}\n********************\n********************\n******************\n");
                          }
                        }
                      }),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text('or log in with : '),
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
                            height: 40),
                      ),
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
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Register()));
                    },
                    child: Text(
                      'create account?',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
