import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../controller/shared_prefs.dart';
import '../../../../core/network/dio_factory.dart';
import '../../data/data_sources/auth_service_client.dart';
import '../../data/models/register_response.dart';
import '../../data/models/user_model.dart';
import '../../data/models/forgot_password_response.dart';
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
  AsyncValue<RegisterResponse?> build() {
    return const AsyncData(null);
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String phoneNumber,
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
      );

      // Save token and set logged in status
      final sharedPrefs = SharedPerfManager();
      sharedPrefs.token = response.accessToken;
      sharedPrefs.isLoggedIn = true;

      return response;
    });
  }
}

@riverpod
class LoginController extends _$LoginController {
  @override
  AsyncValue<RegisterResponse?> build() {
    return const AsyncData(null);
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard<RegisterResponse?>(() async {
      final repository = ref.read(authRepositoryProvider);
      final response = await repository.login(
        email: email,
        password: password,
      );

      // Save token and set logged in status
      final sharedPrefs = SharedPerfManager();
      sharedPrefs.token = response.accessToken;
      sharedPrefs.isLoggedIn = true;

      return response;
    });
  }
}

@riverpod
class ProfileController extends _$ProfileController {
  @override
  FutureOr<UserModel> build() async {
    final repository = ref.read(authRepositoryProvider);
    return await repository.getProfile();
  }

  Future<void> refreshProfile() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard<UserModel>(() async {
      final repository = ref.read(authRepositoryProvider);
      return await repository.getProfile();
    });
  }

  Future<void> logout() async {
    final repository = ref.read(authRepositoryProvider);
    await repository.logout();
    // After logout, the token and isLoggedIn are cleared in repository implementation
  }
}

@riverpod
class ForgotPasswordController extends _$ForgotPasswordController {
  @override
  AsyncValue<ForgotPasswordResponse?> build() {
    return const AsyncData(null);
  }

  Future<void> forgotPassword(String email) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard<ForgotPasswordResponse?>(() async {
      final repository = ref.read(authRepositoryProvider);
      return await repository.forgotPassword(email);
    });
  }
}
