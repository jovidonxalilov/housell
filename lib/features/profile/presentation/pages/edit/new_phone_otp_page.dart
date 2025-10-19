import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:housell/config/theme/app_colors.dart';
import 'package:housell/core/constants/app_status.dart';
import 'package:housell/core/extensions/widget_extension.dart';
import 'package:housell/core/widgets/app_image.dart';
import 'package:housell/core/widgets/app_text.dart';
import 'package:housell/core/widgets/w__container.dart';
import 'package:housell/core/widgets/w_custom_app_bar.dart';
import 'package:housell/core/widgets/w_text_form.dart';
import 'package:housell/features/profile/domain/entities/new_phone.dart';
import 'package:housell/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:housell/features/profile/presentation/bloc/profile_event.dart';
import 'package:housell/features/profile/presentation/bloc/profile_state.dart';

import '../../../../../../core/constants/app_assets.dart';
import '../../../../../../core/dp/dp_injection.dart';
import '../../../../../../core/widgets/phone_formatter.dart';
import '../../../../../../core/widgets/w_validator.dart';
import '../../../domain/usecase/profile_usecase.dart';

class NewPhoneOtpPage extends StatefulWidget {
  const NewPhoneOtpPage({super.key, required this.id});

  final String id;

  @override
  State<NewPhoneOtpPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<NewPhoneOtpPage> {
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
        backgroundColor: AppColors.white,
        appBar: WCustomAppBar(
          leading: AppImage(
            path: AppAssets.chevronLeft,
            onTap: () => context.pop(),
          ),
          title: AppText(text: "Change Number"),
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
                              text: "New Number",
                              fontSize: 24,
                              fontWeight: 700,
                              color: AppColors.darkest,
                            ),
                            SizedBox(height: 12.h),
                            AppText(
                              text:
                                  "AppTextEnter your new phone number to keep your account verified and secure.",
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

                                context.read<ProfileBloc>().add(
                                  ProfileNewPhoneOtpEvent(
                                    newPhoneE: NewPhoneE(
                                      id: widget.id,
                                      phoneNumber: phoneToSend,
                                    ),
                                    onSuccess: () {
                                      print("🎉 UI: Success callback");
                                      context.push(
                                        '/new_phone_verify_otp_page/${widget.id}',
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
      ),
    );
  }
}
