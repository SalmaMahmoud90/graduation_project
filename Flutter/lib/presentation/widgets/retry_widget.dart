import 'package:flutter/material.dart';

import 'text/body_title.dart';



class RetryWidget extends StatelessWidget {
  final Function() onReload;
  final bool showText;

  const RetryWidget({super.key, required this.onReload, this.showText = true});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: onReload,
          ),
          if (showText)
            const BodyTitle(
              text: "Failed Loading Try Again",
            ),
        ],
      ),
    );
  }
}
