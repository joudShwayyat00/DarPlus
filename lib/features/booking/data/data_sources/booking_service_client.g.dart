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
    required int nights,
    required int guests,
    required String paymentMethod,
    String? notes,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.fields.add(MapEntry('asset_id', assetId.toString()));
    _data.fields.add(MapEntry('check_in', checkIn));
    _data.fields.add(MapEntry('check_out', checkOut));
    _data.fields.add(MapEntry('nights', nights.toString()));
    _data.fields.add(MapEntry('guests', guests.toString()));
    _data.fields.add(MapEntry('payment_method', paymentMethod));
    if (notes != null) {
      _data.fields.add(MapEntry('notes', notes));
    }
    final _options = _setStreamType<BookingResponse>(
      Options(method: 'POST', headers: _headers, extra: _extra)
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

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions = requestOptions.copyWith(responseType: ResponseType.plain);
      } else {
        requestOptions = requestOptions.copyWith(responseType: ResponseType.json);
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
