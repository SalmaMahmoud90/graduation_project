
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


import '../../core/resources/app_colors.dart';
import '../../core/resources/app_values.dart';
import 'text/body_title.dart';
import 'text/section_title.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final bool showSkipButton;
  final bool centerTitle;
  final bool showScrolledUnderElevation;
  final Function()? onTapSkipButton;
  final Function()? onTapBackButton;
  final String title;
  final Color? backgroundColor;
  final VoidCallback? onBack;

  final List<Widget>? customActions;

  const CustomAppBar({
    super.key,
    this.backgroundColor = AppColors.backGround,
    this.showBackButton = false,
    this.showSkipButton = false,
    this.showScrolledUnderElevation = true,
    this.centerTitle = false,
    this.onBack,
    this.title = '',
    this.onTapSkipButton,
    this.onTapBackButton,
    this.customActions, // ✅ إضافة البراميتر
  }) : assert(
         (showSkipButton && onTapSkipButton != null) || (!showSkipButton && onTapSkipButton == null),
         'When showSkipButton is true, onTapSkipButton must not be null. When showSkipButton is false, onTapSkipButton must be null.',
       );

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: centerTitle,
      automaticallyImplyLeading: false,
      backgroundColor: backgroundColor,
      scrolledUnderElevation: showScrolledUnderElevation ? 2 : 0,
      surfaceTintColor: AppColors.backGround,
      shadowColor: AppColors.lightGrey,
      actionsPadding: EdgeInsetsDirectional.zero,
      leading: showBackButton
          ? InkWell(
              splashColor: AppColors.none,
              highlightColor: AppColors.none,
              onTap:
                  onTapBackButton ??
                  () {
                    if (onBack != null) {
                      onBack!();
                    } else {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        //HomeRoute().go(context);
                      }
                    }
                  },
              child: Icon(
                Icons.arrow_back_ios,
                color: AppColors.lightBlack,
                size: AppSize.s25,
              ),
            )
          : null,
      title: SectionTitle(text: title),

      actions:
          customActions ??
          (showSkipButton
              ? [
                  Padding(
                    padding: EdgeInsetsDirectional.only(end: AppPaddingWidth.p20),
                    child: InkWell(
                      onTap: onTapSkipButton,
                      child: BodyTitle(
                        text: "context.loc.exit",
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ]
              : []),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppHeight.h60);
}
