import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:msmpusher/business/snapshot_cache/snapshot_cache.dart';
import 'package:msmpusher/core/constants.dart';
import 'package:msmpusher/core/theme/custom_typography.dart';
import 'package:msmpusher/core/util/keyboard_util.dart';
import 'package:msmpusher/core/util/width_constraints.dart';
import 'package:msmpusher/presentation/widget/widgets.dart';
import 'package:provider/provider.dart';

enum ContactRequestSource {
  contactsTabPage,
  sendMessageScreen,
}

class ContactsView extends StatefulWidget {
  final ContactRequestSource source;

  const ContactsView({Key? key, required this.source}) : super(key: key);

  @override
  State<ContactsView> createState() => _ContactsViewState();
}

class _ContactsViewState extends State<ContactsView> {
  late FocusNode _searchTextFieldFocusNode;
  late TextEditingController _searchTextFieldController;

  @override
  void initState() {
    super.initState();

    // deactivate search-mode incase page was exited while still in search mode
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _deactivateSearchMode());

    _searchTextFieldFocusNode = FocusNode();
    _searchTextFieldController = TextEditingController();
  }

  @override
  void dispose() {
    _searchTextFieldFocusNode.dispose();
    _searchTextFieldController.dispose();
    super.dispose();
  }

  void _deactivateSearchMode() {
    final _contactSnapshotCache = context.read<ContactSnapshotCache>();
    _contactSnapshotCache.isSearchingContactsMode = false;
  }

  Widget _buildCreateGroupNote() {
    return SliverToBoxAdapter(
      child: WidthConstraint(context).withHorizontalSymmetricalPadding(
        child: const InfoIndicator(
          label: 'You can select more than one contacts to create a group.',
        ),
      ),
    );
  }

  List<Widget> _buildGroupListSection() {
    return [
      SliverToBoxAdapter(
        child: SizedBox(height: (Sizing.kSizingMultiple * 2).h),
      ),
      _buildCreateGroupNote(),
      SliverToBoxAdapter(
        child: SizedBox(height: (Sizing.kSizingMultiple).h),
      ),
      const GroupList(),
      SliverToBoxAdapter(
        child: SizedBox(height: (Sizing.kSizingMultiple * 3.75).h),
      ),
    ];
  }

  Widget _buildContactSectionTitle() {
    return SliverToBoxAdapter(
      child: WidthConstraint(context).withHorizontalSymmetricalPadding(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('All Contacts'),
            GestureDetector(
              onTap: () {
                HapticFeedback.vibrate();
                // TODO: create new contact
              },
              child: Text(
                'New Contact',
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: CustomTypography.kPrimaryColor,
                    ),
              ),
            ),
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
      const ContactList(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final _contactSnapshotCache = context.read<ContactSnapshotCache>();
    final bool _isKeyboardVisible = KeyboardUtil.isKeyboardVisible(context);

    if (!_isKeyboardVisible) {
      // unfocus search-text field
      _searchTextFieldFocusNode.unfocus();
    }

    return CustomScrollView(
      slivers: [
        SearchSliverAppBar(
          title: 'Contacts',
          focusNode: _searchTextFieldFocusNode,
          controller: _searchTextFieldController,
          onSearchChangedCallback: (value) {
            _contactSnapshotCache.searchContactFromList(value);
          },
          onDisposeCallback: () {
            Provider.of<ContactSnapshotCache>(context, listen: false)
                .isSearchingContactsMode = false;
          },
        ),
        ..._buildGroupListSection(),
        ..._buildContactListSection(),
      ],
    );
  }
}
