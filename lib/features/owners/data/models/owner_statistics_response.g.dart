// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'owner_statistics_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OwnerStatisticsResponse _$OwnerStatisticsResponseFromJson(
  Map<String, dynamic> json,
) => OwnerStatisticsResponse(
  status: json['status'] as bool,
  data: OwnerStatisticsData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$OwnerStatisticsResponseToJson(
  OwnerStatisticsResponse instance,
) => <String, dynamic>{'status': instance.status, 'data': instance.data};

OwnerStatisticsData _$OwnerStatisticsDataFromJson(Map<String, dynamic> json) =>
    OwnerStatisticsData(
      assets: OwnerStatisticsAssets.fromJson(
        json['assets'] as Map<String, dynamic>,
      ),
      bookings: OwnerStatisticsBookings.fromJson(
        json['bookings'] as Map<String, dynamic>,
      ),
      revenue: OwnerStatisticsRevenue.fromJson(
        json['revenue'] as Map<String, dynamic>,
      ),
      appointments: OwnerStatisticsAppointments.fromJson(
        json['appointments'] as Map<String, dynamic>,
      ),
      avgRating: OwnerStatisticsData._numFromJson(json['avg_rating']),
    );

Map<String, dynamic> _$OwnerStatisticsDataToJson(
  OwnerStatisticsData instance,
) => <String, dynamic>{
  'assets': instance.assets,
  'bookings': instance.bookings,
  'revenue': instance.revenue,
  'appointments': instance.appointments,
  'avg_rating': instance.avgRating,
};

OwnerStatisticsAssets _$OwnerStatisticsAssetsFromJson(
  Map<String, dynamic> json,
) => OwnerStatisticsAssets(
  total: (json['total'] as num).toInt(),
  available: (json['available'] as num).toInt(),
);

Map<String, dynamic> _$OwnerStatisticsAssetsToJson(
  OwnerStatisticsAssets instance,
) => <String, dynamic>{
  'total': instance.total,
  'available': instance.available,
};

OwnerStatisticsBookings _$OwnerStatisticsBookingsFromJson(
  Map<String, dynamic> json,
) => OwnerStatisticsBookings(
  total: (json['total'] as num).toInt(),
  pending: (json['pending'] as num).toInt(),
  approved: (json['approved'] as num).toInt(),
);

Map<String, dynamic> _$OwnerStatisticsBookingsToJson(
  OwnerStatisticsBookings instance,
) => <String, dynamic>{
  'total': instance.total,
  'pending': instance.pending,
  'approved': instance.approved,
};

OwnerStatisticsRevenue _$OwnerStatisticsRevenueFromJson(
  Map<String, dynamic> json,
) => OwnerStatisticsRevenue(
  total: OwnerStatisticsData._numFromJson(json['total']),
);

Map<String, dynamic> _$OwnerStatisticsRevenueToJson(
  OwnerStatisticsRevenue instance,
) => <String, dynamic>{'total': instance.total};

OwnerStatisticsAppointments _$OwnerStatisticsAppointmentsFromJson(
  Map<String, dynamic> json,
) => OwnerStatisticsAppointments(
  total: (json['total'] as num).toInt(),
  pending: (json['pending'] as num).toInt(),
);

Map<String, dynamic> _$OwnerStatisticsAppointmentsToJson(
  OwnerStatisticsAppointments instance,
) => <String, dynamic>{'total': instance.total, 'pending': instance.pending};
