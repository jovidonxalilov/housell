import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

class WLanguageSelector extends StatefulWidget {
  final Function(Locale)? onLanguageChanged;
  final String? initialLanguageCode;

  const WLanguageSelector({
    super.key,
    this.onLanguageChanged,
    this.initialLanguageCode,
  });

  @override
  State<WLanguageSelector> createState() => _WLanguageSelectorState();
}

class _WLanguageSelectorState extends State<WLanguageSelector> {
  late Language selectedLanguage;

  final List<Language> languages = const [
    Language(
      name: "O'zbek",
      flagAsset: AppAssets.cUz,
      code: 'uz',
      locale: Locale('uz'),
    ),
    Language(
      name: "Русский",
      flagAsset: AppAssets.cRus,
      code: 'ru',
      locale: Locale('ru'),
    ),
    Language(
      name: "English",
      flagAsset: AppAssets.cEng,
      code: 'en',
      locale: Locale('en'),
    ),
  ];

  @override
  void initState() {
    super.initState();
    selectedLanguage = languages.firstWhere(
          (lang) => lang.code == (widget.initialLanguageCode ?? 'uz'),
      orElse: () => languages.first,
    );
    print("🚀 Boshlang‘ich til: ${selectedLanguage.name} (${selectedLanguage.code})");
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38.h,
      width: 136.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Language>(
          value: selectedLanguage,
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.grey300,
            size: 20,
          ),
          isExpanded: true,
          dropdownColor: Colors.white,
          elevation: 8,
          borderRadius: BorderRadius.circular(12),
          onChanged: (Language? newLanguage) {
            if (newLanguage != null) {
              print("🔄 Yangi til tanlandi: ${newLanguage.name} (${newLanguage.code})");
              setState(() {
                selectedLanguage = newLanguage;
              });

              if (widget.onLanguageChanged != null) {
                print("📢 Callback chaqirilmoqda Locale: ${newLanguage.locale}");
                widget.onLanguageChanged!(newLanguage.locale);
              } else {
                print("⚠️ onLanguageChanged callback null, chaqirilmadi!");
              }
            }
          },
          selectedItemBuilder: (BuildContext context) {
            return languages.map((Language language) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppImage(
                    path: language.flagAsset,
                    size: 18,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: AppText(
                      text: language.name,
                      color: AppColors.black,
                      fontSize: 14,
                      fontWeight: 500,
                    ),
                  ),
                ],
              );
            }).toList();
          },
          items: languages.map((Language language) {
            return DropdownMenuItem<Language>(
              value: language,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    AppImage(
                      path: language.flagAsset,
                      size: 20,
                    ),
                    SizedBox(width: 12.w),
                    AppText(
                      text: language.name,
                      color: AppColors.black,
                      fontSize: 14,
                      fontWeight: selectedLanguage.code == language.code ? 600 : 400,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

