import 'package:dio/dio.dart';
import 'package:msmpusher/core/exceptions/exceptions.dart';

class ExceptionMapper {
  ExceptionType<ExceptionMessage> mapException(DioError e) {
    if (e.type == DioErrorType.connectTimeout) {
      return const ExceptionType<ExceptionMessage>.serverException(
        code: ExceptionCode.REQUEST_TIMEOUT,
        message: ExceptionMessage.REQUEST_TIMEOUT,
      );
    }

    if (e.response?.statusCode == 404) {
      return const ExceptionType<ExceptionMessage>.serverException(
        code: ExceptionCode.NOT_FOUND,
        message: ExceptionMessage.NOT_FOUND,
      );
    }

    if (e.response?.statusCode == 500) {
      return const ExceptionType<ExceptionMessage>.serverException(
        code: ExceptionCode.UNDEFINED,
        message: ExceptionMessage.UNDEFINED,
      );
    }

    return ExceptionType<ExceptionMessage>.serverException(
      code: ExceptionCode.UNDEFINED,
      message: ExceptionMessage.parse(e.message.toString()),
    );
  }
}
