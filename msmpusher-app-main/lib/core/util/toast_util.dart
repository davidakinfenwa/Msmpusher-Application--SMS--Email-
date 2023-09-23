import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastUtil {
  static Future<bool?> showToast(String message, {bool longLength = false}) {
    return Fluttertoast.showToast(
      msg: message,
      toastLength: longLength ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0.sp,
    );
  }
}
