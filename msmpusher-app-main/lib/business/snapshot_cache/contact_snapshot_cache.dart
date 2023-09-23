import 'package:flutter/material.dart';
import 'package:msmpusher/domain/model/models.dart';

class ContactSnapshotCache with ChangeNotifier {
  static bool _isSearchingContactsMode = false;

  static ContactModelList? _deviceContacts;
  static ContactModelList? _deviceFileContacts;
  static ContactModelList? _searchContactResults;

  // selected contacts
  ContactModelList get selectedContacts {
    final _contacts = deviceContacts.contacts
        .where((element) => element.isChecked == true)
        .toList();

    return ContactModelList(contacts: _contacts);
  }

  // device contacts
  ContactModelList get deviceFileContacts =>
      _deviceFileContacts ?? ContactModelList.empty();
  set deviceFileContacts(ContactModelList contacts) {
    _deviceFileContacts = contacts;
    notifyListeners();
  }

  // device contacts
  ContactModelList get deviceContacts =>
      _deviceContacts ?? ContactModelList.empty();
  set deviceContacts(ContactModelList contacts) {
    _deviceContacts = contacts;
    notifyListeners();
  }

  // contacts search-mode
  bool get isSearchingContactsMode => _isSearchingContactsMode;
  set isSearchingContactsMode(bool status) {
    _isSearchingContactsMode = status;

    if (!status) {
      // reset search-result
      _searchContactResults = _deviceContacts;
    }
    notifyListeners();
  }

  // contacts search result
  ContactModelList get searchContactResults =>
      _searchContactResults ??
      const ContactModelList(contacts: <ContactModel>[]);
  set searchContactResults(ContactModelList result) {
    _searchContactResults = result;
    notifyListeners();
  }

  // declare variable at the top
  final Map<int, dynamic> _selectedContactsHash = {};

  // this holds the latest contact-search term
  static String? _contactSearchParams;

  // util methods
  void selectContact(ContactModel contactModel, {int? index}) {
    // for the best user experience, we should be able to keep track of s
    // elected contacts in both device-contact and search-result lists.

    // find contact index since passed index can be wrong from searched contacts
    index = deviceContacts.contacts.indexWhere((element) =>
        element.primaryPhone.value == contactModel.primaryPhone.value);

    // find contact in contact list
    deviceContacts.contacts[index] = ContactModel.map(
      contact: contactModel.contact,
      uniqueId: contactModel.uniqueId,
      isChecked: !contactModel.isChecked,
    );

    final _contact = deviceContacts.contacts[index];

    if (_contact.isChecked) {
      // add selected contact to hash-map
      final value = <int, dynamic>{index: _contact.isChecked};
      _selectedContactsHash.addEntries(value.entries);
    } else {
      // remove selected contact from hash-map
      _selectedContactsHash.remove(index);
    }

    notifyListeners();

    // after selecting a contact, rebuild search-contacts list with previously cache search-params
    // this ensures the newly selected contact is updated as well in search-contact-list
    searchContactFromList(_contactSearchParams ?? '');
  }

// clear selected contacts
  void clearSelectedContacts() {
    for (int key in _selectedContactsHash.keys) {
      // get phone-number in this index
      final _model = deviceContacts.contacts[key];

      // update contacts checked-status to false by re-initializing it
      deviceContacts.contacts[key] = ContactModel.fromDevice(_model.contact);
    }

    notifyListeners();
  }

  void searchContactFromList(String value) {
    // cache search params
    _contactSearchParams = value;

    if (value.isNotEmpty) {
      if (!isSearchingContactsMode) isSearchingContactsMode = true;
    } else {
      isSearchingContactsMode = false;
    }

    // TODO: could implement multiple contact search support
    final _result = _deviceContacts!.contacts
        .where(
          (element) =>
              element.contact.displayName
                  .toLowerCase()
                  .contains(value.toLowerCase()) ||
              element.primaryPhone.value.toString().contains(value),
        )
        .toList();

    searchContactResults = ContactModelList(contacts: _result);

    notifyListeners();
  }
}
