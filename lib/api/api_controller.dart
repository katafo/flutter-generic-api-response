import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'api_manager.dart';
import 'api_response.dart';
import 'decodable.dart';

/// Contruct to handle network request
class APIController {

  /// Send an HTTP request based on APIManager
  static Future<ResponseWrapper<T>> request<T extends Decodable>({
    @required APIManager manager, 
    @required Create<T> create, 
    Map<String, String> body, 
    Map<String, String> query 
  }) async {
    
    final config = manager.getConfig();
    Response response;
    print(config.url);
  
    if (config.method == HttpMethod.post) {
      response = await post(
        config.url, 
        headers: config.headers, 
        body: body
      );
    } else {
      response = await get(
        config.url + Uri(queryParameters: query).toString(), 
        headers: config.headers
      );
    }
    
    final responseJson = jsonDecode(response.body);
    
    if (response.statusCode == 200) {
      return ResponseWrapper.init(create: create, json: responseJson);
    }
    
    final error = ErrorResponse.fromJson(responseJson);
    
    throw error ?? ErrorResponse(
      message: 'Request failed with status code: ${response.statusCode}'
    );

  }

}
