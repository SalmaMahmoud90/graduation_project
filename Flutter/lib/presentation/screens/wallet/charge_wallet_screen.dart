import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

import 'package:a_tareqaak/core/extension/localization_extension.dart';
import 'package:a_tareqaak/core/extension/validation_extension.dart';
import 'package:a_tareqaak/core/resources/app_colors.dart';
import 'package:a_tareqaak/core/resources/app_fonts.dart';
import 'package:a_tareqaak/core/resources/app_values.dart';
import 'package:a_tareqaak/presentation/widgets/custom_bottom_sheet.dart';
import 'package:a_tareqaak/presentation/widgets/custom_snack_bar.dart';
import 'package:a_tareqaak/presentation/widgets/custom_elevated_button.dart';
import 'package:a_tareqaak/presentation/widgets/form/custom_input_field.dart';
import 'package:a_tareqaak/presentation/widgets/text/body_title.dart';
import 'package:a_tareqaak/presentation/widgets/text/section_title.dart';

class ChargeWalletScreen extends StatefulWidget {
  const ChargeWalletScreen({super.key});

  @override
  State<ChargeWalletScreen> createState() => _ChargeWalletScreenState();
}

class _ChargeWalletScreenState extends State<ChargeWalletScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _amountController = TextEditingController(text: '50,000');

  void _showSuccessSheet(BuildContext context) {
    final tr = context.loc;
    CustomBottomSheet.show(
      context,
      title: tr.charge_request_submitted,
      body: Column(
        spacing: AppHeight.h16,
        children: [
          CircleAvatar(
            radius: AppRadius.r30,
            backgroundColor: AppColors.green,
            child: FaIcon(
              FontAwesomeIcons.check,
              color: AppColors.white,
              size: AppSize.s24,
            ),
          ),
          BodyTitle(
            text: tr.charge_request_sub,
            textAlign: TextAlign.center,
            fontSize: AppFontSize.s13,
          ),
          CustomElevatedButton(
            height: AppHeight.h45,
            width: double.infinity,
            borderRadius: AppRadius.r12,
            color: AppColors.primary,
            onPressed: () {
              context.pop();
              context.pop();
            },
            child: BodyTitle(
              text: tr.ok,
              color: AppColors.white,
              fontWeight: AppFontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tr = context.loc;
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      backgroundColor: AppColors.backGround,
      body: SafeArea(
        child: Padding(
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
                    text: '${tr.charge_balance} - ${tr.syriatel_cash}',
                    fontSize: AppFontSize.s18,
                    fontWeight: AppFontWeight.bold,
                  ),
                  SizedBox(width: AppWidth.w40),
                ],
              ),

              CustomInputField(
                controller: _phoneController,
                title: tr.sender_number,
                hintText: '09XXXXXXXX',
                textInputType: TextInputType.phone,
                isExpanded: true,
              ),

              CustomInputField(
                controller: _amountController,
                title: tr.amount,
                hintText: '50,000',
                textInputType: TextInputType.number,
                isExpanded: true,
              ),

              // خيارات خيارات المبالغ المتاحة (25,000 / 50,000 / 100,000)
              Row(
                spacing: AppWidth.w8,
                children: [
                  _buildAmountChip('25,000'),
                  _buildAmountChip('50,000'),
                  _buildAmountChip('100,000'),
                  _buildAmountChip(tr.other_amount),
                ],
              ),

              const Spacer(),

              CustomElevatedButton(
                height: AppHeight.h50,
                width: double.infinity,
                borderRadius: AppRadius.r12,
                color: AppColors.primary,
                onPressed: () {
                  final phone = _phoneController.text.trim();
                  if (!phone.isValidPhone) {
                    showCustomSnackBar(
                      context: context,
                      title: tr.error_title,
                      message: tr.enter_valid_phone,
                      contentType: ContentType.failure,
                    );
                    return;
                  }
                  _showSuccessSheet(context);
                },
                child: BodyTitle(
                  text: tr.charge_balance,
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

  Widget _buildAmountChip(String label) {
    return Expanded(
      child: InkWell(
        onTap: () {
          if (label != context.loc.other_amount) {
            _amountController.text = label;
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: AppPaddingHeight.p8),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.r8),
            border: Border.all(color: AppColors.lightGreySec),
          ),
          child: BodyTitle(
            text: label,
            textAlign: TextAlign.center,
            fontSize: AppFontSize.s12,
          ),
        ),
      ),
    );
  }
}