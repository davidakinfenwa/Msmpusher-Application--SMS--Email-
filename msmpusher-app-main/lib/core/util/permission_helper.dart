import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  Future<bool> requestPermission(Permission permission) async {
    final _isPermanentlyDenied = await permission.isPermanentlyDenied;
    if (_isPermanentlyDenied) {
      final _isPermissionResolved = await openAppSettings();
      print('permission status - $_isPermissionResolved');
      return _isPermissionResolved;
    }

    return permission.request().isGranted;
  }
}
