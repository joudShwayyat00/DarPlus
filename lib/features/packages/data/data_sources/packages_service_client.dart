import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/api_constants.dart';
import '../models/packages_response.dart';
import '../models/my_subscriptions_response.dart';
import '../models/payment_info_response.dart';
import '../models/subscribe_response.dart';
import '../models/upload_proof_response.dart';

part 'packages_service_client.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class PackagesServiceClient {
  factory PackagesServiceClient(Dio dio, {String baseUrl}) =
      _PackagesServiceClient;

  @GET('${ApiConstants.packages}/{lang}')
  Future<PackagesResponse> getPackages(@Path('lang') String lang);

  @GET(ApiConstants.mySubscriptions)
  Future<MySubscriptionsResponse> getMySubscriptions();

  @GET(ApiConstants.paymentInfo)
  Future<PaymentInfoResponse> getPaymentInfo();

  @POST(ApiConstants.subscribe)
  @MultiPart()
  Future<SubscribeResponse> subscribe(
    @Part(name: 'package_id') int packageId,
  );

  @POST(ApiConstants.uploadSubscriptionProof)
  @MultiPart()
  Future<UploadProofResponse> uploadSubscriptionProof(
    @Part(name: 'transfer_name') String transferName,
    @Part(name: 'transfer_amount') String transferAmount,
    @Part(name: 'transfer_phone') String transferPhone,
    @Part(name: 'transfer_receipt') MultipartFile transferReceipt,
  );
}
