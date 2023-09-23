import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:msmpusher/business/blocs/auth_blocs/get_authenticated_user_cubit/get_authenticated_user_cubit.dart';
import 'package:msmpusher/business/blocs/bloc_state.dart';
import 'package:msmpusher/core/constants.dart';
import 'package:msmpusher/core/dependence/dependence.dart';
import 'package:msmpusher/core/exceptions/exceptions.dart';
import 'package:msmpusher/core/route/app_router.dart';
import 'package:msmpusher/core/theme/custom_typography.dart';
import 'package:msmpusher/domain/model/models.dart';
import 'package:msmpusher/presentation/widget/widgets.dart';

class SplashScreen extends StatelessWidget implements AutoRouteWrapper {
  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider<GetAuthenticatedUserCubit>(
      create: (context) =>
          getIt<GetAuthenticatedUserCubit>()..getAuthenticatedUser(),
      child: this,
    );
  }

  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomTypography.kDarkPrimaryColor,
      body: BlocConsumer<GetAuthenticatedUserCubit,
          BlocState<Failure<ExceptionMessage>, UserInfoModel>>(
        listener: (context, state) {
          state.maybeMap(
            orElse: () => null,
            success: (state) async {
              await Future.delayed(
                  const Duration(seconds: Sizing.kSplashScreenDelay));
              if (state.data.response) {
                // navigate to tab-screen
                context.router.replaceAll([const TabScreenRoute()]);
              } else {
                context.router.replaceAll([const StartScreenRoute()]);
              }
            },
            error: (state) async {
              await Future.delayed(
                  const Duration(seconds: Sizing.kSplashScreenDelay));
              context.router.replaceAll([const StartScreenRoute()]);
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
              LoadingIndicator(
                type: LoadingIndicatorType.linearProgressIndicator(),
              ),
            ],
          );
        },
      ),
    );
  }
}
