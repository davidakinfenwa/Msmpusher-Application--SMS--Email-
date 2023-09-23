import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:msmpusher/business/snapshot_cache/snapshot_cache.dart';
import 'package:msmpusher/core/constants.dart';
import 'package:msmpusher/core/theme/custom_typography.dart';
import 'package:msmpusher/core/util/width_constraints.dart';
import 'package:msmpusher/domain/model/models.dart';
import 'package:msmpusher/presentation/widget/tab_screens/send_message_tab/message_recipient_list_union.dart';
import 'package:msmpusher/presentation/widget/widgets.dart';
import 'package:provider/provider.dart';

class MessageRecipientList extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final MessageRecipientListUnion messageRecipientListUnion;

  const MessageRecipientList({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
    required this.messageRecipientListUnion,
  }) : super(key: key);

  Widget _buildContactItemLeading(
      {required IconData icon, required bool isChecked}) {
    return CircleAvatar(
      backgroundColor: CustomTypography.kLightGreyColor,
      foregroundColor: CustomTypography.kMidGreyColor,
      child: Stack(
        children: [
          const Icon(Icons.person_outline_rounded),
          if (isChecked) ...[
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
      {required Either<ContactModel, ContactGroup>
          contactModelOrContactGroup}) {
    final _contextModel = contactModelOrContactGroup.fold(
        (contactModel) => contactModel, (contactGroup) => contactGroup);

    final _title = contactModelOrContactGroup.fold(
      (contactModel) => contactModel.contact.displayName,
      (contactGroup) => contactGroup.name,
    );

    final _leading = contactModelOrContactGroup.fold(
      (contactModel) => _buildContactItemLeading(
          icon: Icons.person_outline_rounded,
          isChecked: contactModel.isChecked),
      (contactGroup) => _buildContactItemLeading(
          icon: Icons.people_outline, isChecked: contactGroup.isChecked),
    );

    final _subTitleText = contactModelOrContactGroup.fold(
      (contactModel) => contactModel.primaryPhone.value,
      (contactGroup) => '${contactGroup.contactList.contacts.length} Contacts',
    );

    return Builder(builder: (context) {
      return CustomListTile(
        onTap: () {
          // verify will model is passed to method
          if (contactModelOrContactGroup.isLeft()) {
            // select or unselect contact
            Provider.of<ContactSnapshotCache>(context, listen: false)
                .selectContact(_contextModel as ContactModel);
          } else {
            // select or unselect contact-group
            Provider.of<GroupSnapshotCache>(context, listen: false)
                .selectContactGroup(_contextModel as ContactGroup);
          }
        },
        leading: _leading,
        title: _title,
        description: _subTitleText,
      );
    });
  }

  List<Widget> _buildContactGroupsList() {
    return messageRecipientListUnion.map(
      contactModel: (state) {
        if (state.contactModelList.contacts.isEmpty) {
          return [
            const InfoIndicator(label: 'No selected contact to send message!'),
            SizedBox(height: (Sizing.kSizingMultiple * 2).h)
          ];
        }

        return state.contactModelList.contacts.map((e) {
          return _buildContactItem(contactModelOrContactGroup: left(e));
        }).toList();
      },
      groupModel: (state) {
        if (state.contactGroupList.groups.isEmpty) {
          return [
            const InfoIndicator(label: 'No selected group to send message!'),
            SizedBox(height: (Sizing.kSizingMultiple * 2).h),
          ];
        }

        return state.contactGroupList.groups.map((e) {
          return _buildContactItem(contactModelOrContactGroup: right(e));
        }).toList();
      },
    );
  }

  Widget _buildMessageRecipientListTile() {
    return Builder(
      builder: (context) {
        return Container(
          constraints: BoxConstraints(
            maxWidth: WidthConstraint(context).maxWidthConstraint,
          ),
          child: ExpansionTile(
            tilePadding: EdgeInsets.symmetric(
              horizontal: WidthConstraint(context).contentPadding,
            ),
            leading: CircleAvatar(
              backgroundColor: CustomTypography.kLightGreyColor,
              foregroundColor: CustomTypography.kMidGreyColor,
              child: Icon(icon),
            ),
            title: Text(title),
            subtitle: Text(
              description,
              style: Theme.of(context).textTheme.subtitle2,
            ),
            children: _buildContactGroupsList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          _buildMessageRecipientListTile(),
          Divider(
            height: Sizing.kZeroValue,
            color: CustomTypography.kLightGreyColor,
          ),
        ],
      ),
    );
  }
}
