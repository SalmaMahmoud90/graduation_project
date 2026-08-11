// lib/presentation/screens/rider_rides/search_results_screen.dart
import 'package:a_tareqaak/data/models/ride/ride_model.dart';
import 'package:a_tareqaak/data/models/rides/ride_data_model.dart';
import 'package:a_tareqaak/presentation/cubit/rides/search_rides/search_rides_cubit.dart';
import 'package:a_tareqaak/presentation/cubit/rides/search_rides/search_rides_state.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import 'package:a_tareqaak/core/extension/localization_extension.dart';
import 'package:a_tareqaak/core/resources/app_colors.dart';
import 'package:a_tareqaak/core/resources/app_fonts.dart';
import 'package:a_tareqaak/core/resources/app_values.dart';

import 'package:a_tareqaak/presentation/screens/rider_rides/widgets/rider_ride_card_widget.dart';
import 'package:a_tareqaak/presentation/widgets/custom_snack_bar.dart';
import 'package:a_tareqaak/presentation/widgets/text/body_title.dart';
import 'package:a_tareqaak/presentation/widgets/text/section_title.dart';

class SearchResultsScreen extends StatelessWidget {
  final String? location;
  final String? destination;

  const SearchResultsScreen({super.key, this.location, this.destination});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchRidesCubit()
        ..search(
          location: location ?? '',
          destination: destination ?? '',
        ),
      child: _SearchResultsContent(
        location: location ?? '',
        destination: destination ?? '',
      ),
    );
  }
}

class _SearchResultsContent extends StatelessWidget {
  final String location;
  final String destination;

  const _SearchResultsContent({
    required this.location,
    required this.destination,
  });

  RideModel _toUiRide(RideDataModel r) {
    final parsed = DateTime.tryParse(
      '${r.departureDate ?? ''} ${r.departureTime ?? ''}'.trim(),
    );
    return RideModel(
      id: (r.id ?? 0).toString(),
      departureCity: r.location ?? '',
      destinationCity: r.destination ?? '',
      departureDateTime: parsed ?? DateTime.now(),
      duration: r.expectedDuration ?? '',
      price: double.tryParse(r.cost ?? '') ?? 0,
      availableSeats: r.availableSeats ?? 0,
    );
  }

  Future<void> _book(BuildContext context, RideDataModel r) async {
    final tr = context.loc;
    final cubit = context.read<SearchRidesCubit>();
    final error = await cubit.book(
      rideId: r.id ?? 0,
      pickupLocation: r.location ?? location,
    );
    if (!context.mounted) return;
    if (error == null) {
      showCustomSnackBar(
        context: context,
        title: tr.success_title,
        message: tr.reservation_success,
        contentType: ContentType.success,
      );
    } else {
      showCustomSnackBar(
        context: context,
        title: tr.error_title,
        message: error,
        contentType: ContentType.failure,
      );
    }
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
              child: BlocBuilder<SearchRidesCubit, SearchRidesState>(
                builder: (context, state) {
                  if (state is SearchRidesLoading ||
                      state is SearchRidesInitial) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is SearchRidesError) {
                    return _EmptyResults(
                      title: tr.error_title,
                      subtitle: state.message,
                    );
                  }
                  final rides =
                      state is SearchRidesLoaded ? state.rides : <RideDataModel>[];
                  if (rides.isEmpty) {
                    return _EmptyResults(
                      title: tr.no_matching_rides,
                      subtitle: tr.try_changing_time_or_dest,
                    );
                  }
                  return ListView.separated(
                    padding: EdgeInsets.all(AppPaddingWidth.p20),
                    itemCount: rides.length,
                    separatorBuilder: (_, _) =>
                        SizedBox(height: AppHeight.h12),
                    itemBuilder: (context, index) {
                      final r = rides[index];
                      return RiderRideCardWidget(
                        ride: _toUiRide(r),
                        onBookTap: () => _book(context, r),
                        onTapCard: () =>
                            context.push('/ride-details', extra: _toUiRide(r)),
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

class _EmptyResults extends StatelessWidget {
  final String title;
  final String subtitle;

  const _EmptyResults({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
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
          SectionTitle(text: title, fontSize: AppFontSize.s18),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppPaddingWidth.p20),
            child: BodyTitle(
              text: subtitle,
              color: AppColors.greyText,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
