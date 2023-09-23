import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:msmpusher/business/blocs/auth_blocs/resend_otp_code_form_cubit/resend_otp_code_form_cubit.dart';
import 'package:msmpusher/business/blocs/auth_blocs/signup_otp_verification_form_cubit/signup_otp_verification_form_cubit.dart';
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
import 'package:msmpusher/domain/model/shared/response_model.dart';
import 'package:msmpusher/presentation/widget/widgets.dart';

enum OtpVerificationScreenSource { login, signup }

class OtpVerificationScreen extends StatefulWidget implements AutoRouteWrapper {
  final OtpVerificationScreenSource source;

  const OtpVerificationScreen({
    Key? key,
    this.source = OtpVerificationScreenSource.signup,
  }) : super(key: key);

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SignupOtpVerificationFormCubit>(
          create: (context) => getIt<SignupOtpVerificationFormCubit>(),
        ),
        BlocProvider<ResendOtpCodeFormCubit>(
          create: (context) => getIt<ResendOtpCodeFormCubit>(),
        ),
      ],
      child: this,
    );
  }
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  Timer? _timer;
  int _currentSeconds = 0;
  final _interval = const Duration(seconds: 1);

  int get _timerMaxSeconds => Sizing.kOTPExpiryDuration;

  // represents where this screen is navigated from
  // OtpVerificationScreenSource get _source => widget.source;
  bool _shouldEnableResendOTPCodeButton = false;

  late FocusNode _otpVerificationCodeTextFieldFocusNode;
  late TextEditingController _otpVerificationCodeTextFieldController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _otpVerificationCodeTextFieldFocusNode = FocusNode();
    _otpVerificationCodeTextFieldController = TextEditingController();

    if (widget.source == OtpVerificationScreenSource.signup) {
      if (mounted) _startTimeout();

      setState(() {
        _shouldEnableResendOTPCodeButton = false;
      });
    } else {
      setState(() {
        _shouldEnableResendOTPCodeButton = true;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();

    _otpVerificationCodeTextFieldFocusNode.dispose();
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

    final _authenticatedUserInfo = context.read<AuthSnapshotCache>().userInfo;

    final _signupOtpVerificationFormParams = SignupOtpVerificationFormParams(
      uid: _authenticatedUserInfo.uid,
      otpCode: _otpVerificationCodeTextFieldController.text,
    );

    context.read<SignupOtpVerificationFormCubit>().verifyOTPCode(
        signupOtpVerificationFormParams: _signupOtpVerificationFormParams);
  }

  void _onResendOTPValidationCodeCallback() {
    final _authenticatedUserInfo = context.read<AuthSnapshotCache>().userInfo;

    final _resendOtpFormParams =
        ResendOtpFormParams(phoneNumber: _authenticatedUserInfo.phoneNumber);
    context
        .read<ResendOtpCodeFormCubit>()
        .resendOTPVerificationCode(resendOtpFormParams: _resendOtpFormParams);
  }

  Widget _buildTitleSection() {
    final _authenticatedUserInfo = context.watch<AuthSnapshotCache>().userInfo;

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
                text: _authenticatedUserInfo.phoneNumber,
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: CustomTypography.kPrimaryColor,
                    ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOtpVerificationProgressIndicator() {
    return BlocConsumer<
        SignupOtpVerificationFormCubit,
        BlocState<Failure<ExceptionMessage>,
            ResponseModel<GenericResponseModel>>>(
      listener: (context, state) {
        state.maybeMap(
          orElse: () => null,
          success: (state) {
            state.data.map(
              successResponse: (state) {
                // clear form inputs
                _formKey.currentState!.reset();

                context.router
                    .pushAll([const UserProfileInitializationScreenRoute()]);
              },
              errorResponse: (state) {
                SnackBarUtil.snackbarError<String>(
                  context,
                  showAction: true,
                  code: ExceptionCode.UNDEFINED,
                  message: state.data.message,
                  onRefreshCallback: () => _onOTPVerificationCallback(),
                );
              },
            );
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
      focusNode: _otpVerificationCodeTextFieldFocusNode,
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
    return BlocConsumer<ResendOtpCodeFormCubit,
        BlocState<Failure<ExceptionMessage>, GenericResponseModel>>(
      listener: (context, state) {
        state.maybeMap(
          orElse: () => null,
          success: (state) {
            if (state.data.response) {
              // TODO: fix bug with disabling button after resending otp-code
              // start timeout
              if (mounted) {
                setState(() {
                  _shouldEnableResendOTPCodeButton = false;
                  _startTimeout();
                });
              }

              ToastUtil.showToast('Sent otp-verification code!');
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
            onTap: () => _onResendOTPValidationCodeCallback(),
            isLoadingMode: _isLoading,
            label: 'Resend Verification Code',
            isDisabledMode: !_shouldEnableResendOTPCodeButton,
          ),
        );
      },
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

    final bool _isKeyboardVisible = KeyboardUtil.isKeyboardVisible(context);

    if (!_isKeyboardVisible) {
      // unfocus search-text field
      _otpVerificationCodeTextFieldFocusNode.unfocus();
    }

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
