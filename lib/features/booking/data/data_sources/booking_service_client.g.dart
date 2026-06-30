// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_service_client.dart';

// dart format off

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element,unnecessary_string_interpolations,unused_element_parameter,avoid_unused_constructor_parameters,unreachable_from_main

class _BookingServiceClient implements BookingServiceClient {
  _BookingServiceClient(this._dio, {this.baseUrl, this.errorLogger}) {
    baseUrl ??= 'https://darplus.moneymaker-app.com/';
  }

  final Dio _dio;

  String? baseUrl;

  final ParseErrorLogger? errorLogger;

  @override
  Future<BookingResponse> bookAsset({
    required int assetId,
    required String checkIn,
    required String checkOut,
    int? nights,
    int? monthsCount,
    int? yearsCount,
    required int guests,
    required String paymentMethod,
    String? notes,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.fields.add(MapEntry('asset_id', assetId.toString()));
    _data.fields.add(MapEntry('check_in', checkIn));
    _data.fields.add(MapEntry('check_out', checkOut));
    if (nights != null) {
      _data.fields.add(MapEntry('nights', nights.toString()));
    }
    if (monthsCount != null) {
      _data.fields.add(MapEntry('months_count', monthsCount.toString()));
    }
    if (yearsCount != null) {
      _data.fields.add(MapEntry('years_count', yearsCount.toString()));
    }
    _data.fields.add(MapEntry('guests', guests.toString()));
    _data.fields.add(MapEntry('payment_method', paymentMethod));
    if (notes != null) {
      _data.fields.add(MapEntry('notes', notes));
    }
    final _options = _setStreamType<BookingResponse>(
      Options(
            method: 'POST',
            headers: _headers,
            extra: _extra,
            contentType: 'multipart/form-data',
          )
          .compose(
            _dio.options,
            'api/assets/book',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BookingResponse _value;
    try {
      _value = BookingResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<List<MyBookingItem>> getMyBookings({required String status}) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.fields.add(MapEntry('status', status));
    final _options = _setStreamType<List<MyBookingItem>>(
      Options(
            method: 'POST',
            headers: _headers,
            extra: _extra,
            contentType: 'multipart/form-data',
          )
          .compose(
            _dio.options,
            'api/my_bookings',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<List<dynamic>>(_options);
    late List<MyBookingItem> _value;
    try {
      _value = _result.data!
          .map((dynamic i) => MyBookingItem.fromJson(i as Map<String, dynamic>))
          .toList();
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<AssetCalendarResponse> getAssetCalendar(int assetId) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<AssetCalendarResponse>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'api/calendar/${assetId}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late AssetCalendarResponse _value;
    try {
      _value = AssetCalendarResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(String dioBaseUrl, String? baseUrl) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}

// dart format on
