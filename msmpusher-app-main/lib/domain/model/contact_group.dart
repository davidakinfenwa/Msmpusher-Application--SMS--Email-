// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:msmpusher/domain/model/models.dart';

class ContactGroup extends Equatable {
  final String name;
  final bool isChecked;
  final UniqueId uniqueId;
  final ContactModelList contactList;

  int get contactsLength => contactList.contacts.length;

  const ContactGroup._({
    required this.name,
    required this.isChecked,
    required this.uniqueId,
    required this.contactList,
  });

  factory ContactGroup.init(
      {required String name, required ContactModelList contactModelList}) {
    return ContactGroup._(
      name: name,
      isChecked: false,
      uniqueId: UniqueId(),
      contactList: contactModelList,
    );
  }

  factory ContactGroup.empty() {
    return ContactGroup._(
      name: '',
      isChecked: false,
      uniqueId: UniqueId(),
      contactList: ContactModelList.empty(),
    );
  }

  factory ContactGroup.map({
    required String name,
    required bool isChecked,
    required UniqueId uniqueId,
    required ContactModelList contactModelList,
  }) {
    return ContactGroup._(
      name: name,
      isChecked: isChecked,
      uniqueId: uniqueId,
      contactList: contactModelList,
    );
  }

  factory ContactGroup.fromJson(Map<String, dynamic> json) {
    final _contacts = (json['contacts'] as List)
        .map((e) => ContactModel.fromJson(e))
        .toList();

    return ContactGroup._(
      name: json['name'],
      isChecked: false,
      uniqueId: UniqueId.parse(json['uniqueId']),
      contactList: ContactModelList(contacts: _contacts),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'uniqueId': uniqueId.toString(),
      'contacts': contactList.contacts.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object> get props => [name, contactList];

  @override
  String toString() {
    return 'ContactGroup(name: $name, isChecked: $isChecked, uniqueId: $uniqueId, contactList: $contactList)';
  }
}

class ContactGroupList extends Equatable {
  final List<ContactGroup> groups;

  int get LENGTH => groups.isEmpty ? 0 : groups.length;

  ContactModelList get ALL_MERGED_CONTACTS {
    final _contactModelsList = groups.map((e) => e.contactList).toList();

    final _expandedContactModel =
        _contactModelsList.expand((e) => e.contacts).toList();

    return ContactModelList(contacts: _expandedContactModel);
  }

  const ContactGroupList({required this.groups});

  factory ContactGroupList.fromJson(List<dynamic> json) {
    return ContactGroupList(
      groups: json
          .map((e) => ContactGroup.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  factory ContactGroupList.empty() {
    return const ContactGroupList(groups: []);
  }

  List<Map<String, dynamic>> toJson() {
    return groups.map((e) => e.toJson()).toList();
  }

  @override
  List<Object> get props => [groups];

  @override
  String toString() => 'ContactGroupList(groups: $groups)';
}
