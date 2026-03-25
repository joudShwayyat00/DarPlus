import '../../domain/repositories/auth_repository.dart';
import '../data_sources/auth_service_client.dart';
import '../models/register_response.dart';
import '../models/user_model.dart';
import '../models/logout_response.dart';
import '../models/forgot_password_response.dart';
import '../models/edit_profile_response.dart';
import '../../../../controller/shared_prefs.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthServiceClient _authServiceClient;

  AuthRepositoryImpl(this._authServiceClient);

  @override
  Future<RegisterResponse> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String phoneNumber,
  }) async {
    final response = await _authServiceClient.register(
      name,
      email,
      password,
      passwordConfirmation,
      phoneNumber,
    );
    // Save token and set logged in
    SharedPerfManager().token = response.accessToken;
    SharedPerfManager().isLoggedIn = true;
    return response;
  }

  @override
  Future<RegisterResponse> login({
    required String email,
    required String password,
  }) async {
    final response = await _authServiceClient.login(email, password);
    // Save token and set logged in
    SharedPerfManager().token = response.accessToken;
    SharedPerfManager().isLoggedIn = true;
    return response;
  }

  @override
  Future<UserModel> getProfile() async {
    return await _authServiceClient.getProfile();
  }

  @override
  Future<LogoutResponse> logout() async {
    final response = await _authServiceClient.logout();
    if (response.status) {
      SharedPerfManager().token = '';
      SharedPerfManager().isLoggedIn = false;
    }
    return response;
  }

  @override
  Future<ForgotPasswordResponse> forgotPassword(String email) async {
    return await _authServiceClient.forgotPassword(email);
  }

  @override
  Future<EditProfileResponse> editProfile({
    required String name,
    required String email,
    required String phoneNumber,
  }) async {
    final response = await _authServiceClient.editProfile(
      name,
      email,
      phoneNumber,
    );

    return response;
  }
}
