import 'package:dio/dio.dart';
import 'package:msmpusher/core/constants.dart';

final _options = BaseOptions(
  baseUrl: 'https://api.msmpusher.com/msmapi',
  connectTimeout: ClientRequestTimeout.kConnectionTimeout,
  receiveTimeout: ClientRequestTimeout.kRecieveTimeout,
);

final dioClient = Dio(_options);
