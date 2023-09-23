import 'dart:convert';

import 'package:msmpusher/core/constants.dart';
import 'package:msmpusher/core/exceptions/exceptions.dart';
import 'package:msmpusher/domain/form_params/form_params.dart';
import 'package:msmpusher/domain/model/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SenderLocalDataSource {
  Future<SenderIdList> getSenderIds(
      GetAccountDetailsFormParams getAccountDetailsFormParams);
  Future<void> cacheSenderIds({
    required SenderIdList senderIdList,
    required GetAccountDetailsFormParams getAccountDetailsFormParams,
  });
}

class SenderLocalDataSourceImpl implements SenderLocalDataSource {
  final SharedPreferences _storage;

  SenderLocalDataSourceImpl({required SharedPreferences storage})
      : _storage = storage;

  String _generateSenderIdKey(
      GetAccountDetailsFormParams getAccountDetailsFormParams) {
    return '${Persistence.SENDER_ID}_${getAccountDetailsFormParams.accountNumber}';
  }

  @override
  Future<SenderIdList> getSenderIds(
      GetAccountDetailsFormParams getAccountDetailsFormParams) async {
    final _senderIdListString =
        _storage.getString(_generateSenderIdKey(getAccountDetailsFormParams));

    if (_senderIdListString == null) {
      throw const ExceptionType<ExceptionMessage>.cacheException(
        code: ExceptionCode.NOT_FOUND,
        message: ExceptionMessage.NOT_FOUND,
      );
    }

    return SenderIdList.fromJson(json.decode(_senderIdListString));
  }

  @override
  Future<void> cacheSenderIds({
    required SenderIdList senderIdList,
    required GetAccountDetailsFormParams getAccountDetailsFormParams,
  }) async {
    final _senderIdListString = json.encode(senderIdList.toJson());
    await _storage.setString(
        _generateSenderIdKey(getAccountDetailsFormParams), _senderIdListString);

    return;
  }
}
