import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:msmpusher/business/blocs/contact_blocs/create_contact_group_cubit/create_contact_group_cubit.dart';
import 'package:msmpusher/business/snapshot_cache/snapshot_cache.dart';
import 'package:msmpusher/core/constants.dart';
import 'package:msmpusher/core/theme/custom_typography.dart';
import 'package:msmpusher/core/util/dialog_util.dart';
import 'package:msmpusher/core/util/width_constraints.dart';
import 'package:msmpusher/presentation/widget/shared/contacts_view.dart';
import 'package:msmpusher/presentation/widget/widgets.dart';
import 'package:provider/provider.dart';

class ContactsTab extends StatefulWidget {
  const ContactsTab({Key? key}) : super(key: key);

  @override
  State<ContactsTab> createState() => _ContactsTabState();
}

class _ContactsTabState extends State<ContactsTab> {
  late TextEditingController _groupNameTextFieldController;

  @override
  void initState() {
    super.initState();

    _groupNameTextFieldController = TextEditingController();
  }

  @override
  void dispose() {
    _groupNameTextFieldController.dispose();
    super.dispose();
  }

  void _openCreateGroupFormBottomSheet() {
    final _selectedContacts =
        context.read<ContactSnapshotCache>().selectedContacts;

    DialogUtil(context).bottomModal(
      enableDrag: false,
      isDismissible: false,
      child: BlocProvider.value(
        value: BlocProvider.of<CreateContactGroupCubit>(context),
        child: GroupCreateForm(
          contactModelList: _selectedContacts,
        ),
      ),
    );
  }

  Widget _buildCreateGroupToAddContactsButton() {
    return FloatingActionButton.extended(
      onPressed: _openCreateGroupFormBottomSheet,
      tooltip: 'Group selected contacts',
      backgroundColor: CustomTypography.kPrimaryColor,
      icon: const Icon(Icons.people_outline),
      label: const Text('Group Contacts'),
    );
  }

  Widget _buildClearSelectedContactsButton() {
    return Consumer<ContactSnapshotCache>(
      builder: (context, snapshot, child) {
        final _canCreateContactGroup =
            snapshot.selectedContacts.contacts.length >= 2;

        return FloatingActionButton(
          onPressed: () {
            HapticFeedback.vibrate();

            // clear selected contacts
            Provider.of<ContactSnapshotCache>(context, listen: false)
                .clearSelectedContacts();
          },
          mini: _canCreateContactGroup ? true : false,
          tooltip: 'Clear selected contacts',
          backgroundColor: CustomTypography.kPrimaryColor,
          child: const Icon(Icons.clear_rounded),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ContactSnapshotCache>(
      builder: (context, snapshot, child) {
        final _canCreateContactGroup =
            snapshot.selectedContacts.contacts.length >= 2;
        final _canClearSelectedContacts =
            snapshot.selectedContacts.contacts.isNotEmpty;

        return Stack(
          children: [
            const ContactsView(source: ContactRequestSource.contactsTabPage),
            if (_canCreateContactGroup || _canClearSelectedContacts) ...[
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  margin: EdgeInsets.only(
                    right: WidthConstraint(context).contentPadding,
                    bottom: (Sizing.kSizingMultiple * 2.5).h,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_canCreateContactGroup) ...[
                        _buildCreateGroupToAddContactsButton(),
                      ],
                      if (_canClearSelectedContacts) ...[
                        SizedBox(width: Sizing.kSizingMultiple.h),
                        _buildClearSelectedContactsButton(),
                      ]
                    ],
                  ),
                ),
              ),
            ]
          ],
        );
      },
    );
  }
}
