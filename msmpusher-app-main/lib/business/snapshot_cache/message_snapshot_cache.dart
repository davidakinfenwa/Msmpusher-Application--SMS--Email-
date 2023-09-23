import 'package:flutter/material.dart';
import 'package:msmpusher/domain/model/models.dart';

class MessageSnapshotCache with ChangeNotifier {
  static bool _isSearchingMessageInfoListMode = false;

  static MessageInfoList? _messageInfoList;
  static MessageInfoList? _searchMessageInfoListResult;

  // this holds the latest contact-search term
  static String? _messageInfoSearchParams;

  MessageInfoList get messageInfoList =>
      _messageInfoList ?? MessageInfoList.empty();
  set messageInfoList(MessageInfoList messageInfos) {
    _messageInfoList = messageInfos;
    notifyListeners();
  }

  // contacts search-mode
  bool get isSearchingMessageInfoListMode => _isSearchingMessageInfoListMode;
  set isSearchingMessageInfoListMode(bool status) {
    _isSearchingMessageInfoListMode = status;

    if (!status) {
      // reset search-result
      _searchMessageInfoListResult = _messageInfoList;
    }
    notifyListeners();
  }

  // message-report search result
  MessageInfoList get searchMessageInfoListResult =>
      _searchMessageInfoListResult ??
      const MessageInfoList(messages: <MessageInfo>[]);
  set searchMessageInfoListResult(MessageInfoList result) {
    _searchMessageInfoListResult = result;
    notifyListeners();
  }

  void notifyAllListeners() {
    notifyListeners();
  }

  void searchMessageInfoFromList(String value) {
    // cache search params
    _messageInfoSearchParams = value;

    if (value.isNotEmpty) {
      if (!isSearchingMessageInfoListMode) {
        isSearchingMessageInfoListMode = true;
      }
    } else {
      isSearchingMessageInfoListMode = false;
    }

    final _result = _messageInfoList!.messages
        .where(
          (element) =>
              element.message.toLowerCase().contains(value.toLowerCase()) ||
              element.receivers
                  .join(',')
                  .toLowerCase()
                  .contains(value.toLowerCase()) ||
              element.dateSent
                  .toString()
                  .toLowerCase()
                  .contains(value.toLowerCase()),
        )
        .toList();

    searchMessageInfoListResult = MessageInfoList(messages: _result);

    notifyListeners();
  }
}
