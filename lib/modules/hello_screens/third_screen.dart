import 'package:flutter/material.dart';
import 'package:project/shared/components/components.dart';

class ThirdScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Have a trip? \n Share it...',
                style: TextStyle(
                  fontSize: 35.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 3.0,
              ),
              Text(
                'and earn on every ride!',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              image(
                path: 'assets/images/travel.jpg',
                width: 300,
                height: 300,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
