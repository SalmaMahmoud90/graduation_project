import 'package:a_tareqaak/core/routes/app_routes.dart';
import 'package:a_tareqaak/presentation/widgets/form/custom_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:a_tareqaak/core/extension/localization_extension.dart';
import 'package:a_tareqaak/core/extension/validation_extension.dart';
import 'package:a_tareqaak/core/resources/app_colors.dart';
import 'package:a_tareqaak/core/resources/app_fonts.dart';
import 'package:a_tareqaak/core/resources/app_values.dart';
import 'package:a_tareqaak/presentation/cubit/auth/login/login_cubit.dart';
import 'package:a_tareqaak/presentation/cubit/auth/login/login_state.dart';
import 'package:a_tareqaak/presentation/cubit/language/language_cubit.dart';
import 'package:a_tareqaak/presentation/screens/auth/widgets/auth_header_widget.dart';
import 'package:a_tareqaak/presentation/widgets/custom_elevated_button.dart';

import 'package:a_tareqaak/presentation/widgets/text/body_title.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(),
      child: const _LoginContent(),
    );
  }
}

class _LoginContent extends StatefulWidget {
  const _LoginContent();

  @override
  State<_LoginContent> createState() => _LoginContentState();
}

class _LoginContentState extends State<_LoginContent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<LoginCubit>().login(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tr = context.loc;

    return Scaffold(
      backgroundColor: AppColors.backGround,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppPaddingWidth.p25,
            vertical: AppPaddingHeight.p15,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              spacing: AppHeight.h20,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // زر تبديل اللغة أعلى الشاشة
                Align(
                  alignment: AlignmentDirectional.topEnd,
                  child: InkWell(
                    onTap: () {
                      final langCubit = context.read<LanguageCubit>();
                      final newLocale = Localizations.localeOf(context).languageCode == 'ar'
                          ? const Locale('en')
                          : const Locale('ar');
                      langCubit.setLocale(newLocale);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: AppWidth.w5,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.globe,
                          color: AppColors.primary,
                          size: AppSize.s20,
                        ),
                        BodyTitle(
                          text: tr.language_switch,
                          fontWeight: AppFontWeight.medium,
                          fontSize: AppFontSize.s14,
                        ),
                      ],
                    ),
                  ),
                ),

                // الهيدر الرئيسي (اللوجو والعناوين)
                AuthHeaderWidget(
                  title: tr.welcome_back,
                  subtitle: tr.login_to_access,
                ),

                // حقل أدخل البريد الإلكتروني
                 CustomInputField(
                      controller: _emailController,
                      title: tr.email ,
                      hintText: tr.email_hint,
                      isExpanded: true,
                      textInputType: TextInputType.emailAddress,
                      prefixIcon: FaIcon(
                        FontAwesomeIcons.envelope,
                        color: AppColors.grey,
                        size: AppSize.s20,
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
                 

                // حقل كلمة المرور مع التحكم في الإظهار والإخفاء
                BlocBuilder<LoginCubit, LoginState>(
                  builder: (context, state) {
                    final cubit = context.read<LoginCubit>();
                    return CustomInputField(
                          controller: _passwordController,
                          title: tr.password,
                          hintText: tr.password_hint,
                          isSecure: cubit.isPasswordObscured,
                          isExpanded: true,
                          maxLines: 1,
                          prefixIcon: FaIcon(
                            FontAwesomeIcons.lock,
                            color: AppColors.grey,
                            size: AppSize.s20,
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

                // رابط نسيت كلمة المرور
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: InkWell(
                    onTap: () {
                      CheckCodeRoute().push(context);
                      // للانتقال لشاشة استعادة كلمة المرور
                    },
                    child: BodyTitle(
                      text: tr.forgot_password,
                      color: AppColors.primary,
                      fontSize: AppFontSize.s13,
                      fontWeight: AppFontWeight.semiBold,
                    ),
                  ),
                ),

                // زر تسجيل الدخول الرئيسي
                BlocBuilder<LoginCubit, LoginState>(
                  builder: (context, state) {
                    final cubit = context.read<LoginCubit>();
                    return CustomElevatedButton(
                      height: AppHeight.h50,
                      width: double.infinity,
                      borderRadius: AppRadius.r12,
                      color: AppColors.primary,
                      loading: cubit.isLoading || state is LoginLoadingState,
                      onPressed: () => _onLoginPressed(context),
                      child: BodyTitle(
                        text: tr.login,
                        color: AppColors.white,
                        fontSize: AppFontSize.s16,
                        fontWeight: AppFontWeight.bold,
                      ),
                    );
                  },
                ),

                // رابط الانقال لإنشاء حساب جديد
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: AppWidth.w4,
                  children: [
                    BodyTitle(
                      text: tr.dont_have_account,
                      color: AppColors.greyText,
                      fontSize: AppFontSize.s14,
                    ),
                    InkWell(
                      onTap: () {
                        RegisterRoute().push(context);
                      },
                      child: BodyTitle(
                        text: tr.create_new_account,
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
    );
  }
}