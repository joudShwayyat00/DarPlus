import 'package:dar_plus_app/core/network/api_constants.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/register_response.dart';
import '../models/user_model.dart';
import '../models/logout_response.dart';
import '../models/delete_account_response.dart';
import '../models/forgot_password_response.dart';
import '../models/edit_profile_response.dart';
import '../models/update_password_response.dart';
import '../models/upload_image_response.dart';

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
    @Part(name: 'role') String role,
  );

  @POST(ApiConstants.login)
  @MultiPart()
  Future<RegisterResponse> login(@Part() String email, @Part() String password);

  @GET(ApiConstants.profile)
  Future<UserModel> getProfile();

  @POST(ApiConstants.logout)
  Future<LogoutResponse> logout();

  @POST(ApiConstants.deleteAccount)
  @MultiPart()
  Future<DeleteAccountResponse> deleteAccount(@Part() String password);

  @POST(ApiConstants.forgotPassword)
  @MultiPart()
  Future<ForgotPasswordResponse> forgotPassword(@Part() String email);

  @POST(ApiConstants.editProfile)
  @MultiPart()
  Future<EditProfileResponse> editProfile(
    @Part() String name,
    @Part() String email,
    @Part() String phoneNumber,
  );

  @POST(ApiConstants.updatePassword)
  @MultiPart()
  Future<UpdatePasswordResponse> updatePassword(
    @Part() String password,
    @Part(name: 'password_confirmation') String passwordConfirmation,
  );

  @POST(ApiConstants.uploadImage)
  @MultiPart()
  Future<UploadImageResponse> uploadImage(
    @Part(name: 'image') MultipartFile image,
  );
}
