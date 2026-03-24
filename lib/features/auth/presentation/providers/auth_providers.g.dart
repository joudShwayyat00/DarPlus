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
    extends
        $NotifierProvider<RegisterController, AsyncValue<RegisterResponse?>> {
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

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<RegisterResponse?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<RegisterResponse?>>(
        value,
      ),
    );
  }
}

String _$registerControllerHash() =>
    r'c6b1adaed16c55f262e2cb334a27749252a25a2c';

abstract class _$RegisterController
    extends $Notifier<AsyncValue<RegisterResponse?>> {
  AsyncValue<RegisterResponse?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<RegisterResponse?>,
              AsyncValue<RegisterResponse?>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<RegisterResponse?>,
                AsyncValue<RegisterResponse?>
              >,
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
    extends $NotifierProvider<LoginController, AsyncValue<RegisterResponse?>> {
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

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<RegisterResponse?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<RegisterResponse?>>(
        value,
      ),
    );
  }
}

String _$loginControllerHash() => r'6ba46cf74b8f1c91773325bd9a246931313cf006';

abstract class _$LoginController
    extends $Notifier<AsyncValue<RegisterResponse?>> {
  AsyncValue<RegisterResponse?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<RegisterResponse?>,
              AsyncValue<RegisterResponse?>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<RegisterResponse?>,
                AsyncValue<RegisterResponse?>
              >,
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

String _$profileControllerHash() => r'f9ceb8b647bc24ac70c82cffa857bb0383b72a99';

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
        $NotifierProvider<
          ForgotPasswordController,
          AsyncValue<ForgotPasswordResponse?>
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

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<ForgotPasswordResponse?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<ForgotPasswordResponse?>>(
        value,
      ),
    );
  }
}

String _$forgotPasswordControllerHash() =>
    r'07550ec5bfe8cdc98f182fb89453b8dd44671c07';

abstract class _$ForgotPasswordController
    extends $Notifier<AsyncValue<ForgotPasswordResponse?>> {
  AsyncValue<ForgotPasswordResponse?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<ForgotPasswordResponse?>,
              AsyncValue<ForgotPasswordResponse?>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<ForgotPasswordResponse?>,
                AsyncValue<ForgotPasswordResponse?>
              >,
              AsyncValue<ForgotPasswordResponse?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
