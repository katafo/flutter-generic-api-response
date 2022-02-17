import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../api_client.dart';
import '../decodable.dart';

class AuthToken implements Decodable<AuthToken> {
  String? accessToken;
  String? refreshToken;
  int? expiredTime;

  AuthToken({required this.accessToken, this.refreshToken, this.expiredTime});

  @override
  AuthToken decode(dynamic data) {
    expiredTime = data['expired_time'];
    return this;
  }

  Future startRefreshToken() async {
    await Future.delayed(Duration(seconds: 5));
    // assign new access token
    accessToken = 'abcxyz';
  }

  bool isExpired() {
    return true;
  }
}

class AuthInterceptor extends InterceptorsWrapper {
  final APIClient client;
  final AuthToken? token;

  AuthInterceptor({required this.client, this.token});

  @override
  Future onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final authorize = options.extra['Authorize'] ?? false;
    if (!authorize || token == null) {
      return super.onRequest(options, handler);
    }

    if (token!.isExpired()) {
      client.instance.lock();
      debugPrint('Lock request for refreshing token...');
      await token!.startRefreshToken();
      client.instance.unlock();
      debugPrint('Refresh token completed!');
    }

    options.headers['Authorization'] = 'Bearer $token';
    return super.onRequest(options, handler);
  }
}
