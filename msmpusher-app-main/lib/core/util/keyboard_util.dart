import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class KeyboardUtil {
  static bool isKeyboardVisible(BuildContext context) =>
      KeyboardVisibilityProvider.isKeyboardVisible(context);

  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }
}
