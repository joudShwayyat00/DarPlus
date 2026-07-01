import '../../data/models/my_subscription_item.dart';
import '../../data/models/package_item.dart';
import '../../data/models/payment_callback_response.dart';
import '../../data/models/payment_info_response.dart';
import '../../data/models/subscribe_response.dart';

abstract class PackagesRepository {
  Future<List<PackageItem>> getPackages(String lang);

  Future<List<MySubscriptionItem>> getMySubscriptions();

  Future<PaymentInfoResponse> getPaymentInfo();

  Future<SubscribeResponse> subscribe(int packageId);

  Future<PaymentCallbackResponse> submitPaymentCallback({
    required int subscriptionId,
    required String amount,
    String? transactionId,
    required String imagePath,
  });
}
