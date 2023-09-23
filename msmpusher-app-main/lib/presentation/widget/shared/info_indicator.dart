import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:msmpusher/core/constants.dart';
import 'package:msmpusher/core/theme/custom_typography.dart';

class InfoIndicator extends StatelessWidget {
  final String label;
  final BorderRadius? borderRadius;

  const InfoIndicator({Key? key, required this.label, this.borderRadius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: (Sizing.kSizingMultiple).h,
        horizontal: (Sizing.kSizingMultiple * 2).w,
      ),
      decoration: BoxDecoration(
        color: CustomTypography.kLightGreyColor,
        borderRadius:
            borderRadius ?? BorderRadius.circular(Sizing.kBorderRadius),
      ),
      child: Text(label),
    );
  }
}
