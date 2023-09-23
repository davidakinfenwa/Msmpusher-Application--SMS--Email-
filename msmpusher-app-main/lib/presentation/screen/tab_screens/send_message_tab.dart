import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:msmpusher/business/blocs/bloc_state.dart';
import 'package:msmpusher/business/blocs/message_blocs/send_message_cubit/send_message_cubit.dart';
import 'package:msmpusher/business/snapshot_cache/snapshot_cache.dart';
import 'package:msmpusher/core/constants.dart';
import 'package:msmpusher/core/exceptions/exceptions.dart';
import 'package:msmpusher/core/route/app_router.dart';
import 'package:msmpusher/core/theme/custom_typography.dart';
import 'package:msmpusher/core/util/dialog_util.dart';
import 'package:msmpusher/core/util/keyboard_util.dart';
import 'package:msmpusher/core/util/snackbar_util.dart';
import 'package:msmpusher/core/util/toast_util.dart';
import 'package:msmpusher/core/util/width_constraints.dart';
import 'package:msmpusher/domain/form_params/form_params.dart';
import 'package:msmpusher/domain/model/models.dart';
import 'package:msmpusher/presentation/widget/shared/contacts_view.dart';
import 'package:msmpusher/presentation/widget/tab_screens/send_message_tab/message_recipient_list_union.dart';
import 'package:msmpusher/presentation/widget/widgets.dart';
import 'package:provider/provider.dart';

class SendMessageTab extends StatefulWidget {
  const SendMessageTab({Key? key}) : super(key: key);

  @override
  State<SendMessageTab> createState() => _SendMessageTabState();
}

