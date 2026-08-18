import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import 'package:a_tareqaak/core/extension/localization_extension.dart';
import 'package:a_tareqaak/core/resources/app_colors.dart';
import 'package:a_tareqaak/core/resources/app_fonts.dart';
import 'package:a_tareqaak/core/resources/app_values.dart';
import 'package:a_tareqaak/data/models/payment/payment_models.dart';
import 'package:a_tareqaak/domain/entity/rides/rides_no_params_entity.dart';
import 'package:a_tareqaak/presentation/bloc/payment/get_deposit_requests/get_deposit_requests_bloc.dart';
import 'package:a_tareqaak/presentation/bloc/payment/get_deposit_requests/i_get_deposit_requests_event.dart';
import 'package:a_tareqaak/presentation/bloc/payment/get_deposit_requests/i_get_deposit_requests_state.dart';
import 'package:a_tareqaak/presentation/widgets/text/body_title.dart';
import 'package:a_tareqaak/presentation/widgets/text/section_title.dart';

class DepositRequestsScreen extends StatelessWidget {
  const DepositRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tr = context.loc;
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;

    return BlocProvider(
      create: (_) => GetDepositRequestsBloc()
        ..add(const GetDepositRequestsEvent(RidesNoParamsEntity())),
      child: Scaffold(
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
                      text: tr.deposit_requests_title,
                      fontSize: AppFontSize.s18,
                      fontWeight: AppFontWeight.bold,
                    ),
                    SizedBox(width: AppWidth.w40),
                  ],
                ),
              ),
              Expanded(
                child: BlocBuilder<GetDepositRequestsBloc,
                    IGetDepositRequestsState>(
                  builder: (context, state) {
                    if (state is GetDepositRequestsLoading ||
                        state is GetDepositRequestsInitial) {
                      return Center(
                        child:
                            CircularProgressIndicator(color: AppColors.primary),
                      );
                    }
                    if (state is GetDepositRequestsFailed) {
                      return _MessageView(
                        message: state.message,
                        onRetry: () => context
                            .read<GetDepositRequestsBloc>()
                            .add(const GetDepositRequestsEvent(
                                RidesNoParamsEntity())),
                      );
                    }
                    final requests = state is GetDepositRequestsLoaded
                        ? (state.responseModel?.data?.depositRequests ??
                            <DepositRequestDataModel>[])
                        : <DepositRequestDataModel>[];

                    if (requests.isEmpty) {
                      return _MessageView(message: tr.no_deposit_requests);
                    }

                    return RefreshIndicator(
                      onRefresh: () async => context
                          .read<GetDepositRequestsBloc>()
                          .add(const GetDepositRequestsEvent(
                              RidesNoParamsEntity())),
                      child: ListView.separated(
                        padding: EdgeInsets.all(AppPaddingWidth.p20),
                        itemCount: requests.length,
                        separatorBuilder: (_, __) =>
                            SizedBox(height: AppHeight.h12),
                        itemBuilder: (context, index) =>
                            _buildRequestCard(context, requests[index]),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRequestCard(
      BuildContext context, DepositRequestDataModel req) {
    final tr = context.loc;

    Color statusColor;
    Color statusBg;
    String statusLabel;
    switch (req.status) {
      case 'approved':
        statusColor = AppColors.darkGreen;
        statusBg = AppColors.lightPrim;
        statusLabel = tr.approved_status;
        break;
      case 'rejected':
        statusColor = AppColors.red;
        statusBg = AppColors.lightOrange;
        statusLabel = tr.rejected_status;
        break;
      case 'pending':
      default:
        statusColor = AppColors.orange;
        statusBg = AppColors.lightOrange;
        statusLabel = tr.pending_status;
    }

    final methodLabel =
        req.paymentMethod == 'sham_cash' ? tr.sham_cash : tr.syriatel_cash;

    return Container(
      padding: EdgeInsets.all(AppPaddingWidth.p16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.r16),
        border: Border.all(color: AppColors.lightGreySec),
      ),
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
                  color: statusBg,
                  borderRadius: BorderRadius.circular(AppRadius.r6),
                ),
                child: BodyTitle(
                  text: statusLabel,
                  fontSize: AppFontSize.s12,
                  color: statusColor,
                  fontWeight: AppFontWeight.bold,
                ),
              ),
              SectionTitle(
                text: '${req.amount ?? '0'} ${tr.syrian_pound}',
                fontSize: AppFontSize.s16,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BodyTitle(
                text: methodLabel,
                fontSize: AppFontSize.s13,
                color: AppColors.greyText,
              ),
              BodyTitle(
                text: _formatDate(req.createdAt),
                fontSize: AppFontSize.s12,
                color: AppColors.greyText,
              ),
            ],
          ),
          if ((req.transactionReference ?? '').isNotEmpty)
            BodyTitle(
              text: '${tr.sender_number}: ${req.transactionReference}',
              fontSize: AppFontSize.s12,
              color: AppColors.greyText,
            ),
        ],
      ),
    );
  }
}

String _formatDate(String? raw) {
  if (raw == null || raw.isEmpty) return '';
  final normalized = raw.replaceFirst('T', ' ');
  return normalized.length >= 16 ? normalized.substring(0, 16) : normalized;
}

class _MessageView extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const _MessageView({required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final tr = context.loc;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: AppHeight.h12,
        children: [
          BodyTitle(
            text: message,
            textAlign: TextAlign.center,
            color: AppColors.greyText,
          ),
          if (onRetry != null)
            TextButton(
              onPressed: onRetry,
              child: BodyTitle(text: tr.retry, color: AppColors.primary),
            ),
        ],
      ),
    );
  }
}
