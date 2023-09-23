import 'package:flutter/material.dart';
import 'package:msmpusher/domain/model/models.dart';

class SenderSnapshotCache with ChangeNotifier {
  static SenderIdList? _senderIdList;

  SenderIdList get senderIdList => _senderIdList ?? SenderIdList.empty();
  set senderIdList(SenderIdList senderIdList) {
    _senderIdList = senderIdList;
    notifyListeners();
  }

  void notifyAllListeners() {
    notifyListeners();
  }
}
