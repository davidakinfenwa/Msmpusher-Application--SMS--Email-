import 'dart:io';

import 'package:contacts_service/contacts_service.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:msmpusher/core/exceptions/exceptions.dart';
import 'package:msmpusher/core/util/permission_helper.dart';
import 'package:msmpusher/domain/model/models.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class DeviceContactDataSource {
  Future<ContactModelList> getDeviceContacts();
  Future<ContactModelList> getGetFileContacts();
}

class DeviceContactDataSourceImpl implements DeviceContactDataSource {
  final PermissionHelper _permissionHelper;

  const DeviceContactDataSourceImpl(
      {required PermissionHelper permissionHelper})
      : _permissionHelper = permissionHelper;

  // gets all contacts from device
  Future<List<Contact>> get _getContactsFromDevice async =>
      await ContactsService.getContacts(withThumbnails: false);

  Future<File> _getSingleFileFromDevice({bool isXLSXFile = false}) async {
    FilePickerResult? _result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        if (isXLSXFile) ...['xls', 'xlsx', 'csv'] else ...['jpg', 'jpeg', 'png']
      ],
    );

    if (_result == null) {
      throw const ExceptionType.platformsException(
        code: ExceptionCode.CANCELLED,
        message: ExceptionMessage.CANCELLED,
      );
    }

    return File(_result.files.single.path!);
  }

  @override
  Future<ContactModelList> getDeviceContacts() async {
    try {
      final _hasRequestedPermission =
          await _permissionHelper.requestPermission(Permission.contacts);

      if (_hasRequestedPermission) {
        final _mappedContacts = (await _getContactsFromDevice)
            .where((e) => e.phones != null && e.phones!.isNotEmpty)
            .map((e) {
          // map contacts to contact entity
          final _contactEntity = ContactEntity(
            displayName: e.displayName ?? 'No Display Name',
            phones: e.phones!
                .map((e) => ContactPhone(label: e.label!, value: e.value!))
                .toList(),
          );

          return ContactModel.fromDevice(_contactEntity);
        }).toList();

        return ContactModelList(contacts: _mappedContacts);
      }

      throw const ExceptionType<ExceptionMessage>.platformsException(
        code: ExceptionCode.CONTACT,
        message: ExceptionMessage.CONTACT,
      );
    } catch (e) {
      if (e is ExceptionType<ExceptionMessage>) {
        rethrow;
      }

      throw ExceptionType.platformsException(
        code: ExceptionCode.CONTACT,
        message: e.toString(),
      );
    }
  }

  @override
  Future<ContactModelList> getGetFileContacts() async {
    try {
      final _contactFile = await _getSingleFileFromDevice(isXLSXFile: true);

      final _bytes = _contactFile.readAsBytesSync();
      final _excelFile = Excel.decodeBytes(_bytes);
      final _tables = _excelFile.tables;

      final _contactModelList = <ContactModel>[];

      for (final table in _tables.keys) {
        if (_tables[table] == null) {
          throw ExceptionType.platformsException(
            code: ExceptionCode.NOT_FOUND,
            message: ExceptionMessage.parse(
                'Cannot find contact-file excel sheet! Ensure uploaded file is valid'),
          );
        }

        for (final row in _tables[table]!.rows) {
          final _context = row[0];

          if (_context == null) continue;

          final _contactEntity = ContactEntity(
            displayName: _context.value.toString(),
            phones: <ContactPhone>[
              ContactPhone(label: 'mobile', value: _context.value.toString()),
            ],
          );

          final _contactModel = ContactModel.fromDevice(_contactEntity);

          _contactModelList.add(_contactModel);
        }
      }

      return ContactModelList(contacts: _contactModelList);
    } catch (e) {
      if (e is ExceptionType<ExceptionMessage>) {
        rethrow;
      }

      throw ExceptionType.platformsException(
        code: ExceptionCode.CONTACT,
        message: e.toString(),
      );
    }
  }
}
