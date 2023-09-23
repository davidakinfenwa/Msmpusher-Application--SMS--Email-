import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:msmpusher/core/exceptions/exception_code.dart';

part 'exception_type.freezed.dart';

@freezed
class ExceptionType<T> with _$ExceptionType<T> {
  const factory ExceptionType.serverException({
    int? responseNo,
    @Default(true) bool response,
    required ExceptionCode code,
    required T message,
  }) = ServerException<T>;
  const factory ExceptionType.cacheException({
    int? responseNo,
    @Default(true) bool response,
    required ExceptionCode code,
    required T message,
  }) = CacheException<T>;
  const factory ExceptionType.platformsException({
    int? responseNo,
    @Default(true) bool response,
    required ExceptionCode code,
    required T message,
  }) = PlatformsException<T>;
}
