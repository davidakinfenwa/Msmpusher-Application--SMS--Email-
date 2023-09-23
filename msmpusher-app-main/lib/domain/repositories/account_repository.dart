import 'package:dartz/dartz.dart';
import 'package:msmpusher/core/exceptions/exceptions.dart';
import 'package:msmpusher/domain/form_params/account/get_account_details_form_params.dart';
import 'package:msmpusher/domain/model/models.dart';

abstract class AccountRepository {
  Future<Either<Failure<ExceptionMessage>, AccountBalance>> getAccountBalance(
      {required GetAccountDetailsFormParams getAccountDetailsFormParams});
  Future<Either<Failure<ExceptionMessage>, AccountBalance>>
      revalidateAccountBalance(
          {required GetAccountDetailsFormParams getAccountDetailsFormParams});

  Future<Either<Failure<ExceptionMessage>, AccountMetric>> getAccountMetrics(
      {required GetAccountDetailsFormParams getAccountDetailsFormParams});
  Future<Either<Failure<ExceptionMessage>, AccountMetric>>
      revalidateAccountMetrics(
          {required GetAccountDetailsFormParams getAccountDetailsFormParams});
}
