import 'package:dar_plus_app/controller/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'local_provider.g.dart';

/// Provider for managing the app's locale state
@riverpod
class LocaleNotifier extends _$LocaleNotifier {
  @override
  Locale build() {
    // Initialize with the saved language code from SharedPreferences, fallback to 'en'
    final languageCode = SharedPerfManager().languageCode;
    final code = (languageCode.isNotEmpty) ? languageCode : 'en';
    return Locale(code);
  }

  /// Changes the app's locale and persists it to SharedPreferences
  void setLocale(Locale locale) {
    final code = (locale.languageCode.isNotEmpty) ? locale.languageCode : 'en';
    SharedPerfManager().languageCode = code;
    state = Locale(code);
  }

  /// Gets the current language code
  String get languageCode => state.languageCode;

  /// Checks if the current locale is RTL (Arabic)
  bool get isRTL => state.languageCode == 'ar';

  /// Gets the text direction based on current locale
  TextDirection get textDirection =>
      isRTL ? TextDirection.rtl : TextDirection.ltr;
}
