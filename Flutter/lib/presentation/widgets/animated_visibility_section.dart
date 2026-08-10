import 'package:flutter/material.dart';

class AnimatedVisibilitySection extends StatelessWidget {
  final bool visible;
  final Widget child;

  const AnimatedVisibilitySection({super.key, required this.visible, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      switchInCurve: Curves.fastEaseInToSlowEaseOut,
      switchOutCurve: Curves.fastOutSlowIn,
      reverseDuration: const Duration(milliseconds: 200),
      duration: const Duration(milliseconds: 350),
      transitionBuilder: (child, animation) {
        final offsetTween = Tween<Offset>(
          begin: const Offset(0, -1),
          end: const Offset(0, 0),
        ).animate(animation);
        return SlideTransition(position: offsetTween, child: child);
      },
      child: visible ? child : const SizedBox(),
    );
  }
}
