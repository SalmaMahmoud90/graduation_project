import 'package:a_tareqaak/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import 'package:a_tareqaak/core/extension/localization_extension.dart';
import 'package:a_tareqaak/core/extension/validation_extension.dart';
import 'package:a_tareqaak/core/resources/app_colors.dart';
import 'package:a_tareqaak/core/resources/app_fonts.dart';
import 'package:a_tareqaak/core/resources/app_values.dart';
import 'package:a_tareqaak/core/utils/enums/enum_utils.dart';
import 'package:a_tareqaak/presentation/cubit/auth/register/register_cubit.dart';
import 'package:a_tareqaak/presentation/cubit/auth/register/register_state.dart';
import 'package:a_tareqaak/presentation/cubit/profile/driver_profile_cubit.dart';
import 'package:a_tareqaak/presentation/screens/auth/widgets/auth_header_widget.dart';
import 'package:a_tareqaak/presentation/widgets/custom_elevated_button.dart';
import 'package:a_tareqaak/presentation/widgets/form/custom_drop_down_field.dart';
import 'package:a_tareqaak/presentation/widgets/form/custom_input_field.dart';
import 'package:a_tareqaak/presentation/widgets/text/body_title.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RegisterCubit(),
      child: const _RegisterContent(),
    );
  }
}

class _RegisterContent extends StatefulWidget {
  const _RegisterContent();

  @override
  State<_RegisterContent> createState() => _RegisterContentState();
}

