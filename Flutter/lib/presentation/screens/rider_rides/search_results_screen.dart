// lib/presentation/screens/rider_rides/search_results_screen.dart
import 'package:a_tareqaak/data/models/ride/ride_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import 'package:a_tareqaak/core/extension/localization_extension.dart';
import 'package:a_tareqaak/core/resources/app_colors.dart';
import 'package:a_tareqaak/core/resources/app_fonts.dart';
import 'package:a_tareqaak/core/resources/app_values.dart';

import 'package:a_tareqaak/presentation/screens/rider_rides/widgets/rider_ride_card_widget.dart';
import 'package:a_tareqaak/presentation/widgets/custom_elevated_button.dart';
import 'package:a_tareqaak/presentation/widgets/text/body_title.dart';
import 'package:a_tareqaak/presentation/widgets/text/section_title.dart';

class SearchResultsScreen extends StatefulWidget {
  const SearchResultsScreen({super.key});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  bool hasResults = true; // اختبار تبديل بين وجود نتائج والصفحة الفارغة

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
                    text: tr.search_results_title,
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

            Expanded(
              child: hasResults
                  ? ListView(
                      padding: EdgeInsets.all(AppPaddingWidth.p20),
                      children: [
                        RiderRideCardWidget(
                          ride: RideModel(
                            id: '1',
                            departureCity: 'اللاذقية',
                            destinationCity: 'دمشق',
                            departureDateTime: DateTime(2026, 8, 15, 8, 30),
                            duration: '3 ساعات',
                            price: 50000,
                            availableSeats: 4,
                          ),
                          onBookTap: () {
                            context.push('/my-rides');
                          },
                        ),
                        SizedBox(height: AppHeight.h12),
                        RiderRideCardWidget(
                          ride: RideModel(
                            id: '2',
                            departureCity: 'اللاذقية',
                            destinationCity: 'دمشق',
                            departureDateTime: DateTime(2026, 8, 15, 9, 0),
                            duration: '3 ساعات',
                            price: 45000,
                            availableSeats: 3,
                          ),
                          onBookTap: () {
                            context.push('/my-rides');
                          },
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: AppHeight.h12,
                      children: [
                        CircleAvatar(
                          radius: AppRadius.r45,
                          backgroundColor: AppColors.lightGrey,
                          child: FaIcon(
                            FontAwesomeIcons.magnifyingGlass,
                            size: AppSize.s40,
                            color: AppColors.primary,
                          ),
                        ),
                        SectionTitle(
                          text: tr.no_matching_rides,
                          fontSize: AppFontSize.s18,
                        ),
                        BodyTitle(
                          text: tr.try_changing_time_or_dest,
                          color: AppColors.greyText,
                        ),
                      ],
                    ),
            ),

            Padding(
              padding: EdgeInsets.all(AppPaddingWidth.p20),
              child: CustomElevatedButton(
                height: AppHeight.h50,
                width: double.infinity,
                borderRadius: AppRadius.r12,
                color: AppColors.primary,
                onPressed: () {
                  setState(() {
                    hasResults = !hasResults;
                  });
                },
                child: BodyTitle(
                  text: tr.modify_search,
                  color: AppColors.white,
                  fontWeight: AppFontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}