import 'package:dartz/dartz.dart';
import 'package:msmpusher/core/exceptions/exceptions.dart';
import 'package:msmpusher/core/util/unit_impl.dart';
import 'package:msmpusher/data/datasources/datasources.dart';
import 'package:msmpusher/domain/model/contact_group.dart';
import 'package:msmpusher/domain/model/contact_model.dart';
import 'package:msmpusher/domain/model/shared/unique_id.dart';
import 'package:msmpusher/domain/repositories/repositories.dart';

class ContactRepositoryImpl implements ContactRepository {
  final ContactLocalDataSource _contactLocalDataSource;
  final DeviceContactDataSource _deviceContactDataSource;

  ContactRepositoryImpl({
    required ContactLocalDataSource contactLocalDataSource,
    required DeviceContactDataSource deviceContactDataSource,
  })  : _contactLocalDataSource = contactLocalDataSource,
        _deviceContactDataSource = deviceContactDataSource;

  Future<Either<Failure<ExceptionMessage>, ContactGroupList>>
      _getContactGroupsFromLocalDataSource() async {
    try {
      final _contactGroupList =
          await _contactLocalDataSource.getContactGroups();

      return right(_contactGroupList);
    } on ExceptionType<ExceptionMessage> catch (e) {
      return left(Failure.platformsFailure(exception: e));
    }
  }

  @override
  Future<Either<Failure<ExceptionMessage>, ContactModelList>>
      getContactsFromDevice() async {
    try {
      return right(await _deviceContactDataSource.getDeviceContacts());
    } on ExceptionType<ExceptionMessage> catch (e) {
      return left(Failure.platformsFailure(exception: e));
    }
  }

  @override
  Future<Either<Failure<ExceptionMessage>, ContactModelList>>
      getContactsFromFile() async {
    try {
      final _result = await _deviceContactDataSource.getGetFileContacts();
      return right(_result);
    } on ExceptionType<ExceptionMessage> catch (e) {
      return left(Failure.platformsFailure(exception: e));
    }
  }

  @override
  Future<Either<Failure<ExceptionMessage>, ContactGroupList>>
      getGroups() async {
    final _contactGroupsEither = await _getContactGroupsFromLocalDataSource();

    final _result = _contactGroupsEither.fold(
      (_) => ContactGroupList.empty(),
      (contactGroupList) => contactGroupList,
    );

    return right(_result);
  }

  @override
  Future<Either<Failure<ExceptionMessage>, UnitImpl>> createGroup(
      {required ContactGroup contactGroup}) async {
    try {
      // get contacts-groups
      final _contactGroupListEither =
          await _getContactGroupsFromLocalDataSource();

      List<ContactGroup> _contactGroupListToUpdate = [];

      if (_contactGroupListEither.isLeft()) {
        // create a new list and add contact group
        _contactGroupListToUpdate = [contactGroup];
      } else {
        // add contactGroup to existing contact-group-list
        _contactGroupListToUpdate = [
          contactGroup,
          ..._contactGroupListEither
              .getOrElse(() => ContactGroupList.empty())
              .groups,
        ];
      }

      await _contactLocalDataSource.createContactGroups(
          ContactGroupList(groups: _contactGroupListToUpdate));

      return right(unitImpl);
    } on ExceptionType<ExceptionMessage> catch (e) {
      return left(Failure.platformsFailure(exception: e));
    }
  }

  @override
  Future<Either<Failure<ExceptionMessage>, UnitImpl>> deleteGroup(
      {required UniqueId uniqueId}) async {
    try {
      // get contacts-groups
      final _contactGroupListEither =
          await _getContactGroupsFromLocalDataSource();

      if (_contactGroupListEither.isRight()) {
        final _contactGroupList =
            _contactGroupListEither.getOrElse(() => ContactGroupList.empty());
        final _contactGroups = [..._contactGroupList.groups];

        // find and remove group being-deleted from list
        _contactGroups.removeWhere(
            (element) => element.uniqueId.toString() == uniqueId.toString());

        // save modified list
        await _contactLocalDataSource
            .createContactGroups(ContactGroupList(groups: _contactGroups));
      }

      return right(unitImpl);
    } on ExceptionType<ExceptionMessage> catch (e) {
      return left(Failure.platformsFailure(exception: e));
    }
  }

  @override
  Future<Either<Failure<ExceptionMessage>, ContactGroup>> deleteGroupContact({
    required UniqueId groupUniqueId,
    required UniqueId contactUniqueId,
  }) async {
    try {
      // get contacts-groups
      final _contactGroupListEither =
          await _getContactGroupsFromLocalDataSource();

      ContactGroup? _updatedContactGroup;

      if (_contactGroupListEither.isRight()) {
        final _contactGroupList =
            _contactGroupListEither.getOrElse(() => ContactGroupList.empty());

        final _contactGroups = [..._contactGroupList.groups];

        // find contact group
        final _contactGroupIndex = _contactGroupList.groups.indexWhere(
            (element) =>
                element.uniqueId.toString() == groupUniqueId.toString());

        // find remove contact from group
        final _contactGroup = _contactGroupList.groups[_contactGroupIndex];
        final _groupContacts = [..._contactGroup.contactList.contacts];
        _groupContacts.removeWhere((element) =>
            element.uniqueId.toString() == contactUniqueId.toString());

        // set group contact-list to modified-contact list
        _updatedContactGroup = ContactGroup.map(
          name: _contactGroup.name,
          isChecked: _contactGroup.isChecked,
          uniqueId: _contactGroup.uniqueId,
          contactModelList: ContactModelList(contacts: _groupContacts),
        );

        // update entire contact-group list with modified group
        _contactGroups[_contactGroupIndex] = _updatedContactGroup;

        // save modified list
        await _contactLocalDataSource
            .createContactGroups(ContactGroupList(groups: _contactGroups));
      }

      return right(_updatedContactGroup!);
    } on ExceptionType<ExceptionMessage> catch (e) {
      return left(Failure.platformsFailure(exception: e));
    }
  }
}
