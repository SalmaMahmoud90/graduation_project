import 'package:a_tareqaak/data/models/report/report_data_model.dart';
import 'package:a_tareqaak/domain/entity/rides/id_entity.dart';
import 'package:a_tareqaak/presentation/bloc/report/get_report_details/get_report_details_bloc.dart';
import 'package:a_tareqaak/presentation/bloc/report/get_report_details/i_get_report_details_event.dart';
import 'package:a_tareqaak/presentation/bloc/report/get_report_details/i_get_report_details_state.dart';
import 'package:a_tareqaak/presentation/screens/report/report_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import 'package:a_tareqaak/core/extension/localization_extension.dart';
import 'package:a_tareqaak/core/resources/app_colors.dart';
import 'package:a_tareqaak/core/resources/app_fonts.dart';
import 'package:a_tareqaak/core/resources/app_values.dart';
import 'package:a_tareqaak/presentation/widgets/custom_elevated_button.dart';
import 'package:a_tareqaak/presentation/widgets/text/body_title.dart';
import 'package:a_tareqaak/presentation/widgets/text/section_title.dart';

class ReportDetailsScreen extends StatelessWidget {
  final ReportDataModel report;

  const ReportDetailsScreen({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final bloc = GetReportDetailsBloc();
        if (report.id != null) {
          bloc.add(GetReportDetailsEvent(IdEntity(report.id!)));
        }
        return bloc;
      },
      child: _ReportDetailsContent(fallback: report),
    );
  }
}

class _ReportDetailsContent extends StatelessWidget {
  final ReportDataModel fallback;

  const _ReportDetailsContent({required this.fallback});

  @override
  Widget build(BuildContext context) {
    final tr = context.loc;
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      backgroundColor: AppColors.backGround,
      body: SafeArea(
        child: BlocBuilder<GetReportDetailsBloc, IGetReportDetailsState>(
          builder: (context, state) {
            // نعرض بيانات القائمة مباشرة ثم نُحدّثها بالتفاصيل الكاملة عند وصولها
            final report = state is GetReportDetailsLoaded
                ? (state.responseModel?.data ?? fallback)
                : fallback;
            final bool isLoading = state is GetReportDetailsLoading;
            final bool isPending = report.status != 'reviewed';

            return SingleChildScrollView(
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
                          isRtl
                              ? FontAwesomeIcons.chevronRight
                              : FontAwesomeIcons.chevronLeft,
                          color: AppColors.blackText,
                          size: AppSize.s20,
                        ),
                      ),
                      SectionTitle(
                        text: tr.report_details_title,
                        fontSize: AppFontSize.s18,
                        fontWeight: AppFontWeight.bold,
                      ),
                      SizedBox(width: AppWidth.w40),
                    ],
                  ),

                  if (isLoading)
                    LinearProgressIndicator(
                      color: AppColors.primary,
                      backgroundColor: AppColors.lightGreySec,
                    ),

                  // بطاقة بيانات البلاغ الرئيسية
                  Container(
                    padding: EdgeInsets.all(AppPaddingWidth.p16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(AppRadius.r16),
                      border: Border.all(color: AppColors.lightGreySec),
                    ),
                    child: Column(
                      spacing: AppHeight.h12,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: Container(
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
                              text: localizeReportStatus(tr, report.status),
                              fontSize: AppFontSize.s12,
                              color: isPending
                                  ? AppColors.orange
                                  : AppColors.darkGreen,
                              fontWeight: AppFontWeight.bold,
                            ),
                          ),
                        ),
                        _buildDetailRow(
                            tr.report_type, localizeReportType(tr, report.type)),
                        _buildDetailRow(
                            tr.report_date, formatReportDate(report.createdAt)),
                        if (report.ride != null)
                          _buildDetailRow(
                              tr.related_ride, '#${report.ride}'),
                        Divider(color: AppColors.lightGreySec),
                        SectionTitle(
                          text: tr.report_text,
                          fontSize: AppFontSize.s13,
                          color: AppColors.greyText,
                        ),
                        BodyTitle(
                          text: report.reason ?? '',
                          fontSize: AppFontSize.s14,
                        ),
                      ],
                    ),
                  ),

                  // بطاقة ملاحظات الإدارة — تظهر فقط عند وجود ملاحظة
                  if ((report.adminNote ?? '').isNotEmpty)
                    Container(
                      padding: EdgeInsets.all(AppPaddingWidth.p16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(AppRadius.r16),
                        border: Border.all(color: AppColors.lightGreySec),
                      ),
                      child: Column(
                        spacing: AppHeight.h10,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SectionTitle(
                            text: tr.admin_notes,
                            fontSize: AppFontSize.s14,
                          ),
                          Container(
                            padding: EdgeInsets.all(AppPaddingWidth.p12),
                            decoration: BoxDecoration(
                              color: AppColors.lightOrange.withOpacity(0.5),
                              borderRadius:
                                  BorderRadius.circular(AppRadius.r12),
                              border: Border.all(
                                  color: AppColors.orange.withOpacity(0.3)),
                            ),
                            child: Column(
                              spacing: AppHeight.h6,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                BodyTitle(
                                  text: report.adminNote!,
                                  fontSize: AppFontSize.s13,
                                ),
                                if ((report.updatedAt ?? '').isNotEmpty)
                                  BodyTitle(
                                    text: formatReportDate(report.updatedAt),
                                    fontSize: AppFontSize.s11,
                                    color: AppColors.greyText,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                  SizedBox(height: AppHeight.h20),

                  CustomElevatedButton(
                    height: AppHeight.h50,
                    width: double.infinity,
                    borderRadius: AppRadius.r12,
                    color: AppColors.primary,
                    onPressed: () => context.pop(),
                    child: BodyTitle(
                      text: tr.close_btn,
                      color: AppColors.white,
                      fontSize: AppFontSize.s16,
                      fontWeight: AppFontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppHeight.h2,
      children: [
        BodyTitle(
          text: label,
          fontSize: AppFontSize.s12,
          color: AppColors.greyText,
        ),
        BodyTitle(
          text: value,
          fontSize: AppFontSize.s14,
          fontWeight: AppFontWeight.bold,
        ),
      ],
    );
  }
}
