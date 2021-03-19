import 'package:dio/dio.dart';

class APILogInterceptor extends InterceptorsWrapper {

  @override
  Future onError(DioError err) {
    print('');
    print('# ERROR');
    print('<-- ${err?.response?.statusCode} - ${err?.request?.uri}');
    print('Message: ${err?.error}');
    print('<-- END HTTP');
    return super.onError(err);
  }

  @override
  Future onRequest(RequestOptions options) {
    print('');
    print('# REQUEST');
    final method = options?.method?.toUpperCase();
    print('--> $method - ${options?.uri}');
    print('Headers: ${options?.headers}');
    print('Data: ${options?.data}');
    print('--> END $method');
    return super.onRequest(options);
  }

  @override
  Future onResponse(Response response) {
    print('');
    print('# RESPONSE');
    print('<-- ${response?.statusCode} - ${response?.request?.uri}');
    print('Response: ${response.data}');
    print('<-- END HTTP');
    return super.onResponse(response);
  }

}