import 'package:flutter/material.dart';
import 'package:msmpusher/domain/model/models.dart';

class GroupSnapshotCache with ChangeNotifier {
  static ContactGroup? _previewContext;
  static ContactGroupList? _contactGroupList;

  // selected groups
  ContactGroupList get selectedGroups {
    final _groups = contactGroupList.groups
        .where((element) => element.isChecked == true)
        .toList();

    return ContactGroupList(groups: _groups);
  }

  ContactGroup get previewContext => _previewContext ?? ContactGroup.empty();
  set previewContext(ContactGroup contactGroup) {
    _previewContext = contactGroup;
    notifyListeners();
  }

  ContactGroupList get contactGroupList =>
      _contactGroupList ?? ContactGroupList.empty();
  set contactGroupList(ContactGroupList contactGroupList) {
    _contactGroupList = contactGroupList;
    notifyListeners();
  }

  void notifyAllListeners() {
    notifyListeners();
  }

  // declare variable at the top
  final Map<int, dynamic> _selectedContactGroupsHash = {};

  // util methods
  void selectContactGroup(ContactGroup contactGroup, {int? index}) {
    // find contact index since passed index can be wrong from searched contacts
    index = contactGroupList.groups.indexWhere(
      (element) =>
          element.name == contactGroup.name &&
          element.contactList.contacts.length ==
              contactGroup.contactList.contacts.length,
    );

    // find contact in contact list
    contactGroupList.groups[index] = ContactGroup.map(
      name: contactGroup.name,
      uniqueId: contactGroup.uniqueId,
      isChecked: !contactGroup.isChecked,
      contactModelList: contactGroup.contactList,
    );

    final _group = contactGroupList.groups[index];

    if (_group.isChecked) {
      // add selected contact to hash-map
      final value = <int, dynamic>{index: _group.isChecked};
      _selectedContactGroupsHash.addEntries(value.entries);
    } else {
      // remove selected contact from hash-map
      _selectedContactGroupsHash.remove(index);
    }

    notifyListeners();
  }

// clear selected contacts
  void clearSelectedContactGroups() {
    for (int key in _selectedContactGroupsHash.keys) {
      // get phone-number in this index
      final _contactGroup = contactGroupList.groups[key];

      // update contacts checked-status to false by re-initializing it
      contactGroupList.groups[key] = ContactGroup.map(
        name: _contactGroup.name,
        isChecked: false,
        uniqueId: _contactGroup.uniqueId,
        contactModelList: _contactGroup.contactList,
      );
    }

    notifyListeners();
  }
}
