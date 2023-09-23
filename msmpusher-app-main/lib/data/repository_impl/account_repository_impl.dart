import 'package:dartz/dartz.dart';
import 'package:msmpusher/core/constants.dart';
import 'package:msmpusher/core/exceptions/exceptions.dart';
import 'package:msmpusher/core/network/network.dart';
import 'package:msmpusher/data/datasources/datasources.dart';
import 'package:msmpusher/domain/form_params/account/get_account_details_form_params.dart';
import 'package:msmpusher/domain/model/models.dart';
import 'package:msmpusher/domain/repositories/repositories.dart';

class AccountRepositoryImpl implements AccountRepository {
  final NetworkInfo _networkInfo;
  final AccountLocalDataSource _localDataSource;
  final AccountRemoteDataSource _remoteDataSource;

  // other datasources
  final ContactLocalDataSource _contactLocalDataSource;
  final DeviceContactDataSource _deviceContactDataSource;

  AccountRepositoryImpl({
    required NetworkInfo networkInfo,
    required AccountLocalDataSource localDataSource,
    required AccountRemoteDataSource remoteDataSource,
    required ContactLocalDataSource contactLocalDataSource,
    required DeviceContactDataSource deviceContactDataSource,
  })  : _networkInfo = networkInfo,
        _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource,
        _contactLocalDataSource = contactLocalDataSource,
        _deviceContactDataSource = deviceContactDataSource;

  Future<Either<Failure<ExceptionMessage>, AccountSMSMetric>>
      _getAccountSMSMetricsFromLocalDataSource(
          GetAccountDetailsFormParams getAccountDetailsFormParams) async {
    try {
      final _accountSmsMetrics = await _localDataSource
          .getAccountSMSMetrics(getAccountDetailsFormParams);

      return right(_accountSmsMetrics);
    } on ExceptionType<ExceptionMessage> catch (e) {
      return left(Failure.cacheFailure(exception: e));
    }
  }

  Future<Either<Failure<ExceptionMessage>, ContactModelList>>
      _getDeviceContactsFromDeviceDataSource() async {
    try {
      final _contactModelList =
          await _deviceContactDataSource.getDeviceContacts();

      return right(_contactModelList);
    } on ExceptionType<ExceptionMessage> catch (e) {
      return left(Failure.platformsFailure(exception: e));
    }
  }

  Future<Either<Failure<ExceptionMessage>, ContactGroupList>>
      _getContactGroupListFromLocalDataSource() async {
    try {
      final _contactGroupList =
          await _contactLocalDataSource.getContactGroups();

      return right(_contactGroupList);
    } on ExceptionType<ExceptionMessage> catch (e) {
      return left(Failure.platformsFailure(exception: e));
    }
  }

  @override
  Future<Either<Failure<ExceptionMessage>, AccountBalance>> getAccountBalance(
      {required GetAccountDetailsFormParams
          getAccountDetailsFormParams}) async {
    try {
      final _accountBalance =
          await _localDataSource.getAccountBalance(getAccountDetailsFormParams);

      return right(_accountBalance);
    } on ExceptionType<ExceptionMessage> catch (e) {
      return left(Failure.cacheFailure(exception: e));
    }
  }

  @override
  Future<Either<Failure<ExceptionMessage>, AccountBalance>>
      revalidateAccountBalance(
          {required GetAccountDetailsFormParams
              getAccountDetailsFormParams}) async {
    if (await _networkInfo.isConnected) {
      try {
        final _accountBalanceOrError =
            await _remoteDataSource.getAccountBalance(
                getAccountDetailsFormParams: getAccountDetailsFormParams);

        return _accountBalanceOrError.map(
          errorResponse: (state) {
            final _exception = ExceptionType<ExceptionMessage>.serverException(
              code: ExceptionCode.UNDEFINED,
              message: ExceptionMessage.parse(state.data.message),
            );

            return left(Failure.serverFailure(exception: _exception));
          },
          successResponse: (state) async {
            // cache response
            await _localDataSource.cacheAccountBalance(state.data);

            return right(state.data);
          },
        );
      } on ExceptionType<ExceptionMessage> catch (e) {
        return left(Failure.serverFailure(exception: e));
      }
    }

    return left(const Failure.serverFailure(
        exception: ExceptionMessages.NO_INTERNET_CONNECTION));
  }

  @override
  Future<Either<Failure<ExceptionMessage>, AccountMetric>> getAccountMetrics(
      {required GetAccountDetailsFormParams
          getAccountDetailsFormParams}) async {
    try {
      // get account-sms-metrics
      final _accountSmsMetricsEither =
          await _getAccountSMSMetricsFromLocalDataSource(
              getAccountDetailsFormParams);

      // get device-contacts
      final _contactModelListEither =
          await _getDeviceContactsFromDeviceDataSource();

      // get contact-groups
      final _contactGroupListEither =
          await _getContactGroupListFromLocalDataSource();

      final _accountMetrics = AccountMetric(
        accountSmsMetric: _accountSmsMetricsEither.isLeft()
            ? AccountSMSMetric.empty()
            : _accountSmsMetricsEither
                .getOrElse(() => AccountSMSMetric.empty()),
        contactModelList: _contactModelListEither.isLeft()
            ? ContactModelList.empty()
            : _contactModelListEither.getOrElse(() => ContactModelList.empty()),
        contactGroupList: _contactGroupListEither.isLeft()
            ? ContactGroupList.empty()
            : _contactGroupListEither.getOrElse(() => ContactGroupList.empty()),
      );

      return right(_accountMetrics);
    } on ExceptionType<ExceptionMessage> catch (e) {
      return left(Failure.cacheFailure(exception: e));
    }
  }

  @override
  Future<Either<Failure<ExceptionMessage>, AccountMetric>>
      revalidateAccountMetrics(
          {required GetAccountDetailsFormParams
              getAccountDetailsFormParams}) async {
    if (await _networkInfo.isConnected) {
      try {
        final _accountMetricsOrError =
            await _remoteDataSource.getAccountMetrics(
                getAccountDetailsFormParams: getAccountDetailsFormParams);

        return _accountMetricsOrError.map(
          errorResponse: (state) {
            final _exception = ExceptionType<ExceptionMessage>.serverException(
              code: ExceptionCode.UNDEFINED,
              message: ExceptionMessage.parse(state.data.message),
            );

            return left(Failure.serverFailure(exception: _exception));
          },
          successResponse: (state) async {
            // cache response
            await _localDataSource
                .cacheAccountSMSMetrics(state.data.accountSmsMetric);

            return right(state.data);
          },
        );
      } on ExceptionType<ExceptionMessage> catch (e) {
        return left(Failure.serverFailure(exception: e));
      }
    }

    return left(const Failure.serverFailure(
        exception: ExceptionMessages.NO_INTERNET_CONNECTION));
  }
}
