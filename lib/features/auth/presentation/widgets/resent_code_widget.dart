import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/router/routes.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../core/widgets/app_text.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';

class ResentCodeWidget extends StatefulWidget {
  final TextEditingController phoneController;
  const ResentCodeWidget({super.key, required this.phoneController});

  @override
  State<ResentCodeWidget> createState() => _ResentCodeWidgetState();
}

class _ResentCodeWidgetState extends State<ResentCodeWidget> {

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
    _timer?.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return _isTimerRunning
        ? Text(
      "00:${_seconds.toString().padLeft(2, '0')}",
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    )
        : GestureDetector(
      onTap: () {
        final phoneToSend = widget.phoneController.text
            .replaceAll(RegExp(r'[^0-9+]'), '');
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
        if (_resendCount < 2) {
          setState(() {
            _resendCount++;
          });
          _startTimer();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Limitdan oshib ketdi")),
          );
        }
      },
      child: AppText(
        text: "Resend code",
        fontSize: 16,
        fontWeight: 500,
        textAlign: TextAlign.center,
        color: AppColors.base,
      ),
    );
  }
}
