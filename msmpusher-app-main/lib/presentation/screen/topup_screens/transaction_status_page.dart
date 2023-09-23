import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:msmpusher/core/constants.dart';
import 'package:msmpusher/core/route/app_router.dart';
import 'package:msmpusher/core/theme/custom_typography.dart';
import 'package:msmpusher/core/util/width_constraints.dart';
import 'package:msmpusher/presentation/widget/widgets.dart';

class TransactionStatusPage extends StatefulWidget {
  const TransactionStatusPage({Key? key}) : super(key: key);

  @override
  State<TransactionStatusPage> createState() => _TransactionStatusPageState();
}

class _TransactionStatusPageState extends State<TransactionStatusPage> {
  Widget _buildStatusIndicator() {
    return Container(
      height: (Sizing.kSizingMultiple * 20.25).h,
      width: (Sizing.kSizingMultiple * 20.25).h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: CustomTypography.kLightGreyColor,
      ),
      child: Icon(
        Icons.check,
        color: CustomTypography.kMidGreyColor,
        size: (Sizing.kSizingMultiple * 15).sp,
      ),
    );
  }

  Widget _buildTransactionMessage() {
    return WidthConstraint(context).withHorizontalSymmetricalPadding(
      child: const InfoIndicator(
        label: 'You transaction has been confirmed and your account credited!',
      ),
    );
  }

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

  Widget _buildBackToDashboardButton() {
    return WidthConstraint(context).withHorizontalSymmetricalPadding(
      child: CustomButton(
        type: ButtonType.regularFlatButton(
          onTap: () {
            context.router.pushAndPopUntil(const TabScreenRoute(),
                predicate: (_) => false);
          },
          label: 'Back To Dashboard',
          textColor: CustomTypography.kPrimaryColor,
          // backgroundColor: CustomTypography.kIndicationColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: (Sizing.kSizingMultiple * 5).h),
          _buildStatusIndicator(),
          SizedBox(height: (Sizing.kSizingMultiple * 4.25).h),
          _buildTransactionMessage(),
          SizedBox(height: (Sizing.kSizingMultiple * 3.25).h),
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
          SizedBox(height: (Sizing.kSizingMultiple * 4).h),
          _buildBackToDashboardButton(),
        ],
      ),
    );
  }
}
