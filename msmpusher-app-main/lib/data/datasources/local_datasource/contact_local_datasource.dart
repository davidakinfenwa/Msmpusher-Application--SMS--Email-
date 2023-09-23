import 'dart:convert';

import 'package:msmpusher/core/constants.dart';
import 'package:msmpusher/core/exceptions/exceptions.dart';
import 'package:msmpusher/domain/model/contact_group.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ContactLocalDataSource {
  Future<ContactGroupList> getContactGroups();
  Future<void> createContactGroups(ContactGroupList contactGroupList);
}

class ContactLocalDataSourceImpl implements ContactLocalDataSource {
  final SharedPreferences _storage;

  ContactLocalDataSourceImpl({required SharedPreferences storage})
      : _storage = storage;

  @override
  Future<ContactGroupList> getContactGroups() async {
    final _contactGroupString = _storage.getString(Persistence.CONTACT_GROUPS);

    if (_contactGroupString == null) {
      throw const ExceptionType<ExceptionMessage>.cacheException(
        code: ExceptionCode.NOT_FOUND,
        message: ExceptionMessage.NOT_FOUND,
      );
    }

    return ContactGroupList.fromJson(json.decode(_contactGroupString));
  }

  @override
  Future<void> createContactGroups(ContactGroupList contactGroupList) async {
    final _contactGroupString = json.encode(contactGroupList.toJson());
    await _storage.setString(Persistence.CONTACT_GROUPS, _contactGroupString);

    return;
  }
}
