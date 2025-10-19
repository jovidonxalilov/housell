import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:housell/config/router/routes.dart';
import 'package:housell/config/theme/app_colors.dart';
import 'package:housell/core/constants/app_assets.dart';
import 'package:housell/core/extensions/widget_extension.dart';
import 'package:housell/core/widgets/app_text.dart';
import 'package:housell/core/widgets/w__container.dart';
import 'package:housell/core/widgets/w_custom_app_bar.dart';
import 'package:housell/core/widgets/w_text_form.dart';
import 'package:housell/core/widgets/w_validator.dart';
import 'package:housell/features/auth/domain/usecase/usecase.dart';
import 'package:housell/features/auth/presentation/bloc/auth_bloc.dart';
import '../../../../../config/service/local_service.dart';
import '../../../../../core/constants/app_status.dart';
import '../../../../../core/dp/dp_injection.dart';
import '../../../../../core/widgets/app_image.dart';
import '../../../domain/entities/login.dart';
import '../../bloc/auth_event.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
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
        backgroundColor: AppColors.backgroundP,
        appBar: WCustomAppBar(
          backgroundColor: AppColors.backgroundP,
          title: Center(
            child: AppText(
              text: "Login",
              fontWeight: 400,
              fontSize: 18,
              color: AppColors.blackT,
            ),
          ),
          centerTitle: true,
          leading: AppImage(
            path: AppAssets.arrowChevronLeft,
            onTap: () => context.pop(),
            size: 24,
          ),
          showLeadingAutomatically: true,
        ),
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
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
                              text: "Welcome Back",
                              fontSize: 24,
                              fontWeight: 700,
                              color: AppColors.darkest,
                            ),
                            SizedBox(height: 12.h),
                            AppText(
                              text:
                                  "Log in with your phone number and password",
                              fontSize: 16,
                              fontWeight: 400,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              color: AppColors.darkest,
                            ),
                            SizedBox(height: 32.h),
                            WTextField(
                              validator: (value) {
                                return Validators.phone(value);
                              },
                              // inputFormatters: [
                              //   PhoneFormatter(),
                              //   LengthLimitingTextInputFormatter(17), // +998 88 844 80 80 = 17 ta belgi
                              // ],
                              controller: phoneController,
                              hintText: "Enter phone number",
                              autoPrefix998: true,
                              fillColor: AppColors.backgroundP,
                              borderNoFocusColor: AppColors.lightSky,
                              prefixImage: AppAssets.uzbI,
                              // borderColor: AppColors.lightSky,
                            ),
                            SizedBox(height: 16.h),
                            WTextField(
                              validator: (value) {
                                return SimpleValidators.password(value);
                              },
                              controller: passwordController,
                              borderNoFocusColor: AppColors.lightSky,
                              fillColor: AppColors.backgroundP,
                              hintText: "Enter password",
                              suffixIcon: true,
                            ),

                            SizedBox(height: 16.h),
                            Row(
                              children: [
                                Spacer(),
                                AppText(
                                  onTap: () {
                                    context.push(Routes.resetOtp);
                                  },
                                  text: "Forgot password?",
                                  color: AppColors.base,
                                  fontSize: 16,
                                  fontWeight: 400,
                                ),
                              ],
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
                          : 16,
                    ),
                    child: WContainer(
                      isValidNotifier: _isValidNotifier,
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<AuthBloc>().add(
                            AuthLoginEvent(
                              authLogin: LoginModel(
                                login: phoneController.text.trim(),
                                password: passwordController.text.trim(),
                              ),
                              onSuccess: (value) {
                                getIt<SecureStorageService>().saveToken(value);
                                context.go(Routes.home);
                              },
                              onFailure: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Login yoki parol xato!"),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              },
                            ),
                          );
                        }
                      },
                      height: 48.h,
                      child: state.loginStatus == MainStatus.loading
                          ? Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.white,
                                  ),
                                ),
                              ),
                            )
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [AppText(text: "Continue", )],
                            ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        // Sign up text bottomNavigationBar da
        bottomNavigationBar: Container(
          padding: EdgeInsets.only(bottom: 24, top: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppText(
                text: "Don't have an account? ",
                color: AppColors.darker,
                fontSize: 16,
                fontWeight: 400,
              ),
              AppText(
                onTap: () {
                  if (Navigator.of(context).canPop()) {
                    context.pop();
                  } else {
                    context.push('/otp');
                  }
                },
                text: "Sign up now",
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