class _RegisterContentState extends State<_RegisterContent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // دالة بدء عملية التسجيل والتحقق من الحقول
  void _onRegisterPressed(BuildContext context) {
    final cubit = context.read<RegisterCubit>();

    // 1. التحقق من اختيار الدور أولاً
    if (cubit.selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.loc.role_required),
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }

    // 2. التحقق من الموافقة على الشروط والأحكام
    if (!cubit.isTermsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.loc.must_agree_terms),
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }

    // 3. التحقق من صحة المدخلات بداخل Form
    if (_formKey.currentState?.validate() ?? false) {
      cubit.register(
        fullName: _fullNameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        role: cubit.selectedRole!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tr = context.loc;
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      backgroundColor: AppColors.backGround,
      body: SafeArea(
        child: BlocListener<RegisterCubit, RegisterState>(
          listener: (context, state) {
            // 👈 هُنا يتم فحص المنطق والتوجيه الذكي بعد نجاح التسجيل:
            if (state is RegisterSuccessState) {
              if (state.role == UserType.driver) {
                // للوصول إلى ProfileCubit
                final profileCubit = context.read<DriverProfileCubit>();

                // فحص هل بروفايل السائق غير مكتمل؟ (وهو كذلك حكماً للسائق الجديد)
                if (!profileCubit.isProfileComplete) {
                  // توجيه إجباري لشاشة تعبئة بيانات البروفايل والسيارة
                  EditDriverProfileRoute(isMandatory: true).pushReplacement(context);
                } else {
                  // إذا كان مكتملاً ينتقل للرئيسية
                  DriverHomeRoute().pushReplacement(context);
                }
              } else {
                // إذا كان راكب ينتقل لصفحة الراكب الرئيسية مباشرة
                RiderHomeRoute().pushReplacement(context);
              }
            }
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: AppPaddingWidth.p25,
              vertical: AppPaddingHeight.p15,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                spacing: AppHeight.h16,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // زر العودة للخلف باستخدام FaIcon وبحجم مناسب
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

                  // الهيدر الرئيسي (اللوجو والعنوان)
                  AuthHeaderWidget(
                    title: tr.create_account_title,
                    subtitle: tr.start_journey,
                  ),

                  // حقل الاسم الكامل
                  CustomInputField(
                    controller: _fullNameController,
                    hintText: tr.full_name_hint,
                    title: tr.full_name,
                    isExpanded: true,
                    textInputType: TextInputType.name,
                    prefixIcon: Center(
                      widthFactor: 1.0,
                      child: FaIcon(
                        FontAwesomeIcons.user,
                        color: AppColors.grey,
                        size: AppSize.s20,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return tr.field_required;
                      }
                      return null;
                    },
                  ),

                  // حقل اختيار الدور (سائق / راكب)
                  BlocBuilder<RegisterCubit, RegisterState>(
                    builder: (context, state) {
                      final cubit = context.read<RegisterCubit>();
                      final List<String> roleItems = [tr.driver, tr.rider];

                      return CustomDropDownField(
                        title: tr.role,
                        showInputField: false,
                        dropDownHint: tr.select_role_hint,
                        dropDownItems: roleItems,
                        requiredInput: true,
                        onDropDownChanged: (selectedVal) {
                          if (selectedVal == tr.driver) {
                            cubit.selectRole(UserType.driver);
                          } else if (selectedVal == tr.rider) {
                            cubit.selectRole(UserType.rider);
                          }
                        },
                      );
                    },
                  ),

                  // حقل البريد الإلكتروني
                  CustomInputField(
                    controller: _emailController,
                    hintText: tr.email_hint,
                    isExpanded: true,
                    title: tr.email,
                    textInputType: TextInputType.emailAddress,
                    prefixIcon: Center(
                      widthFactor: 1.0,
                      child: FaIcon(
                        FontAwesomeIcons.envelope,
                        color: AppColors.grey,
                        size: AppSize.s20,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return tr.field_required;
                      }
                      if (!value.isValidEmail) {
                        return tr.enter_valid_email;
                      }
                      return null;
                    },
                  ),

                  // حقل كلمة المرور
                  BlocBuilder<RegisterCubit, RegisterState>(
                    builder: (context, state) {
                      final cubit = context.read<RegisterCubit>();
                      return CustomInputField(
                        controller: _passwordController,
                        hintText: tr.password_hint,
                        title: tr.password,
                        isExpanded: true,
                        maxLines: 1,
                        isSecure: cubit.isPasswordObscured,
                        prefixIcon: Center(
                          widthFactor: 1.0,
                          child: FaIcon(
                            FontAwesomeIcons.lock,
                            color: AppColors.grey,
                            size: AppSize.s20,
                          ),
                        ),
                        suffixIcon: IconButton(
                          icon: FaIcon(
                            cubit.isPasswordObscured
                                ? FontAwesomeIcons.eyeSlash
                                : FontAwesomeIcons.eye,
                            color: AppColors.grey,
                            size: AppSize.s20,
                          ),
                          onPressed: () {
                            cubit.togglePasswordVisibility();
                          },
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return tr.field_required;
                          }
                          if (value.length < 6) {
                            return tr.password_too_short;
                          }
                          return null;
                        },
                      );
                    },
                  ),

                  // حقل تأكيد كلمة المرور
                  BlocBuilder<RegisterCubit, RegisterState>(
                    builder: (context, state) {
                      final cubit = context.read<RegisterCubit>();
                      return CustomInputField(
                        controller: _confirmPasswordController,
                        hintText: tr.confirm_password_hint,
                        title: tr.confirm_password,
                        isExpanded: true,
                        isSecure: cubit.isConfirmPasswordObscured,
                        maxLines: 1,
                        prefixIcon: Center(
                          widthFactor: 1.0,
                          child: FaIcon(
                            FontAwesomeIcons.lock,
                            color: AppColors.grey,
                            size: AppSize.s20,
                          ),
                        ),
                        suffixIcon: IconButton(
                          icon: FaIcon(
                            cubit.isConfirmPasswordObscured
                                ? FontAwesomeIcons.eyeSlash
                                : FontAwesomeIcons.eye,
                            color: AppColors.grey,
                            size: AppSize.s20,
                          ),
                          onPressed: () {
                            cubit.toggleConfirmPasswordVisibility();
                          },
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return tr.field_required;
                          }
                          if (value != _passwordController.text) {
                            return tr.passwords_dont_match;
                          }
                          return null;
                        },
                      );
                    },
                  ),

                  // مربع الاختيار للشروط والأحكام
                  BlocBuilder<RegisterCubit, RegisterState>(
                    builder: (context, state) {
                      final cubit = context.read<RegisterCubit>();
                      return Row(
                        spacing: AppWidth.w5,
                        children: [
                          Checkbox(
                            value: cubit.isTermsAccepted,
                            activeColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppRadius.r4),
                            ),
                            onChanged: (val) {
                              cubit.toggleTerms(val);
                            },
                          ),
                          Expanded(
                            child: BodyTitle(
                              text: tr.agree_terms,
                              fontSize: AppFontSize.s12,
                              color: AppColors.blackText,
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  // زر إنشاء الحساب
                  BlocBuilder<RegisterCubit, RegisterState>(
                    builder: (context, state) {
                      final cubit = context.read<RegisterCubit>();
                      return CustomElevatedButton(
                        height: AppHeight.h50,
                        width: double.infinity,
                        borderRadius: AppRadius.r12,
                        color: AppColors.primary,
                        loading: cubit.isLoading || state is RegisterLoadingState,
                        onPressed: () => _onRegisterPressed(context),
                        child: BodyTitle(
                          text: tr.create_account_btn,
                          color: AppColors.white,
                          fontSize: AppFontSize.s16,
                          fontWeight: AppFontWeight.bold,
                        ),
                      );
                    },
                  ),

                  // رابط العودة لتسجيل الدخول
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: AppWidth.w4,
                    children: [
                      BodyTitle(
                        text: tr.already_have_account,
                        color: AppColors.greyText,
                        fontSize: AppFontSize.s14,
                      ),
                      InkWell(
                        onTap: () {
                          context.pop();
                        },
                        child: BodyTitle(
                          text: tr.login,
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
        ),
      ),
    );
  }
}