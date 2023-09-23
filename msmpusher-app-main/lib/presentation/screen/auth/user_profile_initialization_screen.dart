import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:msmpusher/business/blocs/auth_blocs/get_user_profile_cubit/get_user_profile_cubit.dart';
import 'package:msmpusher/business/blocs/auth_blocs/signout_form_cubit/signout_form_cubit.dart';
import 'package:msmpusher/business/blocs/bloc_state.dart';
import 'package:msmpusher/core/constants.dart';
import 'package:msmpusher/core/dependence/dependence.dart';
import 'package:msmpusher/core/exceptions/exceptions.dart';
import 'package:msmpusher/core/route/app_router.dart';
import 'package:msmpusher/core/theme/custom_typography.dart';
import 'package:msmpusher/core/util/toast_util.dart';
import 'package:msmpusher/core/util/unit_impl.dart';
import 'package:msmpusher/domain/model/models.dart';
import 'package:msmpusher/presentation/widget/widgets.dart';

class UserProfileInitializationScreen extends StatelessWidget
    implements AutoRouteWrapper {
  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GetUserProfileCubit>(
          create: (context) => getIt<GetUserProfileCubit>()..getUserProfile(),
        ),
        BlocProvider<SignoutFormCubit>(
          create: (context) => getIt<SignoutFormCubit>(),
        ),
      ],
      child: this,
    );
  }

  const UserProfileInitializationScreen({Key? key}) : super(key: key);

  Widget _buildSignoutButton() {
    return BlocConsumer<SignoutFormCubit,
        BlocState<Failure<ExceptionMessage>, UnitImpl>>(
      listener: (context, state) {
        state.maybeMap(
          orElse: () => null,
          success: (_) {
            context.router.replaceAll([
              const LoginScreenRoute(),
            ]);
          },
        );
      },
      builder: (context, state) {
        final _isLoading =
            state is Loading<Failure<ExceptionMessage>, UnitImpl>;

        return CustomButton(
          type: ButtonType.withBorderButton(
            onTap: () {
              HapticFeedback.vibrate();

              context.read<SignoutFormCubit>().signout();
            },
            label: 'Signout',
            isLoadingMode: _isLoading,
            textColor: CustomTypography.kBlackColor,
            borderColor: CustomTypography.kBlackColor,
          ),
        );
      },
    );
  }

  Widget _buildErrorIndicator(
      Error<Failure<ExceptionMessage>, UserInfoModel> state) {
    return Builder(builder: (context) {
      return ErrorIndicator(
        backgroundColor: CustomTypography.kLightGreyColor,
        type: ErrorIndicatorType.custom(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                state.failure.exception.code.toString(),
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Text(
                state.failure.exception.message.toString(),
              ),
              SizedBox(height: (Sizing.kSizingMultiple * 2).h),
              Row(
                children: [
                  Flexible(
                    child: _buildSignoutButton(),
                  ),
                  SizedBox(width: (Sizing.kSizingMultiple * 2).w),
                  Flexible(
                    child: CustomButton(
                      type: ButtonType.regularButton(
                        onTap: () {
                          HapticFeedback.vibrate();
                          context.read<GetUserProfileCubit>().getUserProfile();
                        },
                        label: 'Try Again',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildErrorOrInfoIndicator(
      {required BlocState<Failure<ExceptionMessage>, UserInfoModel> state}) {
    return state.maybeMap(
      orElse: () => Column(
        children: [
          Row(
            children: const [
              Expanded(
                child: InfoIndicator(
                  label: 'Initializing user-profile information...',
                ),
              ),
            ],
          ),
          LoadingIndicator(
              type: LoadingIndicatorType.linearProgressIndicator()),
        ],
      ),
      success: (state) {
        // handle case if successful and response is false
        if (!state.data.response) {
          const _exception = ExceptionType<ExceptionMessage>.platformsException(
            code: ExceptionCode.NOT_FOUND,
            message: ExceptionMessage.NOT_FOUND,
          );

          const _state =
              BlocState<Failure<ExceptionMessage>, UserInfoModel>.error(
            failure: Failure.serverFailure(exception: _exception),
          );

          return _buildErrorIndicator(
              _state as Error<Failure<ExceptionMessage>, UserInfoModel>);
        }

        return Container();
      },
      error: (state) => _buildErrorIndicator(state),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomTypography.kDarkPrimaryColor,
      body: BlocConsumer<GetUserProfileCubit,
          BlocState<Failure<ExceptionMessage>, UserInfoModel>>(
        listener: (context, state) {
          state.maybeMap(
            orElse: () => null,
            success: (state) async {
              if (state.data.response) {
                // navigate to tab-screen
                context.router.replaceAll([const TabScreenRoute()]);
              } else {
                ToastUtil.showToast('Could not get user profile!');
              }
            },
          );
        },
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: Center(
                  child: Image.asset(
                    'assets/logos/logo-new.png',
                    width: (Sizing.kSizingMultiple * 30).w,
                  ),
                ),
              ),
              _buildErrorOrInfoIndicator(state: state),
            ],
          );
        },
      ),
    );
  }
}
