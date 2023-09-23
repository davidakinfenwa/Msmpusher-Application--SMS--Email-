import 'dart:convert';

import 'package:msmpusher/core/constants.dart';
import 'package:msmpusher/core/exceptions/exceptions.dart';
import 'package:msmpusher/domain/form_params/form_params.dart';
import 'package:msmpusher/domain/model/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class MessageLocalDataSource {
  Future<MessageInfoList> getMessageInfos(
      {required GetMessageReportsFormParams getMessageReportsFormParams});
  Future<void> cacheMessageInfos({
    required MessageInfoList messageInfoList,
    required GetMessageReportsFormParams getMessageReportsFormParams,
  });
}

class MessageLocalDataSourceImpl implements MessageLocalDataSource {
  final SharedPreferences _storage;

  MessageLocalDataSourceImpl({required SharedPreferences storage})
      : _storage = storage;

  String _generateMessageInfoKey(
      GetMessageReportsFormParams getMessageReportsFormParams) {
    return '${Persistence.MESSAGE_INFO}_${getMessageReportsFormParams.userInfo.accountNumber}';
  }

  @override
  Future<MessageInfoList> getMessageInfos(
      {required GetMessageReportsFormParams
          getMessageReportsFormParams}) async {
    final _messageInfoListString = _storage
        .getString(_generateMessageInfoKey(getMessageReportsFormParams));

    if (_messageInfoListString == null) {
      throw const ExceptionType<ExceptionMessage>.cacheException(
        code: ExceptionCode.NOT_FOUND,
        message: ExceptionMessage.NOT_FOUND,
      );
    }

    return MessageInfoList.fromJson(json.decode(_messageInfoListString));
  }

  @override
  Future<void> cacheMessageInfos({
    required MessageInfoList messageInfoList,
    required GetMessageReportsFormParams getMessageReportsFormParams,
  }) async {
    final _messageInfoListString = json.encode(messageInfoList.toJson());
    await _storage.setString(
        _generateMessageInfoKey(getMessageReportsFormParams),
        _messageInfoListString);

    return;
  }
}
