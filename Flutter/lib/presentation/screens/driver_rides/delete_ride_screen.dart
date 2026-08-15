import 'package:a_tareqaak/core/extension/localization_extension.dart';
import 'package:a_tareqaak/core/resources/app_colors.dart';
import 'package:a_tareqaak/core/resources/app_fonts.dart';
import 'package:a_tareqaak/core/resources/app_values.dart';
import 'package:a_tareqaak/data/models/rides/ride_data_model.dart';
import 'package:a_tareqaak/domain/entity/rides/id_entity.dart';
import 'package:a_tareqaak/presentation/bloc/rides/cancel_ride/cancel_ride_bloc.dart';
import 'package:a_tareqaak/presentation/bloc/rides/cancel_ride/i_cancel_ride_event.dart';
import 'package:a_tareqaak/presentation/bloc/rides/cancel_ride/i_cancel_ride_state.dart';
import 'package:a_tareqaak/presentation/bloc/rides/my_rides_driver/i_my_rides_event.dart';
import 'package:a_tareqaak/presentation/bloc/rides/my_rides_driver/i_my_rides_state.dart';
import 'package:a_tareqaak/presentation/bloc/rides/my_rides_driver/my_rides_bloc.dart';
import 'package:a_tareqaak/presentation/widgets/custom_elevated_button.dart';
import 'package:a_tareqaak/presentation/widgets/drop_filter_dialog.dart';
import 'package:a_tareqaak/presentation/widgets/text/body_title.dart';
import 'package:a_tareqaak/presentation/widgets/text/section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';


class DeleteRideScreen extends StatelessWidget {
  const DeleteRideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => MyRidesBloc()..add(const GetMyRidesEvent()),
        ),
        BlocProvider(
          create: (_) => CancelRideBloc(),
        ),
      ],
      child: const _DeleteRideContent(),
    );
  }
}

class _DeleteRideContent extends StatelessWidget {
  const _DeleteRideContent();

  void _showDeleteDialog(BuildContext context, int rideId) {
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
                borderSide: const BorderSide(color: AppColors.primary, width: 1.0),
                borderRadius: AppRadius.r8,
                onPressed: () => Navigator.pop(context),
                child: BodyTitle(
                  text: tr.cancel,
                  color: AppColors.blackText,
                ),
              ),
              CustomElevatedButton(
                borderSide: const BorderSide(color: AppColors.red, width: 1.0),
                borderRadius: AppRadius.r8,
                onPressed: () {
                  Navigator.pop(context);
                  context
                      .read<CancelRideBloc>()
                      .add(CancelRideEvent(IdEntity(rideId)));
                },
                child: BodyTitle(
                  text: tr.delete_btn,
                  color: AppColors.blackText,
                  fontWeight: AppFontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tr = context.loc;
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      backgroundColor: AppColors.backGround,
      body: SafeArea(
        child: BlocListener<CancelRideBloc, ICancelRideState>(
          listener: (context, state) {
            if (state is CancelRideLoaded) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(tr.ride_deleted_success),
                  backgroundColor: AppColors.red,
                ),
              );
              context.read<MyRidesBloc>().add(const GetMyRidesEvent());
            } else if (state is CancelRideFailed) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.red,
                ),
              );
            }
          },
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
                child: BlocBuilder<MyRidesBloc, IMyRidesState>(
                  builder: (context, state) {
                    if (state is MyRidesLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is MyRidesFailed) {
                      return Center(child: BodyTitle(text: state.message));
                    }
                    final rides = state is MyRidesLoaded
                        ? state.response?.data?.rides ?? <RideDataModel>[]
                        : <RideDataModel>[];

                    if (rides.isEmpty) {
                      return Center(child: BodyTitle(text: tr.no_data));
                    }

                    return ListView.separated(
                      padding: EdgeInsets.all(AppPaddingWidth.p20),
                      itemCount: rides.length,
                      separatorBuilder: (_, __) =>
                          SizedBox(height: AppHeight.h12),
                      itemBuilder: (context, index) {
                        final ride = rides[index];
                        final rideId = ride.id ?? 0;

                        return Dismissible(
                          key: Key(rideId.toString()),
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (_) async {
                            _showDeleteDialog(context, rideId);
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
                                            text: ride.location ?? '',
                                            fontSize: AppFontSize.s16,
                                          ),
                                          FaIcon(
                                            FontAwesomeIcons.arrowRightLong,
                                            size: AppSize.s14,
                                            color: AppColors.primary,
                                          ),
                                          SectionTitle(
                                            text: ride.destination ?? '',
                                            fontSize: AppFontSize.s16,
                                          ),
                                        ],
                                      ),
                                      BodyTitle(
                                        text:
                                            '${ride.departureDate ?? ''} - ${ride.departureTime ?? ''} | ${ride.cost ?? ''} ${tr.syrian_pound}',
                                        fontSize: AppFontSize.s13,
                                        color: AppColors.greyText,
                                      ),
                                      BodyTitle(
                                        text:
                                            '${ride.availableSeats ?? 0} ${tr.available_seats_count}',
                                        fontSize: AppFontSize.s13,
                                        color: AppColors.primary,
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () =>
                                      _showDeleteDialog(context, rideId),
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
      ),
    );
  }
}