import 'package:a_tareqaak/presentation/cubit/publish_ride/publish_ride_cubit.dart';
import 'package:a_tareqaak/presentation/cubit/publish_ride/publish_ride_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

import 'package:a_tareqaak/core/extension/localization_extension.dart';
import 'package:a_tareqaak/core/resources/app_colors.dart';
import 'package:a_tareqaak/core/resources/app_fonts.dart';
import 'package:a_tareqaak/core/resources/app_values.dart';
import 'package:a_tareqaak/presentation/widgets/custom_elevated_button.dart';
import 'package:a_tareqaak/presentation/widgets/custom_snack_bar.dart';
import 'package:a_tareqaak/presentation/widgets/form/custom_input_field.dart';
import 'package:a_tareqaak/presentation/widgets/text/body_title.dart';
import 'package:a_tareqaak/presentation/widgets/text/section_title.dart';

class PublishRideScreen extends StatelessWidget {
  const PublishRideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PublishRideCubit(),
      child: const _PublishRideContent(),
    );
  }
}

class _PublishRideContent extends StatefulWidget {
  const _PublishRideContent();

  @override
  State<_PublishRideContent> createState() => _PublishRideContentState();
}

class _PublishRideContentState extends State<_PublishRideContent> {
  final TextEditingController _departureController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _dateController = TextEditingController(text: '15/08/2026');
  final TextEditingController _timeController = TextEditingController(text: '08:30 AM');
  final TextEditingController _durationController = TextEditingController(text: '3 ساعات');
  final TextEditingController _priceController = TextEditingController(text: '50,000 ل.س');

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
        child: BlocListener<PublishRideCubit, PublishRideState>(
          listener: (context, state) {
            if (state is PublishRideSuccessState) {
              showCustomSnackBar(
                context: context,
                title: tr.success_title,
                message: tr.ride_published_success,
                contentType: ContentType.success,
              );
              context.pop();
            } else if (state is PublishRideErrorState) {
              showCustomSnackBar(
                context: context,
                title: tr.error_title,
                message: state.message == 'missing_fields'
                    ? tr.field_required
                    : state.message,
                contentType: ContentType.failure,
              );
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
                      text: tr.publish_new_ride,
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

                // حقل مكان الانطلاق
                CustomInputField(
                  controller: _departureController,
                  title: tr.departure_location,
                  hintText: tr.select_departure_city,
                  readOnly: true,
                  isExpanded: true,
                  onTap: () async {
                    final selectedCity = await context.push<String>('/select-city');
                    if (selectedCity != null) {
                      _departureController.text = selectedCity;
                      context.read<PublishRideCubit>().setDepartureCity(selectedCity);
                    }
                  },
                  prefixIcon: Center(
                    widthFactor: 1.0,
                    child: FaIcon(
                      FontAwesomeIcons.locationDot,
                      color: AppColors.grey,
                      size: AppSize.s18,
                    ),
                  ),
                ),

                // حقل الوجهة
                CustomInputField(
                  controller: _destinationController,
                  title: tr.destination,
                  hintText: tr.select_destination,
                  readOnly: true,
                  isExpanded: true,
                  onTap: () async {
                    final selectedCity = await context.push<String>('/select-city');
                    if (selectedCity != null) {
                      _destinationController.text = selectedCity;
                      context.read<PublishRideCubit>().setDestinationCity(selectedCity);
                    }
                  },
                 
                ),

                // التاريخ والوقت
                Column(
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
                            onTap: () async {
                              final pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2030),
                              );
                              if (pickedDate != null) {
                                _dateController.text =
                                    '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
                                if (context.mounted) {
                                  context
                                      .read<PublishRideCubit>()
                                      .setDate(pickedDate);
                                }
                              }
                            },
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
                            onTap: () async {
                              final pickedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (pickedTime != null) {
                                _timeController.text = pickedTime.format(context);
                                if (context.mounted) {
                                  context
                                      .read<PublishRideCubit>()
                                      .setTime(pickedTime);
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // حقل مدة الرحلة المتوقعة (تم حذف أيقونة السهم كما طُلِب)
                CustomInputField(
                  controller: _durationController,
                  title: tr.expected_duration,
                  hintText: tr.three_hours,
                  isExpanded: true,
                  onChanged: (v) =>
                      context.read<PublishRideCubit>().setDuration(v),
                ),

                // حقل السعر
                CustomInputField(
                  controller: _priceController,
                  title: tr.price,
                  hintText: '50,000 ${tr.syrian_pound}',
                  textInputType: TextInputType.number,
                  isExpanded: true,
                  onChanged: (v) =>
                      context.read<PublishRideCubit>().setPrice(v),
                  prefixIcon: Center(
                    widthFactor: 1.0,
                    child: FaIcon(
                      FontAwesomeIcons.tag,
                      color: AppColors.grey,
                      size: AppSize.s18,
                    ),
                  ),
                ),

                // عدد المقاعد
                BlocBuilder<PublishRideCubit, PublishRideState>(
                  builder: (context, state) {
                    final cubit = context.read<PublishRideCubit>();
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
                                onPressed: () => cubit.decrementSeats(),
                                icon: FaIcon(
                                  FontAwesomeIcons.minus,
                                  color: AppColors.blackText,
                                  size: AppSize.s16,
                                ),
                              ),
                              SectionTitle(
                                text: cubit.availableSeats.toString(),
                                fontSize: AppFontSize.s18,
                                fontWeight: AppFontWeight.bold,
                              ),
                              IconButton(
                                onPressed: () => cubit.incrementSeats(),
                                icon: FaIcon(
                                  FontAwesomeIcons.plus,
                                  color: AppColors.blackText,
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

                // زر النشر
                BlocBuilder<PublishRideCubit, PublishRideState>(
                  builder: (context, state) {
                    final cubit = context.read<PublishRideCubit>();
                    return CustomElevatedButton(
                      height: AppHeight.h50,
                      width: double.infinity,
                      borderRadius: AppRadius.r12,
                      color: AppColors.primary,
                      loading: state is PublishRideLoadingState,
                      onPressed: () {
                        cubit.publishRide();
                      },
                      child: BodyTitle(
                        text: tr.publish_ride_btn,
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