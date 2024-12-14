import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import '../../_env/env.dart';
import 'api_service_error.dart';

class ApiServices {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: Env.apiFootballBaseUrl,
      headers: {
        Env.apiFootballKey: Env.apiFootballApiKey,
      },
    ),
  )..interceptors.addAll([LogInterceptor(), DebugInterceptors()]);

  static Future<Dio> _createDio({
    required String hiveBoxName,
    Duration? maxStale,
    CachePolicy? policy,
    List<int>? hitCacheOnErrorExcept,
    CachePriority? priority,
  }) async {
    final String path = await getApplicationDocumentsDirectory().then((dir) => dir.path);
    final Dio dio = Dio(
      BaseOptions(
        baseUrl: Env.apiFootballBaseUrl,
        headers: {
          Env.apiFootballKey: Env.apiFootballApiKey,
        },
      ),
    );

    final CacheStore cacheStore = HiveCacheStore(path, hiveBoxName: hiveBoxName);

    final cacheOptions = CacheOptions(
      store: cacheStore,
      maxStale: maxStale ?? const Duration(days: 1),
      priority: priority ?? CachePriority.high,
      policy: policy ?? CachePolicy.forceCache,
      hitCacheOnErrorExcept: hitCacheOnErrorExcept,
    );

    final cacheInterceptor = DioCacheInterceptor(options: cacheOptions);

    dio.interceptors.addAll([cacheInterceptor, LogInterceptor(), DebugInterceptors()]);

    return dio;
  }

  static Future getApiResponse({
    required String path,
    String? hiveBoxName,
    Duration? maxStale,
    CachePolicy? policy,
    List<int>? hitCacheOnErrorExcept,
    CachePriority? priority,
  }) async {
    Response response;
    try {
      if (hiveBoxName != null) {
        final Dio customDio = await _createDio(
          hiveBoxName: hiveBoxName,
          maxStale: maxStale,
          policy: policy,
          hitCacheOnErrorExcept: hitCacheOnErrorExcept,
          priority: priority,
        );
        response = await customDio.get(path);
      } else {
        response = await _dio.get(path);
      }

      if (response.statusCode == 304 && response.data['response'].isEmpty) {
        response = await _dio.get(path);
      }

      if (response.statusCode == 200 || response.statusCode == 304) {
        return response.data;
      }

      throw ApiServiceError.fromCode(response.statusCode);
    } on DioException catch (e) {
      throw ApiServiceError.fromType(e.type);
    } on Exception catch (_) {
      throw const ApiServiceError();
    }
  }
}

class DebugInterceptors extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('REQUEST[${options.method}] => PATH: ${options.path}');
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint('ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    return super.onError(err, handler);
  }
}
