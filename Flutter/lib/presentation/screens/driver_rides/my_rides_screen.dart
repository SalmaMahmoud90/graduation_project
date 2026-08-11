import 'package:a_tareqaak/data/models/ride/ride_model.dart';
import 'package:a_tareqaak/presentation/screens/home/widgets/driver_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:a_tareqaak/core/extension/localization_extension.dart';
import 'package:a_tareqaak/core/resources/app_colors.dart';
import 'package:a_tareqaak/core/resources/app_fonts.dart';
import 'package:a_tareqaak/core/resources/app_values.dart';
import 'package:a_tareqaak/presentation/screens/driver_rides/widgets/ride_card_widget.dart';
import 'package:a_tareqaak/presentation/widgets/text/body_title.dart';
import 'package:a_tareqaak/presentation/widgets/text/section_title.dart';
 // رحلاتي عند السائق
class MyRidesScreen extends StatefulWidget {
  const MyRidesScreen({super.key});

  @override
  State<MyRidesScreen> createState() => _MyRidesScreenState();
}

class _MyRidesScreenState extends State<MyRidesScreen> {
  int currentTab = 0; // 0: غير منجزة، 1: منجزة، 2: محذوفة (بديل مؤرشفة)

  @override
  Widget build(BuildContext context) {
    final tr = context.loc;

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
              child: Center(
                child: SectionTitle(
                  text: tr.my_rides,
                  fontSize: AppFontSize.s18,
                  fontWeight: AppFontWeight.bold,
                ),
              ),
            ),

            // التبويبات الثلاثة (غير منجزة / منجزة / محذوفة)
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
                    _buildTabItem(0, tr.uncompleted),
                    _buildTabItem(1, tr.completed),
                    _buildTabItem(2, tr.deleted),
                  ],
                ),
              ),
            ),

            // القائمة بحل مشكلة الأرقام والتاريخ العربي
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(AppPaddingWidth.p20),
                children: [
                  if (currentTab == 0) ...[
                    RideCardWidget(
                      fromCity: 'اللاذقية',
                      toCity: 'دمشق',
                      dateAndPriceText: '15 آب 2026 - 08:30 صباحاً | 50,000 ل.س',
                      seatsText: '4 مقاعد متاحة',
                      onTap: () {
                        context.push(
                          '/ride-details',
                          extra: RideModel(
                            id: '1',
                            departureCity: 'اللاذقية',
                            destinationCity: 'دمشق',
                            departureDateTime: DateTime(2026, 8, 15, 8, 30),
                            duration: '3 ساعات',
                            price: 50000,
                            availableSeats: 4,
                          ),
                        );
                      },
                    ),
                    SizedBox(height: AppHeight.h12),
                    RideCardWidget(
                      fromCity: 'جبلة',
                      toCity: 'طرطوس',
                      dateAndPriceText: '16 آب 2026 - 09:00 صباحاً | 30,000 ل.س',
                      seatsText: '3 مقاعد متاحة',
                      onTap: () {
                        context.push(
                          '/ride-details',
                          extra: RideModel(
                            id: '2',
                            departureCity: 'جبلة',
                            destinationCity: 'طرطوس',
                            departureDateTime: DateTime(2026, 8, 16, 9, 0),
                            duration: '1 ساعة',
                            price: 30000,
                            availableSeats: 3,
                          ),
                        );
                      },
                    ),
                  ],
                  if (currentTab == 1) ...[
                    RideCardWidget(
                      fromCity: 'اللاذقية',
                      toCity: 'حلب',
                      dateAndPriceText: '10 آب 2026 - 07:00 صباحاً | 50,000 ل.س',
                      seatsText: 'رحلة مكتملة',
                    ),
                  ],
                  if (currentTab == 2) ...[
                    RideCardWidget(
                      fromCity: 'دمشق',
                      toCity: 'حمص',
                      dateAndPriceText: '05 آب 2026 - 11:00 صباحاً | 25,000 ل.س',
                      seatsText: 'رحلة محذوفة',
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(int index, String title) {
    final isSelected = currentTab == index;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => currentTab = index),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: AppPaddingHeight.p8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.none,
            borderRadius: BorderRadius.circular(AppRadius.r10),
          ),
          child: BodyTitle(
            text: title,
            textAlign: TextAlign.center,
            color: isSelected ? AppColors.white : AppColors.greyText,
            fontWeight: AppFontWeight.bold,
            fontSize: AppFontSize.s12,
          ),
        ),
      ),
    );
  }
}