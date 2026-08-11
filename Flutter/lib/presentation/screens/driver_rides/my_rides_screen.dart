import 'package:a_tareqaak/data/models/ride/ride_model.dart';
import 'package:a_tareqaak/data/models/rides/ride_data_model.dart';
import 'package:a_tareqaak/presentation/cubit/rides/my_rides/my_rides_cubit.dart';
import 'package:a_tareqaak/presentation/cubit/rides/my_rides/my_rides_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:a_tareqaak/core/extension/localization_extension.dart';
import 'package:a_tareqaak/core/resources/app_colors.dart';
import 'package:a_tareqaak/core/resources/app_fonts.dart';
import 'package:a_tareqaak/core/resources/app_values.dart';
import 'package:a_tareqaak/presentation/screens/driver_rides/widgets/ride_card_widget.dart';
import 'package:a_tareqaak/presentation/widgets/text/body_title.dart';
import 'package:a_tareqaak/presentation/widgets/text/section_title.dart';

// رحلاتي عند السائق
class MyRidesScreen extends StatelessWidget {
  const MyRidesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MyRidesCubit()..load(),
      child: const _MyRidesContent(),
    );
  }
}

class _MyRidesContent extends StatefulWidget {
  const _MyRidesContent();

  @override
  State<_MyRidesContent> createState() => _MyRidesContentState();
}

class _MyRidesContentState extends State<_MyRidesContent> {
  int currentTab = 0; // 0: غير منجزة، 1: منجزة، 2: محذوفة

  // تحويل نموذج الـ API إلى نموذج الواجهة المستخدم في شاشة التفاصيل
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

            // التبويبات الثلاثة
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

            Expanded(
              child: BlocBuilder<MyRidesCubit, MyRidesState>(
                builder: (context, state) {
                  if (state is MyRidesLoading || state is MyRidesInitial) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is MyRidesError) {
                    return _CenteredMessage(text: state.message);
                  }
                  final rides =
                      state is MyRidesLoaded ? state.rides : <RideDataModel>[];

                  // الخادم يعيد الرحلات النشطة فقط ضمن my_rides
                  if (currentTab != 0) {
                    return _CenteredMessage(text: tr.no_data);
                  }
                  if (rides.isEmpty) {
                    return _CenteredMessage(text: tr.no_data);
                  }

                  return RefreshIndicator(
                    onRefresh: () => context.read<MyRidesCubit>().load(),
                    child: ListView.separated(
                      padding: EdgeInsets.all(AppPaddingWidth.p20),
                      itemCount: rides.length,
                      separatorBuilder: (_, _) =>
                          SizedBox(height: AppHeight.h12),
                      itemBuilder: (context, index) {
                        final r = rides[index];
                        return RideCardWidget(
                          fromCity: r.location ?? '',
                          toCity: r.destination ?? '',
                          dateAndPriceText:
                              '${r.departureDate ?? ''} ${r.departureTime ?? ''} | ${r.cost ?? ''} ${tr.currency_syp}',
                          seatsText:
                              '${r.availableSeats ?? 0} ${tr.available_seats_label}',
                          onTap: () {
                            context.push('/ride-details', extra: _toUiRide(r));
                          },
                        );
                      },
                    ),
                  );
                },
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

class _CenteredMessage extends StatelessWidget {
  final String text;
  const _CenteredMessage({required this.text});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(height: AppHeight.h100),
        Center(
          child: BodyTitle(
            text: text,
            color: AppColors.greyText,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
