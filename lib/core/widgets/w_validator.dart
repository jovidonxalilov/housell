
/// Validatorlar to'plami
class Validators {
  // --- Telefon raqami validatorlari ---

  /// E.164 (xalqaro) format: + va 8–15 ta raqam (masalan: +14155552671)
  static final RegExp _e164 = RegExp(r'^\+[1-9]\d{7,14}$');

  /// O‘zbekiston raqami: +998 (xx) xxx xx xx yoki +998xxxxxxxxx (9 raqamdan keyin jami 12)
  /// Operator kodlari: 90, 91, 93, 94, 95, 97, 98, 99, 33, 88
  static final RegExp _uzPhoneCompact =
  RegExp(r'^\+998(90|91|93|94|95|97|98|99|33|88)\d{7}$');

  /// Bo'shliqlar, chiziqchalar bilan kiritilgan O‘zbekiston raqamini ham qabul qilish
  static final RegExp _uzPhoneFlexible = RegExp(
    r'^\+998[\s-]?(90|91|93|94|95|97|98|99|33|88)[\s-]?\d{3}[\s-]?\d{2}[\s-]?\d{2}$',
  );

  /// FormField uchun: telefon raqami (E.164 yoki O‘zbek raqami) validator
  static String? phone(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Telefon raqami yoki email kiriting';

    // Email formatini tekshirish
    if (v.contains('@')) {
      // Email bo'lishi kerak
      if (v.endsWith('@gmail.com')) {
        // @gmail.com dan oldingi qismni tekshirish
        String beforeAt = v.substring(0, v.length - 10); // @gmail.com ni olib tashlash

        if (beforeAt.isEmpty) {
          return 'Email manzili noto\'g\'ri';
        }

        // Kamida 1 ta harf borligini tekshirish
        bool hasLetter = RegExp(r'[a-zA-Z]').hasMatch(beforeAt);
        if (!hasLetter) {
          return 'Email manzilida kamida 1 ta harf bo\'lishi kerak';
        }

        // Email format tekshiruvi
        final emailRegex = RegExp(r'^[a-zA-Z0-9._-]+@gmail\.com$');
        if (!emailRegex.hasMatch(v)) {
          return 'Email manzili noto\'g\'ri formatda';
        }

        return null; // Email to'g'ri
      } else {
        return 'Faqat @gmail.com manzillariga ruxsat beriladi';
      }
    }

    // Telefon raqami tekshiruvi
    if (v.startsWith('+998')) {
      // +998 dan keyingi raqamlarni tekshirish
      String afterPrefix = v.substring(4); // +998 ni olib tashlash

      // Bo'shliq va tireni olib tashlash
      String cleanNumber = afterPrefix.replaceAll(RegExp(r'[\s-]'), '');

      // Faqat raqamlar borligini tekshirish
      if (!RegExp(r'^[0-9]*$').hasMatch(cleanNumber)) {
        return 'Telefon raqamida faqat raqamlar bo\'lishi kerak';
      }

      // Aynan 9 ta raqam borligini tekshirish
      if (cleanNumber.length < 9) {
        return '+998 dan keyin 9 ta raqam kiriting';
      } else if (cleanNumber.length > 9) {
        return 'Telefon raqami juda uzun';
      }

      return null; // Telefon to'g'ri
    }

    // Agar +998 bilan boshlanmasa va @ yo'q bo'lsa
    // Kengaytirilgan O'zbek formati bo'lsa, bo'shliqlarni olib yana tekshiramiz
    if (_uzPhoneFlexible.hasMatch(v)) {
      final compact = v.replaceAll(RegExp(r'[\s-]'), '');
      if (_uzPhoneCompact.hasMatch(compact)) return null;
    }
    // To'g'ridan-to'g'ri E.164 yoki O'zbek compact
    if (_e164.hasMatch(v) || _uzPhoneCompact.hasMatch(v)) return null;

    return 'Telefon raqam yoki elektron pochtas';
  }

  // --- Parol validatorlari ---

  static final Set<String> _commonPasswords = {
    '123456','123456789','qwerty','password','111111','12345678',
    'abc123','1234567','123123','1q2w3e4r','qwerty123','admin',
  };

  static final RegExp _hasUpper = RegExp(r'[A-Z]');
  static final RegExp _hasLower = RegExp(r'[a-z]');
  static final RegExp _hasDigit = RegExp(r'\d');
  // static final RegExp _hasSpecial = RegExp(r'[!@#\$%\^&\*\(\)_\+\-\=\{\}\[\]\|\\:;\"\'<>,\.\?/~`]');
  static final RegExp _hasWhitespace = RegExp(r'\s');

  /// Kuchsiz ketma-ketliklarni aniqlash (aaa, 1111, abcd, 1234, qwerty)
  static bool _looksSequential(String s) {
    if (s.length < 4) return false;

    // Bir xil belgidan iborat ketma-ketlik (aaaa, 1111)
    if (RegExp(r'^(.)\1{3,}$').hasMatch(s)) return true;

    // Alfavit va raqam ketma-ketliklari (abcd, 1234, abcd1234)
    const alpha = 'abcdefghijklmnopqrstuvwxyz';
    const digits = '0123456789';

    String lower = s.toLowerCase();

    // 4 uzunlikdagi slidlar bo‘yicha tekshirish
    for (int i = 0; i <= lower.length - 4; i++) {
      final chunk = lower.substring(i, i + 4);
      if (alpha.contains(chunk) || alpha.split('').reversed.join().contains(chunk)) {
        return true;
      }
      if (digits.contains(chunk) || digits.split('').reversed.join().contains(chunk)) {
        return true;
      }
    }

    // Klaviatura ketma-ketliklari
    const keyboardRows = [
      'qwertyuiop',
      'asdfghjkl',
      'zxcvbnm',
    ];
    for (final row in keyboardRows) {
      for (int i = 0; i <= lower.length - 4; i++) {
        final chunk = lower.substring(i, i + 4);
        if (row.contains(chunk) || row.split('').reversed.join().contains(chunk)) {
          return true;
        }
      }
    }
    return false;
  }

