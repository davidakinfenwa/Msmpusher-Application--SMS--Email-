import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:msmpusher/core/constants.dart';
import 'package:msmpusher/core/theme/custom_typography.dart';
import 'package:msmpusher/core/util/width_constraints.dart';
import 'package:msmpusher/presentation/widget/shared/custom_button.dart';
import 'package:msmpusher/presentation/widget/shared/custom_divider.dart';

class TopUpPlan extends StatelessWidget {
  final Function() onSelectPlan;
  final String currency;
  final double startAmount;
  final String packageName;
  final Color packageColor;
  final String validity;
  final String pricePerUnit;
  final String minimumAmount;

  const TopUpPlan({
    Key? key,
    required this.onSelectPlan,
    required this.currency,
    required this.startAmount,
    required this.packageName,
    required this.packageColor,
    required this.validity,
    required this.pricePerUnit,
    required this.minimumAmount,
  }) : super(key: key);

  Widget _buildPackageStartPricing() {
    return Builder(builder: (context) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text.rich(
            WidgetSpan(
              child: Transform.translate(
                offset: const Offset(2, -10),
                child: Text(currency),
              ),
            ),
          ),
          Text.rich(
            TextSpan(
              text: startAmount.toString(),
              style: Theme.of(context).textTheme.headline3,
              children: [
                TextSpan(
                  text: '/Starting From',
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildPackageName() {
    return Builder(builder: (context) {
      return Text(
        packageName.toUpperCase(),
        style: Theme.of(context).textTheme.headline3!.copyWith(
              color: CustomTypography.kSecondaryColor,
            ),
      );
    });
  }

  Widget _buildValiditySection() {
    return Builder(builder: (context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(validity),
          Text('Validity', style: Theme.of(context).textTheme.subtitle2),
        ],
      );
    });
  }

  Widget _buildPerUnitPricingSection() {
    return Text(pricePerUnit);
  }

  Widget _buildMinimumAmountSection() {
    return Builder(builder: (context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(minimumAmount),
          Text('Minimum Amount', style: Theme.of(context).textTheme.subtitle2),
        ],
      );
    });
  }

  Widget _buildSelectPlanButton() {
    return CustomButton(
      type: ButtonType.regularButton(
        onTap: () => onSelectPlan(),
        label: 'Select Plan',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _borderRadius = BorderRadius.circular(Sizing.kBorderRadius);

    return Material(
      borderRadius: _borderRadius,
      elevation: Sizing.kCardElevation,
      child: InkWell(
        onTap: () => onSelectPlan(),
        borderRadius: _borderRadius,
        child: Container(
          padding: EdgeInsets.only(
            top: (Sizing.kSizingMultiple * 5).h,
            bottom: (Sizing.kSizingMultiple * 2).h,
            left: (Sizing.kSizingMultiple * 2).w,
            right: (Sizing.kSizingMultiple * 2).w,
          ),
          constraints: BoxConstraints(
            // maxHeight: (WidthConstraint(context).deviceHeight * .5).h,
            maxWidth: (WidthConstraint(context).contentWidth).h,
          ),
          decoration: BoxDecoration(
            // border: Border.all(
            //   color: CustomTypography.kLightGreyColor,
            // ),
            borderRadius: _borderRadius,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPackageStartPricing(),
              _buildPackageName(),
              const CustomDivider(all: 2.75),
              _buildValiditySection(),
              const CustomDivider(all: 2.75),
              _buildPerUnitPricingSection(),
              const CustomDivider(all: 2.75),
              _buildMinimumAmountSection(),
              const CustomDivider(all: 2),
              _buildSelectPlanButton(),
            ],
          ),
        ),
      ),
    );
  }
}
