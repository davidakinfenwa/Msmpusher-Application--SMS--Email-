import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:msmpusher/business/blocs/bloc_state.dart';
import 'package:msmpusher/business/blocs/message_blocs/get_message_reports_cubit/get_message_reports_cubit.dart';
import 'package:msmpusher/business/snapshot_cache/snapshot_cache.dart';
import 'package:msmpusher/core/constants.dart';
import 'package:msmpusher/core/dependence/dependence.dart';
import 'package:msmpusher/core/exceptions/exceptions.dart';
import 'package:msmpusher/core/util/date_time_util.dart';
import 'package:msmpusher/core/util/dialog_util.dart';
import 'package:msmpusher/core/util/keyboard_util.dart';
import 'package:msmpusher/core/util/toast_util.dart';
import 'package:msmpusher/core/util/width_constraints.dart';
import 'package:msmpusher/domain/form_params/form_params.dart';
import 'package:msmpusher/domain/model/models.dart';
import 'package:msmpusher/presentation/widget/widgets.dart';
import 'package:provider/provider.dart';

class ReportScreen extends StatefulWidget implements AutoRouteWrapper {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    final _authSnapshotCache = context.read<AuthSnapshotCache>();

    final _getMessageReportsFormParams = GetMessageReportsFormParams(
        userInfo: _authSnapshotCache.userInfoContext);

    return BlocProvider<GetMessageReportsCubit>(
      create: (context) => getIt<GetMessageReportsCubit>()
        ..getMessageInfoList(
            getMessageReportsFormParams: _getMessageReportsFormParams),
      child: this,
    );
  }
}

class _ReportScreenState extends State<ReportScreen> {
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
    final _messageSnapshotCache = context.read<MessageSnapshotCache>();
    _messageSnapshotCache.isSearchingMessageInfoListMode = false;
  }

  void _showModalBottomSheet(MessageInfo messageInfo) {
    HapticFeedback.vibrate();

    DialogUtil(context).bottomModal(
      child: ReportBottomSheet(messageInfo: messageInfo),
    );
  }

  void _onFetchMessageReportCallback() {
    final _authSnapshotCache = context.read<AuthSnapshotCache>();

    final _getMessageReportsFormParams = GetMessageReportsFormParams(
        userInfo: _authSnapshotCache.userInfoContext);

    context.read<GetMessageReportsCubit>().getMessageInfoList(
        getMessageReportsFormParams: _getMessageReportsFormParams);
  }

  Widget _buildReportItem({required MessageInfo messageInfo}) {
    return CustomListTile(
      onTap: () => _showModalBottomSheet(messageInfo),
      leading: const Icon(Icons.event_note),
      title: DateTimeUtil.toDateString(messageInfo.dateSent),
      description: messageInfo.message,
      trailing: CustomChip(
        label: messageInfo.status,
        foregroundColor: messageInfo.statusForegroundColor,
        backgroundColor: messageInfo.statusBackgroundColor,
      ),
    );
  }

  Widget _buildReportList() {
    final _messageSnapshotCache = context.watch<MessageSnapshotCache>();

    final _messageInfoList =
        _messageSnapshotCache.isSearchingMessageInfoListMode
            ? _messageSnapshotCache.searchMessageInfoListResult
            : _messageSnapshotCache.messageInfoList;

    if (_messageInfoList.IS_EMPTY) {
      return SliverFillRemaining(
        child: Center(
          child: WidthConstraint(context).withHorizontalSymmetricalPadding(
            child: EmptyResponseIndicator(
              type: EmptyResponseIndicatorType.simple(
                context,
                onActionCallback: () => _onFetchMessageReportCallback(),
                message: 'You have no message reports yet!',
              ),
            ),
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return _buildReportItem(
              messageInfo: _messageInfoList.messages[index]);
        },
        childCount: _messageInfoList.LENGTH,
      ),
    );
  }

  Widget _buildMessageReportBuilder() {
    final _messageSnapshotCache = context.read<MessageSnapshotCache>();

    return BlocConsumer<GetMessageReportsCubit,
        BlocState<Failure<ExceptionMessage>, MessageInfoList>>(
      listener: (context, state) {
        state.maybeMap(
          orElse: () => null,
          error: (state) {
            if (!_messageSnapshotCache.messageInfoList.IS_EMPTY) {
              ToastUtil.showToast(state.failure.exception.message.toString());
            }
          },
        );
      },
      builder: (context, state) {
        return state.maybeMap(
          orElse: () {
            if (!_messageSnapshotCache.messageInfoList.IS_EMPTY) {
              return _buildReportList();
            }

            return SliverFillRemaining(
              child: Center(
                child: LoadingIndicator(
                  type: LoadingIndicatorType.circularProgressIndicator(),
                ),
              ),
            );
          },
          success: (_) => _buildReportList(),
          error: (state) {
            if (!_messageSnapshotCache.messageInfoList.IS_EMPTY) {
              return _buildReportList();
            }

            return SliverFillRemaining(
              child: Center(
                child:
                    WidthConstraint(context).withHorizontalSymmetricalPadding(
                  child: ErrorIndicator(
                    type: ErrorIndicatorType.simple(
                      onRetryCallback: () => _onFetchMessageReportCallback(),
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

  @override
  Widget build(BuildContext context) {
    final _messageSnapshotCache = context.read<MessageSnapshotCache>();
    final bool _isKeyboardVisible = KeyboardUtil.isKeyboardVisible(context);

    if (!_isKeyboardVisible) {
      // unfocus search-text field
      _searchTextFieldFocusNode.unfocus();
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SearchSliverAppBar(
            title: 'Reports',
            focusNode: _searchTextFieldFocusNode,
            controller: _searchTextFieldController,
            onSearchChangedCallback: (value) {
              _messageSnapshotCache.searchMessageInfoFromList(value);
            },
            onDisposeCallback: () {
              Provider.of<MessageSnapshotCache>(context, listen: false)
                  .isSearchingMessageInfoListMode = false;
            },
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: (Sizing.kSizingMultiple * 1.75).h),
          ),
          _buildMessageReportBuilder(),
        ],
      ),
    );
  }
}
