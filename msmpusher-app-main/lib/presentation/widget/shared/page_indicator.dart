import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:msmpusher/core/constants.dart';
import 'package:msmpusher/core/theme/custom_typography.dart';

class PageIndicator extends StatefulWidget {
  final int pageCount;
  final int activePageIndex;
  final Color? dotColor;
  final Color? dotIndicatorColor;

  const PageIndicator({
    Key? key,
    required this.pageCount,
    required this.activePageIndex,
    this.dotColor,
    this.dotIndicatorColor,
  }) : super(key: key);
  @override
  _PageIndicatorState createState() => _PageIndicatorState();
}

class _PageIndicatorState extends State<PageIndicator> {
  int get _pageCount => widget.pageCount;
  int get _activePageIndex => widget.activePageIndex;

  Color get _dotColor => widget.dotColor ?? CustomTypography.kWhiteColor;
  Color? get _dotIndicatorColor =>
      widget.dotIndicatorColor ?? CustomTypography.kSecondaryColor;

  Widget _buildActiveIndicator() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: TimeDuration.kAnimationDuration),
      height: Sizing.kSizingMultiple.h,
      width: Sizing.kSizingMultiple.h * 3,
      decoration: BoxDecoration(
        // shape: BoxShape.circle,
        color: _dotIndicatorColor,
        borderRadius: BorderRadius.circular(Sizing.kSizingMultiple),
        boxShadow: const <BoxShadow>[
          BoxShadow(color: Colors.black38, blurRadius: 5.0)
        ],
      ),
    );
  }

  Widget _buildInactiveIndicator() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: TimeDuration.kAnimationDuration),
      height: Sizing.kSizingMultiple.h,
      width: Sizing.kSizingMultiple.h,
      decoration: BoxDecoration(
        // shape: BoxShape.circle,
        color: _dotColor,
        borderRadius: BorderRadius.circular(Sizing.kSizingMultiple * 1.5),
        // boxShadow: const <BoxShadow>[
        //   BoxShadow(color: Colors.black38, blurRadius: 5.0)
        // ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _indicators = [];

    for (var index = 0; index < _pageCount; index++) {
      final _dot = Padding(
          padding: const EdgeInsets.only(right: Sizing.kSizingMultiple),
          child: index == _activePageIndex
              ? _buildActiveIndicator()
              : _buildInactiveIndicator());

      _indicators.add(_dot);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: _indicators,
    );
  }
}
