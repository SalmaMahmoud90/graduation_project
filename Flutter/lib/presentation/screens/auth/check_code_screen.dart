import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:a_tareqaak/core/extension/localization_extension.dart';
import 'package:a_tareqaak/core/resources/app_colors.dart';
import 'package:a_tareqaak/core/resources/app_fonts.dart';
import 'package:a_tareqaak/core/resources/app_values.dart';
import 'package:a_tareqaak/presentation/cubit/auth/otp/otp_cubit.dart';
import 'package:a_tareqaak/presentation/cubit/auth/otp/otp_state.dart';
import 'package:a_tareqaak/presentation/widgets/custom_elevated_button.dart';
import 'package:a_tareqaak/presentation/widgets/text/body_title.dart';
import 'package:a_tareqaak/presentation/widgets/text/section_title.dart';

class CheckCodeScreen extends StatelessWidget {
  final String email;

  const CheckCodeScreen({
    super.key,
    this.email = 'example@email.com',
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OtpCubit(),
      child: _CheckCodeContent(email: email),
    );
  }
}

class _CheckCodeContent extends StatefulWidget {
  final String email;

  const _CheckCodeContent({required this.email});

  @override
  State<_CheckCodeContent> createState() => _CheckCodeContentState();
}

class _CheckCodeContentState extends State<_CheckCodeContent> {
  // التركيز والتحكم لخانات الرمز الـ 5
  final List<FocusNode> _focusNodes = List.generate(5, (_) => FocusNode());
  final List<TextEditingController> _controllers =
      List.generate(5, (_) => TextEditingController());

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  // دالة تأكيد الرمز عند الضغط على الزر
  void _onVerifyPressed(BuildContext context) {
    final cubit = context.read<OtpCubit>();
    if (!cubit.isCodeComplete) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.loc.invalid_otp),
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }

    cubit.verifyCode();
  }

  // تنسيق مؤقت الثواني إلى دقائق وثواني (00:45)
  String _formatTime(int seconds) {
    final minutesStr = (seconds ~/ 60).toString().padLeft(2, '0');
    final secondsStr = (seconds % 60).toString().padLeft(2, '0');
    return '$minutesStr:$secondsStr';
  }

  @override
  Widget build(BuildContext context) {
    final tr = context.loc;
    // فحص اتجاه اللغة الحالية (هل هي من اليمين لليسار RTL؟)
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      backgroundColor: AppColors.backGround,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppPaddingWidth.p25,
            vertical: AppPaddingHeight.p15,
          ),
          child: Column(
            spacing: AppHeight.h20,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // زر العودة متكيف تلقائياً مع اتجاه اللغة باستخدام FontAwesomeIcons
              Align(
                alignment: AlignmentDirectional.topStart,
                child: IconButton(
                  onPressed: () => context.pop(),
                  icon: FaIcon(
                    isRtl
                        ? FontAwesomeIcons.chevronRight
                        : FontAwesomeIcons.chevronLeft,
                    color: AppColors.blackText,
                    size: AppSize.s20,
                  ),
                ),
              ),

             
              // أيقونة البريد التوضيحية مع الشارة الخضراء
              Center(
                child: Container(
                  width: AppWidth.w130,
                  height: AppHeight.h130,
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(AppRadius.r20),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.envelope,
                        size: AppSize.s100,
                        color: AppColors.primary,
                      ),
                      Positioned(
                        bottom: AppHeight.h12,
                        right: AppWidth.w12,
                        child: CircleAvatar(
                          radius: AppRadius.r12,
                          backgroundColor: AppColors.green,
                          child: FaIcon(
                            FontAwesomeIcons.check,
                            color: AppColors.white,
                            size: AppSize.s12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // العناوين التوضيحية والبريد الإلكتروني
              Column(
                spacing: AppHeight.h6,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SectionTitle(
                    text: tr.verify_email_title,
                    fontSize: AppFontSize.s22,
                    fontWeight: AppFontWeight.bold,
                    color: AppColors.primary,
                    textAlign: TextAlign.center,
                  ),
                  BodyTitle(
                    text: '${tr.verify_email_sub} ',
                    fontSize: AppFontSize.s14,
                    color: AppColors.greyText,
                    textAlign: TextAlign.center,
                  ),
                  BodyTitle(
                    text: widget.email,
                    fontSize: AppFontSize.s14,
                    fontWeight: AppFontWeight.bold,
                    color: AppColors.primary,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),

              // حقول الرمز الـ 5 مع مراعاة اتجاه اللغة والانتقال التلقائي بين الخانات
              BlocBuilder<OtpCubit, OtpState>(
                builder: (context, state) {
                  final cubit = context.read<OtpCubit>();
                  return Directionality(
                    textDirection:
                        isRtl ? TextDirection.rtl : TextDirection.ltr,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      spacing: AppWidth.w8,
                      children: List.generate(5, (index) {
                        return SizedBox(
                          width: AppWidth.w55,
                          height: AppHeight.h60,
                          child: TextFormField(
                            controller: _controllers[index],
                            focusNode: _focusNodes[index],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: AppFontSize.s20,
                              fontWeight: AppFontWeight.bold,
                              color: AppColors.blackText,
                            ),
                            maxLength: 1,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: InputDecoration(
                              counterText: '',
                              filled: true,
                              fillColor: AppColors.white,
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(AppRadius.r12),
                                borderSide: const BorderSide(
                                  color: AppColors.lightGreySec,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(AppRadius.r12),
                                borderSide: const BorderSide(
                                  color: AppColors.primary,
                                  width: 1.5,
                                ),
                              ),
                            ),
                            onChanged: (value) {
                              cubit.updateDigit(index, value);
                              // الانتقال للخانة التالية أو السابقة حسب كتابة الرقم أو مسحه
                              if (value.isNotEmpty && index < 4) {
                                _focusNodes[index + 1].requestFocus();
                              } else if (value.isEmpty && index > 0) {
                                _focusNodes[index - 1].requestFocus();
                              }
                            },
                          ),
                        );
                      }),
                    ),
                  );
                },
              ),

              // المؤقت الزمني وزر إعادة الإرسال
              BlocBuilder<OtpCubit, OtpState>(
                builder: (context, state) {
                  final cubit = context.read<OtpCubit>();
                  return Column(
                    spacing: AppHeight.h8,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (!cubit.canResend)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: AppWidth.w4,
                          children: [
                            BodyTitle(
                              text: tr.resend_code_in,
                              color: AppColors.greyText,
                              fontSize: AppFontSize.s14,
                            ),
                            BodyTitle(
                              text: _formatTime(cubit.timerSeconds),
                              color: AppColors.primary,
                              fontWeight: AppFontWeight.bold,
                              fontSize: AppFontSize.s14,
                            ),
                          ],
                        ),
                      InkWell(
                        onTap: cubit.canResend
                            ? () {
                                cubit.resendCode();
                              }
                            : null,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          spacing: AppWidth.w6,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.arrowsRotate,
                              size: AppSize.s18,
                              color: cubit.canResend
                                  ? AppColors.primary
                                  : AppColors.grey,
                            ),
                            BodyTitle(
                              text: tr.resend_code,
                              color: cubit.canResend
                                  ? AppColors.primary
                                  : AppColors.grey,
                              fontWeight: AppFontWeight.bold,
                              fontSize: AppFontSize.s14,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),

              // زر تأكيد الرمز
              BlocBuilder<OtpCubit, OtpState>(
                builder: (context, state) {
                  final cubit = context.read<OtpCubit>();
                  return CustomElevatedButton(
                    height: AppHeight.h50,
                    width: double.infinity,
                    borderRadius: AppRadius.r12,
                    color: AppColors.primary,
                    loading: cubit.isLoading || state is OtpLoadingState,
                    onPressed: () => _onVerifyPressed(context),
                    child: BodyTitle(
                      text: tr.verify_code_btn,
                      color: AppColors.white,
                      fontSize: AppFontSize.s16,
                      fontWeight: AppFontWeight.bold,
                    ),
                  );
                },
              ),

              // رابط التواصل مع الدعم
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: AppWidth.w4,
                children: [
                  BodyTitle(
                    text: tr.having_trouble_code,
                    color: AppColors.greyText,
                    fontSize: AppFontSize.s14,
                  ),
                  InkWell(
                    onTap: () {
                      // للانتقال للدعم الفني
                    },
                    child: BodyTitle(
                      text: tr.contact_us,
                      color: AppColors.primary,
                      fontSize: AppFontSize.s14,
                      fontWeight: AppFontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}