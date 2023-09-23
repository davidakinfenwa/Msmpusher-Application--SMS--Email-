import 'package:permission_handler/permission_handler.dart';

class PermissionUtil {
  static Future<bool?> getStoragePermission() async {
    try {
      final _permission = await Permission.storage.request();

      if (_permission.isGranted) {
        return true;
      } else if (_permission.isPermanentlyDenied) {
        return openAppSettings();
      } else if (_permission.isDenied) {
        return false;
      }
    } catch (e) {
      return false;
    }
    return null;
  }
}
