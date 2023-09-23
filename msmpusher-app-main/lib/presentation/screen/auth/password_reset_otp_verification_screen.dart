import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:msmpusher/business/blocs/auth_blocs/forgot_password_otp_verification_form_cubit/forgot_password_otp_verification_form_cubit.dart';
import 'package:msmpusher/business/blocs/bloc_state.dart';
import 'package:msmpusher/business/snapshot_cache/snapshot_cache.dart';
import 'package:msmpusher/core/constants.dart';
import 'package:msmpusher/core/dependence/dependence.dart';
import 'package:msmpusher/core/exceptions/exceptions.dart';
import 'package:msmpusher/core/route/app_router.dart';
import 'package:msmpusher/core/theme/custom_typography.dart';
import 'package:msmpusher/core/util/keyboard_util.dart';
import 'package:msmpusher/core/util/snackbar_util.dart';
import 'package:msmpusher/core/util/toast_util.dart';
import 'package:msmpusher/core/util/width_constraints.dart';
import 'package:msmpusher/domain/form_params/form_params.dart';
import 'package:msmpusher/domain/model/models.dart';
import 'package:msmpusher/presentation/widget/widgets.dart';

class PasswordResetOTPVerificationScreen extends StatefulWidget
    implements AutoRouteWrapper {
  const PasswordResetOTPVerificationScreen({Key? key}) : super(key: key);

  @override
  State<PasswordResetOTPVerificationScreen> createState() =>
      _PasswordResetOTPVerificationScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider<ForgotPasswordOtpVerificationFormCubit>(
      create: (context) => getIt<ForgotPasswordOtpVerificationFormCubit>(),
      child: this,
    );
  }
}

