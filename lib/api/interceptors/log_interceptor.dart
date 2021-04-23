import 'package:dio/dio.dart';

class APILogInterceptor extends InterceptorsWrapper {

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    print('');
    print('# ERROR');
    print('<-- ${err?.response?.statusCode} - ${err?.requestOptions?.uri}');
    print('Message: ${err?.error}');
    print('<-- END HTTP');
    return super.onError(err, handler);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('');
    print('# REQUEST');
    final method = options?.method?.toUpperCase();
    print('--> $method - ${options?.uri}');
    print('Headers: ${options?.headers}');
    print('Data: ${options?.data}');
    print('--> END $method');
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('');
    print('# RESPONSE');
    print('<-- ${response?.statusCode} - ${response?.requestOptions?.uri}');
    print('Response: ${response.data}');
    print('<-- END HTTP');
    return super.onResponse(response, handler);
  }

}