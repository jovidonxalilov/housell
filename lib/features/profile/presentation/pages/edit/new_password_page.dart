import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:housell/config/theme/app_colors.dart';
import 'package:housell/core/extensions/widget_extension.dart';
import 'package:housell/core/widgets/w_text_form.dart';
import 'package:housell/core/widgets/w_validator.dart';
import 'package:housell/features/auth/domain/entities/reset_password.dart';
import 'package:housell/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:housell/features/profile/presentation/bloc/profile_event.dart';
import 'package:housell/features/profile/presentation/bloc/profile_state.dart';
import '../../../../../config/router/routes.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_status.dart';
import '../../../../../core/dp/dp_injection.dart';
import '../../../../../core/widgets/app_image.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/w__container.dart';
import '../../../../../core/widgets/w_custom_app_bar.dart';
import '../../../domain/usecase/profile_usecase.dart';

class NewPasswordPage extends StatefulWidget {
  const NewPasswordPage({super.key, required this.id});

  final String id;

  @override
  State<NewPasswordPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<NewPasswordPage> {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

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
      create: (context) => ProfileBloc(
        getIt<ProfileGetUsecase>(),
        getIt<ProfilePatchUsecase>(),
        getIt<ProfilePhotoUrlUsecase>(),
        getIt<ProfileNewPhoneOtpUsecase>(),
        getIt<ProfileNewPhoneVerifyOtpUsecase>(),
        getIt<ProfileNewPasswordUsecase>(),
          getIt<ProfileGetMyHousesUsecase>()
      ),
      child: Scaffold(
        backgroundColor: AppColors.backgroundP,
        appBar: WCustomAppBar(
          leading: AppImage(
            path: AppAssets.arrowChevronLeft,
            onTap: () {
              context.pop();
            },
          ),
          title: AppText(
            text: "Forgot Password",
            fontSize: 18,
            fontWeight: 400,
            color: AppColors.lightIcon,
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            final isLoading = state.mainStatus == MainStatus.loading;
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
                              text: "Change Password",
                              fontSize: 24,
                              fontWeight: 700,
                              color: AppColors.darkest,
                            ),
                            SizedBox(height: 12.h),
                            AppText(
                              text:
                                  "Keep your account safe with a new secure password.",
                              fontSize: 16,
                              fontWeight: 400,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              color: AppColors.darkest,
                            ).paddingOnly(left: 20, right: 20),
                            SizedBox(height: 32.h),
                            WTextField(
                              validator: (value) {
                                return SimpleValidators.password(value);
                              },
                              hintText: "Oldingi parolni kiriting",
                              borderRadius: 8,
                              suffixIcon: true,
                              fillColor: AppColors.white,
                              controller: oldPasswordController,
                            ),
                            SizedBox(height: 13.h),
                            WTextField(
                              validator: (value) {
                                return SimpleValidators.password(value);
                              },
                              hintText: "Yangi parolni kiriting",
                              borderRadius: 8,
                              suffixIcon: true,
                              fillColor: AppColors.white,
                              controller: passwordController,
                            ),
                            SizedBox(height: 13.h),
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
                                return null; //
                              },
                              hintText: "Parolni tasqidlang",
                              borderRadius: 8,
                              fillColor: AppColors.white,
                              suffixIcon: true,
                              controller: confirmPasswordController,
                            ),
                            SizedBox(height: 13.h),
                          ],
                        ),
                      ).paddingOnly(left: 16, right: 16, top: 25),
                    ),
                  ),
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
                              if (_formKey.currentState!.validate()) {
                                context.read<ProfileBloc>().add(
                                  ProfileNewPasswordEvent(
                                    newPassword: ResetPassword(
                                      newPassword: passwordController.text,
                                      phoneNumber: oldPasswordController.text,
                                      id: widget.id,
                                    ),
                                    onSuccess: (value) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Password muvaffaqiyatli yangilandi',
                                          ),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                      context.go(Routes.login);
                                    },
                                    onFailure: () {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text("Otp kod xato!"),
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
