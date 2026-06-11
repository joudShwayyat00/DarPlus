import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/api_constants.dart';
import '../models/city_response.dart';
import '../models/country_response.dart';
import '../models/region_response.dart';

part 'location_service_client.g.dart';

@RestApi()
abstract class LocationServiceClient {
  factory LocationServiceClient(Dio dio, {String? baseUrl}) =
      _LocationServiceClient;

  @GET('${ApiConstants.countries}/{lang}')
  Future<CountryResponse> getCountries(@Path('lang') String lang);

  @GET('${ApiConstants.cities}/{countryId}/{lang}')
  Future<CityResponse> getCities(
    @Path('countryId') int countryId,
    @Path('lang') String lang,
  );

  @GET('${ApiConstants.regions}/{cityId}/{lang}')
  Future<RegionResponse> getRegions(
    @Path('cityId') int cityId,
    @Path('lang') String lang,
  );
}
