// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// API language code derived from the current app locale (`en` or `ar`).

@ProviderFor(apiLanguageCode)
const apiLanguageCodeProvider = ApiLanguageCodeProvider._();

/// API language code derived from the current app locale (`en` or `ar`).

final class ApiLanguageCodeProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  /// API language code derived from the current app locale (`en` or `ar`).
  const ApiLanguageCodeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'apiLanguageCodeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$apiLanguageCodeHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return apiLanguageCode(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$apiLanguageCodeHash() => r'2b5c2dc56482cdaef3e43cae5ba8bd1ae853d650';

/// Provider for managing the app's locale state

@ProviderFor(LocaleNotifier)
const localeProvider = LocaleNotifierProvider._();

/// Provider for managing the app's locale state
final class LocaleNotifierProvider
    extends $NotifierProvider<LocaleNotifier, Locale> {
  /// Provider for managing the app's locale state
  const LocaleNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localeNotifierHash();

  @$internal
  @override
  LocaleNotifier create() => LocaleNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Locale value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Locale>(value),
    );
  }
}

String _$localeNotifierHash() => r'7e8ce7154436f3d9687f55da597fbe60769284ce';

/// Provider for managing the app's locale state

abstract class _$LocaleNotifier extends $Notifier<Locale> {
  Locale build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Locale, Locale>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Locale, Locale>,
              Locale,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
