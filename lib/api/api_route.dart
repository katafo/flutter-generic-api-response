import 'package:dio/dio.dart';

enum APIType { listEmployees, detailsEmployee }

class APIRoute implements APIRouteConfigurable {
  final APIType type;
  final String? routeParams;
  final headers = {
    'accept': 'application/json',
    'content-type': 'application/json'
  };

  APIRoute(this.type, {this.routeParams});

  /// Return config of api (method, url, header)
  @override
  RequestOptions? getConfig() {
    // pass extra value to detect public or auth api
    final authorize = {'Authorize': true};

    switch (type) {

      //login
      case APIType.listEmployees:
        return RequestOptions(
            path: '/employees/all.json',
            method: APIMethod.get,
            extra: authorize);

      case APIType.detailsEmployee:
        return RequestOptions(
          path: '/employees/$routeParams.json',
          method: APIMethod.get,
        );

      default:
        return null;
    }
  }
}

// ignore: one_member_abstracts
abstract class APIRouteConfigurable {
  RequestOptions? getConfig();
}

class APIMethod {
  static const get = 'GET';
  static const post = 'POST';
  static const put = 'PUT';
  static const patch = 'PATCH';
  static const delete = 'DELETE';
}
