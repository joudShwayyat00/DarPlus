import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../core/network/api_constants.dart';
import '../models/category_response.dart';

part 'category_service_client.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class CategoryServiceClient {
  factory CategoryServiceClient(Dio dio, {String baseUrl}) =
      _CategoryServiceClient;

  @GET("${ApiConstants.categories}/{lang}")
  Future<CategoryResponse> getCategories(@Path("lang") String lang);
}
