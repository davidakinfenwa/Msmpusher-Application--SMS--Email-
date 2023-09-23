import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:msmpusher/core/constants.dart';
import 'package:msmpusher/core/exceptions/exceptions.dart';
import 'package:msmpusher/core/theme/custom_typography.dart';

class ErrorIndicatorType extends Equatable {
  final Widget child;

  const ErrorIndicatorType._({required this.child});

  factory ErrorIndicatorType.simple({
    required ExceptionCode? code,
    required String? message,
    bool? showRetryAction,
    Function? onRetryCallback,
  }) {
    return ErrorIndicatorType._(
      child: Builder(
        builder: (context) {
          return Row(
            children: [
              const Icon(Icons.error),
              const SizedBox(width: Sizing.kSizingMultiple),
              Expanded(
                child: Text.rich(
                    TextSpan(
                      text: code == ExceptionCode.UNDEFINED
                          ? ''
                          : '${code.toString()} \n',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      children: <InlineSpan>[
                        TextSpan(
                          text: message,
                          style: const TextStyle(fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.left),
              ),
              if (showRetryAction ?? true) ...[
                GestureDetector(
                  onTap: () {
                    HapticFeedback.vibrate();
                    onRetryCallback!();
                  },
                  child: Text(
                    'Retry',
                    style: Theme.of(context)
                        .primaryTextTheme
                        .bodyText1!
                        .copyWith(color: Theme.of(context).colorScheme.secondary),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  factory ErrorIndicatorType.custom({required Widget child}) {
    return ErrorIndicatorType._(
      child: child,
    );
  }

  @override
  List<Object> get props => [child];
}

class ErrorIndicator extends StatelessWidget {
  final Color? backgroundColor;
  final ErrorIndicatorType type;

  const ErrorIndicator({
    Key? key,
    required this.type,
    this.backgroundColor,
  }) : super(key: key);

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
