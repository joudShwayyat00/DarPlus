import '../../data/models/register_response.dart';
import '../../data/models/user_model.dart';
import '../../data/models/logout_response.dart';
import '../../data/models/forgot_password_response.dart';
import '../../data/models/edit_profile_response.dart';
import '../../data/models/update_password_response.dart';

abstract class AuthRepository {
  Future<RegisterResponse> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String phoneNumber,
  });

  Future<RegisterResponse> login({
    required String email,
    required String password,
  });

  Future<UserModel> getProfile();

  Future<LogoutResponse> logout();
  Future<ForgotPasswordResponse> forgotPassword(String email);

  Future<EditProfileResponse> editProfile({
    required String name,
    required String email,
    required String phoneNumber,
  });

  Future<UpdatePasswordResponse> updatePassword({
    required String password,
    required String passwordConfirmation,
  });
}
