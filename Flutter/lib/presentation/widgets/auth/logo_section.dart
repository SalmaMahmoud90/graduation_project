import 'package:a_tareqaak/core/resources/app_assets.dart';
import 'package:a_tareqaak/core/resources/app_values.dart';
import 'package:a_tareqaak/presentation/widgets/image_view.dart';
import 'package:flutter/material.dart';


class LogoSection extends StatelessWidget {
  const LogoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ImageView(
      imagePath: AppAssets.logo,
      fit: BoxFit.contain,
      height: AppHeight.h160,
    );
  }
}
