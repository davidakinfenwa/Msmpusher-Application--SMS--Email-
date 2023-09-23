// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:msmpusher/domain/model/models.dart';

class ContactPhone extends Equatable {
  final String label;
  final String value;

  const ContactPhone({required this.label, required this.value});

  factory ContactPhone.fromJson(Map<String, dynamic> json) {
    return ContactPhone(label: json['label'], value: json['value']);
  }

  Map<String, dynamic> toJson() {
    return {'label': label, 'value': value};
  }

  @override
  List<Object> get props => [label, value];

  @override
  String toString() => 'ContactPhone(label: $label, value: $value)';
}

class ContactEntity extends Equatable {
  final String displayName;
  final List<ContactPhone> phones;

  const ContactEntity({required this.displayName, required this.phones});

  factory ContactEntity.fromJson(Map<String, dynamic> json) {
    return ContactEntity(
      displayName: json['displayName'] ?? 'No Display Name!',
      phones: (json['phones'] as List)
          .map((e) => ContactPhone.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'displayName': displayName,
      'phones': phones.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object> get props => [displayName, phones];

  @override
  String toString() =>
      'ContactEntity(displayName: $displayName, phones: $phones)';
}

class ContactModel extends Equatable {
  final bool isChecked;
  final UniqueId uniqueId;
  final ContactEntity contact;

  ContactPhone get primaryPhone => contact.phones.first;

  const ContactModel._(
      {required this.isChecked, required this.uniqueId, required this.contact});

  factory ContactModel.map({
    required ContactEntity contact,
    required UniqueId uniqueId,
    required bool isChecked,
  }) {
    return ContactModel._(
        isChecked: isChecked, uniqueId: uniqueId, contact: contact);
  }

  factory ContactModel.fromDevice(ContactEntity contact) {
    return ContactModel._(
        isChecked: false, uniqueId: UniqueId(), contact: contact);
  }

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel._(
      isChecked: false,
      uniqueId: UniqueId.parse(json['uniqueId']),
      contact: ContactEntity.fromJson(json['contact']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'contact': contact.toJson(),
      'uniqueId': uniqueId.toString(),
    };
  }

  @override
  String toString() =>
      'ContactModel(isChecked: $isChecked, uniqueId: $uniqueId, contact: ${contact.toJson()})';

  @override
  List<Object> get props => [isChecked, uniqueId, contact];
}

class ContactModelList extends Equatable {
  final List<ContactModel> contacts;

  bool get IS_EMPTY => contacts.isEmpty;
  int get LENGTH => contacts.isEmpty ? 0 : contacts.length;

  List<String> get phoneNumberStrings =>
      contacts.map((e) => e.primaryPhone.value).toList();

  const ContactModelList({required this.contacts});

  factory ContactModelList.empty() {
    return const ContactModelList(contacts: []);
  }

  List<Map<String, dynamic>> toJson() {
    return contacts.map((e) => e.toJson()).toList();
  }

  @override
  String toString() => 'ContactModelList(contacts: $contacts)';

  @override
  List<Object> get props => [contacts];
}
