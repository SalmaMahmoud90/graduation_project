import 'package:flutter/material.dart';
import 'package:project/shared/components/components.dart';

class FirstScreen extends StatelessWidget {
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
                'Forget the traffic...',
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
                'book your ride with a single tap ',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              image(
                path: 'assets/images/image.jpg',
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
