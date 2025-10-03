import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  static const String _themeKey = 'isDarkMode';

  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadTheme();
  }

  // Saved theme ni yuklash
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(_themeKey) ?? false;
    notifyListeners();
    _updateSystemUI();
  }

  // Theme ni o'zgartirish
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, _isDarkMode);
    notifyListeners();
    _updateSystemUI();
  }

  // System UI ni yangilash
  void _updateSystemUI() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        // Status bar fon rangi (shaffof)
        statusBarIconBrightness: _isDarkMode
            ? Brightness.light
            : Brightness.dark,
        // Status bar ikonkalar rangi
        statusBarBrightness: _isDarkMode ? Brightness.dark : Brightness.light,
        // iOS uchun status bar yorqinligi
        systemNavigationBarColor: _isDarkMode
            ? const Color(0xFF1A1A1A)
            : Colors.white,
        // Pastki navigatsiya paneli fon rangi
        systemNavigationBarDividerColor: Colors.transparent,
        // Navigatsiya paneli bo'luvchisi rangi
        systemNavigationBarIconBrightness: _isDarkMode
            ? Brightness.light
            : Brightness.dark, // Navigatsiya paneli ikonka rangi
      ),
    );
  }

  // Theme data ni olish
  ThemeData get themeData {
    return _isDarkMode ? _darkTheme : _lightTheme;
  }

  // Light Theme
  static final ThemeData _lightTheme = ThemeData(
    brightness: Brightness.light,
    // Umumiy yorqinlik darajasi
    scaffoldBackgroundColor: const Color(0xFFF7F7F7),
    // Barcha ekranlarning asosiy fon rangi
    primaryColor: const Color(0xFF6C5CE7),
    // Ilovaning asosiy brend rangi
    canvasColor: const Color(0xFFF7F7F7),
    // BottomSheet, Drawer, Menu fon rangi
    shadowColor: Colors.black.withOpacity(0.1),
    // Umumiy soya rangi
    focusColor: const Color(0xFF6C5CE7).withOpacity(0.12),
    // Fokus holatidagi overlay rangi
    hoverColor: const Color(0xFF6C5CE7).withOpacity(0.04),
    // Hover holatidagi overlay rangi
    highlightColor: const Color(0xFF6C5CE7).withOpacity(0.12),
    // Highlight overlay rangi
    splashColor: const Color(0xFF6C5CE7).withOpacity(0.12),
    // Splash effect rangi (bosilganda)
    disabledColor: Colors.grey[400],
    // O'chirilgan (disabled) elementlar rangi
    hintColor: Colors.black38,
    // Hint matnlar uchun rang
    indicatorColor: const Color(0xFF6C5CE7),
    // TabBar, Stepper kabi indikatorlar rangi
    secondaryHeaderColor: const Color(0xFFF7F7F7),
    // Ikkinchi darajali header fon rangi
    unselectedWidgetColor: Colors.grey,

    // Tanlanmagan checkbox, radio uchun rang
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF6C5CE7),
      // ColorScheme yaratish uchun asos rang
      brightness: Brightness.light,
      // Yorqinlik darajasi
      primary: const Color(0xFF6C5CE7),
      // Asosiy interaktiv elementlar rangi (tugmalar, linklar)
      secondary: const Color(0xFF00B894),
      // Ikkinchi darajali aksent rangi
      error: const Color(0xFFFF7675),
      // Xatolik va ogohlantirish rangi
      surface: Colors.white,
      // Kartalar, modallar, dropdownlar uchun sirt rangi
      background: const Color(0xFFF7F7F7),
      // Umumiy fon rangi
      onPrimary: Colors.white,
      // Primary rang ustidagi matn va ikonkalar rangi
      onSecondary: Colors.white,
      // Secondary rang ustidagi matn rangi
      onError: Colors.white,
      // Error rang ustidagi matn rangi
      onSurface: Colors.black,
      // Surface ustidagi matn rangi
      onBackground: Colors.black,
      // Background ustidagi matn rangi
      surfaceVariant: Colors.grey[100],
      // Surface ning variant rangi
      onSurfaceVariant: Colors.black87,
      // SurfaceVariant ustidagi matn
      outline: Colors.grey[300],
      // Chegara va outline rangi
      shadow: Colors.black.withOpacity(0.1),
      // Soya rangi
      inverseSurface: const Color(0xFF2A2A2A),
      // Teskari surface rangi
      onInverseSurface: Colors.white,
      // Teskari surface ustidagi matn
      inversePrimary: const Color(0xFF8B7FE8),
      // Teskari primary rang
      surfaceTint: const Color(0xFF6C5CE7), // Surface tint rangi
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFF7F7F7),
      // AppBar fon rangi
      foregroundColor: Colors.black,
      // AppBar matn va ikonka asosiy rangi
      elevation: 0,
      // AppBar soyasi balandligi (0 = soyasiz)
      scrolledUnderElevation: 0,
      // Scroll qilganda soya balandligi
      shadowColor: Colors.transparent,
      // AppBar soyasi rangi
      surfaceTintColor: Colors.transparent,
      // AppBar surface tint rangi
      iconTheme: IconThemeData(color: Colors.black),
      // AppBar barcha ikonkalari rangi
      actionsIconTheme: IconThemeData(color: Colors.black),
      // AppBar actions ikonkalari rangi
      titleTextStyle: TextStyle(
        color: Colors.black, // AppBar sarlavha matn rangi
        fontSize: 18, // Sarlavha matn o'lchami
        fontWeight: FontWeight.w600, // Sarlavha qalinligi
      ),
      toolbarTextStyle: TextStyle(
        color: Colors.black, // AppBar toolbar matn rangi
        fontSize: 14,
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        // Status bar fon rangi
        statusBarIconBrightness: Brightness.dark,
        // Status bar ikonkalar rangi
        statusBarBrightness: Brightness.light,
        // iOS uchun status bar yorqinligi
        systemNavigationBarColor: Colors.white,
        // Pastki sistema paneli rangi
        systemNavigationBarIconBrightness:
            Brightness.dark, // Pastki panel ikonka rangi
      ),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      // Bottom navigation bar fon rangi
      selectedItemColor: Color(0xFF6C5CE7),
      // Tanlangan element rangi
      unselectedItemColor: Colors.grey,
      // Tanlanmagan elementlar rangi
      elevation: 0,
      // Navigation bar soyasi
      type: BottomNavigationBarType.fixed,
      // Navigation bar turi (fixed = barcha elementlar doimo ko'rinadi)
      selectedIconTheme: IconThemeData(color: Color(0xFF6C5CE7), size: 24),
      // Tanlangan ikonka rangi va o'lchami
      unselectedIconTheme: IconThemeData(color: Colors.grey, size: 24),
      // Tanlanmagan ikonka rangi
      selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      // Tanlangan label style
      unselectedLabelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
      ),
      // Tanlanmagan label style
      showSelectedLabels: true,
      // Tanlangan label ko'rsatish
      showUnselectedLabels: true, // Tanlanmagan label ko'rsatish
    ),

    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      // NavigationBar fon rangi (Material 3)
      indicatorColor: const Color(0xFF6C5CE7).withOpacity(0.12),
      // Tanlangan element indikator rangi
      iconTheme: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return const IconThemeData(
            color: Color(0xFF6C5CE7),
          ); // Tanlangan ikonka
        }
        return const IconThemeData(color: Colors.grey); // Tanlanmagan ikonka
      }),
      labelTextStyle: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return const TextStyle(
            color: Color(0xFF6C5CE7),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ); // Tanlangan label
        }
        return const TextStyle(
          color: Colors.grey,
          fontSize: 12,
        ); // Tanlanmagan label
      }),
    ),

    cardTheme: CardThemeData(
      color: Colors.white,
      // Karta fon rangi
      elevation: 2,
      // Karta soyasining balandligi
      shadowColor: Colors.black.withOpacity(0.1),
      // Karta soyasi rangi va shaffofligi
      surfaceTintColor: Colors.transparent,
      // Karta surface tint rangi
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          12,
        ), // Karta burchaklarining yumaloqligi
      ),
      margin: const EdgeInsets.all(8), // Karta tashqi margin
    ),

    cardColor: Colors.white,
    // Barcha kartalarning default fon rangi
    dividerColor: Colors.grey[300],
    // Bo'luvchi chiziqlar rangi
    dividerTheme: DividerThemeData(
      color: Colors.grey[300], // Divider rangi
      thickness: 1, // Divider qalinligi
      space: 1, // Divider bo'sh joyi
    ),

    listTileTheme: ListTileThemeData(
      tileColor: Colors.transparent,
      // ListTile default fon rangi
      selectedTileColor: const Color(0xFF6C5CE7).withOpacity(0.12),
      // Tanlangan ListTile fon
      selectedColor: const Color(0xFF6C5CE7),
      // Tanlangan matn va ikonka rangi
      iconColor: Colors.black,
      // ListTile ikonka rangi
      textColor: Colors.black,
      // ListTile matn rangi
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      // ListTile ichki padding
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // ListTile burchak yumaloqligi
      ),
    ),

    drawerTheme: const DrawerThemeData(
      backgroundColor: Colors.white,
      // Drawer fon rangi
      elevation: 16,
      // Drawer soyasi
      shadowColor: Colors.black,
      // Drawer soya rangi
      surfaceTintColor: Colors.transparent,
      // Drawer surface tint
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
    ),

    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.white,
      // BottomSheet fon rangi
      elevation: 8,
      // BottomSheet soyasi
      modalBackgroundColor: Colors.white,
      // Modal BottomSheet fon
      shadowColor: Colors.black,
      // BottomSheet soya rangi
      surfaceTintColor: Colors.transparent,
      // Surface tint
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ), // Yuqori burchaklar yumaloqligi
      ),
    ),

    popupMenuTheme: PopupMenuThemeData(
      color: Colors.white,
      // PopupMenu fon rangi
      elevation: 8,
      // PopupMenu soyasi
      shadowColor: Colors.black.withOpacity(0.2),
      // PopupMenu soya rangi
      surfaceTintColor: Colors.transparent,
      // Surface tint
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // PopupMenu burchak yumaloqligi
      ),
      textStyle: const TextStyle(color: Colors.black), // PopupMenu matn rangi
    ),

    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: Colors.black,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      // Eng katta sarlavha
      displayMedium: TextStyle(
        color: Colors.black,
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
      // O'rtacha katta sarlavha
      displaySmall: TextStyle(
        color: Colors.black,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      // Kichik katta sarlavha
      headlineLarge: TextStyle(
        color: Colors.black,
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
      // Katta headline
      headlineMedium: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      // O'rtacha headline
      headlineSmall: TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      // Kichik headline
      titleLarge: TextStyle(
        color: Colors.black,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      // Katta title
      titleMedium: TextStyle(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      // O'rtacha title
      titleSmall: TextStyle(
        color: Colors.black,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      // Kichik title
      bodyLarge: TextStyle(
        color: Colors.black,
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
      // Katta asosiy matn
      bodyMedium: TextStyle(
        color: Colors.black87,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
      // O'rtacha asosiy matn
      bodySmall: TextStyle(
        color: Colors.black54,
        fontSize: 12,
        fontWeight: FontWeight.normal,
      ),
      // Kichik asosiy matn
      labelLarge: TextStyle(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      // Katta label (tugma matni)
      labelMedium: TextStyle(
        color: Colors.black,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      // O'rtacha label
      labelSmall: TextStyle(
        color: Colors.black54,
        fontSize: 10,
        fontWeight: FontWeight.w500,
      ), // Kichik label
    ),

    primaryTextTheme: const TextTheme(
      displayLarge: TextStyle(
        color: Colors.white,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      // Primary elementlardagi matn
      bodyLarge: TextStyle(color: Colors.white, fontSize: 16),
    ),

    iconTheme: const IconThemeData(
      color: Colors.black, // Barcha ikonkalar uchun default rang
      size: 24, // Ikonkalar uchun default o'lcham
      opacity: 1.0, // Ikonka shaffofligi
    ),

    primaryIconTheme: const IconThemeData(
      color: Colors.white, // Primary elementlardagi ikonka rangi
      size: 24,
    ),

    buttonTheme: ButtonThemeData(
      buttonColor: const Color(0xFF6C5CE7),
      // Eski tugmalar uchun default fon rangi
      textTheme: ButtonTextTheme.primary,
      // Tugma matn rangi primary ga bog'liq
      disabledColor: Colors.grey[300],
      // O'chirilgan tugma rangi
      focusColor: const Color(0xFF6C5CE7).withOpacity(0.12),
      // Fokus overlay rangi
      hoverColor: const Color(0xFF6C5CE7).withOpacity(0.04),
      // Hover overlay rangi
      highlightColor: const Color(0xFF6C5CE7).withOpacity(0.12),
      // Highlight overlay rangi
      splashColor: const Color(0xFF6C5CE7).withOpacity(0.12),
      // Splash effect rangi
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          8,
        ), // Tugma burchaklarining yumaloqligi
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF6C5CE7),
        // ElevatedButton fon rangi
        foregroundColor: Colors.white,
        // ElevatedButton matn va ikonka rangi
        disabledBackgroundColor: Colors.grey[300],
        // O'chirilgan holat fon rangi
        disabledForegroundColor: Colors.grey[600],
        // O'chirilgan holat matn rangi
        elevation: 2,
        // Tugma soyasining balandligi
        shadowColor: Colors.black.withOpacity(0.2),
        // Tugma soyasi rangi
        surfaceTintColor: Colors.transparent,
        // Surface tint rangi
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Tugma burchak yumaloqligi
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        // Tugma ichidagi padding
        minimumSize: const Size(64, 40),
        // Minimal o'lcham
        maximumSize: const Size(double.infinity, 56), // Maksimal o'lcham
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFF6C5CE7), // TextButton matn rangi
        disabledForegroundColor: Colors.grey[400], // O'chirilgan holat rangi
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Tugma burchak yumaloqligi
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF6C5CE7),
        // OutlinedButton matn rangi
        disabledForegroundColor: Colors.grey[400],
        // O'chirilgan holat matn rangi
        side: const BorderSide(color: Color(0xFF6C5CE7)),
        // Tugma chegara rangi va qalinligi
        disabledBackgroundColor: Colors.grey[300],
        // O'chirilgan holat chegara rangi
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Tugma burchak yumaloqligi
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    ),

    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: Colors.black,
        // IconButton ikonka rangi
        disabledForegroundColor: Colors.grey[400],
        // O'chirilgan holat rangi
        highlightColor: const Color(0xFF6C5CE7).withOpacity(0.12),
        // Highlight rangi
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            8,
          ), // IconButton burchak yumaloqligi
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      // Input maydonini fon bilan to'ldirish
      fillColor: Colors.white,
      // Input maydon fon rangi
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8), // Input burchak yumaloqligi
        borderSide: BorderSide(
          color: Colors.grey[300]!,
        ), // Default chegara rangi
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        // Faol holatda burchak yumaloqligi
        borderSide: BorderSide(
          color: Colors.grey[300]!,
        ), // Faol holatda chegara rangi
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        // Fokus holatida burchak yumaloqligi
        borderSide: const BorderSide(
          color: Color(0xFF6C5CE7),
          width: 2,
        ), // Fokus holatida chegara rangi va qalinligi
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        // Xatolik holatida burchak yumaloqligi
        borderSide: const BorderSide(
          color: Color(0xFFFF7675),
        ), // Xatolik chegara rangi
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8), // Fokus va xatolik holatida
        borderSide: const BorderSide(color: Color(0xFFFF7675), width: 2),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8), // O'chirilgan holat
        borderSide: BorderSide(color: Colors.grey[200]!),
      ),
      labelStyle: const TextStyle(color: Colors.black54),
      // Label matn rangi
      floatingLabelStyle: const TextStyle(color: Color(0xFF6C5CE7)),
      // Floating label rangi
      hintStyle: const TextStyle(color: Colors.black38),
      // Hint (placeholder) matn rangi
      helperStyle: const TextStyle(color: Colors.black54),
      // Helper matn rangi
      errorStyle: const TextStyle(color: Color(0xFFFF7675)),
      // Error matn rangi
      prefixIconColor: Colors.black54,
      // Prefix ikonka rangi
      suffixIconColor: Colors.black54,
      // Suffix ikonka rangi
      iconColor: Colors.black54,
      // Icon rangi
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ), // Input ichidagi padding
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF6C5CE7),
      // FAB fon rangi
      foregroundColor: Colors.white,
      // FAB ikonka rangi
      elevation: 4,
      // FAB soyasi balandligi
      focusElevation: 6,
      // Fokus holatida soya
      hoverElevation: 8,
      // Hover holatida soya
      highlightElevation: 12,
      // Bosilganda soya
      disabledElevation: 0,
      // O'chirilgan holat soyasi
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ), // FAB burchak yumaloqligi
      ),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: Colors.grey[200]!,
      // Chip fon rangi
      selectedColor: const Color(0xFF6C5CE7),
      // Tanlangan chip fon rangi
      disabledColor: Colors.grey[100],
      // O'chirilgan chip rangi
      deleteIconColor: Colors.black54,
      // Delete ikonka rangi
      labelStyle: const TextStyle(color: Colors.black),
      // Chip matn rangi
      secondaryLabelStyle: const TextStyle(color: Colors.white),
      // Tanlangan chip matn rangi
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      // Chip ichidagi padding
      labelPadding: const EdgeInsets.symmetric(horizontal: 8),
      // Label padding
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // Chip burchak yumaloqligi
      ),
      side: BorderSide.none,
      // Chip chegarasi
      elevation: 0,
      // Chip soyasi
      pressElevation: 2, // Bosilganda soya
    ),

    dialogTheme: DialogThemeData(
      backgroundColor: Colors.white,
      // Dialog oyna fon rangi
      elevation: 24,
      // Dialog soyasi
      shadowColor: Colors.black.withOpacity(0.3),
      // Dialog soya rangi
      surfaceTintColor: Colors.transparent,
      // Surface tint
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // Dialog burchak yumaloqligi
      ),
      titleTextStyle: const TextStyle(
        color: Colors.black, // Dialog sarlavha matn rangi
        fontSize: 20, // Dialog sarlavha o'lchami
        fontWeight: FontWeight.w600, // Dialog sarlavha qalinligi
      ),
      contentTextStyle: const TextStyle(
        color: Colors.black87, // Dialog content matn rangi
        fontSize: 14,
      ),
      actionsPadding: const EdgeInsets.all(8),
      // Dialog actions padding
      alignment: Alignment.center, // Dialog joylashishi
    ),

    snackBarTheme: SnackBarThemeData(
      backgroundColor: Colors.black87,
      // SnackBar fon rangi
      contentTextStyle: const TextStyle(color: Colors.white),
      // SnackBar matn rangi
      actionTextColor: const Color(0xFF6C5CE7),
      // Action button matn rangi
      disabledActionTextColor: Colors.grey,
      // O'chirilgan action rangi
      elevation: 6,
      // SnackBar soyasi
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // SnackBar burchak yumaloqligi
      ),
      behavior: SnackBarBehavior.floating,
      // SnackBar turi (floating = suzib turadi)
      actionOverflowThreshold: 0.25,
      // Action overflow chegarasi
      showCloseIcon: false,
      // Close ikonka ko'rsatish
      closeIconColor: Colors.white, // Close ikonka rangi
    ),

    bannerTheme: const MaterialBannerThemeData(
      backgroundColor: Colors.white, // MaterialBanner fon rangi
      contentTextStyle: TextStyle(color: Colors.black87), // Content matn rangi
      padding: EdgeInsets.all(16), // Banner padding
      elevation: 0, // Banner soyasi
    ),

    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: Colors.grey[800], // Tooltip fon rangi
        borderRadius: BorderRadius.circular(4), // Tooltip burchak yumaloqligi
      ),
      textStyle: const TextStyle(color: Colors.white, fontSize: 12),
      // Tooltip matn style
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      // Tooltip padding
      margin: const EdgeInsets.all(8),
      // Tooltip margin
      verticalOffset: 24,
      // Tooltip vertikal offset
      preferBelow: true,
      // Tooltip pastda ko'rsatish
      waitDuration: const Duration(milliseconds: 500),
      // Ko'rsatish kutish vaqti
      showDuration: const Duration(
        milliseconds: 1500,
      ), // Ko'rsatish davomiyligi
    ),

    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return Colors.grey[400]; // O'chirilgan holat thumb rangi
        }
        if (states.contains(MaterialState.selected)) {
          return const Color(
            0xFF6C5CE7,
          ); // Yoqilgan holatda thumb (tugma) rangi
        }
        return Colors.grey; // O'chirilgan holatda thumb rangi
      }),
      trackColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return Colors.grey[300]; // O'chirilgan holat track rangi
        }
        if (states.contains(MaterialState.selected)) {
          return const Color(
            0xFF6C5CE7,
          ).withOpacity(0.5); // Yoqilgan holatda track (yo'lak) rangi
        }
        return Colors.grey[300]; // O'chirilgan holatda track rangi
      }),
      overlayColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return const Color(
            0xFF6C5CE7,
          ).withOpacity(0.12); // Tanlangan holat overlay
        }
        return Colors.grey.withOpacity(0.12); // Default overlay
      }),
    ),

    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return Colors.grey[300]; // O'chirilgan holat
        }
        if (states.contains(MaterialState.selected)) {
          return const Color(
            0xFF6C5CE7,
          ); // Tanlangan holatda checkbox fon rangi
        }
        return Colors.transparent; // Tanlanmagan holatda shaffof
      }),
      checkColor: MaterialStateProperty.all(Colors.white),
      // Belgi (galochka) rangi
      overlayColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return const Color(0xFF6C5CE7).withOpacity(0.12); // Tanlangan overlay
        }
        return Colors.grey.withOpacity(0.12); // Default overlay
      }),
      side: BorderSide(color: Colors.grey[400]!, width: 2),
      // Checkbox chegarasi
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4), // Checkbox burchak yumaloqligi
      ),
    ),

    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return Colors.grey[400]; // O'chirilgan holat
        }
        if (states.contains(MaterialState.selected)) {
          return const Color(0xFF6C5CE7); // Tanlangan radio button rangi
        }
        return Colors.grey; // Tanlanmagan radio button rangi
      }),
      overlayColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return const Color(0xFF6C5CE7).withOpacity(0.12); // Tanlangan overlay
        }
        return Colors.grey.withOpacity(0.12); // Default overlay
      }),
    ),

    sliderTheme: SliderThemeData(
      activeTrackColor: const Color(0xFF6C5CE7),
      // Faol slider track rangi
      inactiveTrackColor: Colors.grey[300],
      // Nofaol slider track rangi
      thumbColor: const Color(0xFF6C5CE7),
      // Slider thumb (tugma) rangi
      overlayColor: const Color(0xFF6C5CE7).withOpacity(0.12),
      // Slider overlay rangi
      valueIndicatorColor: const Color(0xFF6C5CE7),
      // Qiymat ko'rsatkichi fon rangi
      activeTickMarkColor: Colors.white,
      // Faol tick mark rangi
      inactiveTickMarkColor: Colors.grey[400],
      // Nofaol tick mark rangi
      disabledActiveTrackColor: Colors.grey[400],
      // O'chirilgan faol track
      disabledInactiveTrackColor: Colors.grey[300],
      // O'chirilgan nofaol track
      disabledThumbColor: Colors.grey[400],
      // O'chirilgan thumb rangi
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
      // Thumb shakli va o'lchami
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
      // Overlay shakli
      trackHeight: 4,
      // Track balandligi
      valueIndicatorTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 12,
      ), // Qiymat matn style
    ),

    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: Color(0xFF6C5CE7),
      // Progress bar va circular indicator rangi
      linearTrackColor: Colors.grey,
      // Linear progress track rangi
      circularTrackColor: Colors.grey,
      // Circular progress track rangi
      refreshBackgroundColor: Colors.white,
      // Refresh indicator fon rangi
      linearMinHeight: 4, // Linear progress minimal balandligi
    ),

    tabBarTheme: TabBarThemeData(
      labelColor: const Color(0xFF6C5CE7),
      // Tanlangan tab matn rangi
      unselectedLabelColor: Colors.grey,
      // Tanlanmagan tab matn rangi
      overlayColor: MaterialStateProperty.all(
        const Color(0xFF6C5CE7).withOpacity(0.12),
      ),
      // Tab overlay rangi
      indicatorColor: const Color(0xFF6C5CE7),
      // Tab indikator rangi
      indicator: const UnderlineTabIndicator(
        borderSide: BorderSide(
          color: Color(0xFF6C5CE7),
          width: 2,
        ), // Tab indikator rangi va qalinligi
      ),
      indicatorSize: TabBarIndicatorSize.tab,
      // Indikator o'lchami
      labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      // Tanlangan tab matn style
      unselectedLabelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
      // Tanlanmagan tab matn style
      labelPadding: const EdgeInsets.symmetric(horizontal: 16),
      // Tab label padding
      dividerColor: Colors.grey[300],
      // Tab divider rangi
      dividerHeight: 1, // Divider balandligi
    ),

    timePickerTheme: TimePickerThemeData(
      backgroundColor: Colors.white,
      // TimePicker fon rangi
      dialBackgroundColor: Colors.grey[100],
      // Dial fon rangi
      dialHandColor: const Color(0xFF6C5CE7),
      // Soat strelka rangi
      hourMinuteColor: Colors.grey[100],
      // Soat/daqiqa fon rangi
      hourMinuteTextColor: Colors.black,
      // Soat/daqiqa matn rangi
      dayPeriodColor: Colors.grey[100],
      // AM/PM fon rangi
      dayPeriodTextColor: Colors.black,
      // AM/PM matn rangi
      entryModeIconColor: Colors.black,
      // Entry mode ikonka rangi
      helpTextStyle: const TextStyle(color: Colors.black87),
      // Help matn style
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          16,
        ), // TimePicker burchak yumaloqligi
      ),
    ),

    datePickerTheme: DatePickerThemeData(
      backgroundColor: Colors.white,
      // DatePicker fon rangi
      headerBackgroundColor: const Color(0xFF6C5CE7),
      // Header fon rangi
      headerForegroundColor: Colors.white,
      // Header matn rangi
      dayForegroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return Colors.white; // Tanlangan kun matn rangi
        }
        if (states.contains(MaterialState.disabled)) {
          return Colors.grey[400]; // O'chirilgan kun matn rangi
        }
        return Colors.black; // Oddiy kun matn rangi
      }),
      dayBackgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return const Color(0xFF6C5CE7); // Tanlangan kun fon rangi
        }
        return Colors.transparent; // Default shaffof
      }),
      todayForegroundColor: MaterialStateProperty.all(const Color(0xFF6C5CE7)),
      // Bugungi kun matn rangi
      todayBackgroundColor: MaterialStateProperty.all(Colors.transparent),
      // Bugungi kun fon rangi
      yearForegroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return Colors.white; // Tanlangan yil matn rangi
        }
        return Colors.black; // Oddiy yil matn rangi
      }),
      yearBackgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return const Color(0xFF6C5CE7); // Tanlangan yil fon rangi
        }
        return Colors.transparent; // Default shaffof
      }),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          16,
        ), // DatePicker burchak yumaloqligi
      ),
      elevation: 8,
      // DatePicker soyasi
      shadowColor: Colors.black.withOpacity(0.2), // Soya rangi
    ),

    expansionTileTheme: ExpansionTileThemeData(
      backgroundColor: Colors.transparent,
      // ExpansionTile fon rangi
      collapsedBackgroundColor: Colors.transparent,
      // Yopiq holat fon rangi
      textColor: Colors.black,
      // Ochiq holat matn rangi
      collapsedTextColor: Colors.black,
      // Yopiq holat matn rangi
      iconColor: const Color(0xFF6C5CE7),
      // Ochiq holat ikonka rangi
      collapsedIconColor: Colors.grey,
      // Yopiq holat ikonka rangi
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          8,
        ), // ExpansionTile burchak yumaloqligi
      ),
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      // Tile padding
      expandedAlignment: Alignment.centerLeft,
      // Ochilgan content joylashuvi
      childrenPadding: const EdgeInsets.all(16), // Children padding
    ),

    searchBarTheme: SearchBarThemeData(
      backgroundColor: MaterialStateProperty.all(Colors.white),
      // SearchBar fon rangi
      elevation: MaterialStateProperty.all(2),
      // SearchBar soyasi
      shadowColor: MaterialStateProperty.all(Colors.black.withOpacity(0.1)),
      // Soya rangi
      surfaceTintColor: MaterialStateProperty.all(Colors.transparent),
      // Surface tint
      overlayColor: MaterialStateProperty.all(
        const Color(0xFF6C5CE7).withOpacity(0.12),
      ),
      // Overlay rangi
      side: MaterialStateProperty.all(BorderSide(color: Colors.grey[300]!)),
      // SearchBar chegarasi
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            8,
          ), // SearchBar burchak yumaloqligi
        ),
      ),
      padding: MaterialStateProperty.all(
        const EdgeInsets.symmetric(horizontal: 16),
      ),
      // SearchBar padding
      textStyle: MaterialStateProperty.all(
        const TextStyle(color: Colors.black),
      ),
      // Matn style
      hintStyle: MaterialStateProperty.all(
        const TextStyle(color: Colors.black38),
      ), // Hint style
    ),

    searchViewTheme: SearchViewThemeData(
      backgroundColor: Colors.white,
      // SearchView fon rangi
      elevation: 8,
      // SearchView soyasi
      surfaceTintColor: Colors.transparent,
      // Surface tint
      dividerColor: Colors.grey[300],
      // Divider rangi
      headerTextStyle: const TextStyle(color: Colors.black, fontSize: 16),
      // Header matn style
      headerHintStyle: const TextStyle(color: Colors.black38, fontSize: 16),
      // Header hint style
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          16,
        ), // SearchView burchak yumaloqligi
      ),
    ),

    badgeTheme: BadgeThemeData(
      backgroundColor: const Color(0xFFFF7675),
      // Badge fon rangi (odatda xatolik yoki ogohlantirish)
      textColor: Colors.white,
      // Badge matn rangi
      smallSize: 6,
      // Kichik badge o'lchami
      largeSize: 16,
      // Katta badge o'lchami
      padding: const EdgeInsets.symmetric(horizontal: 4),
      // Badge padding
      alignment: AlignmentDirectional.topEnd,
      // Badge joylashuvi
      textStyle: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w600,
      ), // Badge matn style
    ),

    segmentedButtonTheme: SegmentedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return const Color(
              0xFF6C5CE7,
            ).withOpacity(0.12); // Tanlangan segment fon
          }
          return Colors.transparent; // Tanlanmagan segment
        }),
        foregroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return const Color(0xFF6C5CE7); // Tanlangan segment matn rangi
          }
          return Colors.black; // Tanlanmagan segment matn rangi
        }),
        side: MaterialStateProperty.all(BorderSide(color: Colors.grey[300]!)),
        // Segment chegarasi
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              8,
            ), // Segment burchak yumaloqligi
          ),
        ),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ), // Segment padding
      ),
    ),

    menuTheme: MenuThemeData(
      style: MenuStyle(
        backgroundColor: MaterialStateProperty.all(Colors.white),
        // Menu fon rangi
        elevation: MaterialStateProperty.all(8),
        // Menu soyasi
        shadowColor: MaterialStateProperty.all(Colors.black.withOpacity(0.2)),
        // Soya rangi
        surfaceTintColor: MaterialStateProperty.all(Colors.transparent),
        // Surface tint
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Menu burchak yumaloqligi
          ),
        ),
        padding: MaterialStateProperty.all(
          const EdgeInsets.all(8),
        ), // Menu padding
      ),
    ),

    menuButtonTheme: MenuButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.hovered)) {
            return const Color(0xFF6C5CE7).withOpacity(0.08); // Hover fon
          }
          return Colors.transparent; // Default shaffof
        }),
        foregroundColor: MaterialStateProperty.all(Colors.black),
        // MenuButton matn rangi
        overlayColor: MaterialStateProperty.all(
          const Color(0xFF6C5CE7).withOpacity(0.12),
        ),
        // Overlay rangi
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        // MenuButton padding
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
      ),
    ),

    navigationDrawerTheme: NavigationDrawerThemeData(
      backgroundColor: Colors.white,
      // NavigationDrawer fon rangi
      elevation: 16,
      // NavigationDrawer soyasi
      shadowColor: Colors.black.withOpacity(0.3),
      // Soya rangi
      surfaceTintColor: Colors.transparent,
      // Surface tint
      indicatorColor: const Color(0xFF6C5CE7).withOpacity(0.12),
      // Tanlangan element indikator rangi
      indicatorShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // Indikator burchak yumaloqligi
      ),
      iconTheme: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return const IconThemeData(
            color: Color(0xFF6C5CE7),
          ); // Tanlangan ikonka
        }
        return const IconThemeData(color: Colors.grey); // Tanlanmagan ikonka
      }),
      labelTextStyle: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return const TextStyle(
            color: Color(0xFF6C5CE7),
            fontWeight: FontWeight.w600,
          ); // Tanlangan matn
        }
        return const TextStyle(color: Colors.black87); // Tanlanmagan matn
      }),
    ),

    // app: const AppBarTheme(
    //   backgroundColor: Color(0xFFF7F7F7),
    //   // AppBar fon rangi
    //   foregroundColor: Colors.black,
    //   // AppBar matn va ikonka asosiy rangi
    //   elevation: 0,
    //   // AppBar soyasi balandligi (0 = soyasiz)
    //   scrolledUnderElevation: 0,
    //   // Scroll qilganda soya balandligi
    //   shadowColor: Colors.transparent,
    //   // AppBar soyasi rangi
    //   surfaceTintColor: Colors.transparent,
    //   // AppBar surface tint rangi
    //   centerTitle: false,
    //   // Sarlavhani markazlashtirish
    //   titleSpacing: 16,
    //   // Sarlavha boshqa elementlardan masofa
    //   toolbarHeight: 56,
    //   // AppBar balandligi
    //   iconTheme: IconThemeData(color: Colors.black),
    //   // AppBar barcha ikonkalari rangi
    //   actionsIconTheme: IconThemeData(color: Colors.black),
    //   // AppBar actions ikonkalari rangi
    //   titleTextStyle: TextStyle(
    //     color: Colors.black, // AppBar sarlavha matn rangi
    //     fontSize: 18, // Sarlavha matn o'lchami
    //     fontWeight: FontWeight.w600, // Sarlavha qalinligi
    //   ),
    //   toolbarTextStyle: TextStyle(
    //     color: Colors.black, // AppBar toolbar matn rangi
    //     fontSize: 14,
    //   ),
    //   systemOverlayStyle: SystemUiOverlayStyle(
    //     statusBarColor: Colors.transparent,
    //     // Status bar fon rangi
    //     statusBarIconBrightness: Brightness.dark,
    //     // Status bar ikonkalar rangi
    //     statusBarBrightness: Brightness.light,
    //     // iOS uchun status bar yorqinligi
    //     systemNavigationBarColor: Colors.white,
    //     // Pastki sistema paneli rangi
    //     systemNavigationBarIconBrightness:
    //         Brightness.dark, // Pastki panel ikonka rangi
    //   ),
    // ),
  );

  // Dark Theme
  static final ThemeData _darkTheme = ThemeData(
    brightness: Brightness.dark,
    // To'q yorqinlik darajasi
    scaffoldBackgroundColor: const Color(0xFF1F1F1F),
    // To'q asosiy fon rangi
    primaryColor: const Color(0xFF6C5CE7),
    // Asosiy brend rangi (light theme bilan bir xil)
    canvasColor: const Color(0xFF2A2A2A),
    // To'q canvas rang
    shadowColor: Colors.black.withOpacity(0.3),
    // To'q soya rangi
    focusColor: const Color(0xFF6C5CE7).withOpacity(0.12),
    // Fokus overlay
    hoverColor: const Color(0xFF6C5CE7).withOpacity(0.04),
    // Hover overlay
    highlightColor: const Color(0xFF6C5CE7).withOpacity(0.12),
    // Highlight overlay
    splashColor: const Color(0xFF6C5CE7).withOpacity(0.12),
    // Splash effect
    disabledColor: Colors.grey[600],
    // O'chirilgan elementlar
    hintColor: Colors.white38,
    // Hint matnlar
    indicatorColor: const Color(0xFF6C5CE7),
    // Indikatorlar rangi
    secondaryHeaderColor: const Color(0xFF2A2A2A),
    // Ikkinchi darajali header
    unselectedWidgetColor: Colors.grey,

    // Tanlanmagan widgetlar
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF6C5CE7),
      // Asos rang
      brightness: Brightness.dark,
      // To'q rejim
      primary: const Color(0xFF6C5CE7),
      // Asosiy interaktiv elementlar rangi
      secondary: const Color(0xFF00B894),
      // Ikkinchi darajali rang
      error: const Color(0xFFFF7675),
      // Xatolik rangi
      surface: const Color(0xFF2A2A2A),
      // To'q sirt rangi (kartalar uchun)
      background: const Color(0xFF1F1F1F),
      // To'q fon rangi
      onPrimary: Colors.white,
      // Primary ustidagi matn
      onSecondary: Colors.white,
      // Secondary ustidagi matn
      onError: Colors.white,
      // Error ustidagi matn
      onSurface: Colors.white,
      // Surface ustidagi matn
      onBackground: Colors.white,
      // Background ustidagi matn
      surfaceVariant: const Color(0xFF3A3A3A),
      // Surface variant
      onSurfaceVariant: Colors.white70,
      // SurfaceVariant ustidagi matn
      outline: Colors.grey[700],
      // Chegara rangi
      shadow: Colors.black.withOpacity(0.3),
      // Soya rangi
      inverseSurface: Colors.white,
      // Teskari surface
      onInverseSurface: Colors.black,
      // Teskari surface ustidagi matn
      inversePrimary: const Color(0xFF4A3FB5),
      // Teskari primary
      surfaceTint: const Color(0xFF6C5CE7), // Surface tint
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1F1F1F),
      // To'q AppBar fon
      foregroundColor: Colors.white,
      // Oq matn va ikonkalar
      elevation: 0,
      // Soyasiz
      scrolledUnderElevation: 0,
      // Scroll qilganda ham soyasiz
      shadowColor: Colors.transparent,
      // Soya rangi
      surfaceTintColor: Colors.transparent,
      // Surface tint
      centerTitle: false,
      // Sarlavha markazda emas
      titleSpacing: 16,
      // Sarlavha masofa
      toolbarHeight: 56,
      // AppBar balandligi
      iconTheme: IconThemeData(color: Colors.white),
      // Oq ikonkalar
      actionsIconTheme: IconThemeData(color: Colors.white),
      // Actions ikonkalari
      titleTextStyle: TextStyle(
        color: Colors.white, // Oq sarlavha
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      toolbarTextStyle: TextStyle(
        color: Colors.white, // Oq toolbar matn
        fontSize: 14,
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        // Shaffof status bar
        statusBarIconBrightness: Brightness.light,
        // Och rangli ikonkalar
        statusBarBrightness: Brightness.dark,
        // iOS uchun to'q rejim
        systemNavigationBarColor: Color(0xFF1A1A1A),
        // Juda to'q navigatsiya paneli
        systemNavigationBarIconBrightness: Brightness.light, // Och ikonkalar
      ),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF2A2A2A),
      // To'q navigation bar fon
      selectedItemColor: Color(0xFF6C5CE7),
      // Tanlangan element rangi (primary)
      unselectedItemColor: Colors.grey,
      // Tanlanmagan elementlar kulrang
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      selectedIconTheme: IconThemeData(color: Color(0xFF6C5CE7), size: 24),
      // Tanlangan ikonka
      unselectedIconTheme: IconThemeData(color: Colors.grey, size: 24),
      // Tanlanmagan ikonka
      selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      // Tanlangan label
      unselectedLabelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
      ),
      // Tanlanmagan label
      showSelectedLabels: true,
      showUnselectedLabels: true,
    ),

    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: const Color(0xFF2A2A2A),
      // To'q NavigationBar fon
      indicatorColor: const Color(0xFF6C5CE7).withOpacity(0.12),
      // Tanlangan indikator
      iconTheme: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return const IconThemeData(color: Color(0xFF6C5CE7));
        }
        return const IconThemeData(color: Colors.grey);
      }),
      labelTextStyle: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return const TextStyle(
            color: Color(0xFF6C5CE7),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          );
        }
        return const TextStyle(color: Colors.grey, fontSize: 12);
      }),
    ),

    cardTheme: CardThemeData(
      color: const Color(0xFF2A2A2A),
      // To'q karta fon
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.3),
      // Ko'proq ko'rinadigan soya
      surfaceTintColor: Colors.transparent,
      // Surface tint
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(8), // Karta margin
    ),

    cardColor: const Color(0xFF2A2A2A),
    // Default to'q karta rangi
    dividerColor: Colors.grey[800],
    // To'q bo'luvchi chiziq
    dividerTheme: DividerThemeData(
      color: Colors.grey[800], // To'q divider
      thickness: 1,
      space: 1,
    ),

    listTileTheme: ListTileThemeData(
      tileColor: Colors.transparent,
      // Shaffof ListTile fon
      selectedTileColor: const Color(0xFF6C5CE7).withOpacity(0.12),
      // Tanlangan fon
      selectedColor: const Color(0xFF6C5CE7),
      // Tanlangan matn va ikonka
      iconColor: Colors.white,
      // Ikonka rangi
      textColor: Colors.white,
      // Matn rangi
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),

    drawerTheme: const DrawerThemeData(
      backgroundColor: Color(0xFF2A2A2A),
      // To'q Drawer fon
      elevation: 16,
      shadowColor: Colors.black,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
    ),

    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Color(0xFF2A2A2A),
      // To'q BottomSheet fon
      elevation: 8,
      modalBackgroundColor: Color(0xFF2A2A2A),
      // Modal BottomSheet fon
      shadowColor: Colors.black,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    ),

    popupMenuTheme: PopupMenuThemeData(
      color: const Color(0xFF2A2A2A),
      // To'q PopupMenu fon
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.4),
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      textStyle: const TextStyle(color: Colors.white), // Oq matn
    ),

    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: Colors.white,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      // Oq matnlar
      displayMedium: TextStyle(
        color: Colors.white,
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      headlineLarge: TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
      bodyMedium: TextStyle(
        color: Colors.white70,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
      // Biroz shaffof oq
      bodySmall: TextStyle(
        color: Colors.white60,
        fontSize: 12,
        fontWeight: FontWeight.normal,
      ),
      // Ko'proq shaffof
      labelLarge: TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      labelMedium: TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      labelSmall: TextStyle(
        color: Colors.white60,
        fontSize: 10,
        fontWeight: FontWeight.w500,
      ),
    ),

    primaryTextTheme: const TextTheme(
      displayLarge: TextStyle(
        color: Colors.white,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(color: Colors.white, fontSize: 16),
    ),

    iconTheme: const IconThemeData(
      color: Colors.white, // Oq ikonkalar
      size: 24,
      opacity: 1.0,
    ),

    primaryIconTheme: const IconThemeData(
      color: Colors.white, // Primary elementlardagi ikonka
      size: 24,
    ),

    buttonTheme: ButtonThemeData(
      buttonColor: const Color(0xFF6C5CE7),
      // Primary rang
      textTheme: ButtonTextTheme.primary,
      disabledColor: Colors.grey[700],
      // O'chirilgan tugma
      focusColor: const Color(0xFF6C5CE7).withOpacity(0.12),
      hoverColor: const Color(0xFF6C5CE7).withOpacity(0.04),
      highlightColor: const Color(0xFF6C5CE7).withOpacity(0.12),
      splashColor: const Color(0xFF6C5CE7).withOpacity(0.12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF6C5CE7),
        // Primary fon
        foregroundColor: Colors.white,
        // Oq matn
        disabledBackgroundColor: Colors.grey[700],
        // O'chirilgan fon
        disabledForegroundColor: Colors.grey[500],
        // O'chirilgan matn
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.4),
        // Ko'proq ko'rinadigan soya
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        minimumSize: const Size(64, 40),
        maximumSize: const Size(double.infinity, 56),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFF6C5CE7), // Primary matn rangi
        disabledForegroundColor: Colors.grey[600], // O'chirilgan holat
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF6C5CE7),
        // Primary matn
        disabledForegroundColor: Colors.grey[600],
        // O'chirilgan matn
        side: const BorderSide(color: Color(0xFF6C5CE7)),
        // Primary chegara
        disabledBackgroundColor: Colors.grey[700],
        // O'chirilgan chegara
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    ),

    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: Colors.white, // Oq ikonka
        disabledForegroundColor: Colors.grey[600],
        highlightColor: const Color(0xFF6C5CE7).withOpacity(0.12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2A2A2A),
      // To'q input fon
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[700]!), // To'q chegara
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[700]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: Color(0xFF6C5CE7),
          width: 2,
        ), // Primary fokus
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFFF7675)), // Error rangi
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFFF7675), width: 2),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[800]!), // O'chirilgan chegara
      ),
      labelStyle: const TextStyle(color: Colors.white60),
      // Shaffof oq label
      floatingLabelStyle: const TextStyle(color: Color(0xFF6C5CE7)),
      // Floating label primary
      hintStyle: const TextStyle(color: Colors.white38),
      // Ko'proq shaffof hint
      helperStyle: const TextStyle(color: Colors.white60),
      // Helper matn
      errorStyle: const TextStyle(color: Color(0xFFFF7675)),
      // Error matn
      prefixIconColor: Colors.white60,
      // Prefix ikonka
      suffixIconColor: Colors.white60,
      // Suffix ikonka
      iconColor: Colors.white60,
      // Icon rangi
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF6C5CE7),
      // Primary fon
      foregroundColor: Colors.white,
      // Oq ikonka
      elevation: 4,
      focusElevation: 6,
      hoverElevation: 8,
      highlightElevation: 12,
      disabledElevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: Colors.grey[800]!,
      // To'q chip fon
      selectedColor: const Color(0xFF6C5CE7),
      // Primary tanlangan
      disabledColor: Colors.grey[900],
      // O'chirilgan chip
      deleteIconColor: Colors.white60,
      // Delete ikonka
      labelStyle: const TextStyle(color: Colors.white),
      // Oq matn
      secondaryLabelStyle: const TextStyle(color: Colors.white),
      // Tanlangan chip matn
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      labelPadding: const EdgeInsets.symmetric(horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      side: BorderSide.none,
      elevation: 0,
      pressElevation: 2,
    ),

    dialogTheme: DialogThemeData(
      backgroundColor: const Color(0xFF2A2A2A),
      // To'q dialog fon
      elevation: 24,
      shadowColor: Colors.black.withOpacity(0.5),
      // Ko'proq ko'rinadigan soya
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      titleTextStyle: const TextStyle(
        color: Colors.white, // Oq sarlavha
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      contentTextStyle: const TextStyle(
        color: Colors.white70, // Shaffof oq content
        fontSize: 14,
      ),
      actionsPadding: const EdgeInsets.all(8),
      alignment: Alignment.center,
    ),

    snackBarTheme: SnackBarThemeData(
      backgroundColor: const Color(0xFF2A2A2A),
      // To'q snackbar fon
      contentTextStyle: const TextStyle(color: Colors.white),
      // Oq matn
      actionTextColor: const Color(0xFF6C5CE7),
      // Primary action
      disabledActionTextColor: Colors.grey[600],
      // O'chirilgan action
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      behavior: SnackBarBehavior.floating,
      actionOverflowThreshold: 0.25,
      showCloseIcon: false,
      closeIconColor: Colors.white,
    ),

    bannerTheme: const MaterialBannerThemeData(
      backgroundColor: Color(0xFF2A2A2A), // To'q banner fon
      contentTextStyle: TextStyle(color: Colors.white70), // Content matn
      padding: EdgeInsets.all(16),
      elevation: 0,
    ),

    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        // Och kulrang tooltip (to'q temada yaxshi ko'rinadi)
        borderRadius: BorderRadius.circular(4),
      ),
      textStyle: const TextStyle(color: Colors.black, fontSize: 12),
      // Qora matn
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      margin: const EdgeInsets.all(8),
      verticalOffset: 24,
      preferBelow: true,
      waitDuration: const Duration(milliseconds: 500),
      showDuration: const Duration(milliseconds: 1500),
    ),

    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return Colors.grey[700]; // O'chirilgan thumb
        }
        if (states.contains(MaterialState.selected)) {
          return const Color(0xFF6C5CE7); // Primary yoqilgan
        }
        return Colors.grey; // Kulrang o'chirilgan
      }),
      trackColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return Colors.grey[800]; // O'chirilgan track
        }
        if (states.contains(MaterialState.selected)) {
          return const Color(0xFF6C5CE7).withOpacity(0.5); // Shaffof primary
        }
        return Colors.grey[700]; // To'q kulrang track
      }),
      overlayColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return const Color(0xFF6C5CE7).withOpacity(0.12);
        }
        return Colors.grey.withOpacity(0.12);
      }),
    ),

    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return Colors.grey[700]; // O'chirilgan
        }
        if (states.contains(MaterialState.selected)) {
          return const Color(0xFF6C5CE7); // Primary tanlangan
        }
        return Colors.transparent; // Shaffof tanlanmagan
      }),
      checkColor: MaterialStateProperty.all(Colors.white),
      // Oq galochka
      overlayColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return const Color(0xFF6C5CE7).withOpacity(0.12);
        }
        return Colors.grey.withOpacity(0.12);
      }),
      side: BorderSide(color: Colors.grey[600]!, width: 2),
      // To'q checkbox chegarasi
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),

    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return Colors.grey[700]; // O'chirilgan
        }
        if (states.contains(MaterialState.selected)) {
          return const Color(0xFF6C5CE7); // Primary tanlangan
        }
        return Colors.grey; // Kulrang tanlanmagan
      }),
      overlayColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return const Color(0xFF6C5CE7).withOpacity(0.12);
        }
        return Colors.grey.withOpacity(0.12);
      }),
    ),

    sliderTheme: SliderThemeData(
      activeTrackColor: const Color(0xFF6C5CE7),
      // Primary faol track
      inactiveTrackColor: Colors.grey[700],
      // To'q nofaol track
      thumbColor: const Color(0xFF6C5CE7),
      // Primary thumb
      overlayColor: const Color(0xFF6C5CE7).withOpacity(0.12),
      // Overlay
      valueIndicatorColor: const Color(0xFF6C5CE7),
      // Qiymat ko'rsatkichi
      activeTickMarkColor: Colors.white,
      // Oq faol tick
      inactiveTickMarkColor: Colors.grey[600],
      // To'q nofaol tick
      disabledActiveTrackColor: Colors.grey[700],
      // O'chirilgan faol
      disabledInactiveTrackColor: Colors.grey[800],
      // O'chirilgan nofaol
      disabledThumbColor: Colors.grey[700],
      // O'chirilgan thumb
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
      trackHeight: 4,
      valueIndicatorTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 12,
      ),
    ),

    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: Color(0xFF6C5CE7),
      // Primary progress
      linearTrackColor: Colors.grey,
      // Linear track
      circularTrackColor: Colors.grey,
      // Circular track
      refreshBackgroundColor: Color(0xFF2A2A2A),
      // To'q refresh fon
      linearMinHeight: 4,
    ),

    tabBarTheme: TabBarThemeData(
      labelColor: const Color(0xFF6C5CE7),
      // Primary tanlangan tab
      unselectedLabelColor: Colors.grey,
      // Kulrang tanlanmagan
      overlayColor: MaterialStateProperty.all(
        const Color(0xFF6C5CE7).withOpacity(0.12),
      ),
      indicatorColor: const Color(0xFF6C5CE7),
      // Primary indikator
      indicator: const UnderlineTabIndicator(
        borderSide: BorderSide(color: Color(0xFF6C5CE7), width: 2),
      ),
      indicatorSize: TabBarIndicatorSize.tab,
      labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      unselectedLabelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
      labelPadding: const EdgeInsets.symmetric(horizontal: 16),
      dividerColor: Colors.grey[800],
      // To'q divider
      dividerHeight: 1,
    ),

    timePickerTheme: TimePickerThemeData(
      backgroundColor: const Color(0xFF2A2A2A),
      // To'q TimePicker fon
      dialBackgroundColor: Colors.grey[800],
      // To'q dial fon
      dialHandColor: const Color(0xFF6C5CE7),
      // Primary strelka
      hourMinuteColor: Colors.grey[800],
      // To'q soat/daqiqa fon
      hourMinuteTextColor: Colors.white,
      // Oq soat/daqiqa matn
      dayPeriodColor: Colors.grey[800],
      // To'q AM/PM fon
      dayPeriodTextColor: Colors.white,
      // Oq AM/PM matn
      entryModeIconColor: Colors.white,
      // Oq entry mode ikonka
      helpTextStyle: const TextStyle(color: Colors.white70),
      // Help matn
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    datePickerTheme: DatePickerThemeData(
      backgroundColor: const Color(0xFF2A2A2A),
      // To'q DatePicker fon
      headerBackgroundColor: const Color(0xFF6C5CE7),
      // Primary header
      headerForegroundColor: Colors.white,
      // Oq header matn
      dayForegroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return Colors.white; // Tanlangan kun oq matn
        }
        if (states.contains(MaterialState.disabled)) {
          return Colors.grey[700]; // O'chirilgan kun
        }
        return Colors.white; // Oddiy kun oq matn
      }),
      dayBackgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return const Color(0xFF6C5CE7); // Primary tanlangan kun fon
        }
        return Colors.transparent; // Shaffof default
      }),
      todayForegroundColor: MaterialStateProperty.all(const Color(0xFF6C5CE7)),
      // Primary bugungi kun
      todayBackgroundColor: MaterialStateProperty.all(Colors.transparent),
      // Shaffof bugungi kun fon
      yearForegroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return Colors.white; // Tanlangan yil oq
        }
        return Colors.white; // Oddiy yil oq
      }),
      yearBackgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return const Color(0xFF6C5CE7); // Primary tanlangan yil fon
        }
        return Colors.transparent; // Shaffof
      }),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.4),
    ),

    expansionTileTheme: ExpansionTileThemeData(
      backgroundColor: Colors.transparent,
      // Shaffof ExpansionTile fon
      collapsedBackgroundColor: Colors.transparent,
      // Yopiq holat shaffof
      textColor: Colors.white,
      // Oq ochiq holat matn
      collapsedTextColor: Colors.white,
      // Oq yopiq holat matn
      iconColor: const Color(0xFF6C5CE7),
      // Primary ochiq ikonka
      collapsedIconColor: Colors.grey,
      // Kulrang yopiq ikonka
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      expandedAlignment: Alignment.centerLeft,
      childrenPadding: const EdgeInsets.all(16),
    ),

    searchBarTheme: SearchBarThemeData(
      backgroundColor: MaterialStateProperty.all(const Color(0xFF2A2A2A)),
      // To'q SearchBar fon
      elevation: MaterialStateProperty.all(2),
      shadowColor: MaterialStateProperty.all(Colors.black.withOpacity(0.3)),
      surfaceTintColor: MaterialStateProperty.all(Colors.transparent),
      overlayColor: MaterialStateProperty.all(
        const Color(0xFF6C5CE7).withOpacity(0.12),
      ),
      side: MaterialStateProperty.all(BorderSide(color: Colors.grey[700]!)),
      // To'q chegara
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      padding: MaterialStateProperty.all(
        const EdgeInsets.symmetric(horizontal: 16),
      ),
      textStyle: MaterialStateProperty.all(
        const TextStyle(color: Colors.white),
      ),
      // Oq matn
      hintStyle: MaterialStateProperty.all(
        const TextStyle(color: Colors.white38),
      ), // Shaffof hint
    ),

    searchViewTheme: SearchViewThemeData(
      backgroundColor: const Color(0xFF2A2A2A),
      // To'q SearchView fon
      elevation: 8,
      surfaceTintColor: Colors.transparent,
      dividerColor: Colors.grey[800],
      // To'q divider
      headerTextStyle: const TextStyle(color: Colors.white, fontSize: 16),
      // Oq header
      headerHintStyle: const TextStyle(color: Colors.white38, fontSize: 16),
      // Shaffof hint
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    badgeTheme: BadgeThemeData(
      backgroundColor: const Color(0xFFFF7675),
      // Error rangi badge
      textColor: Colors.white,
      // Oq badge matn
      smallSize: 6,
      largeSize: 16,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      alignment: AlignmentDirectional.topEnd,
      textStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
    ),

    segmentedButtonTheme: SegmentedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return const Color(
              0xFF6C5CE7,
            ).withOpacity(0.12); // Primary tanlangan
          }
          return Colors.transparent; // Shaffof
        }),
        foregroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return const Color(0xFF6C5CE7); // Primary tanlangan matn
          }
          return Colors.white; // Oq tanlanmagan matn
        }),
        side: MaterialStateProperty.all(BorderSide(color: Colors.grey[700]!)),
        // To'q chegara
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
    ),

    menuTheme: MenuThemeData(
      style: MenuStyle(
        backgroundColor: MaterialStateProperty.all(const Color(0xFF2A2A2A)),
        // To'q menu fon
        elevation: MaterialStateProperty.all(8),
        shadowColor: MaterialStateProperty.all(Colors.black.withOpacity(0.4)),
        surfaceTintColor: MaterialStateProperty.all(Colors.transparent),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        padding: MaterialStateProperty.all(const EdgeInsets.all(8)),
      ),
    ),

    menuButtonTheme: MenuButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.hovered)) {
            return const Color(0xFF6C5CE7).withOpacity(0.08); // Primary hover
          }
          return Colors.transparent; // Shaffof
        }),
        foregroundColor: MaterialStateProperty.all(Colors.white),
        // Oq matn
        overlayColor: MaterialStateProperty.all(
          const Color(0xFF6C5CE7).withOpacity(0.12),
        ),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
      ),
    ),

    navigationDrawerTheme: NavigationDrawerThemeData(
      backgroundColor: const Color(0xFF2A2A2A),
      // To'q NavigationDrawer fon
      elevation: 16,
      shadowColor: Colors.black.withOpacity(0.5),
      surfaceTintColor: Colors.transparent,
      indicatorColor: const Color(0xFF6C5CE7).withOpacity(0.12),
      // Primary indikator
      indicatorShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      iconTheme: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return const IconThemeData(
            color: Color(0xFF6C5CE7),
          ); // Primary tanlangan
        }
        return const IconThemeData(color: Colors.grey); // Kulrang tanlanmagan
      }),
      labelTextStyle: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return const TextStyle(
            color: Color(0xFF6C5CE7),
            fontWeight: FontWeight.w600,
          ); // Primary tanlangan
        }
        return const TextStyle(color: Colors.white70); // Shaffof oq tanlanmagan
      }),
    ),
  );
}
