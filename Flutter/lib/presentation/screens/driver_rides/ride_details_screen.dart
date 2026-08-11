// lib/presentation/screens/driver_rides/ride_details_screen.dart (أجزاء التحديث الرئيسية)
import 'package:a_tareqaak/data/models/ride/ride_model.dart';
import 'package:a_tareqaak/presentation/widgets/current_location_map_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import 'package:a_tareqaak/core/extension/localization_extension.dart';
import 'package:a_tareqaak/core/resources/app_colors.dart';
import 'package:a_tareqaak/core/resources/app_fonts.dart';
import 'package:a_tareqaak/core/resources/app_values.dart';
import 'package:a_tareqaak/presentation/cubit/driver_rides/ride_details/ride_details_cubit.dart';
import 'package:a_tareqaak/presentation/cubit/driver_rides/ride_details/ride_details_state.dart';
import 'package:a_tareqaak/presentation/widgets/custom_elevated_button.dart';
import 'package:a_tareqaak/presentation/widgets/map_widget.dart';
import 'package:a_tareqaak/presentation/widgets/text/body_title.dart';
import 'package:a_tareqaak/presentation/widgets/text/section_title.dart';

class RideDetailsScreen extends StatelessWidget {
  final RideModel ride;

  const RideDetailsScreen({super.key, required this.ride});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RideDetailsCubit()..loadRideDetails(ride),
      child: const _RideDetailsContent(),
    );
  }
}

class _RideDetailsContent extends StatelessWidget {
  const _RideDetailsContent();

  @override
  Widget build(BuildContext context) {
    final tr = context.loc;
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      backgroundColor: AppColors.backGround,
      body: SafeArea(
        child: BlocBuilder<RideDetailsCubit, RideDetailsState>(
          builder: (context, state) {
            if (state is RideDetailsLoadedState) {
              final ride = state.ride;
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: AppPaddingWidth.p20,
                  vertical: AppPaddingHeight.p15,
                ),
                child: Column(
                  spacing: AppHeight.h16,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // الشريط العلوي
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => context.pop(),
                          icon: FaIcon(
                            isRtl
                                ? FontAwesomeIcons.chevronRight
                                : FontAwesomeIcons.chevronLeft,
                            color: AppColors.blackText,
                            size: AppSize.s20,
                          ),
                        ),
                        SectionTitle(
                          text: tr.ride_details_title,
                          fontSize: AppFontSize.s18,
                          fontWeight: AppFontWeight.bold,
                        ),
                        SizedBox(width: AppWidth.w40),
                      ],
                    ),

                    // مسار الانطلاق والوصول
                    Container(
                      padding: EdgeInsets.all(AppPaddingWidth.p16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(AppRadius.r16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.08),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SectionTitle(
                            text: ride.departureCity,
                            fontSize: AppFontSize.s16,
                            color: AppColors.primary,
                          ),
                          FaIcon(
                            FontAwesomeIcons.arrowRightLong,
                            color: AppColors.primary,
                            size: AppSize.s20,
                          ),
                          SectionTitle(
                            text: ride.destinationCity,
                            fontSize: AppFontSize.s16,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ),

                    // معلومات السائق والسيارة المضافة حديثاً
                    Container(
                      padding: EdgeInsets.all(AppPaddingWidth.p14),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(AppRadius.r16),
                        border: Border.all(color: AppColors.lightGreySec),
                      ),
                      child: Row(
                        spacing: AppWidth.w12,
                        children: [
                          // صورة السائق الشخصية
                          CircleAvatar(
                            radius: AppRadius.r25,
                            backgroundColor: AppColors.lightGrey,
                            child: FaIcon(
                              FontAwesomeIcons.user,
                              color: AppColors.primary,
                              size: AppSize.s24,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              spacing: AppHeight.h4,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SectionTitle(
                                  text: 'أحمد علي',
                                  fontSize: AppFontSize.s15,
                                ),
                                BodyTitle(
                                  text: 'Kia Rio - أبيض',
                                  fontSize: AppFontSize.s12,
                                  color: AppColors.greyText,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // خريطة الانطلاق
                    CurrentLocationMapWidget(
                      latitude: (ride.latitude ?? 35.5317),
                      longitude: (ride.longitude ?? 35.7912),
                    ),

                    // زر مشاركة الرحلة المضاف حديثاً
                    CustomElevatedButton(
                      height: AppHeight.h50,
                      width: double.infinity,
                      borderRadius: AppRadius.r12,
                      color: AppColors.primary,
                      onPressed: () {
                        // مشاركة رابط الرحلة
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: AppWidth.w8,
                        children: [
                          FaIcon(
                            FontAwesomeIcons.shareNodes,
                            color: AppColors.white,
                            size: AppSize.s18,
                          ),
                          BodyTitle(
                            text: tr.share_ride,
                            color: AppColors.white,
                            fontSize: AppFontSize.s16,
                            fontWeight: AppFontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}