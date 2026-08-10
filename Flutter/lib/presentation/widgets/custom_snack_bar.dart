import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

class SlideFadeInSnackBar extends StatelessWidget {
  final String title;
  final String message;
  final ContentType contentType;
  final double bottomPadding;
  final bool isVisible;

  const SlideFadeInSnackBar({
    super.key,
    required this.title,
    required this.message,
    required this.contentType,
    required this.isVisible, // To handle appearing and disappearing animations
    required this.bottomPadding,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: isVisible ? 0.0 : 1.0, end: isVisible ? 1.0 : 0.0), // Controls appearing/disappearing
      duration: const Duration(milliseconds: 300),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, (1 - value) * 40), // Slide animation on Y-axis
          child: Opacity(
            opacity: value, // Fade animation
            child: SnackBarContent(
              title: title,
              message: message,
              contentType: contentType,
            ),
          ),
        );
      },
    );
  }
}

class SnackBarContent extends StatelessWidget {
  final String title;
  final String message;
  final ContentType contentType;

  const SnackBarContent({
    super.key,
    required this.title,
    required this.message,
    required this.contentType,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: AwesomeSnackbarContent(

        inMaterialBanner: true,
        title: title,
        message: message,
        contentType: contentType,
      ),
    );
  }
}

void showCustomSnackBar({
  required BuildContext context,
  required String title,
  required String message,
  required ContentType contentType,
  double bottomPadding = 40.0,
}) {
  final overlay = Overlay.of(context);
  OverlayEntry? overlayEntry;

  // First, we show the SnackBar with visibility true
  overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      bottom: bottomPadding,
      left: 20.0,
      right: 20.0,
      child: SlideFadeInSnackBar(
        title: title,
        message: message,
        contentType: contentType,
        bottomPadding: bottomPadding,
        isVisible: true, // Start with showing the SnackBar
      ),
    ),
  );

  overlay.insert(overlayEntry);

  // After 2.5 seconds, reverse the animation to hide the SnackBar
  Future.delayed(const Duration(milliseconds: 2500), () {
    overlayEntry?.remove();

    // Remove with reverse animation (isVisible set to false)
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: bottomPadding,
        left: 20.0,
        right: 20.0,
        child: SlideFadeInSnackBar(
          title: title,
          message: message,
          contentType: contentType,
          bottomPadding: bottomPadding,
          isVisible: false, // Hide the SnackBar
        ),
      ),
    );

    overlay.insert(overlayEntry!);

    // Finally, remove the entry completely after the hiding animation finishes
    Future.delayed(const Duration(milliseconds: 300), () {
      overlayEntry?.remove();
    });
  });
}
