import 'dart:async';

// ignore: unused_import
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:housell/core/extensions/widget_extension.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:housell/features/auth/domain/entities/otp.dart';
import 'package:housell/features/auth/presentation/bloc/auth_event.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../config/router/routes.dart';
import '../../../../../config/theme/app_colors.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/dp/dp_injection.dart';
import '../../../../../core/widgets/app_image.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/w__container.dart';
import '../../../../../core/widgets/w_custom_app_bar.dart';
import '../../../domain/usecase/usecase.dart';
import '../../bloc/auth_bloc.dart';

class OtpVerify extends StatefulWidget {
  const OtpVerify({super.key});

  @override
  State<OtpVerify> createState() => _OtpVerifyState();
}

class _OtpVerifyState extends State<OtpVerify> {
  final ValueNotifier<String> passwordNotifier = ValueNotifier('');
  final _formKey = GlobalKey<FormState>();

  final ValueNotifier<bool> _isValidNotifier = ValueNotifier(false);
  final TextEditingController otpController = TextEditingController();
  late TextEditingController phoneController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final extra = GoRouterState.of(context).extra as Map? ?? {};
    phoneController = TextEditingController(text: extra["phone"] ?? "");
  }

  Timer? _timer;
  int _seconds = 60;
  int _resendCount = 0;
  bool _isTimerRunning = true;
  bool _isBlocked = false;
  DateTime? _blockEndTime;

  @override
  void initState() {
    super.initState();
    _checkBlockStatus();
    _startTimer();
  }

  // Block statusni tekshirish
  Future<void> _checkBlockStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final phoneNumber = phoneController.text;

    final blockEndTimeStr = prefs.getString('block_end_time_$phoneNumber');
    final resendCount = prefs.getInt('resend_count_$phoneNumber') ?? 0;

    if (blockEndTimeStr != null) {
      final blockEndTime = DateTime.parse(blockEndTimeStr);
      final now = DateTime.now();

      if (now.isBefore(blockEndTime)) {
        // Hali block vaqti tugamagan
        setState(() {
          _isBlocked = true;
          _blockEndTime = blockEndTime;
          _resendCount = resendCount;
        });
        _startBlockTimer();
      } else {
        // Block vaqti tugagan, tozalash
        await _clearBlockData();
      }
    } else {
      setState(() {
        _resendCount = resendCount;
      });
    }
  }

  // Block timerni boshlash
  void _startBlockTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_blockEndTime != null) {
        final now = DateTime.now();
        if (now.isBefore(_blockEndTime!)) {
          setState(() {
            _seconds = _blockEndTime!.difference(now).inSeconds;
          });
        } else {
          _clearBlockData();
          timer.cancel();
        }
      }
    });
  }

  // Block ma'lumotlarini tozalash
  Future<void> _clearBlockData() async {
    final prefs = await SharedPreferences.getInstance();
    final phoneNumber = phoneController.text;

    await prefs.remove('block_end_time_$phoneNumber');
    await prefs.remove('resend_count_$phoneNumber');

    setState(() {
      _isBlocked = false;
      _resendCount = 0;
      _blockEndTime = null;
    });
  }

  // Resend countni saqlash
  Future<void> _saveResendCount() async {
    final prefs = await SharedPreferences.getInstance();
    final phoneNumber = phoneController.text;
    await prefs.setInt('resend_count_$phoneNumber', _resendCount);
  }

  // Block qilish
  Future<void> _blockUser() async {
    final prefs = await SharedPreferences.getInstance();
    final phoneNumber = phoneController.text;
    final blockEndTime = DateTime.now().add(const Duration(hours: 1));

    await prefs.setString('block_end_time_$phoneNumber', blockEndTime.toIso8601String());
    await prefs.setInt('resend_count_$phoneNumber', _resendCount);

    setState(() {
      _isBlocked = true;
      _blockEndTime = blockEndTime;
    });

    _startBlockTimer();
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

  // Qolgan vaqtni formatlash
  String _getBlockTimeRemaining() {
    if (_blockEndTime == null) return '';

    final now = DateTime.now();
    final difference = _blockEndTime!.difference(now);

    if (difference.inMinutes > 0) {
      return '${difference.inMinutes} daqiqa';
    } else {
      return '${difference.inSeconds} soniya';
    }
  }

  @override
  void dispose() {
    _isValidNotifier.dispose();
    phoneController.dispose();
    _timer?.cancel();
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
                                  selectedColor: AppColors.primary,
                                  activeColor: AppColors.primary,
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

                            // Timer yoki Resend button
                            _isBlocked
                                ? Column(
                              children: [
                                Icon(
                                  Icons.block,
                                  color: AppColors.red,
                                  size: 32,
                                ),
                                SizedBox(height: 8.h),
                                AppText(
                                  text: "Limitdan oshib ketdi",
                                  fontSize: 16,
                                  fontWeight: 600,
                                  color: AppColors.red,
                                ),
                                SizedBox(height: 4.h),
                                AppText(
                                  text: "${_getBlockTimeRemaining()} dan keyin qayta urinib ko'ring",
                                  fontSize: 14,
                                  fontWeight: 400,
                                  color: AppColors.darkest,
                                ),
                              ],
                            )
                                : _isTimerRunning
                                ? Text(
                              "00:${_seconds.toString().padLeft(2, '0')}",
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            )
                                : GestureDetector(
                              onTap: () {
                                // Avval limit tekshirish
                                if (_resendCount >= 2) {
                                  _blockUser();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          "Limitdan oshib ketdi. 1 soatdan keyin qayta urinib ko'ring"),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }

                                // Limit ichida bo'lsa davom etadi
                                final phoneToSend = phoneController.text
                                    .replaceAll(RegExp(r'[^0-9+]'), '');

                                context.read<AuthBloc>().add(
                                  AuthSendOtpEvent(
                                    phoneNumber: phoneToSend,
                                    onSuccess: () {
                                      print("🎉 UI: Success callback");

                                      setState(() {
                                        _resendCount++;
                                      });

                                      _saveResendCount();

                                      // OTP inputni tozalash
                                      otpController.clear();

                                      // Timerni qayta boshlash
                                      _startTimer();
                                    },
                                    onFailure: () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text("Raqam topilmadi"),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                              child: AppText(
                                text: "Resend code ($_resendCount/3)",
                                fontSize: 16,
                                fontWeight: 500,
                                textAlign: TextAlign.center,
                                color: AppColors.primary,
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
                          context.read<AuthBloc>().add(
                            AuthVerifyOtpEvent(
                              verifyOtpModel: VerifyOtpModel(
                                otp: otpController.text,
                                phoneNumber: phoneController.text,
                              ),
                              onSuccess: (value) {
                                // Success bo'lsa block ma'lumotlarini tozalash
                                _clearBlockData();

                                context.push(
                                  Routes.signUp,
                                  extra: {
                                    "phone": phoneController.text,
                                  },
                                );
                              },
                              onFailure: () {
                                ScaffoldMessenger.of(context).showSnackBar(
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
