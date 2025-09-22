import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:housell/config/router/routes.dart';
import 'package:housell/config/theme/app_colors.dart';
import 'package:housell/core/constants/app_status.dart';
import 'package:housell/core/extensions/widget_extension.dart';
import 'package:housell/core/widgets/app_image.dart';
import 'package:housell/core/widgets/app_text.dart';
import 'package:housell/core/widgets/w__container.dart';
import 'package:housell/core/widgets/w_custom_app_bar.dart';
import 'package:housell/core/widgets/w_text_form.dart';
import 'package:housell/features/auth/presentation/bloc/auth_event.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/dp/dp_injection.dart';
import '../../../../../core/widgets/phone_formatter.dart';
import '../../../../../core/widgets/w_validator.dart';
import '../../../domain/usecase/usecase.dart';
import '../../bloc/auth_bloc.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<OtpPage> {
  final TextEditingController phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> _isValidNotifier = ValueNotifier(false);

  String? _serverError;

  @override
  void dispose() {
    _isValidNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(
        getIt<AuthLoginUsecase>(),
        getIt<AuthSentOtpUsecase>(),
        getIt<AuthVerifyOtpUsecase>(),
        getIt<AuthSignUpUsecase>(),
        getIt<AuthResetVerifyOtpUsecase>(),
        getIt<AuthResetPasswordUsecase>(),
        getIt<AuthResetSendOtpUsecase>(),
      ),
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: WCustomAppBar(
          leading: AppImage(
            path: AppAssets.arrowChevronLeft,
            onTap: () => context.pop(),
          ),
          title: AppText(text: "Sign up"),
          centerTitle: true,
        ),
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final isLoading = state.otpStatus == MainStatus.loading;
            return SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onChanged: () {
                          if (_serverError != null) {
                            setState(() => _serverError = null);
                          }
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            _isValidNotifier.value =
                                _formKey.currentState?.validate() ?? false;
                          });
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            AppText(
                              text: "Add Your Phone Number",
                              fontSize: 24,
                              fontWeight: 700,
                              color: AppColors.darkest,
                            ),
                            SizedBox(height: 12.h),
                            AppText(
                              text: "Your number helps us verify your account.",
                              fontSize: 16,
                              fontWeight: 400,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              color: AppColors.darkest,
                            ),
                            SizedBox(height: 32.h),
                            WTextField(
                              inputFormatters: [
                                PhoneFormatter(),
                                LengthLimitingTextInputFormatter(17),
                              ],
                              validator: (value) {
                                final local = Validators.phone(value);
                                if (local != null) return local;
                                if (_serverError != null) return _serverError;
                                return null;
                              },
                              controller: phoneController,
                              hintText: "Enter phone number",
                              autoPrefix998: true,
                              prefixImage: AppAssets.uzbI,
                              // Agar WTextField’da onChanged bo‘lsa, qo‘shimcha:
                              // onChanged: (_) { if (_serverError != null) setState(() => _serverError = null); },
                            ),

                            SizedBox(height: 16.h),
                            AppText(
                              text:
                                  "You will receive an SMS verification that may apply message and data rates.",
                              maxLines: 3,
                              textAlign: TextAlign.start,
                              color: AppColors.light,
                              fontSize: 12,
                              fontWeight: 400,
                            ),
                            SizedBox(height: 50.h),
                          ],
                        ).paddingOnly(top: 48, left: 24, right: 24),
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.only(
                      left: 24,
                      right: 24,
                      bottom: MediaQuery.of(context).viewInsets.bottom > 0
                          ? MediaQuery.of(context).viewInsets.bottom + 16
                          : 16,
                    ),
                    child: WContainer(
                      isValidNotifier: _isValidNotifier,
                      onTap: isLoading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                final phoneToSend = phoneController.text
                                    .replaceAll(RegExp(r'[^0-9+]'), '');

                                print(
                                  "🎯 UI: OTP jo'natish boshlandi: $phoneToSend",
                                );

                                context.read<AuthBloc>().add(
                                  AuthSendOtpEvent(
                                    phoneNumber: phoneToSend,
                                    onSuccess: () {
                                      print("🎉 UI: Success callback");
                                      context.push(
                                        Routes.otpVerify,
                                        extra: {"phone": phoneToSend},
                                      );
                                    },
                                    onFailure: () {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "Bunday raqam bilan ro'yxatdan o'tilgan!",
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }
                            },
                      height: 48.h,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (isLoading)
                            const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          else
                            AppText(text: "Continue"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),

        bottomNavigationBar: Container(
          padding: const EdgeInsets.only(bottom: 24, top: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppText(
                text: "Have an account? ",
                color: AppColors.darker,
                fontSize: 16,
                fontWeight: 400,
              ),
              AppText(
                onTap: () => context.push(Routes.login),
                text: "Log in",
                color: AppColors.base,
                fontSize: 16,
                fontWeight: 500,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
