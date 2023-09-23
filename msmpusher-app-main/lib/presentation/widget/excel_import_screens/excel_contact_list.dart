import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:msmpusher/business/snapshot_cache/snapshot_cache.dart';
import 'package:msmpusher/core/constants.dart';
import 'package:msmpusher/core/route/app_router.dart';
import 'package:msmpusher/core/theme/custom_typography.dart';
import 'package:msmpusher/core/util/width_constraints.dart';
import 'package:msmpusher/domain/model/models.dart';
import 'package:msmpusher/presentation/widget/widgets.dart';
import 'package:provider/provider.dart';

class ExcelContactList extends StatelessWidget {
  const ExcelContactList({Key? key}) : super(key: key);

  Widget _buildLoadingIndicator() {
    return SliverFillRemaining(
      child: LoadingIndicator(
        type: LoadingIndicatorType.circularProgressIndicator(),
      ),
    );
  }

  Widget _buildContactItemLeading(ContactModel contactModel) {
    return CircleAvatar(
      backgroundColor: CustomTypography.kLightGreyColor,
      foregroundColor: CustomTypography.kMidGreyColor,
      child: Stack(
        children: [
          const Icon(Icons.person_outline_rounded),
          if (contactModel.isChecked) ...[
            Container(
              decoration: BoxDecoration(
                color: CustomTypography.kLightGreyColor,
              ),
              child: Icon(
                Icons.check,
                color: CustomTypography.kIndicationColor,
              ),
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildContactItem(
      {required ContactModel contactModel, required int index}) {
    return Builder(builder: (context) {
      return CustomListTile(
        onTap: () {
          // select or unselect contact
          Provider.of<ContactSnapshotCache>(context, listen: false)
              .selectContact(contactModel, index: index);
        },
        leading: _buildContactItemLeading(contactModel),
        title: contactModel.contact.displayName,
        description: contactModel.primaryPhone.value,
      );
    });
  }

  Widget _buildExcelContactList() {
    return Consumer<ContactSnapshotCache>(
      builder: (context, snapshot, child) {
        final _contacts = snapshot.deviceFileContacts.contacts;

        if (_contacts.isEmpty) {
          return const SliverFillRemaining(
            child: Center(
              child: InfoIndicator(
                  label:
                      'No contacts found! Make sure file contacts are valid'),
            ),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return _buildContactItem(
                  contactModel: _contacts[index], index: index);
            },
            childCount: _contacts.length,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ContactSnapshotCache>(
      builder: (context, snapshot, child) {
        final _contacts = snapshot.deviceFileContacts.contacts;

        if (_contacts.isEmpty) {
          return SliverFillRemaining(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const InfoIndicator(
                  label:
                      'No contacts found! Make sure excel file contacts are valid',
                ),
                SizedBox(height: (Sizing.kSizingMultiple * 2).h),
                WidthConstraint(context).withHorizontalSymmetricalPadding(
                  child: CustomButton(
                    type: ButtonType.regularButton(
                      onTap: () {
                        context.router.replace(const ImportIntroScreenRoute());
                      },
                      label: 'View Sample Format',
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return _buildContactItem(
                  contactModel: _contacts[index], index: index);
            },
            childCount: _contacts.length,
          ),
        );
      },
    );
  }
}
