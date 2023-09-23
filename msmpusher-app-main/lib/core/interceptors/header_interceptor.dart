import 'dart:io';

import 'package:dio/dio.dart';

class HeaderInterceptors extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // TODO: using postman agent here (resolve when fix is applied to server to allow client access returning 403)
    options.headers.addAll({
      // HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.userAgentHeader: 'PostmanRuntime/7.29.0',
    });

    return handler.next(options);
  }
}
