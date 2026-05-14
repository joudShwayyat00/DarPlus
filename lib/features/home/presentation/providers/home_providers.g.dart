// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(sliderServiceClient)
const sliderServiceClientProvider = SliderServiceClientProvider._();

final class SliderServiceClientProvider
    extends
        $FunctionalProvider<
          SliderServiceClient,
          SliderServiceClient,
          SliderServiceClient
        >
    with $Provider<SliderServiceClient> {
  const SliderServiceClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sliderServiceClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sliderServiceClientHash();

  @$internal
  @override
  $ProviderElement<SliderServiceClient> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SliderServiceClient create(Ref ref) {
    return sliderServiceClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SliderServiceClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SliderServiceClient>(value),
    );
  }
}

String _$sliderServiceClientHash() =>
    r'16671ba0bcef890000d12192285de83071feb716';

@ProviderFor(homeRepository)
const homeRepositoryProvider = HomeRepositoryProvider._();

final class HomeRepositoryProvider
    extends $FunctionalProvider<HomeRepository, HomeRepository, HomeRepository>
    with $Provider<HomeRepository> {
  const HomeRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeRepositoryHash();

  @$internal
  @override
  $ProviderElement<HomeRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  HomeRepository create(Ref ref) {
    return homeRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HomeRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HomeRepository>(value),
    );
  }
}

String _$homeRepositoryHash() => r'349f84f31e63bfc238fc4cf079a1684068362e20';

@ProviderFor(HomeSliderController)
const homeSliderControllerProvider = HomeSliderControllerProvider._();

final class HomeSliderControllerProvider
    extends $AsyncNotifierProvider<HomeSliderController, List<SliderItem>> {
  const HomeSliderControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeSliderControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeSliderControllerHash();

  @$internal
  @override
  HomeSliderController create() => HomeSliderController();
}

String _$homeSliderControllerHash() =>
    r'4f69005066022f0d852c6d718da4378c2c62efe7';

abstract class _$HomeSliderController extends $AsyncNotifier<List<SliderItem>> {
  FutureOr<List<SliderItem>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<List<SliderItem>>, List<SliderItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<SliderItem>>, List<SliderItem>>,
              AsyncValue<List<SliderItem>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
