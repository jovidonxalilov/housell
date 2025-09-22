import 'package:flutter/services.dart';

// Phone formatter class
class PhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    String text = newValue.text;

    String digitsOnly = text.replaceAll(RegExp(r'\D'), '');

    if (!digitsOnly.startsWith('998')) {
      if (digitsOnly.length > 0) {
        digitsOnly = '998$digitsOnly';
      } else {
        digitsOnly = '998';
      }
    }

    // Maksimal 12 ta raqam (998 + 9 ta raqam)
    if (digitsOnly.length > 12) {
      digitsOnly = digitsOnly.substring(0, 12);
    }

    // Formatlash (faqat bo'shliq bilan)
    String formatted = '';
    if (digitsOnly.length >= 3) {
      formatted = '+${digitsOnly.substring(0, 3)}';
      if (digitsOnly.length > 3) {
        formatted += ' ${digitsOnly.substring(3, digitsOnly.length > 5 ? 5 : digitsOnly.length)}';
      }
      if (digitsOnly.length > 5) {
        formatted += ' ${digitsOnly.substring(5, digitsOnly.length > 8 ? 8 : digitsOnly.length)}';
      }
      if (digitsOnly.length > 8) {
        formatted += ' ${digitsOnly.substring(8, digitsOnly.length > 10 ? 10 : digitsOnly.length)}';
      }
      if (digitsOnly.length > 10) {
        formatted += ' ${digitsOnly.substring(10)}';
      }
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
