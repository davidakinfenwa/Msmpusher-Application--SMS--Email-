import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:msmpusher/core/constants.dart';
import 'package:msmpusher/core/theme/custom_typography.dart';
import 'package:msmpusher/core/util/width_constraints.dart';

class CustomDivider extends StatelessWidget {
  final num top;
  final num bottom;
  final num all;

  const CustomDivider({
    Key? key,
    this.top = 0.0,
    this.bottom = 0.0,
    this.all = 0.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: WidthConstraint(context).maxWidthConstraint,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: (Sizing.kSizingMultiple * ((all > 0) ? all : top)).h,
          ),
          Divider(
            height: Sizing.kZeroValue,
            color: CustomTypography.kLightGreyColor,
          ),
          SizedBox(
            height: (Sizing.kSizingMultiple * ((all > 0) ? all : bottom)).h,
          ),
        ],
      ),
    );
  }
}
