# API Implementation Guide for Dar Plus App

This document serves as a reference for implementing new APIs in the Dar Plus Flutter application. It follows a clean architecture approach using **Dio**, **Retrofit**, and **Riverpod**.

## 1. Define API Endpoint
Add the new endpoint to `lib/core/network/api_constants.dart`.

```dart
static const String myNewEndpoint = '/api/my-endpoint';
```

## 2. Create Models
Create request and response models in the appropriate feature directory: `lib/features/[feature_name]/data/models/`.
Ensure models use `@JsonSerializable()` and include `.g.dart` part files.

```dart
import 'package:json_annotation/json_annotation.dart';
part 'my_response.g.dart';

@JsonSerializable()
class MyResponse {
  final bool status;
  final String message;
  // ... fields

  MyResponse({required this.status, required this.message});
  factory MyResponse.fromJson(Map<String, dynamic> json) => _$MyResponseFromJson(json);
}
```

## 3. Update Service Client
Add the method to the Retrofit service client (e.g., `lib/features/auth/data/data_sources/auth_service_client.dart`).

```dart
@GET(ApiConstants.myNewEndpoint)
Future<MyResponse> getMyData();
```

## 4. Repository Pattern
### Domain Layer
Add the method signature to the repository interface in `lib/features/[feature_name]/domain/repositories/`.

```dart
Future<MyResponse> getMyData();
```

### Data Layer
Implement the method in the repository implementation in `lib/features/[feature_name]/data/repositories/`.

```dart
@override
Future<MyResponse> getMyData() async {
  return await _serviceClient.getMyData();
}
```

## 5. Code Generation
Run the following command to generate the necessary boilerplate code:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## 6. Riverpod Controller
Create a controller (usually an `AsyncNotifier`) in `lib/features/[feature_name]/presentation/providers/`.

```dart
final myControllerProvider = AsyncNotifierProvider<MyController, MyResponse>(MyController.new);

class MyController extends AsyncNotifier<MyResponse> {
  @override
  Future<MyResponse> build() async {
    final repo = ref.read(myRepositoryProvider);
    return await repo.getMyData();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(myRepositoryProvider).getMyData());
  }
}
```

## 7. UI Integration
Use `ref.watch` to observe the state and handle loading/error/data states using `.when()`.

```dart
final myData = ref.watch(myControllerProvider);

myData.when(
  data: (data) => MyWidget(data: data),
  loading: () => const CircularProgressIndicator(),
  error: (err, stack) => ErrorWidget(err.toString()),
);
```

## 8. Localization
Always use `AppLocalizations` for user-facing strings. Add keys to `lib/features/l10n/app_en.arb` and `app_ar.arb`, then run:
```bash
flutter gen-l10n
```
