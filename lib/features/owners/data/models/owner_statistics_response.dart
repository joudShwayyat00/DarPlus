import 'package:json_annotation/json_annotation.dart';

part 'owner_statistics_response.g.dart';

@JsonSerializable()
class OwnerStatisticsResponse {
  final bool status;
  final OwnerStatisticsData data;

  const OwnerStatisticsResponse({
    required this.status,
    required this.data,
  });

  factory OwnerStatisticsResponse.fromJson(Map<String, dynamic> json) =>
      _$OwnerStatisticsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OwnerStatisticsResponseToJson(this);
}

@JsonSerializable()
class OwnerStatisticsData {
  final OwnerStatisticsAssets assets;
  final OwnerStatisticsBookings bookings;
  final OwnerStatisticsRevenue revenue;
  final OwnerStatisticsAppointments appointments;
  @JsonKey(name: 'avg_rating', fromJson: _numFromJson)
  final num avgRating;

  const OwnerStatisticsData({
    required this.assets,
    required this.bookings,
    required this.revenue,
    required this.appointments,
    required this.avgRating,
  });

  factory OwnerStatisticsData.fromJson(Map<String, dynamic> json) =>
      _$OwnerStatisticsDataFromJson(json);

  Map<String, dynamic> toJson() => _$OwnerStatisticsDataToJson(this);

  static num _numFromJson(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value;
    if (value is String) return num.tryParse(value) ?? 0;
    return 0;
  }
}

@JsonSerializable()
class OwnerStatisticsAssets {
  final int total;
  final int available;

  const OwnerStatisticsAssets({
    required this.total,
    required this.available,
  });

  factory OwnerStatisticsAssets.fromJson(Map<String, dynamic> json) =>
      _$OwnerStatisticsAssetsFromJson(json);

  Map<String, dynamic> toJson() => _$OwnerStatisticsAssetsToJson(this);
}

@JsonSerializable()
class OwnerStatisticsBookings {
  final int total;
  final int pending;
  final int approved;

  const OwnerStatisticsBookings({
    required this.total,
    required this.pending,
    required this.approved,
  });

  factory OwnerStatisticsBookings.fromJson(Map<String, dynamic> json) =>
      _$OwnerStatisticsBookingsFromJson(json);

  Map<String, dynamic> toJson() => _$OwnerStatisticsBookingsToJson(this);
}

@JsonSerializable()
class OwnerStatisticsRevenue {
  @JsonKey(fromJson: OwnerStatisticsData._numFromJson)
  final num total;

  const OwnerStatisticsRevenue({required this.total});

  factory OwnerStatisticsRevenue.fromJson(Map<String, dynamic> json) =>
      _$OwnerStatisticsRevenueFromJson(json);

  Map<String, dynamic> toJson() => _$OwnerStatisticsRevenueToJson(this);
}

@JsonSerializable()
class OwnerStatisticsAppointments {
  final int total;
  final int pending;

  const OwnerStatisticsAppointments({
    required this.total,
    required this.pending,
  });

  factory OwnerStatisticsAppointments.fromJson(Map<String, dynamic> json) =>
      _$OwnerStatisticsAppointmentsFromJson(json);

  Map<String, dynamic> toJson() => _$OwnerStatisticsAppointmentsToJson(this);
}
