import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:msmpusher/core/constants.dart';
import 'package:msmpusher/core/theme/custom_typography.dart';
import 'package:msmpusher/core/util/date_time_util.dart';
import 'package:msmpusher/core/util/width_constraints.dart';
import 'package:msmpusher/domain/model/models.dart';
import 'package:msmpusher/presentation/widget/widgets.dart';

class ReportBottomSheet extends StatelessWidget {
  final String? title;
  final MessageInfo messageInfo;

  const ReportBottomSheet({
    Key? key,
    required this.messageInfo,
    this.title,
  }) : super(key: key);

  Widget _buildReportDetailsItem({
    required IconData icon,
    required String title,
    required String description,
    Widget? trailing,
  }) {
    return CustomListTile(
      leading: Icon(icon),
      title: title,
      description: description,
      trailing: trailing,
    );
  }

  Widget _buildStatsCount() {
    return Builder(builder: (context) {
      return WidthConstraint(context).withHorizontalSymmetricalPadding(
        child: Wrap(
          spacing: (Sizing.kSizingMultiple * 1.75).w,
          runSpacing: (Sizing.kSizingMultiple * 1.75).h,
          children: [
            CustomChip(
              prefix: messageInfo.messagePage.toString(),
              label: 'Message Pages',
              foregroundColor: CustomTypography.kPrimaryColor,
              backgroundColor: CustomTypography.kPrimaryColor10,
            ),
            CustomChip(
              prefix: messageInfo.totalCharge.toString(),
              label: 'Unit Charge',
              foregroundColor: CustomTypography.kErrorColor,
              backgroundColor: CustomTypography.kErrorColor10,
            ),
            // CustomChip(
            //   prefix: messageInfo.totalReceivers.toString(),
            //   label: 'Receivers',
            //   foregroundColor: CustomTypography.kIndicationColor,
            //   backgroundColor: CustomTypography.kIndicationColor10,
            // ),
            CustomChip(
              prefix: messageInfo.numbToBeSent.toString(),
              label: 'Pending',
              foregroundColor: CustomTypography.kSecondaryColor,
              backgroundColor: CustomTypography.kSecondaryColor10,
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GenericBottomSheet(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text.rich(
            TextSpan(
              text: title ?? 'Report Details',
              style: Theme.of(context).textTheme.headline5,
              children: [
                TextSpan(
                  text: ' (${messageInfo.senderName})',
                  style: Theme.of(context).textTheme.headline5!.copyWith(
                        color: CustomTypography.kGreyColor,
                      ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              HapticFeedback.vibrate();
            },
            icon: const Icon(Icons.more_horiz_rounded),
          ),
        ],
      ),
      description: Text(
        messageInfo.message,
        style: Theme.of(context).textTheme.subtitle2,
      ),
      child: Column(
        children: [
          _buildReportDetailsItem(
            icon: Icons.date_range,
            title: DateTimeUtil.toDateString(messageInfo.dateSent),
            description: 'Transaction Date',
          ),
          _buildReportDetailsItem(
            icon: Icons.people_outline,
            title: '${messageInfo.RECIPIENT_LENGTH} Contacts',
            description: 'Total Contacts',
            // trailing: CustomChip(
            //   label: 'SENT',
            //   foregroundColor: CustomTypography.kIndicationColor,
            //   backgroundColor: CustomTypography.kIndicationColor10,
            // ),
          ),
          SizedBox(height: (Sizing.kSizingMultiple * 2).h),
          _buildStatsCount(),
          SizedBox(height: (Sizing.kSizingMultiple * 2).h),
        ],
      ),
    );
  }
}
