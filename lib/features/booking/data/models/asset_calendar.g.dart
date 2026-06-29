// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_calendar.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetCalendarResponse _$AssetCalendarResponseFromJson(
  Map<String, dynamic> json,
) => AssetCalendarResponse(
  status: json['status'] as bool,
  data: AssetCalendarData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AssetCalendarResponseToJson(
  AssetCalendarResponse instance,
) => <String, dynamic>{'status': instance.status, 'data': instance.data};

AssetCalendarData _$AssetCalendarDataFromJson(Map<String, dynamic> json) =>
    AssetCalendarData(
      blockedByOwner: AssetCalendarData._entriesFromJson(
        json['blocked_by_owner'],
      ),
      bookedDates: AssetCalendarData._entriesFromJson(json['booked_dates']),
    );

Map<String, dynamic> _$AssetCalendarDataToJson(AssetCalendarData instance) =>
    <String, dynamic>{
      'blocked_by_owner': instance.blockedByOwner,
      'booked_dates': instance.bookedDates,
    };

CalendarDateEntry _$CalendarDateEntryFromJson(Map<String, dynamic> json) =>
    CalendarDateEntry(
      date: json['date'] as String,
      status: json['status'] as String?,
      source: json['source'] as String?,
    );

Map<String, dynamic> _$CalendarDateEntryToJson(CalendarDateEntry instance) =>
    <String, dynamic>{
      'date': instance.date,
      'status': instance.status,
      'source': instance.source,
    };
