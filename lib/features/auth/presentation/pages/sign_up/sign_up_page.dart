import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:housell/config/router/routes.dart';
import 'package:housell/config/theme/app_colors.dart';
import 'package:housell/core/extensions/widget_extension.dart';
import 'package:housell/core/widgets/sing_drop_down.dart';
import 'package:housell/core/widgets/w_text_form.dart';
import 'package:housell/features/auth/data/model/auth_model.dart';
import 'package:housell/features/auth/presentation/bloc/auth_event.dart';
import '../../../../../config/service/local_service.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_status.dart';
import '../../../../../core/dp/dp_injection.dart';
import '../../../../../core/widgets/app_image.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/w__container.dart';
import '../../../../../core/widgets/w_custom_app_bar.dart';
import '../../../../../core/widgets/w_validator.dart';
import '../../../domain/entities/login.dart';
import '../../../domain/usecase/usecase.dart';
import '../../bloc/auth_bloc.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController namedController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final ValueNotifier<String?> statusController = ValueNotifier<String?>(null);

  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> _isValidNotifier = ValueNotifier(false);
  late TextEditingController phoneController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final extra = GoRouterState.of(context).extra as Map? ?? {};
    phoneController = TextEditingController(text: extra["phone"] ?? "");
  }

  @override
  void dispose() {
    namedController.dispose();
    surnameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    statusController.dispose();
    phoneController.dispose();
    _isValidNotifier.dispose();
    super.dispose();
  }

  // Role mapping helper
  String _mapRoleToEnglish(String uzbekRole) {
    switch (uzbekRole) {
      case "Xaridor":
        return "CUSTOMER";
      case "Sotuvchi":
        return "SELLER";
      case "Makler":
        return "BROKER";
      default:
        return "CUSTOMER";
    }
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
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          // Handle error messages
          if (state.loginStatus == MainStatus.failure &&
              state.errorMessage.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.white,
          appBar: WCustomAppBar(
            leading: AppImage(
              path: AppAssets.arrowChevronLeft,
              onTap: () {
                context.pop();
              },
            ),
            title: AppText(text: "Sign up"),
            centerTitle: true,
          ),
          body: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              final isLoading = state.loginStatus == MainStatus.loading;

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
                                text: "Start Your Profile",
                                fontSize: 24,
                                fontWeight: 700,
                                color: AppColors.darkest,
                              ),
                              SizedBox(height: 12.h),
                              AppText(
                                text:
                                    "Enter your name, surname, and a secure password.",
                                fontSize: 16,
                                fontWeight: 400,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                color: AppColors.darkest,
                              ),
                              SizedBox(height: 32.h),

                              // Name field
                              WTextField(
                                hintText: "Name",
                                controller: namedController,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Name is required';
                                  }
                                  if (value.trim().length < 2) {
                                    return 'Name must be at least 2 characters';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 13.h),

                              // Surname field
                              WTextField(
                                hintText: "Surname",
                                controller: surnameController,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Surname is required';
                                  }
                                  if (value.trim().length < 2) {
                                    return 'Surname must be at least 2 characters';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 13.h),

                              // Password field
                              WTextField(
                                validator: (value) {
                                  return SimpleValidators.password(value);
                                },
                                hintText: "Parol kiriting",
                                borderRadius: 8,
                                suffixIcon: true,
                                controller: passwordController,
                              ),
                              SizedBox(height: 13.h),

                              // Confirm password field
                              WTextField(
                                validator: (value) {
                                  String? passwordError =
                                      SimpleValidators.password(value);
                                  if (passwordError != null) {
                                    return passwordError;
                                  }
                                  if (value != passwordController.text) {
                                    return 'Parollar bir xil emas';
                                  }
                                  return null;
                                },
                                hintText: "Parolni qayta kiriting",
                                borderRadius: 8,
                                suffixIcon: true,
                                controller: confirmPasswordController,
                              ),
                              SizedBox(height: 13.h),
                              //
                              // // Role selection
                              // SingleFieldDropdown(
                              //   controller: statusController,
                              //   hintText: "Rolni tanlash",
                              //   options: ["Xaridor", "Sotuvchi", "Makler"],
                              //   validator: (value) {
                              //     if (value == null || value.isEmpty) {
                              //       return 'Rolni tanlang';
                              //     }
                              //     return null;
                              //   },
                              // ),
                            ],
                          ),
                        ).paddingOnly(left: 16, right: 16, top: 25),
                      ),
                    ),

                    // Submit button
                    Container(
                      padding: EdgeInsets.only(
                        left: 24,
                        right: 24,
                        bottom: MediaQuery.of(context).viewInsets.bottom > 0
                            ? 24
                            : 30,
                      ),
                      child: WContainer(
                        isValidNotifier: _isValidNotifier,
                        onTap: isLoading
                            ? null
                            : () {
                                context.read<AuthBloc>().add(
                                  AuthSignUpEvent(
                                    signUp: SignUpModel(
                                      name: namedController.text.trim(),
                                      surname: surnameController.text.trim(),
                                      password: passwordController.text,
                                      phone: phoneController.text,
                                      role: "CUSTOMER",
                                    ),
                                    onSuccess: (accessToken) async {
                                      try {
                                        await getIt<SecureStorageService>()
                                            .saveToken(accessToken);

                                        if (context.mounted) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Muvaffaqiyatli ro\'yxatdan o\'tdingiz va kirdingiz!',
                                              ),
                                              backgroundColor: Colors.green,
                                            ),
                                          );
                                          context.go(Routes.home);
                                        }
                                      } catch (e) {
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Token saqlashda xatolik: $e',
                                              ),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      }
                                    },
                                    onFailure: () {},
                                    onLoginFailure: () {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Ro\'yxatdan o\'tdingiz! Iltimos, qayta kiring.',
                                            ),
                                            backgroundColor: Colors.orange,
                                          ),
                                        );
                                        context.pushReplacement(
                                          Routes.login,
                                          extra: {"phone": phoneController},
                                        );
                                      }
                                    },
                                  ),
                                );
                              },
                        height: 48.h,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (isLoading) ...[
                              SizedBox(
                                width: 20.w,
                                height: 20.h,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              AppText(text: "Yuklanmoqda..."),
                            ] else ...[
                              AppText(text: "Continue"),
                            ],
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
      ),
    );
  }
}
