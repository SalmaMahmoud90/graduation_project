import 'package:a_tareqaak/core/routes/app_routes.dart';
import 'package:a_tareqaak/data/models/report/report_model.dart';
import 'package:a_tareqaak/presentation/cubit/report/reports_cubit.dart';
import 'package:a_tareqaak/presentation/cubit/report/reports_state.dart';
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

class MyReportsScreen extends StatelessWidget {
  const MyReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ReportsCubit()..fetchReports(),
      child: const _MyReportsContent(),
    );
  }
}

class _MyReportsContent extends StatelessWidget {
  const _MyReportsContent();

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
                      isRtl
                          ? FontAwesomeIcons.chevronRight
                          : FontAwesomeIcons.chevronLeft,
                      color: AppColors.blackText,
                      size: AppSize.s20,
                    ),
                  ),
                  SectionTitle(
                    text: tr.my_reports_title,
                    fontSize: AppFontSize.s18,
                    fontWeight: AppFontWeight.bold,
                  ),
                  SizedBox(width: AppWidth.w40),
                ],
              ),
            ),

            Expanded(
              child: BlocBuilder<ReportsCubit, ReportsState>(
                builder: (context, state) {
                  final cubit = context.read<ReportsCubit>();
                  final reports = cubit.reportsList;

                  return ListView.separated(
                    padding: EdgeInsets.all(AppPaddingWidth.p20),
                    itemCount: reports.length,
                    separatorBuilder: (_, __) =>
                        SizedBox(height: AppHeight.h12),
                    itemBuilder: (context, index) {
                      final report = reports[index];
                      return _buildReportCard(context, report);
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

  Widget _buildReportCard(BuildContext context, ReportModel report) {
    final bool isPending = report.status == 'معلق';

    return Container(
      padding: EdgeInsets.all(AppPaddingWidth.p16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.r16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          // النقر على البلاغ يفتحه بصفحة تفاصيل البلاغ
          ReportDetailsRoute($extra: report).push(context);
        
        },
        child: Column(
          spacing: AppHeight.h8,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppPaddingWidth.p10,
                    vertical: AppPaddingHeight.p4,
                  ),
                  decoration: BoxDecoration(
                    color: isPending
                        ? AppColors.lightOrange
                        : AppColors.lightPrim,
                    borderRadius: BorderRadius.circular(AppRadius.r6),
                  ),
                  child: BodyTitle(
                    text: report.status,
                    fontSize: AppFontSize.s12,
                    color: isPending ? AppColors.orange : AppColors.darkGreen,
                    fontWeight: AppFontWeight.bold,
                  ),
                ),
                SectionTitle(
                  text: report.type,
                  fontSize: AppFontSize.s16,
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: BodyTitle(
                    text: report.description,
                    fontSize: AppFontSize.s13,
                    color: AppColors.greyText,
                    maxLines: 2,
                  ),
                ),
                FaIcon(
                  FontAwesomeIcons.chevronLeft,
                  size: AppSize.s14,
                  color: AppColors.greyText,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BodyTitle(
                  text: report.date,
                  fontSize: AppFontSize.s12,
                  color: AppColors.greyText,
                ),
                Row(
                  spacing: AppWidth.w4,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.comment,
                      size: AppSize.s12,
                      color: AppColors.greyText,
                    ),
                    BodyTitle(
                      text: report.commentsCount.toString(),
                      fontSize: AppFontSize.s12,
                      color: AppColors.greyText,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}