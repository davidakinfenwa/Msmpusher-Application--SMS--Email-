import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:msmpusher/core/constants.dart';
import 'package:msmpusher/presentation/screen/screens.dart';
import 'package:msmpusher/presentation/screen/tab_screens/tab_screen.dart';
import 'package:msmpusher/presentation/widget/shared/contacts_view.dart';

part 'app_router.gr.dart';

@CustomAutoRouter(
  // replaceInRouteName: 'Screen,Route',
  transitionsBuilder: TransitionsBuilders.fadeIn,
  durationInMilliseconds: TimeDuration.kAnimationDuration,
  routes: <AutoRoute>[
    AutoRoute(page: SplashScreen, initial: true),
    AutoRoute(page: StartScreen),
    AutoRoute(page: LoginScreen),
    AutoRoute(page: SignUpScreen),
    AutoRoute(page: UserProfileInitializationScreen),
    AutoRoute(page: OtpVerificationScreen),
    AutoRoute(page: ForgotPasswordScreen),
    AutoRoute(page: PasswordResetOTPVerificationScreen),
    AutoRoute(page: ChangePasswordScreen),
    AutoRoute(page: TabScreen),
    AutoRoute(page: UserAccountScreen),
    AutoRoute(page: ChangePhoneNumberScreen),
    AutoRoute(page: SecurityScreen),
    AutoRoute(page: ProfileUpdateScreen),
    AutoRoute(page: ContactScreen),
    AutoRoute(page: TransactionDetailScreen),
    AutoRoute(page: ReportScreen),
    AutoRoute(page: SenderIdScreen),
    AutoRoute(page: TopUpWizardScreen),
    AutoRoute(page: ImportIntroScreen),
    AutoRoute(page: FileContactsViewScreen),
  ],
)
class AppRouter extends _$AppRouter {}
