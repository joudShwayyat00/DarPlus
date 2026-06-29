import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/dio_factory.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/data_sources/booking_service_client.dart';
import '../../data/models/asset_calendar.dart';
import '../../data/models/booking_response.dart';
import '../../data/models/my_booking_item.dart';
import '../../data/repositories/booking_repository_impl.dart';
import '../../domain/booking_status_filter.dart';
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
    required int guests,
    required String paymentMethod,
    required String? rentType,
    required int periodCount,
    String? notes,
  }) async {
    int? nights;
    int? monthsCount;
    int? yearsCount;

    switch (rentType) {
      case 'monthly':
        monthsCount = periodCount;
        break;
      case 'yearly':
        yearsCount = periodCount;
        break;
      default:
        nights = periodCount;
    }

    state = const AsyncLoading();
    state = await AsyncValue.guard<BookingData?>(() async {
      final response = await ref.read(bookingRepositoryProvider).bookAsset(
        assetId: assetId,
        checkIn: checkIn,
        checkOut: checkOut,
        nights: nights,
        monthsCount: monthsCount,
        yearsCount: yearsCount,
        guests: guests,
        paymentMethod: paymentMethod,
        notes: notes,
      );
      return response.data;
    });

    if (state.hasValue && state.value != null) {
      for (final status in BookingStatusFilter.values) {
        ref.invalidate(myBookingsControllerProvider(status));
      }
    }
  }

  void reset() => state = const AsyncData(null);
}

@riverpod
Future<AssetCalendarData> assetCalendar(Ref ref, int assetId) async {
  return ref.read(bookingRepositoryProvider).getAssetCalendar(assetId);
}

@riverpod
class MyBookingsController extends _$MyBookingsController {
  @override
  FutureOr<List<MyBookingItem>> build(BookingStatusFilter status) async {
    if (!ref.read(isLoggedInProvider)) return [];
    return ref
        .read(bookingRepositoryProvider)
        .getMyBookings(status: status.apiValue);
  }

  Future<void> refresh() async {
    if (!ref.read(isLoggedInProvider)) {
      state = const AsyncData([]);
      return;
    }
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      return ref
          .read(bookingRepositoryProvider)
          .getMyBookings(status: status.apiValue);
    });
  }
}
