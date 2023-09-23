import 'package:get_it/get_it.dart';
import 'package:msmpusher/business/blocs/auth_blocs/change_password_form_cubit/change_password_form_cubit.dart';
import 'package:msmpusher/business/blocs/auth_blocs/forgot_password_form_cubit/forgot_password_form_cubit.dart';
import 'package:msmpusher/business/blocs/auth_blocs/forgot_password_otp_verification_form_cubit/forgot_password_otp_verification_form_cubit.dart';
import 'package:msmpusher/business/blocs/auth_blocs/get_authenticated_user_cubit/get_authenticated_user_cubit.dart';
import 'package:msmpusher/business/blocs/auth_blocs/get_user_profile_cubit/get_user_profile_cubit.dart';
import 'package:msmpusher/business/blocs/auth_blocs/resend_otp_code_form_cubit/resend_otp_code_form_cubit.dart';
import 'package:msmpusher/business/blocs/auth_blocs/signin_form_cubit/signin_form_cubit.dart';
import 'package:msmpusher/business/blocs/auth_blocs/signout_form_cubit/signout_form_cubit.dart';
import 'package:msmpusher/business/blocs/auth_blocs/signup_form_cubit/signup_form_cubit.dart';
import 'package:msmpusher/business/blocs/auth_blocs/signup_otp_verification_form_cubit/signup_otp_verification_form_cubit.dart';
import 'package:msmpusher/business/snapshot_cache/snapshot_cache.dart';
import 'package:msmpusher/data/datasources/datasources.dart';
import 'package:msmpusher/data/repository_impl/auth_repository_impl.dart';
import 'package:msmpusher/domain/repositories/repositories.dart';

void authDependenciesInit(GetIt getIt) {
  // controllers
  getIt.registerFactory<GetAuthenticatedUserCubit>(() =>
      GetAuthenticatedUserCubit(repository: getIt(), snapshotCache: getIt()));
  getIt.registerFactory<SignupFormCubit>(
      () => SignupFormCubit(repository: getIt(), snapshotCache: getIt()));
  getIt.registerFactory<SigninFormCubit>(
      () => SigninFormCubit(repository: getIt(), snapshotCache: getIt()));
  getIt.registerFactory<GetUserProfileCubit>(
      () => GetUserProfileCubit(repository: getIt(), snapshotCache: getIt()));
  getIt.registerFactory<ForgotPasswordFormCubit>(() =>
      ForgotPasswordFormCubit(repository: getIt(), snapshotCache: getIt()));
  getIt.registerFactory<ForgotPasswordOtpVerificationFormCubit>(
      () => ForgotPasswordOtpVerificationFormCubit(repository: getIt()));
  getIt.registerFactory<ChangePasswordFormCubit>(
      () => ChangePasswordFormCubit(repository: getIt()));
  getIt.registerFactory<SignupOtpVerificationFormCubit>(
      () => SignupOtpVerificationFormCubit(repository: getIt()));
  getIt.registerFactory<ResendOtpCodeFormCubit>(
      () => ResendOtpCodeFormCubit(repository: getIt()));
  getIt.registerFactory<SignoutFormCubit>(
      () => SignoutFormCubit(repository: getIt()));

  // snapshot caches
  getIt.registerLazySingleton<AuthSnapshotCache>(() => AuthSnapshotCache());

  // repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      networkInfo: getIt(),
      localDataSource: getIt(),
      remoteDataSource: getIt(),
    ),
  );

  // data sources
  getIt.registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(storage: getIt()));

  getIt.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(exceptionMapper: getIt()));
}
