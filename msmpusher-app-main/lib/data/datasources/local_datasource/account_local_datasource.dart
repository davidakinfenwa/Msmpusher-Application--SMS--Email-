import 'dart:convert';

import 'package:msmpusher/core/constants.dart';
import 'package:msmpusher/core/exceptions/exceptions.dart';
import 'package:msmpusher/domain/form_params/form_params.dart';
import 'package:msmpusher/domain/model/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AccountLocalDataSource {
  Future<AccountBalance> getAccountBalance(
      GetAccountDetailsFormParams getAccountBalanceFormParams);
  Future<AccountSMSMetric> getAccountSMSMetrics(
      GetAccountDetailsFormParams getAccountBalanceFormParams);

  Future<void> cacheAccountBalance(AccountBalance accountBalance);
  Future<void> cacheAccountSMSMetrics(AccountSMSMetric accountSMSMetric);
}

class AccountLocalDataSourceImpl implements AccountLocalDataSource {
  final SharedPreferences _storage;

  AccountLocalDataSourceImpl({required SharedPreferences storage})
      : _storage = storage;

  @override
  Future<AccountBalance> getAccountBalance(
      GetAccountDetailsFormParams getAccountBalanceFormParams) async {
    final _accountBalanceString =
        _storage.getString(Persistence.ACCOUNT_BALANCE);

    if (_accountBalanceString == null) {
      throw const ExceptionType<ExceptionMessage>.cacheException(
        code: ExceptionCode.NOT_FOUND,
        message: ExceptionMessage.NOT_FOUND,
      );
    }

    return AccountBalance.fromJson(json.decode(_accountBalanceString));
  }

  @override
  Future<AccountSMSMetric> getAccountSMSMetrics(
      GetAccountDetailsFormParams getAccountBalanceFormParams) async {
    final _accountSmsMetricString =
        _storage.getString(Persistence.ACCOUNT_METRICS);

    if (_accountSmsMetricString == null) {
      throw const ExceptionType<ExceptionMessage>.cacheException(
        code: ExceptionCode.NOT_FOUND,
        message: ExceptionMessage.NOT_FOUND,
      );
    }

    return AccountSMSMetric.fromJson(json.decode(_accountSmsMetricString));
  }

  @override
  Future<void> cacheAccountBalance(AccountBalance accountBalance) async {
    final _accountBalanceString = json.encode(accountBalance.toJson());
    await _storage.setString(
        Persistence.ACCOUNT_BALANCE, _accountBalanceString);

    return;
  }

  @override
  Future<void> cacheAccountSMSMetrics(AccountSMSMetric accountSMSMetric) async {
    final _accountSmsMetricString = json.encode(accountSMSMetric.toJson());
    await _storage.setString(
        Persistence.ACCOUNT_METRICS, _accountSmsMetricString);

    return;
  }
}
