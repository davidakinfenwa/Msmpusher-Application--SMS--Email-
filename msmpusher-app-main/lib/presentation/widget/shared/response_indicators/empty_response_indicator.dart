import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:msmpusher/core/constants.dart';
import 'package:msmpusher/core/theme/custom_typography.dart';

class EmptyResponseIndicatorType extends Equatable {
  final Widget child;

  const EmptyResponseIndicatorType._({required this.child});

  factory EmptyResponseIndicatorType.simple(
    BuildContext context, {
    required Function onActionCallback,
    required String message,
    Widget? action,
  }) {
    return EmptyResponseIndicatorType._(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.vibrate();
          onActionCallback();
        },
        child: Row(
          children: [
            // TODO: consider changing icon representaion here
            const Icon(Icons.dashboard),
            SizedBox(width: Sizing.kSizingMultiple.h),
            Expanded(
              child: Text.rich(
                TextSpan(
                  text: message,
                  style: Theme.of(context).primaryTextTheme.bodyText1!.copyWith(
                        color: CustomTypography.kBlackColor,
                      ),
                ),
                textAlign: TextAlign.left,
              ),
            ),
            action ??
                Text(
                  'Retry',
                  style: Theme.of(context)
                      .primaryTextTheme
                      .bodyText1!
                      .copyWith(color: Theme.of(context).colorScheme.secondary),
                ),
          ],
        ),
      ),
    );
  }

  @override
  List<Object> get props => [child];
}

class EmptyResponseIndicator extends StatelessWidget {
  final EmptyResponseIndicatorType type;
  final Color? backgroundColor;

  const EmptyResponseIndicator(
      {Key? key, required this.type, this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Sizing.kSizingMultiple * 2),
      decoration: BoxDecoration(
        color: backgroundColor ?? CustomTypography.kLightGreyColor,
        borderRadius: BorderRadius.circular(Sizing.kSizingMultiple),
      ),
      child: type.child,
    );
  }
}
