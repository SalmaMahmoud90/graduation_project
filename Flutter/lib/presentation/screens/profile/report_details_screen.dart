// lib/presentation/screens/reports/report_details_screen.dart
import 'package:a_tareqaak/data/models/report/report_model.dart';
import 'package:flutter/material.dart';
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
  final ReportModel report;

  const ReportDetailsScreen({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    final tr = context.loc;
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;
    final bool isPending = report.status == 'معلق';

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
              // الشريط العلوي
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
                          text: report.status,
                          fontSize: AppFontSize.s12,
                          color:
                              isPending ? AppColors.orange : AppColors.darkGreen,
                          fontWeight: AppFontWeight.bold,
                        ),
                      ),
                    ),
                    _buildDetailRow(tr.report_type, report.type),
                    _buildDetailRow(
                        tr.report_date, '10:30 - 10 مايو 2024 ص'),
                    if (report.relatedRide != null)
                      _buildDetailRow(tr.related_ride, report.relatedRide!),
                    Divider(color: AppColors.lightGreySec),
                    SectionTitle(
                      text: tr.report_text,
                      fontSize: AppFontSize.s13,
                      color: AppColors.greyText,
                    ),
                    BodyTitle(
                      text: report.description,
                      fontSize: AppFontSize.s14,
                    ),
                  ],
                ),
              ),

              // بطاقة ملاحظات الإدارة باللون الأصفر المميز المطابق للصورة 3
              if (report.adminNotes != null)
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
                          borderRadius: BorderRadius.circular(AppRadius.r12),
                          border: Border.all(
                              color: AppColors.orange.withOpacity(0.3)),
                        ),
                        child: Column(
                          spacing: AppHeight.h6,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BodyTitle(
                              text: report.adminNotes!,
                              fontSize: AppFontSize.s13,
                            ),
                            BodyTitle(
                              text: report.adminNoteDate ?? '02:15 - 21 مايو 2024',
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

              // زر إغلاق الرئيسي
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