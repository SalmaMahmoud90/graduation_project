import 'package:a_tareqaak/data/models/ride/ride_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

import 'package:a_tareqaak/core/extension/localization_extension.dart';
import 'package:a_tareqaak/core/resources/app_colors.dart';
import 'package:a_tareqaak/core/resources/app_fonts.dart';
import 'package:a_tareqaak/core/resources/app_values.dart';

import 'package:a_tareqaak/presentation/cubit/driver_rides/edit_ride/edit_ride_cubit.dart';
import 'package:a_tareqaak/presentation/cubit/driver_rides/edit_ride/edit_ride_state.dart';
import 'package:a_tareqaak/presentation/widgets/custom_elevated_button.dart';
import 'package:a_tareqaak/presentation/widgets/custom_snack_bar.dart';
import 'package:a_tareqaak/presentation/widgets/form/custom_input_field.dart';
import 'package:a_tareqaak/presentation/widgets/text/body_title.dart';
import 'package:a_tareqaak/presentation/widgets/text/section_title.dart';

class EditRideScreen extends StatelessWidget {
  final RideModel? ride;

  const EditRideScreen({super.key, this.ride});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EditRideCubit(initialRide: ride),
      child: const _EditRideContent(),
    );
  }
}

class _EditRideContent extends StatefulWidget {
  const _EditRideContent();

  @override
  State<_EditRideContent> createState() => _EditRideContentState();
}

