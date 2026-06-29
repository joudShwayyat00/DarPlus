import 'package:json_annotation/json_annotation.dart';

part 'asset_calendar.g.dart';

@JsonSerializable()
class AssetCalendarResponse {
  final bool status;
  final AssetCalendarData data;

  const AssetCalendarResponse({
    required this.status,
    required this.data,
  });

  factory AssetCalendarResponse.fromJson(Map<String, dynamic> json) =>
      _$AssetCalendarResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AssetCalendarResponseToJson(this);
}

@JsonSerializable()
class AssetCalendarData {
  @JsonKey(name: 'blocked_by_owner', fromJson: _entriesFromJson)
  final List<CalendarDateEntry> blockedByOwner;

  @JsonKey(name: 'booked_dates', fromJson: _entriesFromJson)
  final List<CalendarDateEntry> bookedDates;

  const AssetCalendarData({
    required this.blockedByOwner,
    required this.bookedDates,
  });

  factory AssetCalendarData.fromJson(Map<String, dynamic> json) =>
      _$AssetCalendarDataFromJson(json);

  Map<String, dynamic> toJson() => _$AssetCalendarDataToJson(this);

  Set<DateTime> get bookedDateSet =>
      bookedDates.map((e) => e.normalizedDate).toSet();

  Set<DateTime> get blockedDateSet =>
      blockedByOwner.map((e) => e.normalizedDate).toSet();

  Set<DateTime> get unavailableDateSet => {...bookedDateSet, ...blockedDateSet};

  bool isBooked(DateTime day) => bookedDateSet.contains(normalize(day));

  bool isBlockedByOwner(DateTime day) =>
      blockedDateSet.contains(normalize(day));

  bool isUnavailable(DateTime day) =>
      unavailableDateSet.contains(normalize(day));

  /// Returns true when any night in [checkIn, checkOut) is unavailable.
  bool rangeHasUnavailable(DateTime checkIn, DateTime checkOut) {
    var cursor = normalize(checkIn);
    final end = normalize(checkOut);
    while (cursor.isBefore(end)) {
      if (isUnavailable(cursor)) return true;
      cursor = cursor.add(const Duration(days: 1));
    }
    return false;
  }

  static DateTime normalize(DateTime d) => DateTime(d.year, d.month, d.day);

  static List<CalendarDateEntry> _entriesFromJson(dynamic value) {
    if (value is! List) return const [];
    return value
        .map(CalendarDateEntry.fromDynamic)
        .whereType<CalendarDateEntry>()
        .toList();
  }
}

@JsonSerializable()
class CalendarDateEntry {
  final String date;
  final String? status;
  final String? source;

  const CalendarDateEntry({
    required this.date,
    this.status,
    this.source,
  });

  DateTime get normalizedDate {
    final parts = date.split('-');
    if (parts.length != 3) return DateTime.now();
    return AssetCalendarData.normalize(
      DateTime(
        int.tryParse(parts[0]) ?? 0,
        int.tryParse(parts[1]) ?? 0,
        int.tryParse(parts[2]) ?? 0,
      ),
    );
  }

  factory CalendarDateEntry.fromJson(Map<String, dynamic> json) =>
      _$CalendarDateEntryFromJson(json);

  Map<String, dynamic> toJson() => _$CalendarDateEntryToJson(this);

  static CalendarDateEntry? fromDynamic(dynamic value) {
    if (value is String && value.trim().isNotEmpty) {
      return CalendarDateEntry(date: value.trim());
    }
    if (value is Map) {
      final rawDate = value['date'];
      if (rawDate is String && rawDate.trim().isNotEmpty) {
        return CalendarDateEntry(
          date: rawDate.trim(),
          status: value['status']?.toString(),
          source: value['source']?.toString(),
        );
      }
    }
    return null;
  }
}
