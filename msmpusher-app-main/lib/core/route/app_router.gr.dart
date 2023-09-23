// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

part of 'app_router.dart';

class _$AppRouter extends RootStackRouter {
  _$AppRouter([GlobalKey<NavigatorState>? navigatorKey]) : super(navigatorKey);

  @override
  final Map<String, PageFactory> pagesMap = {
    SplashScreenRoute.name: (routeData) {
      return CustomPage<dynamic>(
          routeData: routeData,
          child: const SplashScreen(),
          transitionsBuilder: TransitionsBuilders.fadeIn,
          durationInMilliseconds: 300,
          opaque: true,
          barrierDismissible: false);
    },
    StartScreenRoute.name: (routeData) {
      return CustomPage<dynamic>(
          routeData: routeData,
          child: const StartScreen(),
          transitionsBuilder: TransitionsBuilders.fadeIn,
          durationInMilliseconds: 300,
          opaque: true,
          barrierDismissible: false);
    },
    LoginScreenRoute.name: (routeData) {
      return CustomPage<dynamic>(
          routeData: routeData,
          child: const LoginScreen(),
          transitionsBuilder: TransitionsBuilders.fadeIn,
          durationInMilliseconds: 300,
          opaque: true,
          barrierDismissible: false);
    },
    SignUpScreenRoute.name: (routeData) {
      return CustomPage<dynamic>(
          routeData: routeData,
          child: const SignUpScreen(),
          transitionsBuilder: TransitionsBuilders.fadeIn,
          durationInMilliseconds: 300,
          opaque: true,
          barrierDismissible: false);
    },
    UserProfileInitializationScreenRoute.name: (routeData) {
      return CustomPage<dynamic>(
          routeData: routeData,
          child: const UserProfileInitializationScreen(),
          transitionsBuilder: TransitionsBuilders.fadeIn,
          durationInMilliseconds: 300,
          opaque: true,
          barrierDismissible: false);
    },
    OtpVerificationScreenRoute.name: (routeData) {
      final args = routeData.argsAs<OtpVerificationScreenRouteArgs>(
          orElse: () => const OtpVerificationScreenRouteArgs());
      return CustomPage<dynamic>(
          routeData: routeData,
          child: OtpVerificationScreen(key: args.key, source: args.source),
          transitionsBuilder: TransitionsBuilders.fadeIn,
          durationInMilliseconds: 300,
          opaque: true,
          barrierDismissible: false);
    },
    ForgotPasswordScreenRoute.name: (routeData) {
      return CustomPage<dynamic>(
          routeData: routeData,
          child: const ForgotPasswordScreen(),
          transitionsBuilder: TransitionsBuilders.fadeIn,
          durationInMilliseconds: 300,
          opaque: true,
          barrierDismissible: false);
    },
    PasswordResetOTPVerificationScreenRoute.name: (routeData) {
      return CustomPage<dynamic>(
          routeData: routeData,
          child: const PasswordResetOTPVerificationScreen(),
          transitionsBuilder: TransitionsBuilders.fadeIn,
          durationInMilliseconds: 300,
          opaque: true,
          barrierDismissible: false);
    },
    ChangePasswordScreenRoute.name: (routeData) {
      final args = routeData.argsAs<ChangePasswordScreenRouteArgs>(
          orElse: () => const ChangePasswordScreenRouteArgs());
      return CustomPage<dynamic>(
          routeData: routeData,
          child: ChangePasswordScreen(key: args.key, source: args.source),
          transitionsBuilder: TransitionsBuilders.fadeIn,
          durationInMilliseconds: 300,
          opaque: true,
          barrierDismissible: false);
    },
    TabScreenRoute.name: (routeData) {
      return CustomPage<dynamic>(
          routeData: routeData,
          child: const TabScreen(),
          transitionsBuilder: TransitionsBuilders.fadeIn,
          durationInMilliseconds: 300,
          opaque: true,
          barrierDismissible: false);
    },
    UserAccountScreenRoute.name: (routeData) {
      return CustomPage<dynamic>(
          routeData: routeData,
          child: const UserAccountScreen(),
          transitionsBuilder: TransitionsBuilders.fadeIn,
          durationInMilliseconds: 300,
          opaque: true,
          barrierDismissible: false);
    },
    ChangePhoneNumberScreenRoute.name: (routeData) {
      return CustomPage<dynamic>(
          routeData: routeData,
          child: const ChangePhoneNumberScreen(),
          transitionsBuilder: TransitionsBuilders.fadeIn,
          durationInMilliseconds: 300,
          opaque: true,
          barrierDismissible: false);
    },
    SecurityScreenRoute.name: (routeData) {
      return CustomPage<dynamic>(
          routeData: routeData,
          child: const SecurityScreen(),
          transitionsBuilder: TransitionsBuilders.fadeIn,
          durationInMilliseconds: 300,
          opaque: true,
          barrierDismissible: false);
    },
    ProfileUpdateScreenRoute.name: (routeData) {
      return CustomPage<dynamic>(
          routeData: routeData,
          child: const ProfileUpdateScreen(),
          transitionsBuilder: TransitionsBuilders.fadeIn,
          durationInMilliseconds: 300,
          opaque: true,
          barrierDismissible: false);
    },
    ContactScreenRoute.name: (routeData) {
      final args = routeData.argsAs<ContactScreenRouteArgs>();
      return CustomPage<dynamic>(
          routeData: routeData,
          child: ContactScreen(key: args.key, source: args.source),
          transitionsBuilder: TransitionsBuilders.fadeIn,
          durationInMilliseconds: 300,
          opaque: true,
          barrierDismissible: false);
    },
    TransactionDetailScreenRoute.name: (routeData) {
      return CustomPage<dynamic>(
          routeData: routeData,
          child: const TransactionDetailScreen(),
          transitionsBuilder: TransitionsBuilders.fadeIn,
          durationInMilliseconds: 300,
          opaque: true,
          barrierDismissible: false);
    },
    ReportScreenRoute.name: (routeData) {
      return CustomPage<dynamic>(
          routeData: routeData,
          child: const ReportScreen(),
          transitionsBuilder: TransitionsBuilders.fadeIn,
          durationInMilliseconds: 300,
          opaque: true,
          barrierDismissible: false);
    },
    SenderIdScreenRoute.name: (routeData) {
      return CustomPage<dynamic>(
          routeData: routeData,
          child: const SenderIdScreen(),
          transitionsBuilder: TransitionsBuilders.fadeIn,
          durationInMilliseconds: 300,
          opaque: true,
          barrierDismissible: false);
    },
    TopUpWizardScreenRoute.name: (routeData) {
      return CustomPage<dynamic>(
          routeData: routeData,
          child: const TopUpWizardScreen(),
          transitionsBuilder: TransitionsBuilders.fadeIn,
          durationInMilliseconds: 300,
          opaque: true,
          barrierDismissible: false);
    },
    ImportIntroScreenRoute.name: (routeData) {
      return CustomPage<dynamic>(
          routeData: routeData,
          child: const ImportIntroScreen(),
          transitionsBuilder: TransitionsBuilders.fadeIn,
          durationInMilliseconds: 300,
          opaque: true,
          barrierDismissible: false);
    },
    FileContactsViewScreenRoute.name: (routeData) {
      return CustomPage<dynamic>(
          routeData: routeData,
          child: const FileContactsViewScreen(),
          transitionsBuilder: TransitionsBuilders.fadeIn,
          durationInMilliseconds: 300,
          opaque: true,
          barrierDismissible: false);
    }
  };

