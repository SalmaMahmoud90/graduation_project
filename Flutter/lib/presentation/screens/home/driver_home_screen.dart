import 'package:a_tareqaak/core/routes/app_routes.dart';
import 'package:a_tareqaak/data/models/ride/ride_model.dart';
import 'package:a_tareqaak/presentation/cubit/driver_home/driver_home_cubit.dart';
import 'package:a_tareqaak/presentation/cubit/driver_home/driver_home_state.dart';
import 'package:a_tareqaak/presentation/screens/home/widgets/driver_bottom_nav_bar.dart';
import 'package:a_tareqaak/presentation/widgets/current_location_map_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:a_tareqaak/core/extension/localization_extension.dart';
import 'package:a_tareqaak/core/resources/app_assets.dart';
import 'package:a_tareqaak/core/resources/app_colors.dart';
import 'package:a_tareqaak/core/resources/app_fonts.dart';
import 'package:a_tareqaak/core/resources/app_values.dart';
import 'package:a_tareqaak/presentation/screens/driver_rides/widgets/ride_card_widget.dart';
import 'package:a_tareqaak/presentation/widgets/custom_elevated_button.dart';
import 'package:a_tareqaak/presentation/widgets/custom_snack_bar.dart';
import 'package:a_tareqaak/presentation/widgets/image_view.dart';
import 'package:a_tareqaak/presentation/widgets/text/body_title.dart';
import 'package:a_tareqaak/presentation/widgets/text/section_title.dart';

// الشاشة الرئيسية للسائق مع شريط التنقل السفلي وخريطة الموقع والرحلات
class DriverHomeScreen extends StatelessWidget {
  const DriverHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DriverHomeCubit(),
      child: const _DriverHomeContent(),
    );
  }
}

class _DriverHomeContent extends StatelessWidget {
  const _DriverHomeContent();

