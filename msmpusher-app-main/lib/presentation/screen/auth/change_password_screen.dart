import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:msmpusher/business/blocs/auth_blocs/change_password_form_cubit/change_password_form_cubit.dart';
import 'package:msmpusher/business/blocs/bloc_state.dart';
import 'package:msmpusher/business/snapshot_cache/snapshot_cache.dart';
import 'package:msmpusher/core/constants.dart';
import 'package:msmpusher/core/dependence/dependence.dart';
import 'package:msmpusher/core/exceptions/exceptions.dart';
import 'package:msmpusher/core/route/app_router.dart';
import 'package:msmpusher/core/util/keyboard_util.dart';
import 'package:msmpusher/core/util/snackbar_util.dart';
import 'package:msmpusher/core/util/toast_util.dart';
import 'package:msmpusher/core/util/width_constraints.dart';
import 'package:msmpusher/domain/form_params/form_params.dart';
import 'package:msmpusher/domain/model/models.dart';
import 'package:msmpusher/presentation/widget/widgets.dart';

enum ChangePasswordScreenSource {
  userAccount,
  authentication,
}

class ChangePasswordScreen extends StatefulWidget implements AutoRouteWrapper {
  final ChangePasswordScreenSource source;

  const ChangePasswordScreen({
    Key? key,
    this.source = ChangePasswordScreenSource.authentication,
  }) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider<ChangePasswordFormCubit>(
      create: (context) => getIt<ChangePasswordFormCubit>(),
      child: this,
    );
  }
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool _obscuredNewPassword = true;
  bool _obscuredConfirmPassword = true;

  late TextEditingController _newPasswordTextFieldController;
  late TextEditingController _confirmPasswordTextFieldController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ChangePasswordScreenSource get _source => widget.source;

  @override
  void initState() {
    super.initState();

    _newPasswordTextFieldController = TextEditingController();
    _confirmPasswordTextFieldController = TextEditingController();
  }

  @override
  void dispose() {
    _newPasswordTextFieldController.dispose();
    _confirmPasswordTextFieldController.dispose();
    super.dispose();
  }

  void _onChangePasswordButtonPressedCallback() {
    KeyboardUtil.hideKeyboard(context);

    if (!_formKey.currentState!.validate()) return;

    final _authSnapshotCache = context.read<AuthSnapshotCache>();

    final _phoneNumber = _source == ChangePasswordScreenSource.authentication
        ? _authSnapshotCache.forgotPasswordPhoneNumber!
        : _authSnapshotCache.userInfo.phoneNumber;

    final _changePasswordFormParams = ChangePasswordFormParams(
      phoneNumber: _phoneNumber,
      newPassword: _newPasswordTextFieldController.text,
    );

    context
        .read<ChangePasswordFormCubit>()
        .changePassword(changePasswordFormParams: _changePasswordFormParams);
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: Builder(builder: (context) {
        return Text(
          'Change Password',
          style: Theme.of(context).textTheme.headline5,
        );
      }),
    );
  }

  Widget _buildTitleSection() {
    return const Text('Enter a new password to update your previous password.');
  }

  Widget _buildNewPasswordTextField() {
    return TextFormField(
      controller: _newPasswordTextFieldController,
      keyboardType: TextInputType.phone,
      obscureText: _obscuredNewPassword,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        hintText: 'New password',
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _obscuredNewPassword = !_obscuredNewPassword;
            });
          },
          icon: Icon(
            _obscuredNewPassword
                ? Icons.visibility_rounded
                : Icons.visibility_off_rounded,
          ),
        ),
      ),
      validator: (value) {
        return _newPasswordTextFieldController.text.isEmpty
            ? 'New password is required!'
            : null;
      },
    );
  }

  Widget _buildConfirmPasswordTextField() {
    return TextFormField(
      controller: _confirmPasswordTextFieldController,
      keyboardType: TextInputType.phone,
      obscureText: _obscuredConfirmPassword,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        hintText: 'Confirm password',
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _obscuredConfirmPassword = !_obscuredConfirmPassword;
            });
          },
          icon: Icon(
            _obscuredConfirmPassword
                ? Icons.visibility_rounded
                : Icons.visibility_off_rounded,
          ),
        ),
      ),
      validator: (value) {
        if (_confirmPasswordTextFieldController.text.isEmpty) {
          return 'Confirm password is required!';
        }

        if (_confirmPasswordTextFieldController.text !=
            _newPasswordTextFieldController.text) {
          return 'Passwords do not match!';
        }

        return null;
      },
    );
  }

  Widget _buildChangePasswordButton() {
    return BlocConsumer<ChangePasswordFormCubit,
        BlocState<Failure<ExceptionMessage>, GenericResponseModel>>(
      listener: (context, state) {
        state.maybeMap(
          orElse: () => null,
          success: (state) {
            if (state.data.response) {
              ToastUtil.showToast(
                  '${state.data.message}. Please login to continue!');

              if (_source == ChangePasswordScreenSource.authentication) {
                // navigate to login-screen
                context.router.replaceAll([
                  const StartScreenRoute(),
                  const LoginScreenRoute(),
                ]);
              } else {
                context.router.pop();
              }
            } else {
              SnackBarUtil.snackbarError<String>(
                context,
                code: ExceptionCode.UNDEFINED,
                message: state.data.message,
              );
            }
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
        final _isLoading =
            state is Loading<Failure<ExceptionMessage>, GenericResponseModel>;

        return CustomButton(
          type: ButtonType.regularButton(
            onTap: () => _onChangePasswordButtonPressedCallback(),
            isLoadingMode: _isLoading,
            label: 'Change Password',
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: WidthConstraint(context).withHorizontalSymmetricalPadding(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomDivider(),
                  _buildTitleSection(),
                  SizedBox(height: (Sizing.kSizingMultiple * 2.5).h),
                  _buildNewPasswordTextField(),
                  SizedBox(height: (Sizing.kSizingMultiple * 1.5).h),
                  _buildConfirmPasswordTextField(),
                  SizedBox(height: (Sizing.kSizingMultiple * 6.75).h),
                  _buildChangePasswordButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
