import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:msmpusher/business/blocs/bloc_state.dart';
import 'package:msmpusher/business/blocs/sender_blocs/create_sender_id_cubit/create_sender_id_cubit.dart';
import 'package:msmpusher/business/snapshot_cache/snapshot_cache.dart';
import 'package:msmpusher/core/constants.dart';
import 'package:msmpusher/core/exceptions/exceptions.dart';
import 'package:msmpusher/core/util/keyboard_util.dart';
import 'package:msmpusher/core/util/toast_util.dart';
import 'package:msmpusher/core/util/width_constraints.dart';
import 'package:msmpusher/domain/form_params/form_params.dart';
import 'package:msmpusher/domain/model/models.dart';
import 'package:msmpusher/presentation/widget/widgets.dart';

class CreateSenderIdForm extends StatefulWidget {
  const CreateSenderIdForm({Key? key}) : super(key: key);

  @override
  State<CreateSenderIdForm> createState() => _CreateSenderIdFormState();
}

class _CreateSenderIdFormState extends State<CreateSenderIdForm> {
  late TextEditingController _senderIdTextFieldController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _senderIdTextFieldController = TextEditingController();
  }

  @override
  void dispose() {
    _senderIdTextFieldController.dispose();
    super.dispose();
  }

  void _onCreateSenderIdCallback() {
    KeyboardUtil.hideKeyboard(context);
    if (!_formKey.currentState!.validate()) return;

    final _userInfoContext = context.read<AuthSnapshotCache>().userInfoContext;

    final _createSenderIdFormParams = CreateSenderIdFormParams(
      userId: _userInfoContext.uid,
      senderName: _senderIdTextFieldController.text,
      accountNumber: _userInfoContext.accountNumber!,
    );

    context
        .read<CreateSenderIdCubit>()
        .createSenderId(createSenderIdFormParams: _createSenderIdFormParams);
  }

  Widget _buildSenderIdTextField() {
    return TextFormField(
      controller: _senderIdTextFieldController,
      textAlignVertical: TextAlignVertical.center,
      // focusNode: widget.focusNode,
      decoration: const InputDecoration(
        hintText: 'Enter Sender ID',
      ),
      validator: (value) {
        return _senderIdTextFieldController.text.isEmpty
            ? 'Sender-ID is required!'
            : null;
      },
    );
  }

  Widget _buildBottomSheetButton() {
    return BlocConsumer<CreateSenderIdCubit,
        BlocState<Failure<ExceptionMessage>, SenderIdList>>(
      listener: (context, state) {
        state.maybeMap(
          orElse: () => null,
          success: (state) async {
            await context.router.pop();

            ToastUtil.showToast('Sender-ID created successfully');
            context.read<SenderSnapshotCache>().notifyAllListeners();

            // clear form data
            _formKey.currentState!.reset();
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
            onTap: () => _onCreateSenderIdCallback(),
            label: 'Create Sender ID',
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
        'Create Sender ID',
        style: Theme.of(context).textTheme.headline5,
      ),
      description: Text(
        'Create a new sender-id. We will notify you when it is approved',
        style: Theme.of(context).textTheme.subtitle2,
      ),
      child: WidthConstraint(context).withHorizontalSymmetricalPadding(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: (Sizing.kSizingMultiple * 2).h),
              _buildSenderIdTextField(),
              SizedBox(height: (Sizing.kSizingMultiple * 2).h),
              _buildBottomSheetButton(),
              SizedBox(height: (Sizing.kSizingMultiple * 2).h),
            ],
          ),
        ),
      ),
    );
  }
}
