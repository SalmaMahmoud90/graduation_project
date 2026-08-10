import 'package:flutter/material.dart';
import 'package:a_tareqaak/core/resources/app_colors.dart';
import 'package:a_tareqaak/core/resources/app_values.dart';
import 'package:a_tareqaak/presentation/widgets/animated_visibility_section.dart';
import 'package:a_tareqaak/presentation/widgets/custom_search.dart';

class SearchSection extends StatelessWidget {
  final ValueNotifier<bool> isPaddingVisible;

  const SearchSection({super.key, required this.isPaddingVisible});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isPaddingVisible,
      builder: (context, visible, child) => AnimatedVisibilitySection(
        visible: visible,
        child: Container(
          margin: const EdgeInsetsDirectional.only(
            // end: AppMarginWidth.m17,
            // start: AppMarginWidth.m17,
          ),
          color: AppColors.backGround,
          child: CustomSearch(
            color: AppColors.searchColor,
            paddingBottom: AppPaddingHeight.p13,
            paddingTop: AppPaddingHeight.p10,
            paddingStart: AppPaddingWidth.p8,
            paddingEnd: AppPaddingWidth.p8,
          ),
        ),
      ),
    );
  }
}
