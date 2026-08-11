import 'package:a_tareqaak/data/models/ride/ride_model.dart';
import 'package:a_tareqaak/presentation/cubit/driver_rides/ride_list/edit_ride_list_cubit.dart';
import 'package:a_tareqaak/presentation/cubit/driver_rides/ride_list/edit_ride_list_state.dart';
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

class EditRideListScreen extends StatelessWidget {
  const EditRideListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EditRideListCubit()..fetchRides(),
      child: const _EditRideListContent(),
    );
  }
}

class _EditRideListContent extends StatefulWidget {
  const _EditRideListContent();

  @override
  State<_EditRideListContent> createState() => _EditRideListContentState();
}

class _EditRideListContentState extends State<_EditRideListContent> {
  int selectedTab = 0; // 0: قابلة للتعديل، 1: كل الرحلات

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
                    text: tr.edit_ride_title,
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

            // التبويب العلوي
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppPaddingWidth.p20),
              child: Container(
                padding: EdgeInsets.all(AppPaddingWidth.p4),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppRadius.r12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(() => selectedTab = 0),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: AppPaddingHeight.p8,
                          ),
                          decoration: BoxDecoration(
                            color: selectedTab == 0
                                ? AppColors.primary
                                : AppColors.none,
                            borderRadius: BorderRadius.circular(AppRadius.r10),
                          ),
                          child: BodyTitle(
                            text: tr.editable_rides,
                            textAlign: TextAlign.center,
                            color: selectedTab == 0
                                ? AppColors.white
                                : AppColors.greyText,
                            fontWeight: AppFontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(() => selectedTab = 1),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: AppPaddingHeight.p8,
                          ),
                          decoration: BoxDecoration(
                            color: selectedTab == 1
                                ? AppColors.primary
                                : AppColors.none,
                            borderRadius: BorderRadius.circular(AppRadius.r10),
                          ),
                          child: BodyTitle(
                            text: tr.all_rides,
                            textAlign: TextAlign.center,
                            color: selectedTab == 1
                                ? AppColors.white
                                : AppColors.greyText,
                            fontWeight: AppFontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: BlocBuilder<EditRideListCubit, EditRideListState>(
                builder: (context, state) {
                  final cubit = context.read<EditRideListCubit>();
                  final rides = selectedTab == 0
                      ? cubit.rides.where((r) => r.isEditable).toList()
                      : cubit.rides;

                  return ListView.separated(
                    padding: EdgeInsets.all(AppPaddingWidth.p20),
                    itemCount: rides.length,
                    separatorBuilder: (_, __) =>
                        SizedBox(height: AppHeight.h12),
                    itemBuilder: (context, index) {
                      final ride = rides[index];
                      return _buildRideItem(context, ride);
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

  Widget _buildRideItem(BuildContext context, RideModel ride) {
    final tr = context.loc;

    return Container(
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
      child: InkWell(
        // النقر على البطاقة يفتح شاشة تفاصيل الرحلة بالكامل
        onTap: () {
          context.push('/ride-details', extra: ride);
        },
        child: Column(
          spacing: AppHeight.h10,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                // زر القلم للتعديل واستقبال الرحلة المحدثة للتحديث الفوري
                IconButton(
                  onPressed: ride.isEditable
                      ? () async {
                          final updatedRide = await context.push<RideModel>(
                            '/edit-ride',
                            extra: ride,
                          );
                          if (updatedRide != null && context.mounted) {
                            context
                                .read<EditRideListCubit>()
                                .updateRide(updatedRide);
                          }
                        }
                      : null,
                  icon: CircleAvatar(
                    radius: AppRadius.r18,
                    backgroundColor: ride.isEditable
                        ? AppColors.lightGrey
                        : AppColors.lightGrey.withOpacity(0.5),
                    child: FaIcon(
                      ride.isEditable
                          ? FontAwesomeIcons.penToSquare
                          : FontAwesomeIcons.lock,
                      size: AppSize.s14,
                      color: ride.isEditable
                          ? AppColors.blackText
                          : AppColors.grey,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BodyTitle(
                  text:
                      '${ride.departureDateTime.day}/${ride.departureDateTime.month}/${ride.departureDateTime.year} - ${ride.departureDateTime.hour}:${ride.departureDateTime.minute.toString().padLeft(2, '0')}',
                  fontSize: AppFontSize.s13,
                  color: AppColors.greyText,
                ),
                BodyTitle(
                  text: '${ride.price.toInt()} ${tr.syrian_pound}',
                  fontSize: AppFontSize.s13,
                  color: AppColors.blackText,
                  fontWeight: AppFontWeight.bold,
                ),
              ],
            ),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: BodyTitle(
                text: '${ride.availableSeats} ${tr.available_seats_count}',
                fontSize: AppFontSize.s13,
                color: AppColors.primary,
              ),
            ),
            if (!ride.isEditable) ...[
              Divider(color: AppColors.lightGreySec),
              Container(
                padding: EdgeInsets.all(AppPaddingWidth.p8),
                decoration: BoxDecoration(
                  color: AppColors.lightRed,
                  borderRadius: BorderRadius.circular(AppRadius.r8),
                ),
                child: Column(
                  spacing: AppHeight.h4,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: AppWidth.w4,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.lock,
                          size: AppSize.s12,
                          color: AppColors.red,
                        ),
                        BodyTitle(
                          text: tr.edit_expired_badge,
                          color: AppColors.red,
                          fontWeight: AppFontWeight.bold,
                          fontSize: AppFontSize.s12,
                        ),
                      ],
                    ),
                    BodyTitle(
                      text: tr.edit_expired_warning,
                      color: AppColors.red,
                      fontSize: AppFontSize.s11,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}