import 'package:flutter/material.dart';

class ColorUtil {
  static Color colorFromHex(String hexColor) {
    final _hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$_hexCode', radix: 16));
  }
}
