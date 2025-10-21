import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:housell/core/widgets/w__container.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/theme/app_colors.dart';
import '../constants/app_assets.dart';
import 'app_image.dart';
import 'app_text.dart';

class Language {
  final String name;
  final String flagAsset;
  final String code;
  final Locale locale;

  const Language({
    required this.name,
    required this.flagAsset,
    required this.code,
    required this.locale,
  });
}

class LanguageService {
  static const String _languageKey = 'selected_language';

  static Future<void> saveLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
  }

  static Future<String> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageKey) ?? 'uz';
  }
}

class WLanguageSelector extends StatelessWidget {
  final Function(Locale)? onLanguageChanged;
  final String? initialLanguageCode;

  const WLanguageSelector({
    super.key,
    this.onLanguageChanged,
    this.initialLanguageCode,
  });

  static const List<Language> languages = [
    Language(
      name: "English",
      flagAsset: AppAssets.cEng,
      code: 'en',
      locale: Locale('en'),
    ),
    Language(
      name: "Uzbek",
      flagAsset: AppAssets.cUz,
      code: 'uz',
      locale: Locale('uz'),
    ),
    Language(
      name: "Russian",
      flagAsset: AppAssets.cRus,
      code: 'ru',
      locale: Locale('ru'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final currentLanguageCode = initialLanguageCode ?? context.setLocale;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: languages.map((language) {
        final isSelected = currentLanguageCode == language.code;
        return _buildLanguageOption(context, language, isSelected);
      }).toList(),
    );
  }

  Widget _buildLanguageOption(BuildContext context, Language language, bool isSelected) {
    return InkWell(
      onTap: () async {
        // 1. SharedPreferences ga saqlash
        await LanguageService.saveLanguage(language.code);

        // 2. EasyLocalization ga o'rnatish (avtomatik rebuild)
        await context.setLocale(language.locale);

        // 3. Callback chaqirish
        onLanguageChanged?.call(language.locale);

        print("🔄 Til o'zgartirildi: ${language.name} (${language.code})");
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: ContainerW(
          width: double.infinity,
          height: 40.h,
          radius: 8,
          color: isSelected ? AppColors.base.withOpacity(0.2) : AppColors.white,
          child: Center(
            child: AppText(
              text: language.name,
              fontSize: 16,
              fontWeight: isSelected ? 600 : 400,
              color: isSelected ? AppColors.base : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}
