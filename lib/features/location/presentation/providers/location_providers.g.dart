// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(locationServiceClient)
const locationServiceClientProvider = LocationServiceClientProvider._();

final class LocationServiceClientProvider
    extends
        $FunctionalProvider<
          LocationServiceClient,
          LocationServiceClient,
          LocationServiceClient
        >
    with $Provider<LocationServiceClient> {
  const LocationServiceClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'locationServiceClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$locationServiceClientHash();

  @$internal
  @override
  $ProviderElement<LocationServiceClient> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LocationServiceClient create(Ref ref) {
    return locationServiceClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocationServiceClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocationServiceClient>(value),
    );
  }
}

String _$locationServiceClientHash() =>
    r'25a4e775054c06f0d8567566980fb8c9c23bb8bd';

/// All countries — cached for the session.

@ProviderFor(countries)
const countriesProvider = CountriesProvider._();

/// All countries — cached for the session.

final class CountriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CountryItem>>,
          List<CountryItem>,
          FutureOr<List<CountryItem>>
        >
    with
        $FutureModifier<List<CountryItem>>,
        $FutureProvider<List<CountryItem>> {
  /// All countries — cached for the session.
  const CountriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'countriesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$countriesHash();

  @$internal
  @override
  $FutureProviderElement<List<CountryItem>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CountryItem>> create(Ref ref) {
    return countries(ref);
  }
}

String _$countriesHash() => r'9fa27c85676ce385f190dcbedd0692e749837a28';

/// Cities for a specific [countryId] — fetched on demand.

@ProviderFor(cities)
const citiesProvider = CitiesFamily._();

/// Cities for a specific [countryId] — fetched on demand.

final class CitiesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CityItem>>,
          List<CityItem>,
          FutureOr<List<CityItem>>
        >
    with $FutureModifier<List<CityItem>>, $FutureProvider<List<CityItem>> {
  /// Cities for a specific [countryId] — fetched on demand.
  const CitiesProvider._({
    required CitiesFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'citiesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$citiesHash();

  @override
  String toString() {
    return r'citiesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<CityItem>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CityItem>> create(Ref ref) {
    final argument = this.argument as int;
    return cities(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CitiesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$citiesHash() => r'e5e03fafb4074b936aba669e89c1bb792c5d1332';

/// Cities for a specific [countryId] — fetched on demand.

final class CitiesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<CityItem>>, int> {
  const CitiesFamily._()
    : super(
        retry: null,
        name: r'citiesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Cities for a specific [countryId] — fetched on demand.

  CitiesProvider call(int countryId) =>
      CitiesProvider._(argument: countryId, from: this);

  @override
  String toString() => r'citiesProvider';
}

/// Regions for a specific [cityId] — fetched on demand.

@ProviderFor(regions)
const regionsProvider = RegionsFamily._();

/// Regions for a specific [cityId] — fetched on demand.

final class RegionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<RegionItem>>,
          List<RegionItem>,
          FutureOr<List<RegionItem>>
        >
    with $FutureModifier<List<RegionItem>>, $FutureProvider<List<RegionItem>> {
  /// Regions for a specific [cityId] — fetched on demand.
  const RegionsProvider._({
    required RegionsFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'regionsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$regionsHash();

  @override
  String toString() {
    return r'regionsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<RegionItem>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<RegionItem>> create(Ref ref) {
    final argument = this.argument as int;
    return regions(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RegionsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$regionsHash() => r'a1b2c3d4e5f6789012345678abcdef9012345678';

/// Regions for a specific [cityId] — fetched on demand.

final class RegionsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<RegionItem>>, int> {
  const RegionsFamily._()
    : super(
        retry: null,
        name: r'regionsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Regions for a specific [cityId] — fetched on demand.

  RegionsProvider call(int cityId) =>
      RegionsProvider._(argument: cityId, from: this);

  @override
  String toString() => r'regionsProvider';
}
