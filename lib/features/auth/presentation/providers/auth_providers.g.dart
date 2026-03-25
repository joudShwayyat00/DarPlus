// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(authServiceClient)
const authServiceClientProvider = AuthServiceClientProvider._();

final class AuthServiceClientProvider
    extends
        $FunctionalProvider<
          AuthServiceClient,
          AuthServiceClient,
          AuthServiceClient
        >
    with $Provider<AuthServiceClient> {
  const AuthServiceClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authServiceClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authServiceClientHash();

  @$internal
  @override
  $ProviderElement<AuthServiceClient> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AuthServiceClient create(Ref ref) {
    return authServiceClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthServiceClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthServiceClient>(value),
    );
  }
}

String _$authServiceClientHash() => r'603627e22bb33ddf0788b42b9ea253f17b6e895a';

@ProviderFor(authRepository)
const authRepositoryProvider = AuthRepositoryProvider._();

final class AuthRepositoryProvider
    extends $FunctionalProvider<AuthRepository, AuthRepository, AuthRepository>
    with $Provider<AuthRepository> {
  const AuthRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authRepositoryHash();

  @$internal
  @override
  $ProviderElement<AuthRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthRepository create(Ref ref) {
    return authRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthRepository>(value),
    );
  }
}

String _$authRepositoryHash() => r'78ac713939f0c35741c5b74c13527c19c8f2d2a5';

@ProviderFor(RegisterController)
const registerControllerProvider = RegisterControllerProvider._();

final class RegisterControllerProvider
    extends $AsyncNotifierProvider<RegisterController, RegisterResponse?> {
  const RegisterControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'registerControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$registerControllerHash();

  @$internal
  @override
  RegisterController create() => RegisterController();
}

String _$registerControllerHash() =>
    r'10f195ab8bc9efe165338c62a0bc4eb8339c2bb5';

abstract class _$RegisterController extends $AsyncNotifier<RegisterResponse?> {
  FutureOr<RegisterResponse?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<RegisterResponse?>, RegisterResponse?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<RegisterResponse?>, RegisterResponse?>,
              AsyncValue<RegisterResponse?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(LoginController)
const loginControllerProvider = LoginControllerProvider._();

final class LoginControllerProvider
    extends $AsyncNotifierProvider<LoginController, RegisterResponse?> {
  const LoginControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loginControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loginControllerHash();

  @$internal
  @override
  LoginController create() => LoginController();
}

String _$loginControllerHash() => r'c51c5ce51f3cfe4e7980877cc24377dc2ad1a2a5';

abstract class _$LoginController extends $AsyncNotifier<RegisterResponse?> {
  FutureOr<RegisterResponse?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<RegisterResponse?>, RegisterResponse?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<RegisterResponse?>, RegisterResponse?>,
              AsyncValue<RegisterResponse?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(ProfileController)
const profileControllerProvider = ProfileControllerProvider._();

final class ProfileControllerProvider
    extends $AsyncNotifierProvider<ProfileController, UserModel> {
  const ProfileControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileControllerHash();

  @$internal
  @override
  ProfileController create() => ProfileController();
}

String _$profileControllerHash() => r'2e779025f0602994e8a259abea3139395dfafe6b';

abstract class _$ProfileController extends $AsyncNotifier<UserModel> {
  FutureOr<UserModel> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<UserModel>, UserModel>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<UserModel>, UserModel>,
              AsyncValue<UserModel>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(ForgotPasswordController)
const forgotPasswordControllerProvider = ForgotPasswordControllerProvider._();

final class ForgotPasswordControllerProvider
    extends
        $AsyncNotifierProvider<
          ForgotPasswordController,
          ForgotPasswordResponse?
        > {
  const ForgotPasswordControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'forgotPasswordControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$forgotPasswordControllerHash();

  @$internal
  @override
  ForgotPasswordController create() => ForgotPasswordController();
}

String _$forgotPasswordControllerHash() =>
    r'899f89592a98c46704a93d37f125a891fe2c97af';

abstract class _$ForgotPasswordController
    extends $AsyncNotifier<ForgotPasswordResponse?> {
  FutureOr<ForgotPasswordResponse?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<ForgotPasswordResponse?>,
              ForgotPasswordResponse?
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<ForgotPasswordResponse?>,
                ForgotPasswordResponse?
              >,
              AsyncValue<ForgotPasswordResponse?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(EditProfileController)
const editProfileControllerProvider = EditProfileControllerProvider._();

final class EditProfileControllerProvider
    extends
        $AsyncNotifierProvider<EditProfileController, EditProfileResponse?> {
  const EditProfileControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'editProfileControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$editProfileControllerHash();

  @$internal
  @override
  EditProfileController create() => EditProfileController();
}

String _$editProfileControllerHash() =>
    r'5c3da3af71a906fa432516eeff480746a6b85244';

abstract class _$EditProfileController
    extends $AsyncNotifier<EditProfileResponse?> {
  FutureOr<EditProfileResponse?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<AsyncValue<EditProfileResponse?>, EditProfileResponse?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<EditProfileResponse?>,
                EditProfileResponse?
              >,
              AsyncValue<EditProfileResponse?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
