import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/api_constants.dart';
import '../models/packages_response.dart';
import '../models/my_subscriptions_response.dart';
import '../models/payment_callback_response.dart';
import '../models/payment_info_response.dart';
import '../models/subscribe_response.dart';

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

  @POST(ApiConstants.paymentsCallback)
  @MultiPart()
  Future<PaymentCallbackResponse> submitPaymentCallback(
    @Part(name: 'subscription_id') int subscriptionId,
    @Part(name: 'amount') String amount,
    @Part(name: 'transaction_id') String transactionId,
    @Part(name: 'image') MultipartFile image,
  );
}
