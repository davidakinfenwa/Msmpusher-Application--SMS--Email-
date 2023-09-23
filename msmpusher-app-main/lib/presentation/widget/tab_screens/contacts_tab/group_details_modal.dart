import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:msmpusher/business/blocs/bloc_state.dart';
import 'package:msmpusher/business/blocs/contact_blocs/delete_contact_group_cubit/delete_contact_group_cubit.dart';
import 'package:msmpusher/business/blocs/contact_blocs/delete_group_contact_cubit/delete_group_contact_cubit.dart';
import 'package:msmpusher/business/snapshot_cache/snapshot_cache.dart';
import 'package:msmpusher/core/constants.dart';
import 'package:msmpusher/core/exceptions/exceptions.dart';
import 'package:msmpusher/core/theme/custom_typography.dart';
import 'package:msmpusher/core/util/toast_util.dart';
import 'package:msmpusher/core/util/unit_impl.dart';
import 'package:msmpusher/core/util/width_constraints.dart';
import 'package:msmpusher/domain/model/models.dart';
import 'package:msmpusher/presentation/widget/widgets.dart';

class GroupDetailsModal extends StatefulWidget {
  final ContactGroup contactGroup;

  const GroupDetailsModal({Key? key, required this.contactGroup})
      : super(key: key);

  @override
  State<GroupDetailsModal> createState() => _GroupDetailsModalState();
}

class _GroupDetailsModalState extends State<GroupDetailsModal> {
  ContactModel? _contactModelContextToDelete;

  Widget _buildContactItemLeading(
      {required IconData icon, required bool isChecked}) {
    return CircleAvatar(
      backgroundColor: CustomTypography.kLightGreyColor,
      foregroundColor: CustomTypography.kMidGreyColor,
      child: Stack(
        children: [
          Icon(icon),
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

  Widget _buildGroupContactItem({
    required ContactModel contactModel,
    required ContactGroup contactGroup,
    required int index,
  }) {
    return BlocBuilder<DeleteGroupContactCubit,
        BlocState<Failure<ExceptionMessage>, ContactGroup>>(
      builder: (context, state) {
        final _isLoading =
            state is Loading<Failure<ExceptionMessage>, ContactGroup> &&
                _contactModelContextToDelete == contactModel;

        return CustomListTile(
          leading: _buildContactItemLeading(
            icon: Icons.person_outline_rounded,
            isChecked: false,
          ),
          title: contactModel.contact.displayName,
          description: contactModel.primaryPhone.value,
          trailing: IconButton(
            onPressed: () {
              HapticFeedback.vibrate();
              // set context
              _contactModelContextToDelete = contactModel;

              context.read<DeleteGroupContactCubit>().deleteGroupContact(
                    groupUniqueId: contactGroup.uniqueId,
                    contactUniqueId: contactModel.uniqueId,
                  );
            },
            icon: _isLoading
                ? LoadingIndicator(
                    type: LoadingIndicatorType.circularProgressIndicator(
                        isSmallSize: true),
                  )
                : const Icon(Icons.delete_outline_rounded),
          ),
        );
      },
    );
  }

  List<Widget> _buildContactListInGroup(ContactGroup contactGroup) {
    if (contactGroup.contactList.contacts.isEmpty) {
      return [
        SizedBox(height: (Sizing.kSizingMultiple * 2).h),
        const InfoIndicator(label: 'No contact belongs to this group!'),
        SizedBox(height: (Sizing.kSizingMultiple * 2).h),
      ];
    }

    return List.generate(contactGroup.contactsLength, (index) {
      return _buildGroupContactItem(
        contactModel: contactGroup.contactList.contacts[index],
        contactGroup: contactGroup,
        index: index,
      );
    });
  }

  Widget _buildDeleteGroupButton(ContactGroup contactGroup) {
    return BlocConsumer<DeleteContactGroupCubit,
        BlocState<Failure<ExceptionMessage>, UnitImpl>>(
      listener: (context, state) {
        state.maybeMap(
          orElse: () => null,
          success: (_) {
            ToastUtil.showToast('Group deleted successfully');

            // trigger widget rebuild
            context.read<GroupSnapshotCache>().notifyAllListeners();

            // close bottom-sheet
            context.router.pop();
          },
        );
      },
      builder: (context, state) {
        final _isLoading =
            state is Loading<Failure<ExceptionMessage>, UnitImpl>;

        return WidthConstraint(context).withHorizontalSymmetricalPadding(
          child: CustomButton(
            type: ButtonType.regularFlatButton(
              onTap: () {
                HapticFeedback.vibrate();

                context
                    .read<DeleteContactGroupCubit>()
                    .deleteContactGroup(uniqueId: contactGroup.uniqueId);
              },
              isLoadingMode: _isLoading,
              backgroundColor: CustomTypography.kLightGreyColor,
              textColor: CustomTypography.kErrorColor,
              label: 'Delete Group',
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final _contactGroupPreviewContext =
        context.watch<GroupSnapshotCache>().previewContext;

    return GenericBottomSheet(
      title: BlocListener<DeleteGroupContactCubit,
          BlocState<Failure<ExceptionMessage>, ContactGroup>>(
        listener: (context, state) {
          state.maybeMap(
            orElse: () => null,
            success: (state) {
              ToastUtil.showToast('Contact removed from group successfully');

              // trigger widget rebuild
              context.read<GroupSnapshotCache>().notifyAllListeners();

              // set preview context
              context.read<GroupSnapshotCache>().previewContext = state.data;
            },
          );
        },
        child: Text(
          _contactGroupPreviewContext.name,
          style: Theme.of(context).textTheme.headline5,
        ),
      ),
      description: Text(
        '${_contactGroupPreviewContext.contactsLength} contacts belong to this group',
        style: Theme.of(context).textTheme.subtitle2,
      ),
      child: Column(
        children: [
          _buildDeleteGroupButton(_contactGroupPreviewContext),
          SizedBox(height: (Sizing.kSizingMultiple).h),
          ..._buildContactListInGroup(_contactGroupPreviewContext),
        ],
      ),
    );
  }
}
