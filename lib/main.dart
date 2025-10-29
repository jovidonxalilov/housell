import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:housell/config/router/router.dart';
import 'core/dp/dp_injection.dart';
import 'core/extensions/num_extensions.dart';
import 'core/widgets/w_langue_selector.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Global System UI sozlamalari
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent, // ✅ Transparent qoldiramiz
      statusBarIconBrightness: Brightness.dark, // ✅ Dark qilamiz (qora iconlar)
      statusBarBrightness: Brightness.light, // ✅ iOS uchun
    ),
  );

  // System UI mode - 3 ta tugma ko'rinishi uchun
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
    overlays: SystemUiOverlay.values,
  );

  // Preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await EasyLocalization.ensureInitialized();

  // ✅ Saqlangan tilni yuklash
  final savedLanguage = await LanguageService.getLanguage();

  await setupDependencies();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('uz'), Locale('ru'), Locale('en')],
      path: 'assets/localization',
      fallbackLocale: const Locale('uz'),
      startLocale: Locale(savedLanguage), // ✅ Saqlangan til
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SizeUtilsExtension.instance.init(context);

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Housell',
        routerConfig: router,

        // Global builder
        builder: (context, child) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark, // ✅ Dark qilamiz
              statusBarBrightness: Brightness.light, // ✅ iOS uchun
              systemNavigationBarColor: Colors.white,
              systemNavigationBarDividerColor: Colors.transparent,
              systemNavigationBarIconBrightness: Brightness.dark, // ✅ Dark qilamiz
            ),
            child: child ?? Container(),
          );
        },

        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
      ),
    );
  }
}

// Alohida sahifada boshqacha sozlash uchun
// class CustomPageWrapper extends StatelessWidget {
//   final Widget child;
//   final SystemUiOverlayStyle? systemOverlayStyle;
//
//   const CustomPageWrapper({
//     Key? key,
//     required this.child,
//     this.systemOverlayStyle,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     // final themeProvider = Provider.of<ThemeProvider>(context);
//     // final isDark = themeProvider.isDarkMode;
//
//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: systemOverlayStyle ?? SystemUiOverlayStyle(
//         statusBarColor: Colors.transparent,
//         statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
//         systemNavigationBarColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
//         systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
//       ),
//       child: child,
//     );
//   }
// }

// Utility class - kerak bo'lganda ishlatish uchun
// class SystemUIManager {
//   // Normal holat - 3 ta tugma bilan
//   static void setNormalMode() {
//     SystemChrome.setEnabledSystemUIMode(
//       SystemUiMode.manual,
//       overlays: [
//         SystemUiOverlay.top, // Status bar
//         SystemUiOverlay.bottom, // Navigation bar
//       ],
//     );
//   }
//
//   // Fullscreen mode (video uchun)
//   static void setFullscreenMode() {
//     SystemChrome.setEnabledSystemUIMode(
//       SystemUiMode.immersiveSticky,
//     );
//   }
//
//   // Qorong'u tema uchun
//   static void setDarkTheme() {
//     SystemChrome.setSystemUIOverlayStyle(
//       const SystemUiOverlayStyle(
//         statusBarColor: Colors.transparent,
//         statusBarIconBrightness: Brightness.light,
//         statusBarBrightness: Brightness.dark,
//         systemNavigationBarColor: Color(0xFF1A1A1A),
//         systemNavigationBarIconBrightness: Brightness.light,
//       ),
//     );
//   }
//
//   // Och tema uchun
//   static void setLightTheme() {
//     SystemChrome.setSystemUIOverlayStyle(
//       const SystemUiOverlayStyle(
//         statusBarColor: Colors.transparent,
//         statusBarIconBrightness: Brightness.dark,
//         statusBarBrightness: Brightness.light,
//         systemNavigationBarColor: Colors.white,
//         systemNavigationBarIconBrightness: Brightness.dark,
//       ),
//     );
//   }
// }