class _SendMessageTabState extends State<SendMessageTab> {
  String? _senderId;
  late FocusNode _messageTextFieldFocusNode;
  late TextEditingController _messageTextFieldController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _messageTextFieldFocusNode = FocusNode();
    _messageTextFieldController = TextEditingController();
  }

  @override
  void dispose() {
    _messageTextFieldFocusNode.dispose();
    _messageTextFieldController.dispose();
    super.dispose();
  }

  void _clearSelectedContactsAndGroups() {
    context.read<GroupSnapshotCache>().clearSelectedContactGroups();
    context.read<ContactSnapshotCache>().clearSelectedContacts();
  }

  void _onSendMessageCallback() {
    if (!_formKey.currentState!.validate()) return;

    KeyboardUtil.hideKeyboard(context);

    final _authSnapshotCache = context.read<AuthSnapshotCache>();
    final _contactSnapshotCache = context.read<ContactSnapshotCache>();
    final _groupSnapshotCache = context.read<GroupSnapshotCache>();

    // flatten contacts and group-contacts
    final _contactList = _contactSnapshotCache.selectedContacts.contacts
        .map((e) => e.contact.phones.first.value)
        .toList();

    final _groupContactList = _groupSnapshotCache
        .selectedGroups.ALL_MERGED_CONTACTS.contacts
        .map((e) => e.contact.phones.first.value)
        .toList();

    final _mergedContactNumbers = [..._contactList, ..._groupContactList];

    if (_mergedContactNumbers.isEmpty) {
      ToastUtil.showToast('Select contacts or groups to send message!');
      return;
    }

    final _sendMessageFormParams = SendMessageFormParams(
      senderId: 'MSMTEST',
      userInfo: _authSnapshotCache.userInfoContext,
      numbers: _mergedContactNumbers,
      message: _messageTextFieldController.text,
    );

    context
        .read<SendMessageCubit>()
        .sendMessage(sendMessageFormParams: _sendMessageFormParams);
  }

  Future<void> _showModalBottomSheet({required MessageInfo messageInfo}) async {
    HapticFeedback.vibrate();

    await DialogUtil(context).bottomModal(
      child: ReportBottomSheet(
        title: 'Message Sent!',
        messageInfo: messageInfo,
      ),
    );
  }

  Widget _buildHSpacer(num value) {
    return SliverToBoxAdapter(
      child: SizedBox(height: (Sizing.kSizingMultiple * value).h),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      pinned: true,
      centerTitle: true,
      elevation: Sizing.kButtonElevation,
      title: Text('Send Message', style: Theme.of(context).textTheme.headline5),
    );
  }

  Widget _buildInfoIndicator() {
    return SliverToBoxAdapter(
      child: WidthConstraint(context).withHorizontalSymmetricalPadding(
        child: const InfoIndicator(
            label:
                'To send a message, select contacts or group to send message'),
      ),
    );
  }

  Widget _buildSenderIdDropdownTextField() {
    const _suffixBorderRadius = BorderRadius.only(
      topRight: Radius.circular(Sizing.kBorderRadius),
      bottomRight: Radius.circular(Sizing.kBorderRadius),
    );

    // TODO: load sender-ids
    return SliverToBoxAdapter(
      child: WidthConstraint(context).withHorizontalSymmetricalPadding(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Sizing.kBorderRadius),
            border: Border.all(
              color: CustomTypography.kTextFieldBorderColor,
            ),
          ),
          child: DropdownButtonFormField<String>(
            value: _senderId,
            hint: const Text('Select Sender ID'),
            onChanged: (value) {
              setState(() {
                _senderId = value!;
              });
            },
            items: const [
              DropdownMenuItem(
                value: 'MSMPusher',
                child: Text('MSMPusher'),
              ),
              DropdownMenuItem(
                value: 'MTechBiz',
                child: Text('MTechBiz'),
              ),
            ],
            icon: Container(
              margin: EdgeInsets.only(right: Sizing.kSizingMultiple.h),
              child: const Icon(Icons.arrow_drop_down),
            ),
            decoration: InputDecoration(
              enabledBorder: InputBorder.none,
              border: InputBorder.none,
              prefixIcon: const Icon(Icons.person_outline_rounded),
              suffixIcon: Material(
                color: CustomTypography.kPrimaryColor,
                borderRadius: _suffixBorderRadius,
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: _suffixBorderRadius,
                    ),
                    child: const Icon(
                      Icons.add,
                      color: CustomTypography.kWhiteColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionItem({
    required VoidCallback onTap,
    required String imageUrl,
    required String label,
    required String value,
  }) {
    final _borderRadius = BorderRadius.circular(Sizing.kBorderRadius);

    return Expanded(
      child: Material(
        borderRadius: _borderRadius,
        elevation: Sizing.kCardElevation,
        child: InkWell(
          onTap: onTap,
          borderRadius: _borderRadius,
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: (Sizing.kSizingMultiple * 1.625).h,
              horizontal: (Sizing.kSizingMultiple * 2).w,
            ),
            decoration: BoxDecoration(
              // border: Border.all(
              //   color: CustomTypography.kLightGreyColor,
              // ),
              borderRadius: _borderRadius,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.headline4,
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                SizedBox(height: (Sizing.kSizingMultiple * 1.5).h),
                Image.asset(imageUrl, height: Sizing.kIconImagesHeightSize),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionSection() {
    return SliverToBoxAdapter(
      child: WidthConstraint(context).withHorizontalSymmetricalPadding(
        child: Row(
          children: [
            _buildActionItem(
              onTap: () {
                context.router.push(
                  ContactScreenRoute(
                      source: ContactRequestSource.sendMessageScreen),
                );
              },
              imageUrl: 'assets/icons/excel.png',
              label: 'Contact',
              value: 'Select contacts/group',
            ),
            SizedBox(width: (Sizing.kSizingMultiple * 2.5).w),
            _buildActionItem(
              onTap: () {
                context.router.push(const ImportIntroScreenRoute());
              },
              imageUrl: 'assets/icons/contact.png',
              label: 'Excel',
              value: 'Select a file from device',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactSectionTitle() {
    final _groupSnapshotCache = context.watch<GroupSnapshotCache>();
    final _contactSnapshotCache = context.watch<ContactSnapshotCache>();

    return SliverToBoxAdapter(
      child: WidthConstraint(context).withHorizontalSymmetricalPadding(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Recipients'),
            if (_groupSnapshotCache.selectedGroups.groups.isNotEmpty ||
                _contactSnapshotCache.selectedContacts.contacts.isNotEmpty) ...[
              GestureDetector(
                onTap: () => _clearSelectedContactsAndGroups(),
                child: Text(
                  'Clear Contacts',
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: CustomTypography.kPrimaryColor,
                      ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedGroupsList() {
    return Consumer<GroupSnapshotCache>(
      builder: (context, snapshot, child) {
        final _selectedGroups = snapshot.selectedGroups;

        return MessageRecipientList(
          icon: Icons.people_outline,
          title: 'Groups',
          description: '${_selectedGroups.groups.length} groups selected',
          messageRecipientListUnion: MessageRecipientListUnion.groupModel(
              contactGroupList: _selectedGroups),
        );
      },
    );
  }

  Widget _buildSelectedContactsList() {
    return Consumer<ContactSnapshotCache>(
      builder: (context, snapshot, child) {
        final _selectedContacts = snapshot.selectedContacts;

        return MessageRecipientList(
          icon: Icons.person_outline_rounded,
          title: 'Contacts',
          description: '${_selectedContacts.contacts.length} contacts selected',
          messageRecipientListUnion: MessageRecipientListUnion.contactModel(
              contactModelList: _selectedContacts),
        );
      },
    );
  }

  List<Widget> _buildRecipientSection() {
    return [
      _buildHSpacer(3.75),
      _buildContactSectionTitle(),
      _buildHSpacer(1.25),
      _buildSelectedGroupsList(),
      _buildSelectedContactsList(),
    ];
  }

  Widget _buildSendMessageButton() {
    return IconButton(
      onPressed: () => _onSendMessageCallback(),
      color: CustomTypography.kPrimaryColor,
      icon: const Icon(Icons.send),
    );
  }

  Widget _buildMessageTextField() {
    return TextFormField(
      controller: _messageTextFieldController,
      textAlignVertical: TextAlignVertical.center,
      focusNode: _messageTextFieldFocusNode,
      decoration: InputDecoration(
        hintText: 'Enter Message',
        suffixIcon: _buildSendMessageButton(),
        // border: InputBorder.none,
        // enabledBorder: InputBorder.none,
      ),
      validator: (value) {
        return _messageTextFieldController.text.isEmpty
            ? 'Enter message to send!'
            : null;
      },
    );
  }

  Widget _buildMessageFormSection() {
    return Form(
      key: _formKey,
      child: Material(
        elevation: Sizing.kButtonElevation,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: (Sizing.kSizingMultiple).h),
          padding: EdgeInsets.symmetric(
            horizontal: WidthConstraint(context).contentPadding,
          ),
          // color: CustomTypography.kLightGreyColor,
          child: _buildMessageTextField(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool _isKeyboardVisible =
        KeyboardVisibilityProvider.isKeyboardVisible(context);

    if (!_isKeyboardVisible) {
      // unfocus message text-field
      _messageTextFieldFocusNode.unfocus();
    }

    return BlocConsumer<SendMessageCubit,
        BlocState<Failure<ExceptionMessage>, MessageInfoList>>(
      listener: (context, state) {
        state.maybeMap(
          orElse: () => null,
          success: (state) async {
            ToastUtil.showToast('Message successfully sent successfully!');

            // show bottom-sheet for overview of sent-message
            await _showModalBottomSheet(messageInfo: state.data.SINGLE);

            // clear contacts, groups and message
            _clearSelectedContactsAndGroups();
            _messageTextFieldController.clear();
          },
          error: (state) {
            SnackBarUtil.snackbarError(
              context,
              code: state.failure.exception.code,
              message: state.failure.exception.message.toString(),
            );
          },
        );
      },
      builder: (context, state) {
        final _isLoading =
            state is Loading<Failure<ExceptionMessage>, MessageInfoList>;

        return LoadingIndicator(
          type: LoadingIndicatorType.overlay(
            isLoading: _isLoading,
            child: Column(
              children: [
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      _buildAppBar(),
                      _buildHSpacer(1),
                      _buildInfoIndicator(),
                      _buildHSpacer(2),
                      _buildSenderIdDropdownTextField(),
                      _buildHSpacer(2),
                      _buildActionSection(),
                      ..._buildRecipientSection(),
                    ],
                  ),
                ),
                _buildMessageFormSection(),
              ],
            ),
          ),
        );
      },
    );
  }
}
