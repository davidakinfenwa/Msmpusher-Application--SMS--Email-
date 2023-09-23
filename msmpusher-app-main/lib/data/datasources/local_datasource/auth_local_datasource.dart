import 'dart:convert';

import 'package:msmpusher/core/constants.dart';
import 'package:msmpusher/core/exceptions/exceptions.dart';
import 'package:msmpusher/domain/model/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  Future<UserInfoModel> getUserInfo();
  Future<UserInfoModel> getUserProfile();
  Future<AuthKeyModel> getAuthKey();
  Future<void> cacheUserInfo(UserInfoModel userInfoModel);
  Future<void> cacheUserProfile(UserInfoModel userInfoModel);
  Future<void> cacheAuthKey(AuthKeyModel authKeyModel);
  Future<void> clearAppPreference();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences _storage;

  AuthLocalDataSourceImpl({required SharedPreferences storage})
      : _storage = storage;

  @override
  Future<UserInfoModel> getUserInfo() async {
    final _userInfoString = _storage.getString(Persistence.AUTH_USER_INFO);

    if (_userInfoString == null) {
      throw const ExceptionType<ExceptionMessage>.cacheException(
        code: ExceptionCode.NOT_FOUND,
        message: ExceptionMessage.NOT_FOUND,
      );
    }

    return UserInfoModel.fromJson(json.decode(_userInfoString));
  }

  @override
  Future<UserInfoModel> getUserProfile() async {
    final _userProfileString =
        _storage.getString(Persistence.AUTH_USER_PROFILE);

    if (_userProfileString == null) {
      throw const ExceptionType<ExceptionMessage>.cacheException(
        code: ExceptionCode.NOT_FOUND,
        message: ExceptionMessage.NOT_FOUND,
      );
    }

    return UserInfoModel.fromJson(json.decode(_userProfileString));
  }

  @override
  Future<AuthKeyModel> getAuthKey() async {
    final _authKeyString = _storage.getString(Persistence.AUTH_KEY);

    if (_authKeyString == null) {
      throw const ExceptionType<ExceptionMessage>.cacheException(
        code: ExceptionCode.NOT_FOUND,
        message: ExceptionMessage.NOT_FOUND,
      );
    }

    return AuthKeyModel.fromJson(json.decode(_authKeyString));
  }

  @override
  Future<void> cacheUserInfo(UserInfoModel userInfoModel) async {
    final _userInfoString = json.encode(userInfoModel.toJson());
    await _storage.setString(Persistence.AUTH_USER_INFO, _userInfoString);

    return;
  }

  @override
  Future<void> cacheUserProfile(UserInfoModel userInfoModel) async {
    final _userProfileString = json.encode(userInfoModel.toJson());
    await _storage.setString(Persistence.AUTH_USER_PROFILE, _userProfileString);

    return;
  }

  @override
  Future<void> cacheAuthKey(AuthKeyModel authKeyModel) async {
    final _authKeyString = json.encode(authKeyModel.toJson());
    await _storage.setString(Persistence.AUTH_KEY, _authKeyString);

    return;
  }

  @override
  Future<void> clearAppPreference() async {
    await _storage.clear();

    return;
  }
}
