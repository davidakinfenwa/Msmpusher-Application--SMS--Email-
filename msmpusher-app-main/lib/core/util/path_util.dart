// import 'dart:io';

// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf_edit/core/util/permission_util.dart';

// class PathUtil {
//   static Future<String> getFilePath(String fileName) async {
//     await PermissionUtil.getStoragePermission();

//     // if (_permissionGranted == null || !_permissionGranted) return none();

//     Directory _directory = await getTemporaryDirectory();
//     // ignore: unnecessary_null_comparison
//     if (_directory == null) {
//       _directory = await getApplicationDocumentsDirectory();
//     }

//     final _path = join(_directory.path, '$fileName.pdf');
//     // final _path = join(_directory.path,
//     //     '$fileName-${DateTimeUtil.toDateString(DateTime.now())}.pdf');

//     return _path;

//     // return some(_path);
//   }
// }
