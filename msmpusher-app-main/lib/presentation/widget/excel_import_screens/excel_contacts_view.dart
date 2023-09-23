import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:msmpusher/business/snapshot_cache/snapshot_cache.dart';
import 'package:msmpusher/core/constants.dart';
import 'package:msmpusher/core/theme/custom_typography.dart';
import 'package:msmpusher/core/util/width_constraints.dart';
import 'package:msmpusher/presentation/widget/widgets.dart';
import 'package:provider/provider.dart';

class ExcelContactsView extends StatefulWidget {
  const ExcelContactsView({Key? key}) : super(key: key);

  @override
  State<ExcelContactsView> createState() => _ExcelContactsViewState();
}

class _ExcelContactsViewState extends State<ExcelContactsView> {
  Widget _buildAppBar() {
    return SliverAppBar(
      pinned: true,
      centerTitle: true,
      elevation: Sizing.kButtonElevation,
      title: Text.rich(
        TextSpan(
          text: 'Imported Contacts',
          children: [
            TextSpan(
              text: ' (Preview)',
              style: Theme.of(context).textTheme.headline5!.copyWith(
                    color: CustomTypography.kGreyColor,
                  ),
            ),
          ],
        ),
        style: Theme.of(context).textTheme.headline5,
      ),
    );
  }

  Widget _buildContactSectionTitle() {
    final _contactSnapshotCache = context.watch<ContactSnapshotCache>();

    return SliverToBoxAdapter(
      child: _contactSnapshotCache.deviceFileContacts.IS_EMPTY
          ? Container()
          : WidthConstraint(context).withHorizontalSymmetricalPadding(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      '${_contactSnapshotCache.deviceFileContacts.LENGTH.toString()} Contacts'),
                ],
              ),
            ),
    );
  }

  List<Widget> _buildContactListSection() {
    return [
      _buildContactSectionTitle(),
      SliverToBoxAdapter(
        child: SizedBox(height: (Sizing.kSizingMultiple * 1.25).h),
      ),
      const ExcelContactList(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        _buildAppBar(),
        ..._buildContactListSection(),
      ],
    );
  }
}
