import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:msmpusher/business/snapshot_cache/snapshot_cache.dart';
import 'package:msmpusher/core/constants.dart';
import 'package:msmpusher/core/theme/custom_typography.dart';
import 'package:msmpusher/core/util/width_constraints.dart';
import 'package:msmpusher/presentation/widget/shared/contacts_view.dart';
import 'package:provider/provider.dart';

class ContactScreen extends StatefulWidget {
  final ContactRequestSource source;

  const ContactScreen({Key? key, required this.source}) : super(key: key);

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  Widget _buildComposeMessageButton() {
    return FloatingActionButton.extended(
      onPressed: () {
        context.router.pop();
      },
      tooltip: 'Continue',
      backgroundColor: CustomTypography.kPrimaryColor,
      icon: const Icon(Icons.mail_outline),
      label: const Text('Compose Message'),
    );
  }

  Widget _buildClearSelectedContactsButton() {
    return FloatingActionButton(
      onPressed: () {
        HapticFeedback.vibrate();

        // clear selected contacts
        Provider.of<ContactSnapshotCache>(context, listen: false)
            .clearSelectedContacts();

        // clear selected groups
        Provider.of<GroupSnapshotCache>(context, listen: false)
            .clearSelectedContactGroups();
      },
      mini: true,
      tooltip: 'Clear selected contacts',
      heroTag: 'clear-selected-contacts',
      backgroundColor: CustomTypography.kPrimaryColor,
      child: const Icon(Icons.clear_rounded),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _groupSnapshotCache = Provider.of<GroupSnapshotCache>(context);

    return Consumer<ContactSnapshotCache>(
      builder: (context, snapshot, child) {
        final _selectedContacts = snapshot.selectedContacts.contacts.isNotEmpty;
        final _selectedGroups =
            _groupSnapshotCache.selectedGroups.groups.isNotEmpty;

        return Scaffold(
          body: Stack(
            children: [
              const ContactsView(source: ContactRequestSource.contactsTabPage),
              if (_selectedContacts || _selectedGroups) ...[
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
                        if (_selectedContacts || _selectedGroups) ...[
                          _buildComposeMessageButton(),
                          SizedBox(width: Sizing.kSizingMultiple.h),
                          _buildClearSelectedContactsButton(),
                        ],
                      ],
                    ),
                  ),
                ),
              ]
            ],
          ),
        );
      },
    );
  }
}
