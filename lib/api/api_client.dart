import 'package:dio/dio.dart';
import 'api_response.dart';
import 'api_route.dart';
import 'decodable.dart';

// ignore: one_member_abstracts
abstract class BaseAPIClient {
  Future<ResponseWrapper<T>> request<T extends Decodable>({
    required APIRouteConfigurable route,
    required Create<T> create,
    dynamic data,
  });
}

class APIClient implements BaseAPIClient {
  final BaseOptions options;
  late Dio instance;

  APIClient(this.options) {
    instance = Dio(options);
  }

  @override
  Future<ResponseWrapper<T>> request<T extends Decodable>({
    required APIRouteConfigurable route,
    required Create<T> create,
    dynamic data,
  }) async {
    final config = route.getConfig();
    if (config == null) {
      throw ErrorResponse(message: 'Failed to load request options.');
    }
    config.baseUrl = options.baseUrl;
    if (data != null) {
      if (config.method == APIMethod.get) {
        config.queryParameters = data;
      } else {
        config.data = data;
      }
    }
    try {
      final response = await instance.fetch(config);
      return ResponseWrapper.init(create: create, data: response.data);
    } on DioError catch (err) {
      throw ErrorResponse(message: err.message);
    }
  }
}
