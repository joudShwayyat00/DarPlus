import 'package:dio/dio.dart';

import '../../domain/repositories/packages_repository.dart';
import '../data_sources/packages_service_client.dart';
import '../models/my_subscription_item.dart';
import '../models/package_item.dart';
import '../models/payment_callback_response.dart';
import '../models/payment_info_response.dart';
import '../models/subscribe_response.dart';

class PackagesRepositoryImpl implements PackagesRepository {
  final PackagesServiceClient _client;

  PackagesRepositoryImpl(this._client);

  @override
  Future<List<PackageItem>> getPackages(String lang) async {
    final response = await _client.getPackages(lang);
    return response.items;
  }

  @override
  Future<List<MySubscriptionItem>> getMySubscriptions() async {
    final response = await _client.getMySubscriptions();
    return response.data;
  }

  @override
  Future<PaymentInfoResponse> getPaymentInfo() async {
    return _client.getPaymentInfo();
  }

  @override
  Future<SubscribeResponse> subscribe(int packageId) async {
    return _client.subscribe(packageId);
  }

  @override
  Future<PaymentCallbackResponse> submitPaymentCallback({
    required int subscriptionId,
    required String amount,
    String? transactionId,
    required String imagePath,
  }) async {
    final image = await MultipartFile.fromFile(
      imagePath,
      filename: imagePath.split('/').last,
    );
    return _client.submitPaymentCallback(
      subscriptionId,
      amount,
      transactionId ?? '',
      image,
    );
  }
}
