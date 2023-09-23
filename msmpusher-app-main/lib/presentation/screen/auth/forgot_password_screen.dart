import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:msmpusher/business/blocs/auth_blocs/forgot_password_form_cubit/forgot_password_form_cubit.dart';
import 'package:msmpusher/business/blocs/bloc_state.dart';
import 'package:msmpusher/business/snapshot_cache/snapshot_cache.dart';
import 'package:msmpusher/core/constants.dart';
import 'package:msmpusher/core/dependence/dependence.dart';
import 'package:msmpusher/core/exceptions/exceptions.dart';
import 'package:msmpusher/core/route/app_router.dart';
import 'package:msmpusher/core/util/keyboard_util.dart';
import 'package:msmpusher/core/util/snackbar_util.dart';
import 'package:msmpusher/core/util/width_constraints.dart';
import 'package:msmpusher/domain/form_params/form_params.dart';
import 'package:msmpusher/domain/model/models.dart';
import 'package:msmpusher/presentation/widget/widgets.dart';

class ForgotPasswordScreen extends StatefulWidget implements AutoRouteWrapper {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider<ForgotPasswordFormCubit>(
      create: (context) => getIt<ForgotPasswordFormCubit>(),
      child: this,
    );
  }
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late TextEditingController _phoneNumberTextFieldController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    // initialize text-field with previous data if any
    _phoneNumberTextFieldController = TextEditingController(
      text: context.read<AuthSnapshotCache>().forgotPasswordPhoneNumber,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _phoneNumberTextFieldController.dispose();
    super.dispose();
  }

  void _onForgotPasswordButtonPressedCallback() {
    KeyboardUtil.hideKeyboard(context);

    if (!_formKey.currentState!.validate()) return;

    // set context in snapshot cache
    context.read<AuthSnapshotCache>().forgotPasswordPhoneNumber =
        _phoneNumberTextFieldController.text;

    final _forgotPasswordFormParams = ForgotPasswordFormParams(
      phoneNumber: _phoneNumberTextFieldController.text,
    );

    context
        .read<ForgotPasswordFormCubit>()
        .forgotPassword(forgotPasswordFormParams: _forgotPasswordFormParams);
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Forgot Password',
          style: Theme.of(context).textTheme.headline5,
        ),
        SizedBox(height: Sizing.kSizingMultiple.h),
        const Text(
            'Enter your phone number to reset your password. A reset password will be sent to your number.'),
      ],
    );
  }

  Widget _buildPhoneNumberTextField() {
    return TextFormField(
      controller: _phoneNumberTextFieldController,
      keyboardType: TextInputType.phone,
      textAlignVertical: TextAlignVertical.center,
      decoration: const InputDecoration(
        hintText: 'Phone number',
      ),
      validator: (value) {
        return _phoneNumberTextFieldController.text.isEmpty
            ? 'Phone number is required!'
            : null;
      },
    );
  }

  Widget _buildResetPasswordButton() {
    return BlocConsumer<ForgotPasswordFormCubit,
        BlocState<Failure<ExceptionMessage>, ResponseModel<AuthKeyModel>>>(
      listener: (context, state) {
        state.maybeMap(
          orElse: () => null,
          success: (state) {
            state.data.map(
              successResponse: (state) {
                // clear form inputs
                _formKey.currentState!.reset();

                // context.router.push(const ChangePasswordScreenRoute());
                context.router
                    .replace(const PasswordResetOTPVerificationScreenRoute());
              },
              errorResponse: (state) {
                SnackBarUtil.snackbarError<String>(
                  context,
                  code: ExceptionCode.UNDEFINED,
                  message: state.data.message,
                );
              },
            );
          },
          error: (state) {
            SnackBarUtil.snackbarError<String>(
              context,
              code: state.failure.exception.code,
              message: state.failure.exception.message.toString(),
            );
          },
        );
      },
      builder: (context, state) {
        final _isLoading = state
            is Loading<Failure<ExceptionMessage>, ResponseModel<AuthKeyModel>>;

        return CustomButton(
          type: ButtonType.regularButton(
            onTap: () => _onForgotPasswordButtonPressedCallback(),
            label: 'Reset Password',
            isLoadingMode: _isLoading,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WidthConstraint(context).withHorizontalSymmetricalPadding(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: (Sizing.kSizingMultiple * 3.125).h),
                  _buildTitleSection(),
                  SizedBox(height: (Sizing.kSizingMultiple * 5).h),
                  _buildPhoneNumberTextField(),
                  SizedBox(height: (Sizing.kSizingMultiple * 3.75).h),
                  _buildResetPasswordButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
