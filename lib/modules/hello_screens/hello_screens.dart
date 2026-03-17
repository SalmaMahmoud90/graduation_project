import 'package:flutter/material.dart';
import 'package:project/modules/Register/Register.dart';
import 'package:project/modules/hello_screens/first_screen.dart';
import 'package:project/modules/hello_screens/forth_screen.dart';
import 'package:project/modules/hello_screens/second_screen.dart';
import 'package:project/modules/hello_screens/third_screen.dart';
import 'package:project/modules/log_in/log_in_screen.dart';

class HelloScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HelloScreen();
  }
}

class _HelloScreen extends State<HelloScreen> {
  PageController _pageController = PageController();
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(20.0),
        color: Colors.teal[50],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => Register()));
              },
              child: Text(
                index == 3 ? "Register" : 'Skip',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Colors.teal,
                ),
              ),
            ),
            Expanded(
              child: PageView(
                onPageChanged: (value) {
                  setState(() {
                    index = value;
                  });
                },
                controller: _pageController,
                children: [
                  FirstScreen(),
                  SecondScreen(),
                  ThirdScreen(),
                  ForthScreen(),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIndicator(active: index == 0),
                SizedBox(
                  width: 5.0,
                ),
                CustomIndicator(active: index == 1),
                SizedBox(
                  width: 5.0,
                ),
                CustomIndicator(active: index == 2),
                SizedBox(
                  width: 5.0,
                ),
                CustomIndicator(active: index == 3),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: Colors.grey[100],
              ),
              padding: EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: () {
                  if (index == 3) {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => Log_In()));
                  }
                  _pageController.animateToPage(index + 1,
                      duration: Duration(seconds: 1), curve: Curves.linear);
                },
                child: Text(
                  index == 3 ? "Log in" : 'Next',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: Colors.teal,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomIndicator extends StatelessWidget {
  final bool active;
  const CustomIndicator({super.key, required this.active});
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(seconds: 1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: active ? Colors.teal : Colors.grey,
      ),
      width: active ? 20 : 10,
      height: 10,
    );
  }
}
