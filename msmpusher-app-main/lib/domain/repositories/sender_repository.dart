import 'package:dartz/dartz.dart';
import 'package:msmpusher/core/exceptions/exceptions.dart';
import 'package:msmpusher/domain/form_params/form_params.dart';
import 'package:msmpusher/domain/model/models.dart';

abstract class SenderRepository {
  Future<Either<Failure<ExceptionMessage>, SenderIdList>> createSenderId(
      {required CreateSenderIdFormParams createSenderIdFormParams});
  Future<Either<Failure<ExceptionMessage>, SenderIdList>> getSenderIds(
      {required GetAccountDetailsFormParams getAccountDetailsFormParams});
  Future<Either<Failure<ExceptionMessage>, SenderIdList>> revalidateSenderIds(
      {required GetAccountDetailsFormParams getAccountDetailsFormParams});
  Future<Either<Failure<ExceptionMessage>, SenderIdList>> deleteSenderId({
    required DeleteSenderIdFormParams deleteSenderIdFormParams,
  });
}
