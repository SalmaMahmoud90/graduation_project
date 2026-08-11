
import 'package:a_tareqaak/core/routes/app_routes.dart';
import 'package:a_tareqaak/core/services/locator/locator.dart';
import 'package:a_tareqaak/presentation/cubit/language/language_cubit.dart';
import 'package:a_tareqaak/presentation/widgets/text/section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:a_tareqaak/core/extension/localization_extension.dart';
import 'package:a_tareqaak/core/resources/app_colors.dart';
import 'package:a_tareqaak/core/resources/app_fonts.dart';
import 'package:a_tareqaak/core/resources/app_values.dart';
import 'package:a_tareqaak/presentation/widgets/text/body_title.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});
   final List<FaIconData> icons = [
    FontAwesomeIcons.user,
    FontAwesomeIcons.wallet,
    FontAwesomeIcons.language,
    FontAwesomeIcons.moon,
    FontAwesomeIcons.headset,
    FontAwesomeIcons.circleQuestion,
    FontAwesomeIcons.rightFromBracket];
   
    
  @override
  Widget build(BuildContext context) {
    final tr = context.loc;
    List<String> titles = [
    tr.view_profile,
    tr.wallet_and_payment,
    tr.language_switch,
    tr.dark_mode,
    tr.customer_service,
    tr.my_reports,
    tr.logout];
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
                  text: tr.settings,
                  fontSize: AppFontSize.s18,
                  fontWeight: AppFontWeight.bold,
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: AppPaddingWidth.p20),
                child: ListView.separated(
                  itemCount: 7,
                  separatorBuilder: (context, index) => SizedBox(height: AppHeight.h12),
                 itemBuilder:(context, index) => _buildSettingCard(
                      icon: icons[index],
                      title: titles[index],
                      onTap: () {
                        index == 0
                            ? DriverProfileRoute().push(context)
                            : index == 1 
                            ? WalletRoute().push(context)
                                : index == 2
                                ?  context.read<LanguageCubit>().toggleLanguage()
                                    : index == 3
                                  ?   debugPrint('Dark Mode Tapped')
                                        : index == 4
                                        ? CustomerServiceRoute().push(context)
                                        : index == 5
                                            ? MyReportsRoute().push(context)
                                            : LoginRoute().push(context);
                      },
                    ),

                 
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingCard({
    required FaIconData icon,
    required String title,
    Color? color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.r14),
        border: Border.all(color: AppColors.lightGreySec),
      ),
      child: ListTile(
        onTap: onTap,
        leading: FaIcon(
          icon,
          size: AppSize.s18,
          color: color ?? AppColors.primary,
        ),
        title: BodyTitle(
          text: title,
          fontSize: AppFontSize.s15,
          fontWeight: AppFontWeight.bold,
          color: color ?? AppColors.blackText,
        ),
        trailing: FaIcon(
          FontAwesomeIcons.chevronLeft,
          size: AppSize.s14,
          color: AppColors.greyText,
        ),
      ),
    );
  }
}