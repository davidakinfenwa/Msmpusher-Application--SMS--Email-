import 'package:path_provider/path_provider.dart';

class CacheUtil {
  static Future<void> deleteCacheDir() async {
    final _cacheDir = await getTemporaryDirectory();

    if (_cacheDir.existsSync()) {
      _cacheDir.deleteSync(recursive: true);
    }
  }

  static Future<void> deleteAppDir() async {
    final _appDir = await getApplicationSupportDirectory();

    if (_appDir.existsSync()) {
      _appDir.deleteSync(recursive: true);
    }
  }
}
