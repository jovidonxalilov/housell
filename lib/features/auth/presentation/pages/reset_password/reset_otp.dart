import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:housell/config/router/routes.dart';
import 'package:housell/config/theme/app_colors.dart';
import 'package:housell/core/extensions/widget_extension.dart';
import 'package:housell/core/widgets/app_text.dart';
import 'package:housell/core/widgets/w__container.dart';
import 'package:housell/core/widgets/w_custom_app_bar.dart';
import 'package:housell/core/widgets/w_text_form.dart';
import 'package:housell/features/auth/presentation/bloc/auth_event.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_status.dart';
import '../../../../../core/dp/dp_injection.dart';
import '../../../../../core/widgets/app_image.dart';
import '../../../../../core/widgets/phone_formatter.dart';
import '../../../../../core/widgets/w_validator.dart';
import '../../../domain/usecase/usecase.dart';
import '../../bloc/auth_bloc.dart';

class ResetOtpPage extends StatefulWidget {
  const ResetOtpPage({super.key});

  @override
  State<ResetOtpPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<ResetOtpPage> {
  final TextEditingController phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final ValueNotifier<bool> _isValidNotifier = ValueNotifier(false);

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
            onTap: () {
              context.pop();
            },
          ),
          title: AppText(text: "Forgot Password"),
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
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            _isValidNotifier.value =
                                _formKey.currentState?.validate() ?? false;
                          });
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            AppText(
                              text: "Recover Your Account",
                              fontSize: 24,
                              fontWeight: 700,
                              color: AppColors.darkest,
                            ),
                            SizedBox(height: 12.h),
                            AppText(
                              text: "Enter your phone number to start reset.",
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
                                return SimpleValidators.phone(value);
                              },
                              controller: phoneController,
                              hintText: "Enter phone number",
                              autoPrefix998: true,
                              prefixImage: AppAssets.uzbI,
                            ),
                            SizedBox(height: 50.h),
                          ],
                        ),
                      ).paddingOnly(top: 48, left: 24, right: 24),
                    ),
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    padding: EdgeInsets.only(
                      left: 24,
                      right: 24,
                      bottom: MediaQuery.of(context).viewInsets.bottom > 0
                          ? MediaQuery.of(context).viewInsets.bottom + 16
                          : 30,
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
                                  AuthResetSendOtpEvent(
                                    phoneNumber: phoneToSend,
                                    onSuccess: () {
                                      print("🎉 UI: Success callback");
                                      context.push(
                                        Routes.resetOtpVerify,
                                        extra: {"phone": phoneToSend},
                                      );
                                    },
                                    onFailure: () {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text("Raqam topilmadi"),
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
      ),
    );
  }
}
