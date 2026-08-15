

import 'package:a_tareqaak/core/extension/localization_extension.dart';
import 'package:a_tareqaak/core/resources/app_colors.dart';
import 'package:a_tareqaak/core/resources/app_fonts.dart';
import 'package:a_tareqaak/core/resources/app_values.dart';
import 'package:a_tareqaak/data/models/rides/ride_data_model.dart';
import 'package:a_tareqaak/domain/entity/rides/id_entity.dart';
import 'package:a_tareqaak/presentation/bloc/rides/ride_details/i_ride_details_event.dart';
import 'package:a_tareqaak/presentation/bloc/rides/ride_details/i_ride_details_state.dart';
import 'package:a_tareqaak/presentation/bloc/rides/ride_details/ride_details_bloc.dart';
import 'package:a_tareqaak/presentation/widgets/custom_elevated_button.dart';
import 'package:a_tareqaak/presentation/widgets/text/body_title.dart';
import 'package:a_tareqaak/presentation/widgets/text/section_title.dart' show SectionTitle;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class RideDetailsScreen extends StatelessWidget {
  final RideDataModel ride;
  
  const RideDetailsScreen({super.key, required this.ride});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RideDetailsBloc()..add(GetRideDetailsEvent(IdEntity(ride.id!))),
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
        child: BlocBuilder<RideDetailsBloc, IRideDetailsState>(
          builder: (context, state) {
            if (state is RideDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is RideDetailsFailed) {
              return Center(child: BodyTitle(text: state.message));
            }
            if (state is RideDetailsLoaded) {
              final ride = state.response?.data?.ride;
              final driverInfo = ride?.driverInfo;

              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: AppPaddingWidth.p20,
                  vertical: AppPaddingHeight.p15,
                ),
                child: Column(
                  spacing: AppHeight.h16,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
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
                            text: ride?.location ?? '',
                            fontSize: AppFontSize.s16,
                            color: AppColors.primary,
                          ),
                          FaIcon(
                            FontAwesomeIcons.arrowRightLong,
                            color: AppColors.primary,
                            size: AppSize.s20,
                          ),
                          SectionTitle(
                            text: ride?.destination ?? '',
                            fontSize: AppFontSize.s16,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ),

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
                                  text: driverInfo?.driverName ?? tr.driver,
                                  fontSize: AppFontSize.s15,
                                ),
                                BodyTitle(
                                  text:
                                      '${ride?.departureDate ?? ''} | ${ride?.departureTime ?? ''}',
                                  fontSize: AppFontSize.s12,
                                  color: AppColors.greyText,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    CustomElevatedButton(
                      height: AppHeight.h50,
                      width: double.infinity,
                      borderRadius: AppRadius.r12,
                      color: AppColors.primary,
                      onPressed: () {},
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
            return const SizedBox();
          },
        ),
      ),
    );
  }
}