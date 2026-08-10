import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import 'package:a_tareqaak/core/extension/localization_extension.dart';
import 'package:a_tareqaak/core/resources/app_colors.dart';
import 'package:a_tareqaak/core/resources/app_fonts.dart';
import 'package:a_tareqaak/core/resources/app_values.dart';
import 'package:a_tareqaak/presentation/cubit/notifications/notifications_cubit.dart';
import 'package:a_tareqaak/presentation/cubit/notifications/notifications_state.dart';
import 'package:a_tareqaak/presentation/widgets/text/body_title.dart';
import 'package:a_tareqaak/presentation/widgets/text/section_title.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotificationsCubit(),
      child: const _NotificationsContent(),
    );
  }
}

class _NotificationsContent extends StatelessWidget {
  const _NotificationsContent();

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
                    text: tr.notifications,
                    fontSize: AppFontSize.s18,
                    fontWeight: AppFontWeight.bold,
                  ),
                  SizedBox(width: AppWidth.w40),
                ],
              ),
            ),

            // التبويب العلوي (الكل / غير المقروءة)
            BlocBuilder<NotificationsCubit, NotificationsState>(
              builder: (context, state) {
                final cubit = context.read<NotificationsCubit>();
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppPaddingWidth.p20),
                  child: Container(
                    padding: EdgeInsets.all(AppPaddingWidth.p4),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(AppRadius.r12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => cubit.changeTab(0),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: AppPaddingHeight.p8,
                              ),
                              decoration: BoxDecoration(
                                color: cubit.currentTab == 0
                                    ? AppColors.primary
                                    : AppColors.none,
                                borderRadius:
                                    BorderRadius.circular(AppRadius.r10),
                              ),
                              child: BodyTitle(
                                text: tr.all,
                                textAlign: TextAlign.center,
                                color: cubit.currentTab == 0
                                    ? AppColors.white
                                    : AppColors.greyText,
                                fontWeight: AppFontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () => cubit.changeTab(1),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: AppPaddingHeight.p8,
                              ),
                              decoration: BoxDecoration(
                                color: cubit.currentTab == 1
                                    ? AppColors.primary
                                    : AppColors.none,
                                borderRadius:
                                    BorderRadius.circular(AppRadius.r10),
                              ),
                              child: BodyTitle(
                                text: tr.unread,
                                textAlign: TextAlign.center,
                                color: cubit.currentTab == 1
                                    ? AppColors.white
                                    : AppColors.greyText,
                                fontWeight: AppFontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            // قائمة الإشعارات الثابتة
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(AppPaddingWidth.p20),
                children: [
                  _buildNotificationItem(
                    icon: FontAwesomeIcons.bell,
                    iconColor: AppColors.primary,
                    title: 'تم حجز مقعد جديد في رحلتك',
                    time: 'منذ 5 دقائق',
                  ),
                  SizedBox(height: AppHeight.h10),
                  _buildNotificationItem(
                    icon: FontAwesomeIcons.bell,
                    iconColor: AppColors.primary,
                    title: 'قام أحد الركاب بإلغاء الحجز',
                    time: 'منذ 30 دقيقة',
                  ),
                  SizedBox(height: AppHeight.h10),
                  _buildNotificationItem(
                    icon: FontAwesomeIcons.shield,
                    iconColor: AppColors.red,
                    title: 'تلقيت تقييماً جديداً ⭐ 4.8',
                    time: 'منذ ساعة',
                  ),
                  SizedBox(height: AppHeight.h10),
                  _buildNotificationItem(
                    icon: FontAwesomeIcons.bell,
                    iconColor: AppColors.primary,
                    title: 'تمت أرشفة رحلة مكتملة',
                    time: 'منذ 3 ساعات',
                  ),
                  SizedBox(height: AppHeight.h10),
                  _buildNotificationItem(
                    icon: FontAwesomeIcons.bell,
                    iconColor: AppColors.primary,
                    title: 'تحديث جديد في التطبيق',
                    time: 'منذ يوم',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem({
    required FaIconData icon,
    required Color iconColor,
    required String title,
    required String time,
  }) {
    return Container(
      padding: EdgeInsets.all(AppPaddingWidth.p14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.r14),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        spacing: AppWidth.w12,
        children: [
          CircleAvatar(
            radius: AppRadius.r18,
            backgroundColor: iconColor.withOpacity(0.1),
            child: FaIcon(
              icon,
              color: iconColor,
              size: AppSize.s16,
            ),
          ),
          Expanded(
            child: Column(
              spacing: AppHeight.h4,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BodyTitle(
                  text: title,
                  fontSize: AppFontSize.s14,
                  fontWeight: AppFontWeight.bold,
                ),
                BodyTitle(
                  text: time,
                  fontSize: AppFontSize.s12,
                  color: AppColors.greyText,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}