class _EditRideContentState extends State<_EditRideContent> {
  late final TextEditingController _departureController;
  late final TextEditingController _destinationController;
  late final TextEditingController _dateController;
  late final TextEditingController _timeController;
  late final TextEditingController _durationController;
  late final TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<EditRideCubit>();
    _departureController = TextEditingController(text: cubit.departureCity);
    _destinationController = TextEditingController(text: cubit.destinationCity);
    _dateController = TextEditingController(text: '15/08/2026');
    _timeController = TextEditingController(text: '08:30 AM');
    _durationController = TextEditingController(text: cubit.expectedDuration);
    _priceController = TextEditingController(text: cubit.price);
  }

  @override
  void dispose() {
    _departureController.dispose();
    _destinationController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _durationController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tr = context.loc;
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      backgroundColor: AppColors.backGround,
      body: SafeArea(
        child: BlocListener<EditRideCubit, EditRideState>(
          listener: (context, state) {
            if (state is EditRideSuccessState) {
              showCustomSnackBar(
                context: context,
                title: tr.success_title,
                message: tr.ride_updated_success,
                contentType: ContentType.success,
              );
              // إرجاع الكائن المحدث للحفظ وتحديث القائمة فوراً
              context.pop(state.updatedRide);
            }
          },
          child: SingleChildScrollView(
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

                // تنبيه قفل التعديل
                BlocBuilder<EditRideCubit, EditRideState>(
                  builder: (context, state) {
                    final cubit = context.read<EditRideCubit>();
                    if (cubit.isEditable) return const SizedBox();

                    return Container(
                      padding: EdgeInsets.all(AppPaddingWidth.p12),
                      decoration: BoxDecoration(
                        color: AppColors.lightRed,
                        borderRadius: BorderRadius.circular(AppRadius.r12),
                      ),
                      child: Column(
                        spacing: AppHeight.h6,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: AppWidth.w6,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.lock,
                                color: AppColors.red,
                                size: AppSize.s14,
                              ),
                              BodyTitle(
                                text: tr.edit_expired_badge,
                                color: AppColors.red,
                                fontWeight: AppFontWeight.bold,
                                fontSize: AppFontSize.s14,
                              ),
                            ],
                          ),
                          BodyTitle(
                            text: tr.edit_expired_warning,
                            color: AppColors.red,
                            fontSize: AppFontSize.s12,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                ),

                // مكان الانطلاق
                BlocBuilder<EditRideCubit, EditRideState>(
                  builder: (context, state) {
                    final cubit = context.read<EditRideCubit>();
                    return CustomInputField(
                      controller: _departureController,
                      title: tr.departure_location,
                      hintText: tr.select_departure_city,
                      readOnly: true,
                      isExpanded: true,
                      onTap: cubit.isEditable
                          ? () async {
                              final selectedCity =
                                  await context.push<String>('/select-city');
                              if (selectedCity != null) {
                                _departureController.text = selectedCity;
                                cubit.departureCity = selectedCity;
                              }
                            }
                          : null,
                      prefixIcon: Center(
                        widthFactor: 1.0,
                        child: FaIcon(
                          FontAwesomeIcons.locationDot,
                          color: AppColors.grey,
                          size: AppSize.s18,
                        ),
                      ),
                    );
                  },
                ),

                // الوجهة
                BlocBuilder<EditRideCubit, EditRideState>(
                  builder: (context, state) {
                    final cubit = context.read<EditRideCubit>();
                    return CustomInputField(
                      controller: _destinationController,
                      title: tr.destination,
                      hintText: tr.select_destination,
                      readOnly: true,
                      isExpanded: true,
                      onTap: cubit.isEditable
                          ? () async {
                              final selectedCity =
                                  await context.push<String>('/select-city');
                              if (selectedCity != null) {
                                _destinationController.text = selectedCity;
                                cubit.destinationCity = selectedCity;
                              }
                            }
                          : null,
                      suffixIcon: Center(
                        widthFactor: 1.0,
                        child: FaIcon(
                          FontAwesomeIcons.chevronDown,
                          color: AppColors.grey,
                          size: AppSize.s16,
                        ),
                      ),
                    );
                  },
                ),

                // التاريخ والوقت
                BlocBuilder<EditRideCubit, EditRideState>(
                  builder: (context, state) {
                    final cubit = context.read<EditRideCubit>();
                    return Column(
                      spacing: AppHeight.h6,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SectionTitle(
                          text: tr.date_and_time,
                          fontSize: AppFontSize.s14,
                          color: AppColors.primary,
                        ),
                        Row(
                          spacing: AppWidth.w10,
                          children: [
                            Expanded(
                              child: CustomInputField(
                                controller: _dateController,
                                hintText: '15/08/2026',
                                readOnly: true,
                                onTap: cubit.isEditable
                                    ? () async {
                                        final pickedDate = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime(2030),
                                        );
                                        if (pickedDate != null) {
                                          _dateController.text =
                                              '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
                                        }
                                      }
                                    : null,
                                prefixIcon: Center(
                                  widthFactor: 1.0,
                                  child: FaIcon(
                                    FontAwesomeIcons.calendarDay,
                                    color: AppColors.grey,
                                    size: AppSize.s18,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: CustomInputField(
                                controller: _timeController,
                                hintText: '08:30 AM',
                                readOnly: true,
                                showClock: true,
                                onTap: cubit.isEditable
                                    ? () async {
                                        final pickedTime = await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                        );
                                        if (pickedTime != null) {
                                          _timeController.text =
                                              pickedTime.format(context);
                                        }
                                      }
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),

                // مدة الرحلة (تم حذف أيقونة السهم)
                BlocBuilder<EditRideCubit, EditRideState>(
                  builder: (context, state) {
                    final cubit = context.read<EditRideCubit>();
                    return CustomInputField(
                      controller: _durationController,
                      title: tr.expected_duration,
                      hintText: tr.three_hours,
                      readOnly: !cubit.isEditable,
                      isExpanded: true,
                    );
                  },
                ),

                // السعر
                BlocBuilder<EditRideCubit, EditRideState>(
                  builder: (context, state) {
                    final cubit = context.read<EditRideCubit>();
                    return CustomInputField(
                      controller: _priceController,
                      title: tr.price,
                      hintText: '50,000 ${tr.syrian_pound}',
                      textInputType: TextInputType.number,
                      readOnly: !cubit.isEditable,
                      isExpanded: true,
                      prefixIcon: Center(
                        widthFactor: 1.0,
                        child: FaIcon(
                          FontAwesomeIcons.tag,
                          color: AppColors.grey,
                          size: AppSize.s18,
                        ),
                      ),
                    );
                  },
                ),

                // المقاعد
                BlocBuilder<EditRideCubit, EditRideState>(
                  builder: (context, state) {
                    final cubit = context.read<EditRideCubit>();
                    return Column(
                      spacing: AppHeight.h6,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SectionTitle(
                          text: tr.available_seats,
                          fontSize: AppFontSize.s14,
                          color: AppColors.primary,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppPaddingWidth.p15,
                            vertical: AppPaddingHeight.p8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(AppRadius.r12),
                            border: Border.all(color: AppColors.greyDivider),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: cubit.isEditable
                                    ? () => cubit.decrementSeats()
                                    : null,
                                icon: FaIcon(
                                  FontAwesomeIcons.minus,
                                  color: cubit.isEditable
                                      ? AppColors.blackText
                                      : AppColors.grey,
                                  size: AppSize.s16,
                                ),
                              ),
                              SectionTitle(
                                text: cubit.availableSeats.toString(),
                                fontSize: AppFontSize.s18,
                                fontWeight: AppFontWeight.bold,
                              ),
                              IconButton(
                                onPressed: cubit.isEditable
                                    ? () => cubit.incrementSeats()
                                    : null,
                                icon: FaIcon(
                                  FontAwesomeIcons.plus,
                                  color: cubit.isEditable
                                      ? AppColors.blackText
                                      : AppColors.grey,
                                  size: AppSize.s16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),

                // زر الحفظ
                BlocBuilder<EditRideCubit, EditRideState>(
                  builder: (context, state) {
                    final cubit = context.read<EditRideCubit>();
                    return CustomElevatedButton(
                      height: AppHeight.h50,
                      width: double.infinity,
                      borderRadius: AppRadius.r12,
                      color: cubit.isEditable
                          ? AppColors.primary
                          : AppColors.grey,
                      notEnable: !cubit.isEditable,
                      loading: state is EditRideLoadingState,
                      onPressed: () {
                        cubit.saveChanges();
                      },
                      child: BodyTitle(
                        text: tr.save_changes,
                        color: AppColors.white,
                        fontSize: AppFontSize.s16,
                        fontWeight: AppFontWeight.bold,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}