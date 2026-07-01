import 'package:dio/dio.dart';

import '../../domain/repositories/packages_repository.dart';
import '../data_sources/packages_service_client.dart';
import '../models/my_subscription_item.dart';
import '../models/package_item.dart';
import '../models/payment_info_response.dart';
import '../models/subscribe_response.dart';
import '../models/upload_proof_response.dart';

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
    try {
      return await _client.subscribe(packageId);
    } on DioException catch (e) {
      throw Exception(_dioMessage(e, 'Subscription failed'));
    }
  }

  @override
  Future<UploadProofResponse> uploadSubscriptionProof({
    required String transferName,
    required String transferAmount,
    required String transferPhone,
    required String receiptPath,
  }) async {
    final receipt = await MultipartFile.fromFile(
      receiptPath,
      filename: receiptPath.split('/').last,
    );
    try {
      return await _client.uploadSubscriptionProof(
        transferName,
        transferAmount,
        transferPhone,
        receipt,
      );
    } on DioException catch (e) {
      throw Exception(_dioMessage(e, 'Payment proof upload failed'));
    }
  }

  String _dioMessage(DioException error, String fallback) {
    final data = error.response?.data;
    if (data is Map) {
      final message = data['message'];
      if (message is String && message.trim().isNotEmpty) {
        return message;
      }
    }
    return fallback;
  }
}
