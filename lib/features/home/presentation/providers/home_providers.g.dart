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

@ProviderFor(categoryServiceClient)
const categoryServiceClientProvider = CategoryServiceClientProvider._();

final class CategoryServiceClientProvider
    extends
        $FunctionalProvider<
          CategoryServiceClient,
          CategoryServiceClient,
          CategoryServiceClient
        >
    with $Provider<CategoryServiceClient> {
  const CategoryServiceClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoryServiceClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoryServiceClientHash();

  @$internal
  @override
  $ProviderElement<CategoryServiceClient> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CategoryServiceClient create(Ref ref) {
    return categoryServiceClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CategoryServiceClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CategoryServiceClient>(value),
    );
  }
}

String _$categoryServiceClientHash() =>
    r'a80c544db3e32d64ec4becb66fc52d309bf5e7f2';

@ProviderFor(categoryRepository)
const categoryRepositoryProvider = CategoryRepositoryProvider._();

final class CategoryRepositoryProvider
    extends
        $FunctionalProvider<
          CategoryRepository,
          CategoryRepository,
          CategoryRepository
        >
    with $Provider<CategoryRepository> {
  const CategoryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoryRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoryRepositoryHash();

  @$internal
  @override
  $ProviderElement<CategoryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CategoryRepository create(Ref ref) {
    return categoryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CategoryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CategoryRepository>(value),
    );
  }
}

String _$categoryRepositoryHash() =>
    r'aacf5805a4a4e4c04407b8e7491b9c2c3afad343';

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
    r'40b0c2d4181766ddde75a9399cb322ec788932d3';

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

@ProviderFor(HomeCategoryController)
const homeCategoryControllerProvider = HomeCategoryControllerProvider._();

final class HomeCategoryControllerProvider
    extends $AsyncNotifierProvider<HomeCategoryController, List<CategoryItem>> {
  const HomeCategoryControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeCategoryControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeCategoryControllerHash();

  @$internal
  @override
  HomeCategoryController create() => HomeCategoryController();
}

String _$homeCategoryControllerHash() =>
    r'a7e884f18bca031effcbbeb563fa200047cdee0d';

abstract class _$HomeCategoryController
    extends $AsyncNotifier<List<CategoryItem>> {
  FutureOr<List<CategoryItem>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<List<CategoryItem>>, List<CategoryItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<CategoryItem>>, List<CategoryItem>>,
              AsyncValue<List<CategoryItem>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
