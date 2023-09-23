import 'dart:convert';
import 'dart:typed_data';

class FileConvertUtil {
  static String encodeToBase64String(Uint8List bytes) {
    return base64.encode(bytes);
  }

  static Uint8List decodeFromBase64String(String base64String) {
    return base64.decode(base64String);
  }
}
