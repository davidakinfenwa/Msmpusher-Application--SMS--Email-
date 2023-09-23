import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:msmpusher/business/blocs/bloc_state.dart';
import 'package:msmpusher/business/blocs/sender_blocs/create_sender_id_cubit/create_sender_id_cubit.dart';
import 'package:msmpusher/business/blocs/sender_blocs/delete_sender_id_cubit/delete_sender_id_cubit.dart';
import 'package:msmpusher/business/blocs/sender_blocs/get_sender_ids_cubit/get_sender_ids_cubit.dart';
import 'package:msmpusher/business/snapshot_cache/snapshot_cache.dart';
import 'package:msmpusher/core/constants.dart';
import 'package:msmpusher/core/dependence/dependence.dart';
import 'package:msmpusher/core/exceptions/exceptions.dart';
import 'package:msmpusher/core/theme/custom_typography.dart';
import 'package:msmpusher/core/util/dialog_util.dart';
import 'package:msmpusher/core/util/keyboard_util.dart';
import 'package:msmpusher/core/util/snackbar_util.dart';
import 'package:msmpusher/core/util/width_constraints.dart';
import 'package:msmpusher/domain/form_params/form_params.dart';
import 'package:msmpusher/domain/model/models.dart';
import 'package:msmpusher/presentation/widget/widgets.dart';

class SenderIdScreen extends StatefulWidget implements AutoRouteWrapper {
  const SenderIdScreen({Key? key}) : super(key: key);

  @override
  State<SenderIdScreen> createState() => _SenderIdScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    final _authSnapshotCache = context.read<AuthSnapshotCache>();

    final _getAccountDetailsFormParams = GetAccountDetailsFormParams(
      userId: _authSnapshotCache.userInfoContext.uid,
      accountNumber: _authSnapshotCache.userInfoContext.accountNumber!,
    );

    return BlocProvider<GetSenderIdsCubit>(
      create: (context) => getIt<GetSenderIdsCubit>()
        ..getSenderIds(
            getAccountDetailsFormParams: _getAccountDetailsFormParams),
      child: this,
    );
  }
}

class _SenderIdScreenState extends State<SenderIdScreen> {
  late FocusNode _searchTextFieldFocusNode;
  late TextEditingController _searchTextFieldController;

  @override
  void initState() {
    super.initState();
    _searchTextFieldFocusNode = FocusNode();
    _searchTextFieldController = TextEditingController();
  }

  @override
  void dispose() {
    _searchTextFieldFocusNode.dispose();
    _searchTextFieldController.dispose();
    super.dispose();
  }

  void _onGetSenderIdListCallback() {
    final _authSnapshotCache = context.read<AuthSnapshotCache>();

    final _getAccountDetailsFormParams = GetAccountDetailsFormParams(
      userId: _authSnapshotCache.userInfoContext.uid,
      accountNumber: _authSnapshotCache.userInfoContext.accountNumber!,
    );

    context.read<GetSenderIdsCubit>().getSenderIds(
        getAccountDetailsFormParams: _getAccountDetailsFormParams);
  }

  void _showCreateSenderIDModalBottomSheet(BuildContext context) {
    DialogUtil(context).bottomModal(
      child: BlocProvider<CreateSenderIdCubit>(
        create: (context) => getIt<CreateSenderIdCubit>(),
        child: const CreateSenderIdForm(),
      ),
    );
  }

  void _showDeleteSenderIDModalBottomSheet({required SenderId senderId}) {
    DialogUtil(context).bottomModal(
      isDismissible: false,
      child: BlocProvider<DeleteSenderIdCubit>(
        create: (context) => getIt<DeleteSenderIdCubit>(),
        child: DeleteSenderIdBottomSheet(senderId: senderId),
      ),
    );
  }

  Widget _buildInfoIndicator() {
    return SliverToBoxAdapter(
      child: WidthConstraint(context).withHorizontalSymmetricalPadding(
        child: const InfoIndicator(
            label:
                'You can create a new sender-id or delete one by selecting it'),
      ),
    );
  }

