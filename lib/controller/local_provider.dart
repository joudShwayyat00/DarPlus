import 'package:dar_plus_app/controller/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'local_provider.g.dart';

/// Normalizes any locale/language input to the API path segment: `en` or `ar`.
String normalizeApiLangCode(String code) {
  final normalized = code.trim().toLowerCase();
  if (normalized == 'ar' || normalized.startsWith('ar_')) return 'ar';
  return 'en';
}

/// API language code derived from the current app locale (`en` or `ar`).
@riverpod
String apiLanguageCode(Ref ref) {
  final locale = ref.watch(localeProvider);
  return normalizeApiLangCode(locale.languageCode);
}

/// Provider for managing the app's locale state
@riverpod
class LocaleNotifier extends _$LocaleNotifier {
  @override
  Locale build() {
    final languageCode = SharedPerfManager().languageCode;
    final code = normalizeApiLangCode(
      languageCode.isNotEmpty ? languageCode : 'en',
    );
    return Locale(code);
  }

  /// Changes the app's locale and persists it to SharedPreferences
  void setLocale(Locale locale) {
    final code = normalizeApiLangCode(locale.languageCode);
    if (code == state.languageCode) return;
    SharedPerfManager().languageCode = code;
    state = Locale(code);
  }

  /// Gets the current language code (`en` or `ar`)
  String get languageCode => state.languageCode;

  /// Language code for API URL path segments (`en` or `ar`)
  String get apiLangCode => normalizeApiLangCode(state.languageCode);

  /// Checks if the current locale is RTL (Arabic)
  bool get isRTL => state.languageCode == 'ar';

  /// Gets the text direction based on current locale
  TextDirection get textDirection =>
      isRTL ? TextDirection.rtl : TextDirection.ltr;
}
