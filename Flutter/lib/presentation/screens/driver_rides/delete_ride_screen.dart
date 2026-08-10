import 'package:a_tareqaak/presentation/cubit/delete_ride/delete_ride_cubit.dart';
import 'package:a_tareqaak/presentation/cubit/delete_ride/delete_ride_state.dart';
import 'package:a_tareqaak/presentation/widgets/custom_elevated_button.dart';
import 'package:a_tareqaak/presentation/widgets/drop_filter_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import 'package:a_tareqaak/core/extension/localization_extension.dart';
import 'package:a_tareqaak/core/resources/app_colors.dart';
import 'package:a_tareqaak/core/resources/app_fonts.dart';
import 'package:a_tareqaak/core/resources/app_values.dart';
import 'package:a_tareqaak/presentation/widgets/text/body_title.dart';
import 'package:a_tareqaak/presentation/widgets/text/section_title.dart';

class DeleteRideScreen extends StatelessWidget {
  const DeleteRideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DeleteRideCubit()..fetchRides(),
      child: const _DeleteRideContent(),
    );
  }
}

class _DeleteRideContent extends StatelessWidget {
  const _DeleteRideContent();

  void _showDeleteDialog(BuildContext context, String rideId) {
    final tr = context.loc;
    
    dropFilterDialog(
      context: context, 
    height: AppHeight.h200,
    width: AppWidth.w300,
     child: Column(
      spacing: AppHeight.h15,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

      SectionTitle(
          text: tr.confirm_delete_title,
          fontSize: AppFontSize.s16,
          color: AppColors.red,
        ),

        BodyTitle(
          text: tr.confirm_delete_msg,
          fontSize: AppFontSize.s14,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CustomElevatedButton(
              borderSide: BorderSide(color: AppColors.primary, width: 1.0),
              borderRadius: AppRadius.r8,
              onPressed: () => Navigator.pop(context),
              child: BodyTitle(
                text: tr.cancel,
                color: AppColors.blackText,
              ),
            ),
            CustomElevatedButton(
              borderSide: BorderSide(color: AppColors.red, width: 1.0),
              borderRadius: AppRadius.r8,
              onPressed: () {
                Navigator.pop(context);
                context.read<DeleteRideCubit>().deleteRide(rideId);
              },
              child: BodyTitle(
                text: tr.delete_btn,
                color: AppColors.blackText,
                fontWeight: AppFontWeight.bold,
              ),
            ),
          ],
        ),
    ],));

  /*   showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.r16),
        ),
        title: SectionTitle(
          text: tr.confirm_delete_title,
          fontSize: AppFontSize.s16,
        ),
        content: BodyTitle(
          text: tr.confirm_delete_msg,
          fontSize: AppFontSize.s14,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: BodyTitle(
              text: tr.cancel,
              color: AppColors.greyText,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<DeleteRideCubit>().deleteRide(rideId);
            },
            child: BodyTitle(
              text: tr.delete_btn,
              color: AppColors.red,
              fontWeight: AppFontWeight.bold,
            ),
          ),
        ],
      ),
    );
  */
  }
 
  @override
  Widget build(BuildContext context) {
    final tr = context.loc;
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      backgroundColor: AppColors.backGround,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppPaddingWidth.p20,
                vertical: AppPaddingHeight.p15,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: FaIcon(
                      FontAwesomeIcons.xmark,
                      color: AppColors.blackText,
                      size: AppSize.s20,
                    ),
                  ),
                  SectionTitle(
                    text: tr.delete_ride_title,
                    fontSize: AppFontSize.s18,
                    fontWeight: AppFontWeight.bold,
                  ),
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
                ],
              ),
            ),

            Center(
              child: BodyTitle(
                text: tr.swipe_to_delete_hint,
                color: AppColors.greyText,
                fontSize: AppFontSize.s13,
              ),
            ),
            SizedBox(height: AppHeight.h10),

            Expanded(
              child: BlocConsumer<DeleteRideCubit, DeleteRideState>(
                listener: (context, state) {
                  if (state is DeleteRideSuccessState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(tr.ride_deleted_success),
                        backgroundColor: AppColors.red,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  final cubit = context.read<DeleteRideCubit>();
                  final rides = cubit.activeRides;

                  return ListView.separated(
                    padding: EdgeInsets.all(AppPaddingWidth.p20),
                    itemCount: rides.length,
                    separatorBuilder: (_, __) => SizedBox(height: AppHeight.h12),
                    itemBuilder: (context, index) {
                      final ride = rides[index];
                      return Dismissible(
                        key: Key(ride.id),
                        direction: DismissDirection.endToStart,
                        confirmDismiss: (direction) async {
                          _showDeleteDialog(context, ride.id);
                          return false;
                        },
                        background: Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: AppPaddingWidth.p20),
                          decoration: BoxDecoration(
                            color: AppColors.red,
                            borderRadius: BorderRadius.circular(AppRadius.r16),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.trashCan,
                                color: AppColors.white,
                                size: AppSize.s20,
                              ),
                              BodyTitle(
                                text: tr.delete_btn,
                                color: AppColors.white,
                                fontSize: AppFontSize.s12,
                              ),
                            ],
                          ),
                        ),
                        child: Container(
                          padding: EdgeInsets.all(AppPaddingWidth.p16),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(AppRadius.r16),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.08),
                                blurRadius: 12,
                                spreadRadius: 1,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  spacing: AppHeight.h6,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      spacing: AppWidth.w8,
                                      children: [
                                        SectionTitle(
                                          text: ride.departureCity,
                                          fontSize: AppFontSize.s16,
                                        ),
                                        FaIcon(
                                          FontAwesomeIcons.arrowRightLong,
                                          size: AppSize.s14,
                                          color: AppColors.primary,
                                        ),
                                        SectionTitle(
                                          text: ride.destinationCity,
                                          fontSize: AppFontSize.s16,
                                        ),
                                      ],
                                    ),
                                    BodyTitle(
                                      text:
                                          '15 آب - 08:30 صباحاً | ${ride.price.toInt()} ${tr.syrian_pound}',
                                      fontSize: AppFontSize.s13,
                                      color: AppColors.greyText,
                                    ),
                                    BodyTitle(
                                      text:
                                          '${ride.availableSeats} ${tr.available_seats_count}',
                                      fontSize: AppFontSize.s13,
                                      color: AppColors.primary,
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () =>
                                    _showDeleteDialog(context, ride.id),
                                icon: FaIcon(
                                  FontAwesomeIcons.ellipsisVertical,
                                  size: AppSize.s18,
                                  color: AppColors.greyText,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}