  @override
  List<RouteConfig> get routes => [
        RouteConfig(SplashScreenRoute.name, path: '/'),
        RouteConfig(StartScreenRoute.name, path: '/start-screen'),
        RouteConfig(LoginScreenRoute.name, path: '/login-screen'),
        RouteConfig(SignUpScreenRoute.name, path: '/sign-up-screen'),
        RouteConfig(UserProfileInitializationScreenRoute.name,
            path: '/user-profile-initialization-screen'),
        RouteConfig(OtpVerificationScreenRoute.name,
            path: '/otp-verification-screen'),
        RouteConfig(ForgotPasswordScreenRoute.name,
            path: '/forgot-password-screen'),
        RouteConfig(PasswordResetOTPVerificationScreenRoute.name,
            path: '/password-reset-ot-pverification-screen'),
        RouteConfig(ChangePasswordScreenRoute.name,
            path: '/change-password-screen'),
        RouteConfig(TabScreenRoute.name, path: '/tab-screen'),
        RouteConfig(UserAccountScreenRoute.name, path: '/user-account-screen'),
        RouteConfig(ChangePhoneNumberScreenRoute.name,
            path: '/change-phone-number-screen'),
        RouteConfig(SecurityScreenRoute.name, path: '/security-screen'),
        RouteConfig(ProfileUpdateScreenRoute.name,
            path: '/profile-update-screen'),
        RouteConfig(ContactScreenRoute.name, path: '/contact-screen'),
        RouteConfig(TransactionDetailScreenRoute.name,
            path: '/transaction-detail-screen'),
        RouteConfig(ReportScreenRoute.name, path: '/report-screen'),
        RouteConfig(SenderIdScreenRoute.name, path: '/sender-id-screen'),
        RouteConfig(TopUpWizardScreenRoute.name, path: '/top-up-wizard-screen'),
        RouteConfig(ImportIntroScreenRoute.name, path: '/import-intro-screen'),
        RouteConfig(FileContactsViewScreenRoute.name,
            path: '/file-contacts-view-screen')
      ];
}

