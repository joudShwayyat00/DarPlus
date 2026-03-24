import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'api_constants.dart';
import '../../controller/shared_prefs.dart';

class DioFactory {
  // private constructor to prevent instantiation
  DioFactory._();

  static Dio? _dio;

  static Dio getDio() {
    Duration timeOut = const Duration(seconds: 30);

    if (_dio == null) {
      _dio = Dio();
      _dio!
        ..options.baseUrl = ApiConstants.baseUrl
        ..options.connectTimeout = timeOut
        ..options.connectTimeout = timeOut
        ..options.receiveTimeout = timeOut
        ..options.headers = {
          ApiHeaders.acceptHeader: ApiConstants.accept,
          if (SharedPerfManager().token.isNotEmpty)
            ApiHeaders.authHeader: 'Bearer ${SharedPerfManager().token}',
        };

      addDioInterceptor();
      return _dio!;
    } else {
      return _dio!;
    }
  }

  static void addDioInterceptor() {
    final dio = _dio!;
    
    // Add Retry Interceptor
    dio.interceptors.add(
      RetryInterceptor(
        dio: dio,
        logPrint: (message) => debugPrint(message),
        retries: 3,
        retryDelays: const [
          Duration(seconds: 1),
          Duration(seconds: 2),
          Duration(seconds: 3),
        ],
      ),
    );

    // Add Cache Interceptor
    final cacheOptions = CacheOptions(
      store: MemCacheStore(),
      policy: CachePolicy.request,
      hitCacheOnErrorCodes: [401, 403],
      maxStale: const Duration(days: 7),
      priority: CachePriority.normal,
      keyBuilder: CacheOptions.defaultCacheKeyBuilder,
      allowPostMethod: false,
    );
    dio.interceptors.add(DioCacheInterceptor(options: cacheOptions));

    // Add Logging Interceptor
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
        request: true,
      ),
    );
  }
}
