import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:a_tareqaak/core/extension/localization_extension.dart';
import 'package:a_tareqaak/core/resources/app_colors.dart';
import 'package:a_tareqaak/core/resources/app_fonts.dart';
import 'package:a_tareqaak/core/resources/app_values.dart';
import 'package:a_tareqaak/presentation/widgets/text/body_title.dart';

// شريط التنقل السفلي الخاص بصفحات الراكب
class RiderBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const RiderBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tr = context.loc;

    return Container(
      height: AppHeight.h70,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppRadius.r20),
          topRight: Radius.circular(AppRadius.r20),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, FontAwesomeIcons.house, tr.home),
          _buildNavItem(1, FontAwesomeIcons.car, tr.my_rides),
          _buildNavItem(2, FontAwesomeIcons.bell, tr.notifications),
          _buildNavItem(3, FontAwesomeIcons.gear, tr.settings),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, FaIconData icon, String label) {
    final isSelected = currentIndex == index;
    return InkWell(
      onTap: () => onTap(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: AppHeight.h4,
        children: [
          FaIcon(
            icon,
            size: AppSize.s18,
            color: isSelected ? AppColors.primary : AppColors.greyText,
          ),
          BodyTitle(
            text: label,
            fontSize: AppFontSize.s11,
            fontWeight: isSelected ? AppFontWeight.bold : AppFontWeight.regular,
            color: isSelected ? AppColors.primary : AppColors.greyText,
          ),
        ],
      ),
    );
  }
}