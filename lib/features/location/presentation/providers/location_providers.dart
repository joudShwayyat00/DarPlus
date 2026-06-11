import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../controller/local_provider.dart';
import '../../../../core/network/dio_factory.dart';
import '../../data/data_sources/location_service_client.dart';
import '../../data/models/city_item.dart';
import '../../data/models/country_item.dart';
import '../../data/models/region_item.dart';

part 'location_providers.g.dart';

@riverpod
LocationServiceClient locationServiceClient(Ref ref) {
  final dio = DioFactory.getDio();
  return LocationServiceClient(dio);
}

/// All countries — cached for the session.
@riverpod
Future<List<CountryItem>> countries(Ref ref) async {
  final lang = ref.read(localeProvider).languageCode;
  final client = ref.read(locationServiceClientProvider);
  final response = await client.getCountries(lang);
  return response.result;
}

/// Cities for a specific [countryId] — fetched on demand.
@riverpod
Future<List<CityItem>> cities(Ref ref, int countryId) async {
  final lang = ref.read(localeProvider).languageCode;
  final client = ref.read(locationServiceClientProvider);
  final response = await client.getCities(countryId, lang);
  return response.items;
}

/// Regions for a specific [cityId] — fetched on demand.
@riverpod
Future<List<RegionItem>> regions(Ref ref, int cityId) async {
  final lang = ref.read(localeProvider).languageCode;
  final client = ref.read(locationServiceClientProvider);
  final response = await client.getRegions(cityId, lang);
  return response.items;
}
