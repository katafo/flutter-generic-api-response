import 'package:dio/dio.dart';

class APILogInterceptor extends InterceptorsWrapper {

  @override
  Future onError(DioError err) {
    print('ERROR: ${err?.error}');
    return super.onError(err);
  }

  @override
  Future onRequest(RequestOptions options) {
    print('${options?.method?.toUpperCase()} - ${options?.path}');
    print('HEADERS: ${options?.headers}');
    print('DATA: ${options?.data}');
    return super.onRequest(options);
  }

  @override
  Future onResponse(Response response) {
    print('RESPONSE - ${response?.statusCode}: ${response?.data}');
    return super.onResponse(response);
  }

}