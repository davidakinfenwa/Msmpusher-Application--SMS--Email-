import 'package:flutter/material.dart';
import 'package:msmpusher/domain/model/models.dart';

class AuthSnapshotCache with ChangeNotifier {
  static UserInfo? _userInfo;
  static UserInfo? _userInfoContext;
  static AuthKeyModel? _authKeyModel;

  static String? _forgotPasswordPhoneNumber;

  UserInfo get userInfo => _userInfo ?? UserInfo.empty();
  set userInfo(UserInfo user) {
    // set context as well
    _userInfo = _userInfoContext = user;
    notifyListeners();
  }

  UserInfo get userInfoContext => _userInfoContext ?? UserInfo.empty();
  set userInfoContext(UserInfo user) {
    _userInfoContext = user;
    notifyListeners();
  }

  AuthKeyModel get authKeyModel => _authKeyModel ?? AuthKeyModel.empty();
  set authKeyModel(AuthKeyModel authKey) {
    _authKeyModel = authKey;
    notifyListeners();
  }

  String? get forgotPasswordPhoneNumber => _forgotPasswordPhoneNumber;
  set forgotPasswordPhoneNumber(String? phoneNumber) {
    _forgotPasswordPhoneNumber = phoneNumber;
    notifyListeners();
  }

  void notifyAllListeners() {
    notifyListeners();
  }

  void clearSnapshotCache() {
    _userInfo = null;
    _authKeyModel = null;
    notifyAllListeners();
  }
}
