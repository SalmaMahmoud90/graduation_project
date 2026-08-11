import 'package:flutter/material.dart';
import 'package:a_tareqaak/core/extension/localization_extension.dart';
import 'package:a_tareqaak/core/resources/app_colors.dart';
import 'package:a_tareqaak/presentation/widgets/text/section_title.dart';

class RiderHomeScreen extends StatelessWidget {
  const RiderHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGround,
      body: Center(
        child: SectionTitle(
          text: '${context.loc.home} - ${context.loc.rider}',
          color: AppColors.primary,
        ),
      ),
    );
  }
}