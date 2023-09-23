import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:msmpusher/business/blocs/bloc_state.dart';
import 'package:msmpusher/business/blocs/contact_blocs/create_contact_group_cubit/create_contact_group_cubit.dart';
import 'package:msmpusher/business/snapshot_cache/snapshot_cache.dart';
import 'package:msmpusher/core/constants.dart';
import 'package:msmpusher/core/exceptions/exceptions.dart';
import 'package:msmpusher/core/util/keyboard_util.dart';
import 'package:msmpusher/core/util/snackbar_util.dart';
import 'package:msmpusher/core/util/toast_util.dart';
import 'package:msmpusher/core/util/unit_impl.dart';
import 'package:msmpusher/core/util/width_constraints.dart';
import 'package:msmpusher/domain/model/models.dart';
import 'package:msmpusher/presentation/widget/widgets.dart';
import 'package:provider/provider.dart';

class GroupCreateForm extends StatefulWidget {
  final ContactModelList contactModelList;
  final Function(ContactGroup)? onCreateGroupCallback;

  const GroupCreateForm({
    Key? key,
    required this.contactModelList,
    this.onCreateGroupCallback,
  }) : super(key: key);

  @override
  State<GroupCreateForm> createState() => _GroupCreateFormState();
}

class _GroupCreateFormState extends State<GroupCreateForm> {
  late TextEditingController _groupNameTextFieldController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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

  void _onCreateGroupCallback() {
    KeyboardUtil.hideKeyboard(context);
    if (!_formKey.currentState!.validate()) return;

    final _contactGroup = ContactGroup.init(
      name: _groupNameTextFieldController.text,
      contactModelList: widget.contactModelList,
    );

    BlocProvider.of<CreateContactGroupCubit>(context, listen: false)
        .createContactGroup(contactGroup: _contactGroup);
  }

  Widget _buildGroupNameTextField() {
    return TextFormField(
      controller: _groupNameTextFieldController,
      textAlignVertical: TextAlignVertical.center,
      decoration: const InputDecoration(
        hintText: 'Group name',
        prefixIcon: Icon(Icons.people_outline),
      ),
      validator: (value) {
        return _groupNameTextFieldController.text.isEmpty
            ? 'Group name is required!'
            : null;
      },
    );
  }

  Widget _buildCreateGroupButton() {
    return BlocConsumer<CreateContactGroupCubit,
        BlocState<Failure<ExceptionMessage>, ContactGroup>>(
      listener: (context, state) {
        state.maybeMap(
          orElse: () => null,
          success: (state) async {
            // reset form fields
            _groupNameTextFieldController.clear();
            ToastUtil.showToast('Group created and contacts added to group');

            // clear selected contacts
            Provider.of<ContactSnapshotCache>(context, listen: false)
                .clearSelectedContacts();

            // close bottom-sheet
            await context.router.pop();

            // trigger rebuild
            context.read<GroupSnapshotCache>().notifyAllListeners();

            // trigger callback
            widget.onCreateGroupCallback!(state.data);
          },
          error: (state) {
            // TODO:
            SnackBarUtil.snackbarError(
              context,
              showAction: false,
              code: state.failure.exception.code,
              message: state.failure.exception.message,
            );
          },
        );
      },
      builder: (context, state) {
        final _isLoading =
            state is Loading<Failure<ExceptionMessage>, UnitImpl>;

        return CustomButton(
          type: ButtonType.regularButton(
            onTap: _onCreateGroupCallback,
            label: 'Create Group',
            isLoadingMode: _isLoading,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GenericBottomSheet(
      title: Text(
        'Create Group',
        style: Theme.of(context).textTheme.headline5,
      ),
      description: Text(
        'Add selected contacts to created group',
        style: Theme.of(context).textTheme.subtitle2,
      ),
      child: WidthConstraint(context).withHorizontalSymmetricalPadding(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildGroupNameTextField(),
              SizedBox(height: (Sizing.kSizingMultiple * 2).h),
              _buildCreateGroupButton(),
              SizedBox(height: (Sizing.kSizingMultiple * 2).h),
            ],
          ),
        ),
      ),
    );
  }
}
