import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../controller/local_provider.dart';
import '../../../../core/network/dio_factory.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/data_sources/packages_service_client.dart';
import '../../data/models/my_subscription_item.dart';
import '../../data/models/package_item.dart';
import '../../data/models/payment_info_response.dart';
import '../../data/models/subscribe_response.dart';
import '../../data/models/upload_proof_response.dart';
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
  FutureOr<SubscribeResponse?> build() => null;

  Future<SubscribeResponse> subscribe(int packageId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard<SubscribeResponse?>(() async {
      final response = await ref
          .read(packagesRepositoryProvider)
          .subscribe(packageId);
      if (response.status == false) {
        throw Exception(response.message);
      }
      ref.invalidate(profileControllerProvider);
      await ref.read(mySubscriptionsControllerProvider.notifier).refresh();
      return response;
    });
    if (state.hasError) throw state.error!;
    return state.value!;
  }
}

@riverpod
class UploadProofController extends _$UploadProofController {
  @override
  FutureOr<UploadProofResponse?> build() => null;

  Future<UploadProofResponse> submit({
    required String transferName,
    required String transferAmount,
    required String transferPhone,
    required String receiptPath,
    Iterable<int> pendingSubscriptionIds = const [],
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard<UploadProofResponse?>(() async {
      final response = await ref
          .read(packagesRepositoryProvider)
          .uploadSubscriptionProof(
            transferName: transferName,
            transferAmount: transferAmount,
            transferPhone: transferPhone,
            receiptPath: receiptPath,
          );
      if (response.status != true) {
        throw Exception(response.message.isNotEmpty
            ? response.message
            : 'Payment proof upload failed');
      }
      if (pendingSubscriptionIds.isNotEmpty) {
        ref
            .read(awaitingReviewSubscriptionsProvider.notifier)
            .markSubmitted(pendingSubscriptionIds);
      }
      return response;
    });
    if (state.hasError) throw state.error!;
    return state.value!;
  }
}

@Riverpod(keepAlive: true)
class AwaitingReviewSubscriptions extends _$AwaitingReviewSubscriptions {
  @override
  Set<int> build() => {};

  void markSubmitted(Iterable<int> ids) {
    state = {...state, ...ids};
  }

  bool isAwaiting(int subscriptionId) => state.contains(subscriptionId);
}
