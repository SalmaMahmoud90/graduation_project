import 'package:flutter/material.dart';
import 'package:a_tareqaak/core/resources/app_colors.dart';
import 'package:a_tareqaak/core/resources/app_values.dart';
import 'package:a_tareqaak/presentation/widgets/loading_widget.dart';

class MapLoading extends StatelessWidget {
  const MapLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const Alignment(0, -0.97),
      child: Container(
        width: AppWidth.w89,
        height: AppHeight.h45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.r25),
          color: AppColors.backGround,
          boxShadow: const [
            BoxShadow(
              color: AppColors.black,
              offset: Offset(0, 0),
              spreadRadius: -10,
              blurRadius: 15,
            ),
          ],
        ),
        child: LoadingWidget(
          0,
          noCenter: true,
          size: AppSize.s25,
        ),
      ),
    );
  }
}
