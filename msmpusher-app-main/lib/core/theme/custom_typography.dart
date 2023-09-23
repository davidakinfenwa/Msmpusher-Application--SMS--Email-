import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:msmpusher/core/constants.dart';
import 'package:msmpusher/core/util/color_util.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: avoid_classes_with_only_static_members
class CustomTypography {
  // static final kPrimaryColor = ColorUtil.colorFromHex('563b96');
  static final kPrimaryColor = ColorUtil.colorFromHex('#0068DD');
  static final kDarkPrimaryColor = ColorUtil.colorFromHex('#06102B');
  static final kPrimaryColor10 = kPrimaryColor.withOpacity(.10);
  static final kPrimaryColor50 = kPrimaryColor.withOpacity(.50);

  static final kSecondaryColor = ColorUtil.colorFromHex('#FAA037');
  static final kSecondaryColor10 = kSecondaryColor.withOpacity(.10);
  static final kSecondaryColor50 = kSecondaryColor.withOpacity(.50);

  static final kIndicationColor = ColorUtil.colorFromHex('#00A69C');
  static final kIndicationColor10 = kIndicationColor.withOpacity(.10);
  static final kIndicationColor50 = kIndicationColor.withOpacity(.50);

  static final kErrorColor = ColorUtil.colorFromHex('#FA5F3D');
  static final kErrorColor10 = kErrorColor.withOpacity(.10);
  static final kErrorColor50 = kErrorColor.withOpacity(.50);

  static const kGreyColor = Colors.grey;
  static final kLightGreyColor = ColorUtil.colorFromHex('#E5E5E5');
  static final kMidGreyColor = ColorUtil.colorFromHex('#808080');
  static final kDarkGreyColor = ColorUtil.colorFromHex('#494949');

  static const kWhiteColor = Colors.white;
  static const kWhiteColor54 = Colors.white54;

  static const kBlackColor = Colors.black;
  static const kTransparentColor = Colors.transparent;
  static final kBackgroundColor = ColorUtil.colorFromHex('#FFf2f5fb');

  static final kTextFieldBorderColor = Colors.grey.shade400;

  static final _dmSansFont = GoogleFonts.dmSans(fontSize: 14.0.sp);
  static final ThemeData _defaultTheme = ThemeData(
    primaryColor: kPrimaryColor,
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: kSecondaryColor),
    textSelectionTheme: TextSelectionThemeData(cursorColor: kPrimaryColor),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    iconTheme: IconThemeData(size: 24.0.sp),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: _dmSansFont,
      hintStyle: _dmSansFont,
      prefixStyle: _dmSansFont,
      suffixStyle: _dmSansFont,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: kTextFieldBorderColor),
        // gapPadding: Sizing.kZeroValue,
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: kTextFieldBorderColor),
        // gapPadding: Sizing.kZeroValue,
      ),
    ),
    scaffoldBackgroundColor: kBackgroundColor,
    appBarTheme: AppBarTheme(
      color: kBackgroundColor,
      elevation: Sizing.kZeroValue,
    ),
  );

  static final ThemeData themeDataModifications = _defaultTheme.copyWith(
    textTheme: GoogleFonts.dmSansTextTheme(_defaultTheme.textTheme).copyWith(
      headline1: GoogleFonts.dmSans(
        color: kBlackColor,
        fontSize: 33.0.sp,
        fontWeight: FontWeight.bold,
      ),
      headline2: GoogleFonts.dmSans(
        color: kBlackColor,
        fontSize: 30.0.sp,
        fontWeight: FontWeight.bold,
      ),
      headline3: GoogleFonts.dmSans(
        color: kBlackColor,
        fontSize: 27.0.sp,
        // fontWeight: FontWeight.bold,
      ),
      headline4: GoogleFonts.dmSans(
        color: kBlackColor,
        fontSize: 23.0.sp,
        // fontWeight: FontWeight.bold,
      ),
      headline5: GoogleFonts.dmSans(
        color: kBlackColor,
        fontSize: 20.0.sp,
        // fontWeight: FontWeight.bold,
      ),
      headline6: GoogleFonts.dmSans(
        color: kBlackColor,
        fontSize: 16.0.sp,
        fontWeight: FontWeight.bold,
      ),
      caption: GoogleFonts.dmSans(
        color: kBlackColor,
        fontSize: 14.0.sp,
      ),
      bodyText1: GoogleFonts.dmSans(
        color: kBlackColor,
        fontSize: 14.0.sp,
        fontWeight: FontWeight.bold,
      ),
      bodyText2: GoogleFonts.dmSans(
        color: kBlackColor,
        fontSize: 14.0.sp,
        fontWeight: FontWeight.normal,
      ),
      subtitle1: GoogleFonts.dmSans(color: kBlackColor, fontSize: 14.0.sp),
      subtitle2: GoogleFonts.dmSans(color: kGreyColor, fontSize: 14.0.sp),
    ),
  );
}
