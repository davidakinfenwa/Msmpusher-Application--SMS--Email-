import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:msmpusher/core/constants.dart';
import 'package:msmpusher/core/theme/custom_typography.dart';
import 'package:msmpusher/core/util/width_constraints.dart';
import 'package:msmpusher/presentation/widget/shared/custom_button.dart';
import 'package:msmpusher/presentation/widget/shared/custom_divider.dart';
import 'package:msmpusher/presentation/widget/shared/custom_list_tile.dart';
import 'package:msmpusher/presentation/widget/shared/info_indicator.dart';

class PurchaseSummary extends StatefulWidget {
  final VoidCallback onGotoNextPage;

  const PurchaseSummary({Key? key, required this.onGotoNextPage})
      : super(key: key);

  @override
  State<PurchaseSummary> createState() => _PurchaseSummaryState();
}

class _PurchaseSummaryState extends State<PurchaseSummary> {
  String? _paymentOption;

  Widget _buildPurchaseSummarySectionTitle() {
    return WidthConstraint(context).withHorizontalSymmetricalPadding(
      child: const Align(
        alignment: Alignment.centerLeft,
        child: Text('Purchase Summary'),
      ),
    );
  }

  Widget _buildSummaryItem({
    required String title,
    required String trailing,
    Color? trailingColor,
    TextStyle? trailingTextStyle,
  }) {
    return CustomListTile(
      title: title,
      trailing: Text(
        trailing,
        style: trailingTextStyle ??
            Theme.of(context).textTheme.bodyText2!.copyWith(
                  color: trailingColor ?? CustomTypography.kBlackColor,
                ),
      ),
    );
  }

  Widget _buildPaymentOptionsDropdownTextField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Sizing.kBorderRadius),
        border: Border.all(
          color: CustomTypography.kLightGreyColor,
        ),
      ),
      child: DropdownButtonFormField<String>(
        value: _paymentOption,
        hint: const Text('Select Payment Option'),
        onChanged: (value) {
          setState(() {
            _paymentOption = value!;
          });
        },
        items: const [
          DropdownMenuItem(
            value: 'Wallet',
            child: Text('Wallet'),
          ),
          DropdownMenuItem(
            value: 'Mobile Money',
            child: Text('Mobile Money'),
          ),
        ],
        icon: Container(
          margin: EdgeInsets.only(right: Sizing.kSizingMultiple.h),
          child: const Icon(Icons.arrow_drop_down),
        ),
        decoration: const InputDecoration(
          enabledBorder: InputBorder.none,
          border: InputBorder.none,
          prefixIcon: Icon(Icons.payment_rounded),
        ),
      ),
    );
  }

  Widget _buildContinueWithPaymentButton() {
    return CustomButton(
      type: ButtonType.regularButton(
        onTap: () {
          // TODO:

          // goto next page
          widget.onGotoNextPage();
        },
        label: 'Continue With Payment',
      ),
    );
  }

  Widget _buildPaymentOptionsFormSection() {
    return WidthConstraint(context).withHorizontalSymmetricalPadding(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Payment Options'),
          SizedBox(height: (Sizing.kSizingMultiple * 1.25).h),
          _buildPaymentOptionsDropdownTextField(),
          SizedBox(height: (Sizing.kSizingMultiple * 3.25).h),
          _buildContinueWithPaymentButton(),
          SizedBox(height: (Sizing.kSizingMultiple * 5).h),
          const Center(
            child: InfoIndicator(
                label: 'To go back to previous step, press the back button'),
          ),
          SizedBox(height: (Sizing.kSizingMultiple * 3.25).h),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: (Sizing.kSizingMultiple * 5.5).h),
        _buildPurchaseSummarySectionTitle(),
        const CustomDivider(top: 1.25),
        _buildSummaryItem(
          title: 'Plan',
          trailing: 'RESELLER',
          trailingColor: CustomTypography.kPrimaryColor,
        ),
        _buildSummaryItem(title: 'SMS (Unit)', trailing: '50000'),
        _buildSummaryItem(title: 'Amount', trailing: 'GHS 100.00'),
        _buildSummaryItem(
          title: 'Subtotal',
          trailing: 'GHS 100.00',
          trailingTextStyle: Theme.of(context).textTheme.bodyText2!.copyWith(
                color: CustomTypography.kBlackColor,
                fontWeight: FontWeight.bold,
              ),
        ),
        SizedBox(height: (Sizing.kSizingMultiple * 7.25).h),
        _buildPaymentOptionsFormSection()
      ],
    );
  }
}
