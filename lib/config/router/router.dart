import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:housell/config/router/main_scaffold.dart';
import 'package:housell/config/router/routes.dart';
import 'package:housell/core/dp/dp_injection.dart';
import 'package:housell/features/add/domain/usecase/add_usecase.dart';
import 'package:housell/features/add/presentation/bloc/add_bloc.dart';
import 'package:housell/features/add/presentation/pages/add_page.dart';
import 'package:housell/features/auth/presentation/pages/login/login_page.dart';
import 'package:housell/features/auth/presentation/pages/reset_password/reset_otp.dart';
import 'package:housell/features/auth/presentation/pages/reset_password/reset_otp_verify.dart';
import 'package:housell/features/auth/presentation/pages/reset_password/reset_password.dart';
import 'package:housell/features/auth/presentation/pages/sign_up/otp_page.dart';
import 'package:housell/features/auth/presentation/pages/sign_up/otp_verify.dart';
import 'package:housell/features/auth/presentation/pages/sign_up/sign_up_page.dart';
import 'package:housell/features/auth/presentation/pages/splash/splash_page.dart';
import 'package:housell/features/home/presentation/pages/home_page.dart';
import 'package:housell/features/home/presentation/pages/property_page.dart';
import 'package:housell/features/map/presentation/pages/map_page.dart';
import 'package:housell/features/message/presentation/pages/message_page.dart';
import 'package:housell/features/profile/presentation/pages/edit/edit_phone_page.dart';
import 'package:housell/features/profile/presentation/pages/edit/edit_profile_page.dart';
import 'package:housell/features/profile/presentation/pages/edit/new_phone_otp_page.dart';
import 'package:housell/features/profile/presentation/pages/edit/new_phone_verify_otp_page.dart';
import 'package:housell/features/profile/presentation/pages/profile_page.dart';
import 'package:housell/features/profile/presentation/pages/settings/settings_page.dart';

import '../../features/profile/presentation/pages/edit/new_password_page.dart';

final GoRouter router = GoRouter(
  initialLocation: Routes.home,
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return MainScaffold(child: child);
      },
      routes: [
        GoRoute(
          path: Routes.home,
          builder: (context, state) => PropertyGridScreen(),
        ),
        // GoRoute(path: Routes.map, builder: (context, state) => MapPage()),
        GoRoute(
          path: Routes.add,
          builder: (context, state) => BlocProvider(
            create: (context) => AddHouseBloc(
              getIt<AddHouseUsecase>(),
              getIt<AddPhotosUrlUsecase>(),
            ),
            child: AddPage(),
          ),
        ),
        GoRoute(
          path: Routes.message,
          builder: (context, state) => MessagePage(),
        ),
        GoRoute(
          path: Routes.profile,
          builder: (context, state) => ProfilePage(),
        ),
      ],
    ),
    GoRoute(path: Routes.otp, builder: (context, state) => OtpPage()),
    GoRoute(path: Routes.otpVerify, builder: (context, state) => OtpVerify()),
    GoRoute(path: Routes.splash, builder: (context, state) => SplashScreen()),
    GoRoute(
      path: Routes.newPhoneOtpPage,
      pageBuilder: (context, state) {
        final id = state.pathParameters['userId']!;
        return MaterialPage(
          key: ValueKey('newPhoneOtpPage-$id'),
          child: NewPhoneOtpPage(id: id),
        );
      },
    ),
    GoRoute(
      path: Routes.newPhoneVerifyOtpPage,
      pageBuilder: (context, state) {
        final id = state.pathParameters['userId']!;
        return MaterialPage(
          key: ValueKey('newPhoneVerifyOtpPage-$id'),
          child: NewPhoneVerifyOtpPage(id: id),
        );
      },
    ),
    GoRoute(
      path: Routes.newPassword,
      builder: (context, state) {
        final id = state.pathParameters['userId']!;
        return NewPasswordPage(id: id,);
      },
    ),
    GoRoute(
      path: Routes.editPhonePage,
      builder: (context, state) {
        final id = state.pathParameters['userId']!; // ✅ to‘g‘ri
        return EditPhonePage(id: id);
      },
    ),
    GoRoute(
      path: '/property_detail/:propertyId',
      builder: (context, state) {
        final id = state.pathParameters['propertyId']!; // ✅ to‘g‘ri
        return DetailPage(id: id);
      },
    ),

    GoRoute(path: Routes.signUp, builder: (context, state) => SignUpPage()),
    GoRoute(path: Routes.resetOtp, builder: (context, state) => ResetOtpPage()),
    GoRoute(path: Routes.settings, builder: (context, state) => SettingsPage()),
    GoRoute(
      path: "/edit_profile/:userId",
      builder: (context, state) {
        final id = state.pathParameters['userId']!;
        return EditProfilePage(id: id);
      },
    ),
    GoRoute(
      path: Routes.resetOtpVerify,
      builder: (context, state) => ResetOtpVerify(),
    ),
    GoRoute(
      path: Routes.resetPassword,
      builder: (context, state) => ResetPasswordPage(),
    ),
    GoRoute(path: Routes.login, builder: (context, state) => LoginPage()),
  ],
);
