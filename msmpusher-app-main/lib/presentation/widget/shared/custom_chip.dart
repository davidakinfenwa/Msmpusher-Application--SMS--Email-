import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:msmpusher/core/constants.dart';
import 'package:msmpusher/core/theme/custom_typography.dart';

class CustomChip extends StatelessWidget {
  final String label;
  final String? prefix;
  final Color? foregroundColor;
  final Color? backgroundColor;

  const CustomChip({
    Key? key,
    required this.label,
    this.prefix,
    this.foregroundColor,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? CustomTypography.kLightGreyColor,
        borderRadius: BorderRadius.circular(Sizing.kSizingMultiple * 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (prefix != null) ...[
            Container(
              padding: EdgeInsets.all((Sizing.kSizingMultiple).h),
              constraints: BoxConstraints(
                minHeight: (Sizing.kSizingMultiple * 4).h,
                minWidth: (Sizing.kSizingMultiple * 4).h,
              ),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: backgroundColor ?? CustomTypography.kLightGreyColor,
              ),
              child: Text(prefix!),
            ),
          ],
          SizedBox(width: (Sizing.kSizingMultiple).w),
          Padding(
            padding: EdgeInsets.only(
              top: (Sizing.kSizingMultiple * .5).h,
              bottom: (Sizing.kSizingMultiple * .5).h,
              right: (Sizing.kSizingMultiple * 1.5).w,
            ),
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    color: foregroundColor ?? CustomTypography.kBlackColor,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