  /// Parol kuchini ballash (0..6)
  ///  +1: uzunlik >= 12
  ///  +1: katta harf
  ///  +1: kichik harf
  ///  +1: raqam
  ///  +1: maxsus belgi
  ///  +1: takror/ketma-ketlik yo‘q
  static int passwordStrengthScore(String s) {
    int score = 0;
    if (s.length >= 12) score++;
    if (_hasUpper.hasMatch(s)) score++;
    if (_hasLower.hasMatch(s)) score++;
    if (_hasDigit.hasMatch(s)) score++;
    // if (_hasSpecial.hasMatch(s)) score++;
    if (!_looksSequential(s)) score++;
    return score;
  }

  /// FormField uchun: kuchli parol validator
  /// Qoidalar:
  ///  - Minimal 10 ta belgi (12 tavsiya)
  ///  - Kamida 1 ta katta, 1 ta kichik harf
  ///  - Kamida 1 ta raqam
  ///  - Kamida 1 ta maxsus belgi
  ///  - Bo‘sh joy yo‘q
  ///  - Juda oddiy/ketma-ket parollar rad etiladi
  static String? password(String? value, {bool strict = true}) {
    final v = value ?? '';
    if (v.isEmpty) return 'Parolni kiriting';

    if (_hasWhitespace.hasMatch(v)) {
      return 'Parolda bo‘sh joy bo‘lmasin';
    }
    if (v.length < (strict ? 12 : 10)) {
      return 'Parol ${strict ? 12 : 10} ta belgidan kam bo‘lmasin';
    }
    if (!_hasUpper.hasMatch(v)) return 'Kamida 1 ta KATTA harf qo‘shing (A–Z)';
    if (!_hasLower.hasMatch(v)) return 'Kamida 1 ta kichik harf qo‘shing (a–z)';
    if (!_hasDigit.hasMatch(v)) return 'Kamida 1 ta raqam qo‘shing (0–9)';
    // if (!_hasSpecial.hasMatch(v)) {
    //   return 'Kamida 1 ta maxsus belgi qo‘shing (!@#\$%^&* va hok.)';
    // }

    final lower = v.toLowerCase();
    if (_commonPasswords.contains(lower)) {
      return 'Bu parol juda ommabop. Boshqasini tanlang.';
    }
    if (_looksSequential(lower)) {
      return 'Parol juda ketma-ket yoki takroriy. Murakkabroq tanlang.';
    }

    // Minimal kuch talabi: 4+
    if (passwordStrengthScore(v) < (strict ? 5 : 4)) {
      return 'Parol yetarlicha kuchli emas. Murakkabroq kombinatsiya tanlang.';
    }

    return null;
  }

  /// Parolni tasdiqlash (confirm password)
  static String? confirmPassword(String? value, String original) {
    if ((value ?? '').isEmpty) return 'Parolni qayta kiriting';
    if (value != original) return 'Parollar mos kelmadi';
    return null;
  }
}
class SimpleValidators {
  static String? phone(String? value) {
    final v = value?.trim() ?? '';

    // Bo'sh bo'lsa
    if (v.isEmpty) return 'Telefon raqamini kiriting';

    // +998 bilan boshlanishini tekshirish
    if (!v.startsWith('+998')) {
      return 'Telefon raqami +998 bilan boshlanishi kerak';
    }

    // +998 dan keyingi qismni olish
    String afterPrefix = v.substring(4); // +998 ni olib tashlash

    // Bo'shliq va tireni olib tashlash
    String cleanNumber = afterPrefix.replaceAll(RegExp(r'[\s-]'), '');

    // Faqat raqamlar borligini tekshirish
    if (!RegExp(r'^[0-9]+$').hasMatch(cleanNumber)) {
      return 'Telefon raqamida faqat raqamlar bo\'lishi kerak';
    }

    // Aynan 9 ta raqam borligini tekshirish
    if (cleanNumber.length < 9) {
      return '+998 dan keyin 9 ta raqam kiriting';
    } else if (cleanNumber.length > 9) {
      return 'Telefon raqami juda uzun';
    }

    return null; // Telefon to'g'ri
  }
  static String? password(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Parolni kiriting';
    if (v.length < 6) return 'Parol 6 ta belgidan kam bo‘lmasin';
    return null;
  }

  static String? validateText(
      String? value, {
        int minLength = 50,
        String errorText = "Matn kamida 10 ta belgidan iborat bo‘lishi kerak",
      }) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Matnni kiriting';

    // Har qanday belgiga ruxsat beriladi (hech qanday regex yo‘q)

    if (v.length < minLength) {
      return errorText;
    }

    return null;
  }


  static String? numberInRange(String? value, {int min = 0, int max = 100}) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Raqam kiriting';
    if (int.tryParse(v) == null) return 'Faqat raqam kiriting';
    final number = int.parse(v);
    if (number < min || number > max) {
      return 'Raqam $min dan katta va $max dan kichik bo‘lishi kerak';
    }
    return null;
  }
  static String? notEmptyIfFilled(String? value, {String errorText = 'Xato qiymat kiritildi'}) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return errorText;
    return null;
  }

}