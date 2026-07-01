import '../../data/models/my_subscription_item.dart';
import '../../data/models/package_item.dart';
import '../../data/models/payment_info_response.dart';
import '../../data/models/subscribe_response.dart';
import '../../data/models/upload_proof_response.dart';

abstract class PackagesRepository {
  Future<List<PackageItem>> getPackages(String lang);

  Future<List<MySubscriptionItem>> getMySubscriptions();

  Future<PaymentInfoResponse> getPaymentInfo();

  Future<SubscribeResponse> subscribe(int packageId);

  Future<UploadProofResponse> uploadSubscriptionProof({
    required String transferName,
    required String transferAmount,
    required String transferPhone,
    required String receiptPath,
  });
}
