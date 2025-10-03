import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:housell/core/extensions/widget_extension.dart';
import 'package:housell/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:housell/features/profile/presentation/bloc/profile_event.dart';
import 'package:housell/features/profile/presentation/bloc/profile_state.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:housell/features/auth/domain/entities/otp.dart';
import '../../../../../../config/router/routes.dart';
import '../../../../../../config/theme/app_colors.dart';
import '../../../../../../core/constants/app_assets.dart';
import '../../../../../../core/dp/dp_injection.dart';
import '../../../../../../core/widgets/app_image.dart';
import '../../../../../../core/widgets/app_text.dart';
import '../../../../../../core/widgets/w__container.dart' hide AppText;
import '../../../../../../core/widgets/w_custom_app_bar.dart';
import '../../../domain/entities/new_phone.dart';
import '../../../domain/usecase/profile_usecase.dart';

class NewPhoneVerifyOtpPage extends StatefulWidget {
  const NewPhoneVerifyOtpPage({super.key, required this.id});
  final String id;

  @override
  State<NewPhoneVerifyOtpPage> createState() => _OtpVerifyState();
}

class _OtpVerifyState extends State<NewPhoneVerifyOtpPage> {
  final ValueNotifier<String> passwordNotifier = ValueNotifier('');
  final _formKey = GlobalKey<FormState>();

  final ValueNotifier<bool> _isValidNotifier = ValueNotifier(false);
  final TextEditingController otpController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final extra = GoRouterState.of(context).extra as Map? ?? {};
      phoneController.text = extra["phone"] ?? "";
      _isInitialized = true;
    }
  }

  Timer? _timer;
  int _seconds = 60;
  int _resendCount = 0;
  bool _isTimerRunning = true;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    setState(() {
      _seconds = 60;
      _isTimerRunning = true;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds > 0) {
        setState(() {
          _seconds--;
        });
      } else {
        setState(() {
          _isTimerRunning = false;
        });
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _isValidNotifier.dispose();
    phoneController.dispose();
    otpController.dispose();
    passwordNotifier.dispose();
    _timer?.cancel();
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
          getIt<ProfileNewPasswordUsecase>()
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
          title: AppText(text: "Sign up"),
          centerTitle: true,
        ),
        body: BlocBuilder<ProfileBloc, ProfileState>(
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            AppText(
                              text: "Enter authentication code",
                              fontSize: 24,
                              fontWeight: 700,
                              color: AppColors.darkest,
                            ),
                            SizedBox(height: 12.h),
                            RichText(
                              textAlign: TextAlign.center,
                              maxLines: 3,
                              text: TextSpan(
                                style: TextStyle(
                                  color: AppColors.darkest,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                                children: [
                                  TextSpan(
                                    text:
                                    'Enter the 6-digit that we have sent via the phone number ',
                                    style: TextStyle(
                                      color: AppColors.darkest,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  TextSpan(
                                    text: phoneController.text,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.darkest,
                                      decoration: TextDecoration.none,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 32.h),
                            ValueListenableBuilder(
                              valueListenable: passwordNotifier,
                              builder: (context, password, _) => PinCodeTextField(
                                appContext: context,
                                length: 6,
                                obscureText: false,
                                keyboardType: TextInputType.number,
                                animationType: AnimationType.slide,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return '';
                                  }
                                  if (value.length < 6) {
                                    return 'Kod 6 ta raqamdan iborat bo\'lishi kerak';
                                  }
                                  if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                                    return 'Faqat raqamlar kiriting';
                                  }
                                  return null;
                                },
                                controller: otpController,
                                pinTheme: PinTheme(
                                  shape: PinCodeFieldShape.circle,
                                  borderRadius: BorderRadius.circular(22),
                                  fieldHeight: 44.h,
                                  fieldWidth: 44.w,
                                  activeFillColor: AppColors.grey96,
                                  selectedFillColor: AppColors.white,
                                  inactiveFillColor: AppColors.white,
                                  selectedColor: AppColors.base,
                                  activeColor: AppColors.base,
                                  inactiveColor: AppColors.grey96,
                                  errorBorderColor: AppColors.red,
                                ),
                                animationDuration: Duration(milliseconds: 300),
                                enableActiveFill: true,
                                onChanged: (value) {
                                  passwordNotifier.value = value;
                                },
                                onCompleted: (value) {},
                              ),
                            ),
                            SizedBox(height: 22.h),
                            _isTimerRunning
                                ? Text(
                              "00:${_seconds.toString().padLeft(2, '0')}",
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            )
                                : GestureDetector(
                              onTap: () {
                                if (_resendCount >= 2) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Limitdan oshib ketdi")),
                                  );
                                  return;
                                }

                                final phoneToSend = phoneController.text
                                    .replaceAll(RegExp(r'[^0-9+]'), '');
                                context.read<ProfileBloc>().add(
                                  ProfileNewPhoneOtpEvent(
                                    newPhoneE: NewPhoneE(
                                      id: widget.id,
                                      phoneNumber: phoneToSend,
                                    ),
                                    onSuccess: () {
                                      print("🎉 UI: Success callback");
                                      setState(() {
                                        _resendCount++;
                                      });
                                      _startTimer();
                                    },
                                    onFailure: () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
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
                              },
                              child: AppText(
                                text: "Resend code",
                                fontSize: 16,
                                fontWeight: 500,
                                textAlign: TextAlign.center,
                                color: AppColors.base,
                              ),
                            ),
                            SizedBox(height: 50.h),
                          ],
                        ),
                      ).paddingOnly(right: 26, left: 26, top: 60),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      left: 24,
                      right: 24,
                      bottom: MediaQuery.of(context).viewInsets.bottom > 0 ? 16 : 30,
                    ),
                    child: WContainer(
                      isValidNotifier: _isValidNotifier,
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<ProfileBloc>().add(
                            ProfileNewPhoneVerifyOtpEvent(
                              verifyOtpModel: VerifyOtpModel(
                                otp: otpController.text,
                                phoneNumber: phoneController.text,
                                id: widget.id,
                              ),
                              onSuccess: (value) {
                                // ASOSIY O'ZGARISH: push o'rniga go yoki replace
                                // Variantlar:

                                // 1-variant: Barcha stackni tozalab, faqat Profile qoldirish
                                context.go(Routes.profile);

                                // 2-variant: Faqat joriy sahifani almashtirish
                                // context.pushReplacement(Routes.profile);

                                // 3-variant: Stackdagi barcha OTP sahifalarini olib tashlash
                                // while (context.canPop()) {
                                //   context.pop();
                                // }
                                // context.pushReplacement(Routes.profile);
                              },
                              onFailure: () {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Otp kod xato!"),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                            ),
                          );
                        }
                      },
                      height: 48.h,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [AppText(text: "Continue")],
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