  @override
  Widget build(BuildContext context) {
    final tr = context.loc;

    return BlocBuilder<DriverHomeCubit, DriverHomeState>(
      builder: (context, state) {
        final cubit = context.read<DriverHomeCubit>();

        return Scaffold(
          backgroundColor: AppColors.backGround,
          
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: AppPaddingWidth.p20,
                vertical: AppPaddingHeight.p15,
              ),
              child: Column(
                spacing: AppHeight.h16,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // الشريط العلوي (الشعار وأزرار التنبيهات والإعدادات)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ImageView(
                        imagePath: AppAssets.logo,
                        height: AppHeight.h45,
                        fit: BoxFit.contain,
                      ),
                      Row(
                        spacing: AppWidth.w10,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: FaIcon(
                              FontAwesomeIcons.bell,
                              size: AppSize.s20,
                              color: AppColors.blackText,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: FaIcon(
                              FontAwesomeIcons.gear,
                              size: AppSize.s20,
                              color: AppColors.blackText,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // بطاقة الموقع الحالي والطلب الجغرافي الديناميكي
                  Container(
                    padding: EdgeInsets.all(AppPaddingWidth.p15),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(AppRadius.r16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.5),
                          blurRadius: 12,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Column(
                      spacing: AppHeight.h12,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              spacing: AppHeight.h4,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                BodyTitle(
                                  text: tr.current_location,
                                  fontSize: AppFontSize.s12,
                                  color: AppColors.greyText,
                                ),
                                SectionTitle(
                                   text: cubit.currentLocationName ?? tr.location_not_available, fontSize: AppFontSize.s14, 
                                   color: AppColors.primary, ),
                              ],
                            ),
                            // gps icon
                            FaIcon(
                              FontAwesomeIcons.locationDot,
                              size: AppSize.s24,
                              color: AppColors.primary,
                            ),
                          
                          ],
                        ),
                        // عرض الموقع الحالي إن وجد
                        if (cubit.currentLocationName != null && cubit.currentLat != null && cubit.currentLng != null) 
                         CurrentLocationMapWidget( latitude: cubit.currentLat, longitude: cubit.currentLng, ),
                        // عرض رسالة إذا لم يتم الحصول على الموقع بعد
                        if (cubit.currentLocationName == null || cubit.currentLocationName!.isEmpty)
                         Container( 
                          height: AppHeight.h180, 
                          decoration: BoxDecoration(
                             color: AppColors.backGround, 
                             borderRadius: BorderRadius.circular( AppRadius.r16, ), ),
                              child: Column(
                                 mainAxisAlignment: MainAxisAlignment.center,
                                  children: [ 
                                    FaIcon( 
                                      FontAwesomeIcons.locationCrosshairs,
                                       size: AppSize.s35,
                                        color: AppColors.greyText, ), 
                                        SizedBox( height: AppHeight.h10, ),
                                         BodyTitle( 
                                          text: tr.location_not_available,
                                           fontSize: AppFontSize.s13,
                                            color: AppColors.greyText, 
                                            ), 
                                            ],
                                             ),
                                              ),
                        
                        // زر تحديث الموقع مع طلب الإذن ومعالجة الاستجابة
                        CustomElevatedButton( 
                          height: AppHeight.h40,
                           width: double.infinity,
                            borderRadius: AppRadius.r10,
                             color: AppColors.primary,
                              loading: state is DriverHomeLocationLoadingState,
                               onPressed: () {
                                 cubit.requestLocationAndFetch( 
                                  locale: Localizations.localeOf(context), 
                                  onGranted: () { 
                                    showCustomSnackBar( 
                                      context: context, 
                                      title: tr.success_title,
                                       message: tr.location_updated,
                                        contentType: ContentType.success, ); },
                                         onDenied: () { 
                                          showCustomSnackBar(
                                             context: context,
                                              title: tr.warning_title,
                                               message: tr.location_permission_denied, 
                                               contentType: ContentType.warning, ); 
                                               },
                                                );
                                                 },
                                                  child: BodyTitle( 
                                                    text: tr.update_location,
                                                     color: AppColors.white,
                                                      fontSize: AppFontSize.s14, ),
                                                       ),
                                                        ],
                                                         ),
                                                          ),
                        
                        /* CustomElevatedButton(
                          height: AppHeight.h40,
                          width: double.infinity,
                          borderRadius: AppRadius.r10,
                          color: AppColors.primary,
                          loading: state is DriverHomeLocationLoadingState,
                          onPressed: () {
                            cubit.requestLocationAndFetch(
                              onGranted: () {
                                showCustomSnackBar(
                                  context: context,
                                  title: tr.success_title,
                                  message: tr.location_updated,
                                  contentType: ContentType.success,
                                );
                              },
                              onDenied: () {
                                showCustomSnackBar(
                                  context: context,
                                  title: tr.warning_title,
                                  message: tr.location_permission_denied,
                                  contentType: ContentType.warning,
                                );
                              },
                            );
                          },
                          child: BodyTitle(
                            text: tr.update_location,
                            color: AppColors.white,
                            fontSize: AppFontSize.s14,
                          ),
                        ),
                       */
                      
                    
                

                  // قسم الإجراءات السريعة (نشر رحلة، تعديل رحلة، حذف رحلة)
                  Column(
                    spacing: AppHeight.h10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionTitle(
                        text: tr.quick_actions,
                        fontSize: AppFontSize.s16,
                      ),
                      Row(
                        spacing: AppWidth.w10,
                        children: [
                          _buildQuickActionCard(
                            context,
                            title: tr.publish_ride,
                            icon: FontAwesomeIcons.plus,
                            iconColor: AppColors.primary,
                            onTap: () => PublishRideRoute().push(context),
                          ),
                          _buildQuickActionCard(
                            context,
                            title: tr.edit_ride,
                            icon: FontAwesomeIcons.penToSquare,
                            iconColor: AppColors.primary,
                            onTap: () => EditRideListRoute().push(context),
                          ),
                          _buildQuickActionCard(
                            context,
                            title: tr.delete_ride,
                            icon: FontAwesomeIcons.trashCan,
                            iconColor: AppColors.red,
                            onTap: () => DeleteRideRoute().push(context),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // قسم الإحصائيات السريعة (الرحلات النشطة، المكتملة، التقييم)
                  Column(
                    spacing: AppHeight.h10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionTitle(
                        text: tr.quick_stats,
                        fontSize: AppFontSize.s16,
                      ),
                      Row(
                        spacing: AppWidth.w10,
                        children: [
                          _buildStatCard(tr.active_rides, '12'),
                          _buildStatCard(tr.completed_rides, '83'),
                          _buildStatCard(
                            tr.rating,
                            '4.8',
                            icon: FontAwesomeIcons.solidStar,
                          ),
                        ],
                      ),
                    ],
                  ),

                  // قسم الرحلات القادمة (عند النقر يفتح شاشة تفاصيل الرحلة)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SectionTitle(
                        text: tr.upcoming_rides,
                        fontSize: AppFontSize.s16,
                      ),
                      BodyTitle(
                        text: tr.view_all,
                        fontSize: AppFontSize.s13,
                        color: AppColors.primary,
                      ),
                    ],
                  ),

                  RideCardWidget(
                    fromCity: 'اللاذقية',
                    toCity: 'دمشق',
                    dateAndPriceText:
                        '15 آب - 08:30 صباحاً     |     50,000 ${tr.syrian_pound}',
                    seatsText: '4 ${tr.available_seats_count}',
                    onTap: () {
                      RideDetailsRoute($extra: RideModel(
                          id: '1',
                          departureCity: 'اللاذقية',
                          destinationCity: 'دمشق',
                          departureDateTime: DateTime(2026, 8, 15, 8, 30),
                          duration: '3 ساعات',
                          price: 50000,
                          availableSeats: 4,
                        ),
                      ).push(
                        context,
                        
                      );
                     
                    },
                  ),
                  RideCardWidget(
                    fromCity: 'طرطوس',
                    toCity: 'حلب',
                    dateAndPriceText:
                        ' ${tr.syrian_pound}آب - 07:00 صباحاً     |     40,000 16',
                    seatsText: '3 ${tr.available_seats_count}',
                    onTap: () {
                      RideDetailsRoute($extra: RideModel(
                          id: '2',
                          departureCity: 'طرطوس',
                          destinationCity: 'حلب',
                          departureDateTime: DateTime(2026, 8, 16, 7, 0),
                          duration: '2.5 ساعة',
                          price: 40000,
                          availableSeats: 3,
                        ),
                      ).push(
                        context,
                      );
                      
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // بناء بطاقات الإجراءات السريعة
  Widget _buildQuickActionCard(
    BuildContext context, {
    required String title,
    required FaIconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: AppPaddingHeight.p15),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.r12),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.4),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            spacing: AppHeight.h8,
            children: [
              CircleAvatar(
                radius: AppRadius.r18,
                backgroundColor: iconColor.withOpacity(0.1),
                child: FaIcon(
                  icon,
                  color: iconColor,
                  size: AppSize.s16,
                ),
              ),
              BodyTitle(
                text: title,
                fontSize: AppFontSize.s13,
                fontWeight: AppFontWeight.bold,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // بناء بطاقات الإحصائيات
  Widget _buildStatCard(String title, String value, {FaIconData? icon}) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: AppPaddingHeight.p12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.r12),
          border: Border.all(color: AppColors.lightGreySec),
         
        ),
        child: Column(
          spacing: AppHeight.h4,
          children: [
            BodyTitle(
              text: title,
              fontSize: AppFontSize.s12,
              color: AppColors.greyText,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: AppWidth.w4,
              children: [
                SectionTitle(
                  text: value,
                  fontSize: AppFontSize.s18,
                  fontWeight: AppFontWeight.bold,
                  color: AppColors.primary,
                ),
                if (icon != null)
                  FaIcon(
                    icon,
                    size: AppSize.s14,
                    color: AppColors.orange,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}