import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:msmpusher/business/blocs/auth_blocs/signin_form_cubit/signin_form_cubit.dart';
import 'package:msmpusher/business/blocs/bloc_state.dart';
import 'package:msmpusher/core/constants.dart';
import 'package:msmpusher/core/dependence/dependence.dart';
import 'package:msmpusher/core/exceptions/exceptions.dart';
import 'package:msmpusher/core/route/app_router.dart';
import 'package:msmpusher/core/theme/custom_typography.dart';
import 'package:msmpusher/core/util/keyboard_util.dart';
import 'package:msmpusher/core/util/snackbar_util.dart';
import 'package:msmpusher/core/util/width_constraints.dart';
import 'package:msmpusher/domain/form_params/form_params.dart';
import 'package:msmpusher/domain/model/models.dart';
import 'package:msmpusher/presentation/screen/screens.dart';
import 'package:msmpusher/presentation/widget/widgets.dart';

class LoginScreen extends StatefulWidget implements AutoRouteWrapper {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SigninFormCubit>(),
      child: this,
    );
  }
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscuredPassword = true;
  late TapGestureRecognizer _tapRecognizer;

  late TextEditingController _phoneNumberTextFieldController;
  late TextEditingController _passwordTextFieldController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _tapRecognizer = TapGestureRecognizer()..onTap = _handlePress;

    _phoneNumberTextFieldController = TextEditingController();
    _passwordTextFieldController = TextEditingController();
  }

  @override
  void dispose() {
    _phoneNumberTextFieldController.dispose();
    _passwordTextFieldController.dispose();
    super.dispose();
  }

  void _handlePress() {
    HapticFeedback.vibrate();
    context.router.replace(const SignUpScreenRoute());
  }

  void _onUserSigninCallback() {
    KeyboardUtil.hideKeyboard(context);

    if (!_formKey.currentState!.validate()) return;

    final _signInFromParams = SignInFromParams(
      phoneNumber: _phoneNumberTextFieldController.text,
      password: _passwordTextFieldController.text,
    );
    context.read<SigninFormCubit>().signin(signInFromParams: _signInFromParams);
  }

  Widget _buildTopSection() {
    return Column(
      children: [
        Image.asset(
          'assets/logos/MSMNL_IC.png',
          width: Sizing.kSizingMultiple * 7.5,
        ),
        SizedBox(height: (Sizing.kSizingMultiple * 1.5).h),
        const Text('Sign into your account'),
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

  Widget _buildPasswordTextField() {
    return TextFormField(
      obscureText: _obscuredPassword,
      controller: _passwordTextFieldController,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        hintText: 'Password',
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _obscuredPassword = !_obscuredPassword;
            });
          },
          icon: Icon(
            _obscuredPassword
                ? Icons.visibility_rounded
                : Icons.visibility_off_rounded,
          ),
        ),
      ),
      validator: (value) {
        return _passwordTextFieldController.text.isEmpty
            ? 'Password is required!'
            : null;
      },
    );
  }

  Widget _buildForgotPasswordText() {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () {
          HapticFeedback.vibrate();
          context.router.push(const ForgotPasswordScreenRoute());
        },
        child: const Text('Forgot password'),
      ),
    );
  }

  Widget _buildFormSection() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildPhoneNumberTextField(),
          SizedBox(height: (Sizing.kSizingMultiple * 1.5).h),
          _buildPasswordTextField(),
          SizedBox(height: (Sizing.kSizingMultiple * 1.5).h),
          _buildForgotPasswordText(),
        ],
      ),
    );
  }

  Widget _buildSignInButton() {
    return BlocConsumer<SigninFormCubit,
        BlocState<Failure<ExceptionMessage>, UserInfoModel>>(
      listener: (context, state) {
        state.maybeMap(
          orElse: () => null,
          success: (state) {
            if (state.data.SIGN_IN_SUCCESSFUL) {
              // clear form inputs
              _formKey.currentState!.reset();

              context.router
                  .replaceAll([const UserProfileInitializationScreenRoute()]);
            } else if (state.data.VERIFY_ACCOUNT) {
              SnackBarUtil.snackbarError<String>(
                context,
                code: ExceptionCode.UNDEFINED,
                message: state.data.message,
              );

              context.router.replaceAll([
                OtpVerificationScreenRoute(
                    source: OtpVerificationScreenSource.login)
              ]);
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
            state is Loading<Failure<ExceptionMessage>, UserInfoModel>;

        return CustomButton(
          type: ButtonType.regularButton(
            onTap: () => _onUserSigninCallback(),
            label: 'Sign In',
            isLoadingMode: _isLoading,
          ),
        );
      },
    );
  }

  Widget _buildAuthModeSwitcherSection() {
    return Text.rich(
      TextSpan(
        text: 'Don\'t have an account?',
        children: [
          TextSpan(
            text: ' Sign Up',
            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: CustomTypography.kPrimaryColor,
                ),
            recognizer: _tapRecognizer,
          ),
        ],
        style: Theme.of(context).textTheme.bodyText2!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: WidthConstraint(context).withHorizontalSymmetricalPadding(
            child: Column(
              children: [
                _buildTopSection(),
                SizedBox(height: (Sizing.kSizingMultiple * 7).h),
                _buildFormSection(),
                SizedBox(height: (Sizing.kSizingMultiple * 5.25).h),
                _buildSignInButton(),
                SizedBox(height: (Sizing.kSizingMultiple * 8.125).h),
                _buildAuthModeSwitcherSection(),
                SizedBox(height: (Sizing.kSizingMultiple * 3).h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
