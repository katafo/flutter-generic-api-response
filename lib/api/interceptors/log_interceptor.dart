import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class APILogInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final method = options.method.toUpperCase();
    debug('$method  ${options.uri}');
    debug('Headers: ${options.headers}');
    debug('Data: ${options.data}\n');
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debug(
        '''${response.requestOptions.method.toUpperCase()}  ${response.requestOptions.uri} - ${response.statusCode}''');
    final res = response.data.toString();
    debug(
        // ignore: prefer_interpolation_to_compose_strings
        '''Response: ${(res.length > 2500) ? res.substring(0, 2500) + '...' : res}\n''');
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    debug(
        '''${err.requestOptions.method.toUpperCase()}   ${err.requestOptions.uri} - ${err.response?.statusCode}''');
    debug('Error: ${err.error}\n');
    return super.onError(err, handler);
  }

  void debug(String message) {
    debugPrint('[API-debug] $message');
  }
}
