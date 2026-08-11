import 'package:a_tareqaak/core/resources/app_fonts.dart';
import 'package:a_tareqaak/core/resources/app_values.dart';
import 'package:a_tareqaak/presentation/widgets/text/body_title.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomNavItem extends StatelessWidget {
  final void Function() onPressed;
  final String label;
  final FaIconData icon;
  final bool selected;

  const CustomNavItem({
    super.key,
    required this.onPressed,
    required this.label,
    required this.selected,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onPressed,
      child: Padding(
        padding: EdgeInsetsDirectional.symmetric(horizontal: AppPaddingWidth.p4),
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                width: AppWidth.w70,
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeInOut,
                padding: EdgeInsetsDirectional.fromSTEB(
                  0,
                  AppPaddingHeight.p13,
                  0,
                  5,
                ),
                decoration: BoxDecoration(
                  color: selected ? const Color(0xFFDCE5E2) : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppRadius.r18),
                ),
                child: Column(
                  children: [
                    FaIcon(
                      icon,
                      color: selected ? const Color(0xFF0F7A4F) : const Color(0xFF8C96A6),
                      size: AppSize.s20,
                    ),
                    SizedBox(height: AppHeight.h6),
                    BodyTitle(
                      text: label,
                      color: selected ? const Color(0xFF0F7A4F) : const Color(0xFF3F4A5A),
                      fontWeight: AppFontWeight.extraBold,
                      fontSize: AppFontSize.s13,
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      width: AppWidth.w8,
                      height: AppHeight.h8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: selected ? const Color(0xFF0F7A4F) : Colors.transparent,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
