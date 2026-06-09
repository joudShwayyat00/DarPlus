import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dio/dio.dart';

import '../../../../controller/shared_prefs.dart';
import '../../../../core/network/dio_factory.dart';
import '../../data/data_sources/auth_service_client.dart';
import '../../data/models/register_response.dart';
import '../../data/models/user_model.dart';
import '../../data/models/forgot_password_response.dart';
import '../../data/models/edit_profile_response.dart';
import '../../data/models/update_password_response.dart';
import '../../data/models/upload_image_response.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';

part 'auth_providers.g.dart';

@riverpod
AuthServiceClient authServiceClient(Ref ref) {
  final dio = DioFactory.getDio();
  return AuthServiceClient(dio);
}

@riverpod
AuthRepository authRepository(Ref ref) {
  final authService = ref.watch(authServiceClientProvider);
  return AuthRepositoryImpl(authService);
}

@riverpod
class RegisterController extends _$RegisterController {
  @override
  FutureOr<RegisterResponse?> build() {
    return null;
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String phoneNumber,
    required String role,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard<RegisterResponse?>(() async {
      final repository = ref.read(authRepositoryProvider);
      final response = await repository.register(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        phoneNumber: phoneNumber,
        role: role,
      );

      // Save token and set logged in status
      final sharedPrefs = SharedPerfManager();
      sharedPrefs.token = response.accessToken;
      sharedPrefs.isLoggedIn = true;
      DioFactory.updateAuthToken();

      return response;
    });
  }
}

@riverpod
class LoginController extends _$LoginController {
  @override
  FutureOr<RegisterResponse?> build() {
    return null;
  }

  Future<void> login({required String email, required String password}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard<RegisterResponse?>(() async {
      final repository = ref.read(authRepositoryProvider);
      final response = await repository.login(email: email, password: password);

      // Save token and set logged in status
      final sharedPrefs = SharedPerfManager();
      sharedPrefs.token = response.accessToken;
      sharedPrefs.isLoggedIn = true;
      DioFactory.updateAuthToken();

      return response;
    });
  }
}

@riverpod
class ProfileController extends _$ProfileController {
  @override
  FutureOr<UserModel?> build() async {
    if (!SharedPerfManager().isLoggedIn) return null;
    final repository = ref.read(authRepositoryProvider);
    return await repository.getProfile();
  }

  Future<void> refreshProfile() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard<UserModel?>(() async {
      if (!SharedPerfManager().isLoggedIn) return null;
      final repository = ref.read(authRepositoryProvider);
      return await repository.getProfile();
    });
  }

  Future<void> logout() async {
    final repository = ref.read(authRepositoryProvider);
    await repository.logout();
    DioFactory.updateAuthToken();
    // After logout, the token and isLoggedIn are cleared in repository implementation
  }
}

@riverpod
class ForgotPasswordController extends _$ForgotPasswordController {
  @override
  FutureOr<ForgotPasswordResponse?> build() {
    return null;
  }

  Future<void> forgotPassword(String email) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard<ForgotPasswordResponse?>(() async {
      final repository = ref.read(authRepositoryProvider);
      return await repository.forgotPassword(email);
    });
  }
}

@riverpod
class EditProfileController extends _$EditProfileController {
  @override
  FutureOr<EditProfileResponse?> build() {
    return null;
  }

  Future<void> editProfile({
    required String name,
    required String email,
    required String phoneNumber,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard<EditProfileResponse?>(() async {
      final repository = ref.read(authRepositoryProvider);
      final response = await repository.editProfile(
        name: name,
        email: email,
        phoneNumber: phoneNumber,
      );

      return response;
    });
  }
}

@riverpod
class UpdatePasswordController extends _$UpdatePasswordController {
  @override
  FutureOr<UpdatePasswordResponse?> build() {
    return null;
  }

  Future<void> updatePassword({
    required String password,
    required String passwordConfirmation,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard<UpdatePasswordResponse?>(() async {
      final repository = ref.read(authRepositoryProvider);
      final response = await repository.updatePassword(
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
      return response;
    });
  }
}

@riverpod
class UploadImageController extends _$UploadImageController {
  @override
  FutureOr<UploadImageResponse?> build() {
    return null;
  }

  Future<void> uploadImage(String filePath) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard<UploadImageResponse?>(() async {
      final repository = ref.read(authRepositoryProvider);
      final multipartFile = await MultipartFile.fromFile(
        filePath,
        filename: filePath.split('/').last,
      );
      return await repository.uploadImage(multipartFile);
    });
  }
}
