import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:msmpusher/business/blocs/contact_blocs/create_contact_group_cubit/create_contact_group_cubit.dart';
import 'package:msmpusher/business/snapshot_cache/snapshot_cache.dart';
import 'package:msmpusher/core/dependence/dependence.dart';
import 'package:msmpusher/core/theme/custom_typography.dart';
import 'package:msmpusher/core/util/dialog_util.dart';
import 'package:msmpusher/presentation/widget/widgets.dart';

class FileContactsViewScreen extends StatefulWidget {
  const FileContactsViewScreen({Key? key}) : super(key: key);

  @override
  State<FileContactsViewScreen> createState() => _FileContactsViewScreenState();
}

class _FileContactsViewScreenState extends State<FileContactsViewScreen> {
  void _openCreateGroupFormBottomSheet() {
    final _excelFileContacts =
        context.read<ContactSnapshotCache>().deviceFileContacts;

    DialogUtil(context).bottomModal(
      enableDrag: false,
      isDismissible: false,
      child: BlocProvider<CreateContactGroupCubit>(
        create: (_) => getIt<CreateContactGroupCubit>(),
        child: GroupCreateForm(
          onCreateGroupCallback: (contactGroup) {
            // select contact-group (after grouping file contacts)
            context.read<GroupSnapshotCache>().selectContactGroup(contactGroup);

            context.router.pop();
          },
          contactModelList: _excelFileContacts,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _buildCreateGroupToAddContactsButton(),
      body: const ExcelContactsView(),
    );
  }
}
