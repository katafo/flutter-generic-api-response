import 'package:dio/dio.dart';

import '../api_client.dart';
import '../decodable.dart';

class AuthToken implements Decodable<AuthToken> {

  String accessToken;
  String refreshToken;
  int expiredTime;

  AuthToken({ this.accessToken, this.refreshToken, this.expiredTime });

  @override
  AuthToken decode(dynamic data) {
    expiredTime = data['expired_time'];
    return this;
  }

  Future startRefreshToken() async {
    await Future.delayed(Duration(seconds: 5));
    // assign new access token
    accessToken = 'eyadfj9803924jjdfkasjdfjsdf';
  }

  bool isExpired() {
    return true;
  }
  
}

class AuthInterceptor extends InterceptorsWrapper {

  final APIClient client;
  AuthToken token;

  AuthInterceptor(this.client, this.token); 

  @override
  Future onRequest(
    RequestOptions options, 
    RequestInterceptorHandler handler
  ) async {

    if (options.extra['no_auth'] ?? false) {
      return super.onRequest(options, handler);
    }

    if (token.isExpired()) {
      client.instance.lock();
      print('Lock request for refreshing token...');
      await token.startRefreshToken();
      client.instance.unlock();
      print('Refresh token completed!');
    }

    options.headers['Authorization'] = token.accessToken;

    return super.onRequest(options, handler);

  }

}