  Widget _buildSenderIdItem({required SenderId senderId}) {
    return CustomListTile(
      onTap: () {
        _showDeleteSenderIDModalBottomSheet(senderId: senderId);
      },
      leading: const Icon(Icons.manage_accounts_outlined),
      title: senderId.senderId,
      description: senderId.created.toString(),
      trailing: CustomChip(
        label: senderId.label,
        foregroundColor: senderId.indicatorColor,
        backgroundColor: senderId.backgroundColor,
      ),
    );
  }

  Widget _buildSenderIdList() {
    final _senderList = context.watch<SenderSnapshotCache>().senderIdList;

    if (_senderList.senderIds.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: WidthConstraint(context).withHorizontalSymmetricalPadding(
            child: EmptyResponseIndicator(
              type: EmptyResponseIndicatorType.simple(
                context,
                onActionCallback: () => _onGetSenderIdListCallback(),
                message: 'You have not created a sender-id yet!',
              ),
            ),
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final _senderId = _senderList.senderIds[index];

          return _buildSenderIdItem(senderId: _senderId);
        },
        childCount: _senderList.senderIds.length,
      ),
    );
  }

  Widget _buildSenderIdListBuilder() {
    final _senderSnapshotCache = context.watch<SenderSnapshotCache>();

    return BlocConsumer<GetSenderIdsCubit,
        BlocState<Failure<ExceptionMessage>, SenderIdList>>(
      listener: (context, state) {
        state.maybeMap(
          orElse: () => null,
          error: (state) {
            if (_senderSnapshotCache.senderIdList != SenderIdList.empty()) {
              SnackBarUtil.snackbarError(
                context,
                onRefreshCallback: () => _onGetSenderIdListCallback(),
                code: state.failure.exception.code,
                message: state.failure.exception.message.toString(),
              );
            }
          },
        );
      },
      builder: (context, state) {
        return state.maybeMap(
          orElse: () {
            if (_senderSnapshotCache.senderIdList != SenderIdList.empty()) {
              return _buildSenderIdList();
            }

            return SliverFillRemaining(
              child: Center(
                child: LoadingIndicator(
                  type: LoadingIndicatorType.circularProgressIndicator(),
                ),
              ),
            );
          },
          success: (_) => _buildSenderIdList(),
          error: (state) {
            if (_senderSnapshotCache.senderIdList != SenderIdList.empty()) {
              return _buildSenderIdList();
            }

            return SliverFillRemaining(
              child: Center(
                child:
                    WidthConstraint(context).withHorizontalSymmetricalPadding(
                  child: ErrorIndicator(
                    type: ErrorIndicatorType.simple(
                      onRetryCallback: () => _onGetSenderIdListCallback(),
                      code: state.failure.exception.code,
                      message: state.failure.exception.message.toString(),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFloatingActionButton() {
    return Builder(builder: (context) {
      return FloatingActionButton(
        onPressed: () {
          _showCreateSenderIDModalBottomSheet(context);
        },
        tooltip: 'Create Sender-ID',
        elevation: Sizing.kButtonElevation,
        backgroundColor: CustomTypography.kPrimaryColor,
        child: const Icon(Icons.add),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool _isKeyboardVisible = KeyboardUtil.isKeyboardVisible(context);

    if (!_isKeyboardVisible) {
      // unfocus search-text field
      _searchTextFieldFocusNode.unfocus();
    }

    return Scaffold(
      floatingActionButton: _buildFloatingActionButton(),
      // bottomSheet: _buildCreateSenderIdBottomSheet(),
      body: CustomScrollView(
        slivers: [
          SearchSliverAppBar(
            title: 'Sender IDs',
            focusNode: _searchTextFieldFocusNode,
            controller: _searchTextFieldController,
            onSearchChangedCallback: (value) {
              // TODO:
            },
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: (Sizing.kSizingMultiple * 1.75).h),
          ),
          _buildInfoIndicator(),
          SliverToBoxAdapter(
            child: SizedBox(height: (Sizing.kSizingMultiple).h),
          ),
          _buildSenderIdListBuilder(),
        ],
      ),
    );
  }
}
