import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:msmpusher/core/constants.dart';
import 'package:msmpusher/core/theme/custom_typography.dart';
import 'package:msmpusher/core/util/width_constraints.dart';
import 'package:msmpusher/presentation/widget/shared/custom_divider.dart';

class GenericBottomSheet extends StatelessWidget {
  final Widget title;
  final Widget description;
  final Widget? trailing;
  final Widget child;

  const GenericBottomSheet({
    Key? key,
    required this.title,
    required this.description,
    required this.child,
    this.trailing,
  }) : super(key: key);

  Widget _buildTitleSection() {
    return Builder(builder: (context) {
      return WidthConstraint(context).withHorizontalSymmetricalPadding(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  title,
                  description,
                ],
              ),
            ),
            trailing ?? Container(),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // SizedBox(height: (Sizing.kSizingMultiple * 3.5).h),
        AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: CustomTypography.kTransparentColor,
        ),
        _buildTitleSection(),
        SizedBox(height: (Sizing.kSizingMultiple * 1.5).h),
        const CustomDivider(),
        // SizedBox(height: (Sizing.kSizingMultiple * 2).h),
        child,
      ],
    );
  }
}
