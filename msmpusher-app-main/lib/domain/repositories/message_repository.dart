import 'package:dartz/dartz.dart';
import 'package:msmpusher/core/exceptions/exceptions.dart';
import 'package:msmpusher/domain/form_params/form_params.dart';
import 'package:msmpusher/domain/model/models.dart';

abstract class MessageRepository {
  Future<Either<Failure<ExceptionMessage>, MessageInfoList>> getMessageReports(
      {required GetMessageReportsFormParams getMessageReportsFormParams});
  Future<Either<Failure<ExceptionMessage>, MessageInfoList>>
      revalidateMessageReports({
    required GetMessageReportsFormParams getMessageReportsFormParams,
  });
  Future<Either<Failure<ExceptionMessage>, MessageInfoList>> sendMessage(
      {required SendMessageFormParams sendMessageFormParams});
}
