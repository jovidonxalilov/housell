import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:housell/config/router/router.dart';
// import 'package:yandex_mapkit/yandex_mapkit.dart';

import 'core/dp/dp_injection.dart';
import 'core/extensions/num_extensions.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Global System UI sozlamalari - 3 ta tugma ko'rinishi uchun
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      // Navigation bar sozlamalari - 3 ta tugma uchun
      systemNavigationBarColor: Colors.white, // Oq fon
      systemNavigationBarDividerColor: Colors.grey, // Yuqori chiziq
      systemNavigationBarIconBrightness: Brightness.dark, // Qora iconlar

      // Status bar sozlamalari
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  // AndroidYandexMap.useAndroidViewSurface = false;

  // System UI mode - 3 ta tugma ko'rinishi uchun
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [
      SystemUiOverlay.top,    // Status bar
      SystemUiOverlay.bottom, // Navigation bar (3 ta tugma)
    ],
  );

  // Preferred orientations (ixtiyoriy)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // AndroidYandexMap.useAndroidViewSurface = false;

  await EasyLocalization.ensureInitialized();
  await setupDependencies();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('uz'), Locale('ru'), Locale('en')],
      path: 'lib/core/l10/localization',
      fallbackLocale: const Locale('uz'),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SizeUtilsExtension.instance.init(context);
    return ScreenUtilInit(
      designSize: Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),

          // Global AppBar theme - barcha AppBar'larga tasir qiladi
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.light,
              systemNavigationBarColor: Colors.transparent,
              systemNavigationBarIconBrightness: Brightness.dark,
            ),
          ),

          // Global Scaffold theme
          scaffoldBackgroundColor: Colors.white,

          // Bottom navigation bar theme (agar ishlatayotgan bo'lsangiz)
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Colors.white,
            elevation: 0,
          ),
        ),
        routerConfig: router,

        // Global builder - barcha sahifalarga wrappe qiladi
        builder: (context, child) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.light,
              systemNavigationBarColor: Colors.white, // 3 ta tugma uchun oq fon
              systemNavigationBarDividerColor: Colors.transparent,
              systemNavigationBarIconBrightness: Brightness.dark,
            ),
            child: child ?? Container(),
          );
        },
      ),
    );
  }
}

// Agar alohida sahifada boshqacha sozlash kerak bo'lsa
class CustomPageWrapper extends StatelessWidget {
  final Widget child;
  final SystemUiOverlayStyle? systemOverlayStyle;

  const CustomPageWrapper({
    Key? key,
    required this.child,
    this.systemOverlayStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemOverlayStyle ?? const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: child,
    );
  }
}

// Utility class - kerak bo'lganda ishlatish uchun
class SystemUIManager {
  // Normal holat - 3 ta tugma bilan
  static void setNormalMode() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [
        SystemUiOverlay.top,    // Status bar
        SystemUiOverlay.bottom, // Navigation bar
      ],
    );
  }

  // Fullscreen mode (video uchun)
  static void setFullscreenMode() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
    );
  }

  // Qorong'u tema uchun
  static void setDarkTheme() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
  }

  // Och tema uchun
  static void setLightTheme() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }
}

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   SystemChrome.setSystemUIOverlayStyle(
//     const SystemUiOverlayStyle(
//       systemNavigationBarColor: Colors.white, // Pastki tugmalar foni
//       systemNavigationBarIconBrightness:
//       Brightness.dark, // Icon ranglari (qora)
//       statusBarColor: Colors.transparent, // Yuqoridagi status bar fon
//       statusBarIconBrightness: Brightness.dark, // Status bar icon ranglari
//     ),
//   );
//   AndroidYandexMap.useAndroidViewSurface = false;
//   await EasyLocalization.ensureInitialized();
//   await setupDependencies();
//   runApp(
//     EasyLocalization(
//       supportedLocales: const [Locale('uz'), Locale('ru'), Locale('en')],
//       path: 'lib/core/l10/localization',
//       fallbackLocale: const Locale('uz'),
//       child: MyApp(),
//     ),
//   );
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     SizeUtilsExtension.instance.init(context);
//     return ScreenUtilInit(
//       designSize: Size(375, 812),
//       minTextAdapt: true,
//       splitScreenMode: true,
//       child: MaterialApp.router(
//         debugShowCheckedModeBanner: false,
//         title: 'Flutter Demo',
//         theme: ThemeData(
//           colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//           appBarTheme: const AppBarTheme(
//             systemOverlayStyle: SystemUiOverlayStyle(
//               systemNavigationBarColor: Colors.white,
//               systemNavigationBarIconBrightness: Brightness.dark,
//             ),
//           ),
//         ),
//         routerConfig: router,
//       ),
//     );
//   }
// }