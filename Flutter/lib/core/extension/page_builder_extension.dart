
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../utils/enums/enum_utils.dart';

extension PageBuilder on Widget {
  CustomTransitionPage buildPage({
    PageAnimation pageAnimation = PageAnimation.none,
    LocalKey? key,
  }) {
    switch (pageAnimation) {
      case PageAnimation.slide:
        return CustomTransitionPage(
          key: key,
          child: this,
          transitionDuration: const Duration(milliseconds: 350),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = const Offset(-1.0, 0.0);
            var end = Offset.zero;
            var curve = Curves.easeInOut;
            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);
            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
      case PageAnimation.fade:
        return CustomTransitionPage(
          key: key,
          child: this,
          transitionDuration: const Duration(milliseconds: 350),
          reverseTransitionDuration: const Duration(milliseconds: 200),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var curve = Curves.fastEaseInToSlowEaseOut;
            var curvedAnimation = CurvedAnimation(parent: animation, curve: curve);

            return FadeTransition(
              opacity: curvedAnimation,
              child: child,
            );
          },
        );
      case PageAnimation.none:
        return CustomTransitionPage(
          key: key,
          child: this,
          transitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = const Offset(0.0, 1.0);
            var end = Offset.zero;
            var curve = Curves.fastEaseInToSlowEaseOut;
            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);
            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
    }
  }
}