class _PasswordResetOTPVerificationScreenState
    extends State<PasswordResetOTPVerificationScreen> {
  Timer? _timer;
  int _currentSeconds = 0;
  final _interval = const Duration(seconds: 1);

  int get _timerMaxSeconds => Sizing.kOTPExpiryDuration;

  // should enable or disable resend-otp button
  bool _shouldEnableResendOTPCodeButton = false;

  // late FocusNode _otpVerificationCodeTextFieldFocusNode;
  late TextEditingController _otpVerificationCodeTextFieldController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    // _otpVerificationCodeTextFieldFocusNode = FocusNode();
    _otpVerificationCodeTextFieldController = TextEditingController();

    if (mounted) _startTimeout();
  }

  @override
  void dispose() {
    _timer?.cancel();

    // _otpVerificationCodeTextFieldFocusNode.dispose();
    _otpVerificationCodeTextFieldController.dispose();
    super.dispose();
  }

  String get _timerText =>
      '${((_timerMaxSeconds - _currentSeconds) ~/ 60).toString().padLeft(2, '0')}: ${((_timerMaxSeconds - _currentSeconds) % 60).toString().padLeft(2, '0')}';

  void _startTimeout() {
    final _duration = _interval;
    _timer = Timer.periodic(_duration, (timer) {
      setState(() {
        _currentSeconds = timer.tick;

        if (timer.tick >= _timerMaxSeconds) timer.cancel();
      });
    });
  }

  void _showOrHideResendOTPVerificationCodeButton() {
    if (_currentSeconds >= _timerMaxSeconds) {
      setState(() {
        _shouldEnableResendOTPCodeButton = true;
      });
    }
  }

  void _onOTPVerificationCallback() {
    KeyboardUtil.hideKeyboard(context);

    if (!_formKey.currentState!.validate()) return;

    ToastUtil.showToast('Verifying Code! Please wait...');

    final _forgotPasswordPhoneNumber =
        context.read<AuthSnapshotCache>().forgotPasswordPhoneNumber;

    final _forgotPasswordOtpVerificationFormParams =
        ForgotPasswordOtpVerificationFormParams(
      phoneNumber: _forgotPasswordPhoneNumber!,
      otpCode: _otpVerificationCodeTextFieldController.text,
    );

    context
        .read<ForgotPasswordOtpVerificationFormCubit>()
        .verifyForgotPasswordOTPCode(
          forgotPasswordOtpVerificationFormParams:
              _forgotPasswordOtpVerificationFormParams,
        );
  }

  Widget _buildTitleSection() {
    final _forgotPasswordPhoneNumber =
        context.watch<AuthSnapshotCache>().forgotPasswordPhoneNumber;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Account Verification',
          style: Theme.of(context).textTheme.headline5,
        ),
        SizedBox(height: Sizing.kSizingMultiple.h),
        Text.rich(
          TextSpan(
            text:
                'Please enter the ${Sizing.kOTPCodeLength} digit verification code we sent to you on ',
            children: [
              TextSpan(
                text: _forgotPasswordPhoneNumber,
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: CustomTypography.kPrimaryColor,
                    ),
              ),
              const TextSpan(text: 'to continue')
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOtpVerificationProgressIndicator() {
    return BlocConsumer<ForgotPasswordOtpVerificationFormCubit,
        BlocState<Failure<ExceptionMessage>, GenericResponseModel>>(
      listener: (context, state) {
        state.maybeMap(
          orElse: () => null,
          success: (state) {
            if (state.data.response) {
              // clear form inputs
              _formKey.currentState!.reset();

              context.router.pushAll([ChangePasswordScreenRoute()]);
            } else {
              SnackBarUtil.snackbarError<String>(
                context,
                showAction: true,
                code: ExceptionCode.UNDEFINED,
                message: state.data.message,
                onRefreshCallback: () => _onOTPVerificationCallback(),
              );
            }
          },
          error: (state) {
            SnackBarUtil.snackbarError<String>(
              context,
              showAction: true,
              code: state.failure.exception.code,
              message: state.failure.exception.message.toString(),
              onRefreshCallback: () => _onOTPVerificationCallback(),
            );
          },
        );
      },
      builder: (context, state) {
        return state.maybeMap(
          orElse: () => const Icon(Icons.arrow_right_alt_rounded),
          loading: (_) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                LoadingIndicator(
                  type: LoadingIndicatorType.circularProgressIndicator(
                    isSmallSize: true,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildOtpVerificationCodeTextField() {
    return TextFormField(
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      textAlignVertical: TextAlignVertical.center,
      // focusNode: _otpVerificationCodeTextFieldFocusNode,
      controller: _otpVerificationCodeTextFieldController,
      decoration: InputDecoration(
        hintText: 'Enter OTP Verification Code',
        suffixIcon: _buildOtpVerificationProgressIndicator(),
      ),
      onChanged: (value) {
        if (value.length == Sizing.kOTPCodeLength) {
          _onOTPVerificationCallback();
        }
      },
      validator: (value) {
        return _otpVerificationCodeTextFieldController.text.isEmpty
            ? 'OTP Verification Code is required!'
            : null;
      },
    );
  }

  Widget _buildResendVerificationCode() {
    return CustomButton(
      type: ButtonType.regularButton(
        onTap: () {
          context.router.replace(const ForgotPasswordScreenRoute());
        },
        label: 'Resend Verification Code',
        isDisabledMode: !_shouldEnableResendOTPCodeButton,
      ),
    );
  }

  Widget _buildResendCodeTimerDuration() {
    return Text.rich(
      TextSpan(
        text: 'Resend Code in ',
        children: [
          TextSpan(
            text: '$_timerText sec(s)',
            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: CustomTypography.kPrimaryColor,
                ),
          ),
        ],
        style: Theme.of(context).textTheme.bodyText2!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // show or hide resend-otp button
    _showOrHideResendOTPVerificationCodeButton();

    // final bool _isKeyboardVisible = KeyboardUtil.isKeyboardVisible(context);

    // if (!_isKeyboardVisible) {
    //   // unfocus search-text field
    //   _otpVerificationCodeTextFieldFocusNode.unfocus();
    // }

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
                  _buildOtpVerificationCodeTextField(),
                  SizedBox(height: (Sizing.kSizingMultiple * 3.75).h),
                  _buildResendVerificationCode(),
                  SizedBox(height: (Sizing.kSizingMultiple * 8.125).h),
                  if (!_shouldEnableResendOTPCodeButton) ...[
                    _buildResendCodeTimerDuration(),
                  ]
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
