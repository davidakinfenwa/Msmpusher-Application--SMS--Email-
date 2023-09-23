import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:msmpusher/business/blocs/bloc_state.dart';
import 'package:msmpusher/business/blocs/contact_blocs/delete_contact_group_cubit/delete_contact_group_cubit.dart';
import 'package:msmpusher/business/blocs/contact_blocs/delete_group_contact_cubit/delete_group_contact_cubit.dart';
import 'package:msmpusher/business/blocs/contact_blocs/get_contact_groups_cubit/get_contact_groups_cubit.dart';
import 'package:msmpusher/business/snapshot_cache/snapshot_cache.dart';
import 'package:msmpusher/core/constants.dart';
import 'package:msmpusher/core/dependence/dependence.dart';
import 'package:msmpusher/core/exceptions/exceptions.dart';
import 'package:msmpusher/core/theme/custom_typography.dart';
import 'package:msmpusher/core/util/dialog_util.dart';
import 'package:msmpusher/core/util/width_constraints.dart';
import 'package:msmpusher/domain/model/models.dart';
import 'package:msmpusher/presentation/widget/widgets.dart';
import 'package:provider/provider.dart';

class GroupList extends StatefulWidget {
  const GroupList({Key? key}) : super(key: key);

  @override
  State<GroupList> createState() => _GroupListState();
}

class _GroupListState extends State<GroupList> {
  Widget _buildLoadingIndicator() {
    return SliverToBoxAdapter(
      child: LoadingIndicator(
        type: LoadingIndicatorType.circularProgressIndicator(),
      ),
    );
  }

  void _showGroupDetailsModalBottomSheet(ContactGroup contactGroup) {
    DialogUtil(context).bottomModal(
      child: MultiBlocProvider(
        providers: [
          BlocProvider<DeleteContactGroupCubit>(
            create: (context) => getIt<DeleteContactGroupCubit>(),
          ),
          BlocProvider<DeleteGroupContactCubit>(
            create: (context) => getIt<DeleteGroupContactCubit>(),
          ),
        ],
        child: GroupDetailsModal(contactGroup: contactGroup),
      ),
    );
  }

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

  Widget _buildGroupItem(
      {required ContactGroup contactGroup, required int index}) {
    return CustomListTile(
      onTap: () {
        // select or unselect contact-groups
        context
            .read<GroupSnapshotCache>()
            .selectContactGroup(contactGroup, index: index);
      },
      leading: _buildContactItemLeading(
        icon: Icons.people_outline,
        isChecked: contactGroup.isChecked,
      ),
      title: contactGroup.name,
      description: '${contactGroup.contactList.contacts.length} Contacts',
      trailing: IconButton(
        onPressed: () {
          HapticFeedback.vibrate();

          // set preview context
          context.read<GroupSnapshotCache>().previewContext = contactGroup;

          _showGroupDetailsModalBottomSheet(contactGroup);
        },
        icon: const Icon(Icons.more_horiz_rounded),
      ),
    );
  }

  List<Widget> _buildContactGroupsList(ContactGroupList contactGroupList) {
    if (contactGroupList.groups.isEmpty) {
      return [
        const InfoIndicator(label: 'You have no contact groups yet!'),
        SizedBox(height: (Sizing.kSizingMultiple * 2).h),
      ];
    }

    return List.generate(contactGroupList.groups.length, (index) {
      final _contactGroup = contactGroupList.groups[index];

      return _buildGroupItem(contactGroup: _contactGroup, index: index);
    });
  }

  Widget _buildGroupListTile() {
    return Consumer<GroupSnapshotCache>(
      builder: (context, snapshot, child) {
        final _contactGroupList = snapshot.contactGroupList;

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
              child: const Icon(Icons.people_outline),
            ),
            title: const Text('Contacts Groups'),
            subtitle: Text(
              'Expand to see created groups',
              style: Theme.of(context).textTheme.subtitle2,
            ),
            children: _buildContactGroupsList(_contactGroupList),
          ),
        );
      },
    );
  }

  Widget _buildGroupList() {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          _buildGroupListTile(),
          Divider(
            height: Sizing.kZeroValue,
            color: CustomTypography.kLightGreyColor,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetContactGroupsCubit,
        BlocState<Failure<ExceptionMessage>, ContactGroupList>>(
      builder: (context, state) {
        return state.map(
          initial: (_) => _buildLoadingIndicator(),
          loading: (_) => _buildLoadingIndicator(),
          success: (_) => _buildGroupList(),
          error: (error) {
            return SliverToBoxAdapter(
              child: Center(
                child: InfoIndicator(
                  label: error.failure.exception.message.toString(),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