/// generated route for
/// [SplashScreen]
class SplashScreenRoute extends PageRouteInfo<void> {
  const SplashScreenRoute() : super(SplashScreenRoute.name, path: '/');

  static const String name = 'SplashScreenRoute';
}

/// generated route for
/// [StartScreen]
class StartScreenRoute extends PageRouteInfo<void> {
  const StartScreenRoute()
      : super(StartScreenRoute.name, path: '/start-screen');

  static const String name = 'StartScreenRoute';
}

/// generated route for
/// [LoginScreen]
class LoginScreenRoute extends PageRouteInfo<void> {
  const LoginScreenRoute()
      : super(LoginScreenRoute.name, path: '/login-screen');

  static const String name = 'LoginScreenRoute';
}

/// generated route for
/// [SignUpScreen]
class SignUpScreenRoute extends PageRouteInfo<void> {
  const SignUpScreenRoute()
      : super(SignUpScreenRoute.name, path: '/sign-up-screen');

  static const String name = 'SignUpScreenRoute';
}

/// generated route for
/// [UserProfileInitializationScreen]
class UserProfileInitializationScreenRoute extends PageRouteInfo<void> {
  const UserProfileInitializationScreenRoute()
      : super(UserProfileInitializationScreenRoute.name,
            path: '/user-profile-initialization-screen');

  static const String name = 'UserProfileInitializationScreenRoute';
}

/// generated route for
/// [OtpVerificationScreen]
class OtpVerificationScreenRoute
    extends PageRouteInfo<OtpVerificationScreenRouteArgs> {
  OtpVerificationScreenRoute(
      {Key? key,
      OtpVerificationScreenSource source = OtpVerificationScreenSource.signup})
      : super(OtpVerificationScreenRoute.name,
            path: '/otp-verification-screen',
            args: OtpVerificationScreenRouteArgs(key: key, source: source));

  static const String name = 'OtpVerificationScreenRoute';
}

class OtpVerificationScreenRouteArgs {
  const OtpVerificationScreenRouteArgs(
      {this.key, this.source = OtpVerificationScreenSource.signup});

  final Key? key;

  final OtpVerificationScreenSource source;

  @override
  String toString() {
    return 'OtpVerificationScreenRouteArgs{key: $key, source: $source}';
  }
}

/// generated route for
/// [ForgotPasswordScreen]
class ForgotPasswordScreenRoute extends PageRouteInfo<void> {
  const ForgotPasswordScreenRoute()
      : super(ForgotPasswordScreenRoute.name, path: '/forgot-password-screen');

  static const String name = 'ForgotPasswordScreenRoute';
}

/// generated route for
/// [PasswordResetOTPVerificationScreen]
class PasswordResetOTPVerificationScreenRoute extends PageRouteInfo<void> {
  const PasswordResetOTPVerificationScreenRoute()
      : super(PasswordResetOTPVerificationScreenRoute.name,
            path: '/password-reset-ot-pverification-screen');

  static const String name = 'PasswordResetOTPVerificationScreenRoute';
}

/// generated route for
/// [ChangePasswordScreen]
class ChangePasswordScreenRoute
    extends PageRouteInfo<ChangePasswordScreenRouteArgs> {
  ChangePasswordScreenRoute(
      {Key? key,
      ChangePasswordScreenSource source =
          ChangePasswordScreenSource.authentication})
      : super(ChangePasswordScreenRoute.name,
            path: '/change-password-screen',
            args: ChangePasswordScreenRouteArgs(key: key, source: source));

  static const String name = 'ChangePasswordScreenRoute';
}

