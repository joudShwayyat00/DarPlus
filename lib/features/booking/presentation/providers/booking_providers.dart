import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/dio_factory.dart';
import '../../data/data_sources/booking_service_client.dart';
import '../../data/models/booking_response.dart';
import '../../data/repositories/booking_repository_impl.dart';
import '../../domain/repositories/booking_repository.dart';

part 'booking_providers.g.dart';

@riverpod
BookingServiceClient bookingServiceClient(Ref ref) {
  final dio = DioFactory.getDio();
  return BookingServiceClient(dio);
}

@riverpod
BookingRepository bookingRepository(Ref ref) {
  final client = ref.watch(bookingServiceClientProvider);
  return BookingRepositoryImpl(client);
}

@riverpod
class BookingController extends _$BookingController {
  @override
  FutureOr<BookingData?> build() => null;

  Future<void> submit({
    required int assetId,
    required String checkIn,
    required String checkOut,
    required int nights,
    required int guests,
    required String paymentMethod,
    String? notes,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard<BookingData?>(() async {
      final response = await ref.read(bookingRepositoryProvider).bookAsset(
        assetId: assetId,
        checkIn: checkIn,
        checkOut: checkOut,
        nights: nights,
        guests: guests,
        paymentMethod: paymentMethod,
        notes: notes,
      );
      return response.data;
    });
  }

  void reset() => state = const AsyncData(null);
}
