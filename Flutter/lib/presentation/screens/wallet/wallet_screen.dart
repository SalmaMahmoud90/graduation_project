import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import 'package:a_tareqaak/core/extension/localization_extension.dart';
import 'package:a_tareqaak/core/resources/app_colors.dart';
import 'package:a_tareqaak/core/resources/app_fonts.dart';
import 'package:a_tareqaak/core/resources/app_values.dart';
import 'package:a_tareqaak/presentation/widgets/text/body_title.dart';
import 'package:a_tareqaak/presentation/widgets/text/section_title.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tr = context.loc;
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;

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
                    text: tr.wallet_and_payment,
                    fontSize: AppFontSize.s18,
                    fontWeight: AppFontWeight.bold,
                  ),
                  SizedBox(width: AppWidth.w40),
                ],
              ),

              // بطاقة الرصيد
              Container(
                padding: EdgeInsets.all(AppPaddingWidth.p20),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppRadius.r20),
                ),
                child: Column(
                  spacing: AppHeight.h8,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BodyTitle(
                      text: tr.wallet_balance,
                      color: AppColors.white.withOpacity(0.8),
                    ),
                    SectionTitle(
                      text: '120,000 ${tr.syrian_pound}',
                      color: AppColors.white,
                      fontSize: AppFontSize.s24,
                    ),
                  ],
                ),
              ),

              SectionTitle(
                text: tr.charge_balance,
                fontSize: AppFontSize.s14,
                color: AppColors.primary,
              ),

              // خيار سيريتل كاش
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppRadius.r14),
                  border: Border.all(color: AppColors.lightGreySec),
                ),
                child: ListTile(
                  onTap: () => context.push('/charge-wallet'),
                  leading: FaIcon(
                    FontAwesomeIcons.mobileRetro,
                    color: AppColors.red,
                    size: AppSize.s20,
                  ),
                  title: BodyTitle(
                    text: tr.syriatel_cash,
                    fontWeight: AppFontWeight.bold,
                  ),
                  trailing: FaIcon(
                    FontAwesomeIcons.chevronLeft,
                    size: AppSize.s14,
                    color: AppColors.greyText,
                  ),
                ),
              ),

              // خيار شام كاش
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppRadius.r14),
                  border: Border.all(color: AppColors.lightGreySec),
                ),
                child: ListTile(
                  onTap: () {},
                  leading: FaIcon(
                    FontAwesomeIcons.wallet,
                    color: AppColors.darkGreen,
                    size: AppSize.s20,
                  ),
                  title: BodyTitle(
                    text: tr.sham_cash,
                    fontWeight: AppFontWeight.bold,
                  ),
                  trailing: FaIcon(
                    FontAwesomeIcons.chevronLeft,
                    size: AppSize.s14,
                    color: AppColors.greyText,
                  ),
                ),
              ),

              // سجل المعاملات
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppRadius.r14),
                  border: Border.all(color: AppColors.lightGreySec),
                ),
                child: ListTile(
                  onTap: () {},
                  leading: FaIcon(
                    FontAwesomeIcons.list,
                    color: AppColors.blackText,
                    size: AppSize.s20,
                  ),
                  title: BodyTitle(
                    text: tr.transaction_history,
                    fontWeight: AppFontWeight.bold,
                  ),
                  trailing: FaIcon(
                    FontAwesomeIcons.chevronLeft,
                    size: AppSize.s14,
                    color: AppColors.greyText,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}