import 'package:dar_plus_app/core/network/api_constants.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/register_response.dart';
import '../models/user_model.dart';
import '../models/logout_response.dart';
import '../models/forgot_password_response.dart';

part 'auth_service_client.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class AuthServiceClient {
  factory AuthServiceClient(Dio dio, {String baseUrl}) = _AuthServiceClient;

  @POST(ApiConstants.register)
  @MultiPart()
  Future<RegisterResponse> register(
    @Part() String name,
    @Part() String email,
    @Part() String password,
    @Part(name: 'password_confirmation') String passwordConfirmation,
  @Part(name: 'phone_number') String phoneNumber,
  );

  @POST(ApiConstants.login)
  @MultiPart()
  Future<RegisterResponse> login(
    @Part() String email,
    @Part() String password,
  );

  @GET(ApiConstants.profile)
  Future<UserModel> getProfile();

  @POST(ApiConstants.logout)
  Future<LogoutResponse> logout();

  @POST(ApiConstants.forgotPassword)
  Future<ForgotPasswordResponse> forgotPassword(
    @Field("email") String email,
  );
}
