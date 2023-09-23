import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:msmpusher/core/constants.dart';
import 'package:msmpusher/core/theme/custom_typography.dart';

class CustomStepper extends StatelessWidget {
  final double width;
  final int totalSteps;
  final int curStep;
  final Color stepCompleteColor;
  final Color currentStepColor;
  final Color inactiveColor;
  final double lineWidth;

  CustomStepper({
    Key? key,
    required this.width,
    required this.curStep,
    required this.stepCompleteColor,
    required this.totalSteps,
    required this.inactiveColor,
    required this.currentStepColor,
    required this.lineWidth,
  })  : assert(curStep > 0 == true && curStep <= totalSteps + 1),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Padding(
        //   padding: const EdgeInsets.only(
        //     top: 20.0,
        //     left: 40.0,
        //     right: 40.0,
        //   ),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: _steps(),
        //   ),
        // ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _steps(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //crossAxisAlignment: CrossAxisAlignment.end,
          children: _buildText(),
        ),
        // Padding(
        //   padding: const EdgeInsets.only(
        //     left: 20.0,
        //     right: 20.0,
        //   ),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     //crossAxisAlignment: CrossAxisAlignment.end,
        //     children: _buildText(),
        //   ),
        // )
      ],
    );
  }

  final _stepsText = ["Plan", "Summary", "Finish"];

  getCircleColor(i) {
    Color color;
    if (i + 1 < curStep) {
      color = stepCompleteColor;
    } else if (i + 1 == curStep) {
      color = currentStepColor;
    } else {
      color = CustomTypography.kWhiteColor;
    }
    return color;
  }

  getBorderColor(i) {
    Color color;
    if (i + 1 < curStep) {
      color = stepCompleteColor;
    } else if (i + 1 == curStep) {
      color = currentStepColor;
    } else {
      color = inactiveColor;
    }

    return color;
  }

  getLineColor(i) {
    var color =
        curStep > i + 1 ? stepCompleteColor.withOpacity(0.4) : inactiveColor;
    return color;
  }

  List<Widget> _buildText() {
    var wids = <Widget>[];

    _stepsText.asMap().forEach((i, text) {
      wids.add(
        Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: i + 1 <= curStep ? stepCompleteColor : inactiveColor),
        ),
      );
    });

    wids[0] = Padding(
      // padding: EdgeInsets.only(left: Dimensions.width20),
      padding: EdgeInsets.only(left: (Sizing.kSizingMultiple * .5).w),
      child: wids[0],
    );
    wids[1] = Padding(
      // padding: EdgeInsets.only(left: Dimensions.width5),
      padding: EdgeInsets.only(left: (Sizing.kSizingMultiple * 1.5).w),
      child: wids[1],
    );

    wids[2] = Padding(
      padding: EdgeInsets.only(left: (Sizing.kSizingMultiple).w),
      child: wids[2],
    );
    //print(wids[1]);

    return wids;
  }

  List<Widget> _steps() {
    var list = <Widget>[];
    for (int i = 0; i < totalSteps; i++) {
      //colors according to state

      var circleColor = getCircleColor(i);
      var borderColor = getBorderColor(i);
      var lineColor = getLineColor(i);

      // step circles
      list.add(
        Container(
          width: (Sizing.kSizingMultiple * 3.5).h,
          height: (Sizing.kSizingMultiple * 3.5).h,
          child: getInnerElementOfStepper(i),
          decoration: BoxDecoration(
            color: circleColor,
            borderRadius: const BorderRadius.all(Radius.circular(25.0)),
            border: Border.all(
              color: borderColor,
              width: 1.0,
            ),
          ),
        ),
      );

      //line between step circles
      if (i != totalSteps - 1) {
        list.add(
          Expanded(
            child: Container(
              height: lineWidth,
              color: lineColor,
            ),
          ),
        );
      }
    }

    return list;
  }

  Widget getInnerElementOfStepper(index) {
    if (index + 1 < curStep) {
      return const Icon(
        Icons.check,
        color: Colors.white,
        size: 16.0,
      );
    } else if (index + 1 == curStep) {
      return Center(
        child: Text(
          '$curStep',
          style: TextStyle(
            color: CustomTypography.kPrimaryColor,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
