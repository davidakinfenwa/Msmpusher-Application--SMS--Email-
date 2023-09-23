import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:msmpusher/business/blocs/bloc_state.dart';
import 'package:msmpusher/business/blocs/sender_blocs/delete_sender_id_cubit/delete_sender_id_cubit.dart';
import 'package:msmpusher/business/snapshot_cache/snapshot_cache.dart';
import 'package:msmpusher/core/constants.dart';
import 'package:msmpusher/core/exceptions/exceptions.dart';
import 'package:msmpusher/core/theme/custom_typography.dart';
import 'package:msmpusher/core/util/toast_util.dart';
import 'package:msmpusher/core/util/width_constraints.dart';
import 'package:msmpusher/domain/form_params/form_params.dart';
import 'package:msmpusher/domain/model/models.dart';
import 'package:msmpusher/presentation/widget/widgets.dart';

class DeleteSenderIdBottomSheet extends StatelessWidget {
  final SenderId senderId;

  const DeleteSenderIdBottomSheet({Key? key, required this.senderId})
      : super(key: key);

  void _onDeleteSenderIdCallback(BuildContext context) {
    final _userInfoContext = context.read<AuthSnapshotCache>().userInfoContext;

    final _deleteSenderIdFormParams = DeleteSenderIdFormParams(
      sid: senderId.sId,
      userId: _userInfoContext.uid,
      accountNumber: _userInfoContext.accountNumber!,
    );

    context
        .read<DeleteSenderIdCubit>()
        .deleteSenderId(deleteSenderIdFormParams: _deleteSenderIdFormParams);
  }

  Widget _buildBottomSheetButton() {
    return BlocConsumer<DeleteSenderIdCubit,
        BlocState<Failure<ExceptionMessage>, SenderIdList>>(
      listener: (context, state) {
        state.maybeMap(
          orElse: () => null,
          success: (state) async {
            await context.router.pop();

            ToastUtil.showToast('${senderId.senderId} deleted successfully');
            context.read<SenderSnapshotCache>().notifyAllListeners();
          },
          error: (state) {
            ToastUtil.showToast(
              state.failure.exception.message.toString(),
              longLength: true,
            );
          },
        );
      },
      builder: (context, state) {
        final _isLoading =
            state is Loading<Failure<ExceptionMessage>, SenderIdList>;

        return CustomButton(
          type: ButtonType.regularButton(
            onTap: () => _onDeleteSenderIdCallback(context),
            label: 'Delete Sender ID',
            isLoadingMode: _isLoading,
            backgroundColor: CustomTypography.kErrorColor,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GenericBottomSheet(
      title: Text(
        'Delete ${senderId.senderId}?',
        style: Theme.of(context).textTheme.headline5,
      ),
      description: Text(
        'You can delete this sender-id by selecting the button below',
        style: Theme.of(context).textTheme.subtitle2,
      ),
      child: WidthConstraint(context).withHorizontalSymmetricalPadding(
        child: Column(
          children: [
            SizedBox(height: (Sizing.kSizingMultiple).h),
            _buildBottomSheetButton(),
            SizedBox(height: (Sizing.kSizingMultiple).h),
          ],
        ),
      ),
    );
  }
}
