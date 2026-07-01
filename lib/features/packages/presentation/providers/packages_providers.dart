import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../controller/local_provider.dart';
import '../../../../core/network/dio_factory.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/data_sources/packages_service_client.dart';
import '../../data/models/my_subscription_item.dart';
import '../../data/models/package_item.dart';
import '../../data/models/payment_callback_response.dart';
import '../../data/models/payment_info_response.dart';
import '../../data/repositories/packages_repository_impl.dart';
import '../../domain/repositories/packages_repository.dart';

part 'packages_providers.g.dart';

@riverpod
PackagesServiceClient packagesServiceClient(Ref ref) {
  return PackagesServiceClient(DioFactory.getDio());
}

@riverpod
PackagesRepository packagesRepository(Ref ref) {
  return PackagesRepositoryImpl(ref.watch(packagesServiceClientProvider));
}

@riverpod
class PackagesController extends _$PackagesController {
  @override
  FutureOr<List<PackageItem>> build() async {
    final lang = ref.watch(apiLanguageCodeProvider);
    return ref.read(packagesRepositoryProvider).getPackages(lang);
  }
}

@riverpod
class MySubscriptionsController extends _$MySubscriptionsController {
  @override
  FutureOr<List<MySubscriptionItem>> build() async {
    if (!ref.watch(isLoggedInProvider)) return [];
    return ref.read(packagesRepositoryProvider).getMySubscriptions();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      if (!ref.read(isLoggedInProvider)) return <MySubscriptionItem>[];
      return ref.read(packagesRepositoryProvider).getMySubscriptions();
    });
  }
}

@riverpod
class PaymentInfoController extends _$PaymentInfoController {
  @override
  FutureOr<PaymentInfoResponse?> build() async {
    if (!ref.watch(isLoggedInProvider)) return null;
    return ref.read(packagesRepositoryProvider).getPaymentInfo();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      if (!ref.read(isLoggedInProvider)) return null;
      return ref.read(packagesRepositoryProvider).getPaymentInfo();
    });
  }
}

@riverpod
class SubscribeController extends _$SubscribeController {
  @override
  FutureOr<String?> build() => null;

  Future<String> subscribe(int packageId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard<String>(() async {
      final response = await ref
          .read(packagesRepositoryProvider)
          .subscribe(packageId);
      ref.invalidate(profileControllerProvider);
      ref.invalidate(mySubscriptionsControllerProvider);
      return response.message;
    });
    if (state.hasError) throw state.error!;
    return state.value!;
  }
}

@riverpod
class PaymentCallbackController extends _$PaymentCallbackController {
  @override
  FutureOr<PaymentCallbackResponse?> build() => null;

  Future<String> submit({
    required int subscriptionId,
    required String amount,
    String? transactionId,
    required String imagePath,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard<PaymentCallbackResponse?>(() async {
      final response = await ref
          .read(packagesRepositoryProvider)
          .submitPaymentCallback(
            subscriptionId: subscriptionId,
            amount: amount,
            transactionId: transactionId,
            imagePath: imagePath,
          );
      ref.invalidate(mySubscriptionsControllerProvider);
      return response;
    });
    if (state.hasError) throw state.error!;
    return state.value!.message;
  }
}
