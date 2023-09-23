import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:msmpusher/core/constants.dart';
import 'package:msmpusher/core/theme/custom_typography.dart';
import 'package:msmpusher/core/util/width_constraints.dart';

class PageItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final Color backgroundColor;
  final bool reversed;
  final TextAlign textAlign;
  final Color textColor;

  const PageItem({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.backgroundColor,
    this.reversed = false,
    this.textAlign = TextAlign.center,
    this.textColor = CustomTypography.kWhiteColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      padding: EdgeInsets.symmetric(
        horizontal: WidthConstraint(context).contentPadding,
      ),
      child: Column(
        children: [
          SizedBox(height: Sizing.kHSpacing35),
          if (!reversed) ...[
            Image.asset(
              imageUrl,
              height: (Sizing.kSizingMultiple * 43).h,
              width: (Sizing.kSizingMultiple * 48.75).w,
            ),
          ],
          Text(
            title,
            textAlign: textAlign,
            style: Theme.of(context).textTheme.headline2!.copyWith(
                  color: textColor,
                ),
          ),
          SizedBox(height: Sizing.kSizingMultiple.h),
          Text(
            description,
            textAlign: textAlign,
            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                  color: textColor,
                ),
          ),
          if (reversed) ...[
            SizedBox(height: (Sizing.kSizingMultiple * 3.25).h),
            Image.asset(
              imageUrl,
              height: (Sizing.kSizingMultiple * 43).h,
              width: (Sizing.kSizingMultiple * 48.75).w,
            ),
          ],
        ],
      ),
    );
  }
}