class ChangePasswordScreenRouteArgs {
  const ChangePasswordScreenRouteArgs(
      {this.key, this.source = ChangePasswordScreenSource.authentication});

  final Key? key;

  final ChangePasswordScreenSource source;

  @override
  String toString() {
    return 'ChangePasswordScreenRouteArgs{key: $key, source: $source}';
  }
}

/// generated route for
/// [TabScreen]
class TabScreenRoute extends PageRouteInfo<void> {
  const TabScreenRoute() : super(TabScreenRoute.name, path: '/tab-screen');

  static const String name = 'TabScreenRoute';
}

/// generated route for
/// [UserAccountScreen]
class UserAccountScreenRoute extends PageRouteInfo<void> {
  const UserAccountScreenRoute()
      : super(UserAccountScreenRoute.name, path: '/user-account-screen');

  static const String name = 'UserAccountScreenRoute';
}

/// generated route for
/// [ChangePhoneNumberScreen]
class ChangePhoneNumberScreenRoute extends PageRouteInfo<void> {
  const ChangePhoneNumberScreenRoute()
      : super(ChangePhoneNumberScreenRoute.name,
            path: '/change-phone-number-screen');

  static const String name = 'ChangePhoneNumberScreenRoute';
}

/// generated route for
/// [SecurityScreen]
class SecurityScreenRoute extends PageRouteInfo<void> {
  const SecurityScreenRoute()
      : super(SecurityScreenRoute.name, path: '/security-screen');

  static const String name = 'SecurityScreenRoute';
}

/// generated route for
/// [ProfileUpdateScreen]
class ProfileUpdateScreenRoute extends PageRouteInfo<void> {
  const ProfileUpdateScreenRoute()
      : super(ProfileUpdateScreenRoute.name, path: '/profile-update-screen');

  static const String name = 'ProfileUpdateScreenRoute';
}

/// generated route for
/// [ContactScreen]
class ContactScreenRoute extends PageRouteInfo<ContactScreenRouteArgs> {
  ContactScreenRoute({Key? key, required ContactRequestSource source})
      : super(ContactScreenRoute.name,
            path: '/contact-screen',
            args: ContactScreenRouteArgs(key: key, source: source));

  static const String name = 'ContactScreenRoute';
}

class ContactScreenRouteArgs {
  const ContactScreenRouteArgs({this.key, required this.source});

  final Key? key;

  final ContactRequestSource source;

  @override
  String toString() {
    return 'ContactScreenRouteArgs{key: $key, source: $source}';
  }
}

/// generated route for
/// [TransactionDetailScreen]
class TransactionDetailScreenRoute extends PageRouteInfo<void> {
  const TransactionDetailScreenRoute()
      : super(TransactionDetailScreenRoute.name,
            path: '/transaction-detail-screen');

  static const String name = 'TransactionDetailScreenRoute';
}

/// generated route for
/// [ReportScreen]
class ReportScreenRoute extends PageRouteInfo<void> {
  const ReportScreenRoute()
      : super(ReportScreenRoute.name, path: '/report-screen');

  static const String name = 'ReportScreenRoute';
}

/// generated route for
/// [SenderIdScreen]
class SenderIdScreenRoute extends PageRouteInfo<void> {
  const SenderIdScreenRoute()
      : super(SenderIdScreenRoute.name, path: '/sender-id-screen');

  static const String name = 'SenderIdScreenRoute';
}

/// generated route for
/// [TopUpWizardScreen]
class TopUpWizardScreenRoute extends PageRouteInfo<void> {
  const TopUpWizardScreenRoute()
      : super(TopUpWizardScreenRoute.name, path: '/top-up-wizard-screen');

  static const String name = 'TopUpWizardScreenRoute';
}

/// generated route for
/// [ImportIntroScreen]
class ImportIntroScreenRoute extends PageRouteInfo<void> {
  const ImportIntroScreenRoute()
      : super(ImportIntroScreenRoute.name, path: '/import-intro-screen');

  static const String name = 'ImportIntroScreenRoute';
}

/// generated route for
/// [FileContactsViewScreen]
class FileContactsViewScreenRoute extends PageRouteInfo<void> {
  const FileContactsViewScreenRoute()
      : super(FileContactsViewScreenRoute.name,
            path: '/file-contacts-view-screen');

  static const String name = 'FileContactsViewScreenRoute';
}
