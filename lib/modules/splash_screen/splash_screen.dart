import 'dart:async';

import 'package:flutter/material.dart';
import 'package:project/modules/hello_screens/hello_screens.dart';

import '../../shared/components/components.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashScreen();
  }
}

class _SplashScreen extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> _logoAnimation;
  late Animation<double> _textFadeAnimation;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    _logoAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeIn));
    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeIn));
    animationController.forward();

    animationController.repeat();
    Timer(
        Duration(seconds: 3),
        () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HelloScreen())));
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal, Colors.tealAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeTransition(
                opacity: _logoAnimation,
                child: CircleAvatar(
                  radius: 90,
                  backgroundColor: Colors.white,
                  //backgroundImage: AssetImage("assets/images/HopOn logo.jpg"),
                  child: image(
                    path: 'assets/images/HopOn logo.jpg',
                    width: 150,
                    height: 150,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              FadeTransition(
                opacity: _textFadeAnimation,
                child: Text(
                  'HopOn',
                  style: TextStyle(
                    fontFamily: 'MyFonttt',
                    color: Colors.white,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.bold,
                    fontSize: 48.0,
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              CircularProgressIndicator(
                color: Colors.teal,
                backgroundColor: Colors.grey,
                strokeWidth: 3.0,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
