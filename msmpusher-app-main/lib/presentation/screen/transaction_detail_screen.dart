import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:msmpusher/core/constants.dart';
import 'package:msmpusher/core/theme/custom_typography.dart';
import 'package:msmpusher/core/util/width_constraints.dart';
import 'package:msmpusher/presentation/widget/widgets.dart';

class TransactionDetailScreen extends StatelessWidget {
  const TransactionDetailScreen({Key? key}) : super(key: key);

  Widget _buildAmountSection() {
    return Builder(
      builder: (context) {
        return Padding(
          padding: EdgeInsets.symmetric(
            vertical: (Sizing.kSizingMultiple * 4.375).h,
          ),
          child: Column(
            children: [
              Text(
                'GHS 20.00',
                style: Theme.of(context).textTheme.headline3!,
              ),
              Text(
                'COMPLETED',
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                      color: CustomTypography.kIndicationColor,
                    ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTransactionDetailItem({
    required VoidCallback onTap,
    required IconData icon,
    required String title,
    required String description,
  }) {
    return CustomListTile(
      onTap: onTap,
      leading: Icon(icon),
      title: title,
      description: description,
    );
  }

  Widget _buildTransactionDetailsSection() {
    return Builder(builder: (context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WidthConstraint(context).withHorizontalSymmetricalPadding(
            child: Row(
              children: [
                const Text('Transaction Details'),
                SizedBox(width: (Sizing.kSizingMultiple * .50).w),
                Text(
                  '(ubxlz10ivdg)',
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ],
            ),
          ),
          SizedBox(height: (Sizing.kSizingMultiple * 1.25).h),
          _buildTransactionDetailItem(
            onTap: () {},
            icon: Icons.date_range_rounded,
            title: 'Thursday, 14 April 2022',
            description: 'Transaction Date',
          ),
          _buildTransactionDetailItem(
            onTap: () {},
            icon: Icons.phone_android_rounded,
            title: 'Mobile Money',
            description: 'Payment Option',
          ),
          _buildTransactionDetailItem(
            onTap: () {},
            icon: Icons.email_outlined,
            title: '75000',
            description: 'SMS Units',
          ),
          SizedBox(height: (Sizing.kSizingMultiple * 1.25).h),
          WidthConstraint(context).withHorizontalSymmetricalPadding(
            child: const Text(
                'Officia do irure deserunt sit nostrud sint dolor adipisicing.'),
          )
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Transaction Details',
          style: Theme.of(context).textTheme.headline5,
        ),
      ),
      body: Column(
        children: [
          const CustomDivider(),
          _buildAmountSection(),
          const CustomDivider(),
          SizedBox(height: (Sizing.kSizingMultiple * 1.25).h),
          _buildTransactionDetailsSection(),
        ],
      ),
    );
  }
}
