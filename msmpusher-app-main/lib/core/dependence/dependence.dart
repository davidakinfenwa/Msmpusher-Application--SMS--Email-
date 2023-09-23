import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:msmpusher/core/dependence/account_dependence.dart';
import 'package:msmpusher/core/dependence/auth_dependence.dart';
import 'package:msmpusher/core/dependence/contact_dependence.dart';
import 'package:msmpusher/core/dependence/message_dependence.dart';
import 'package:msmpusher/core/dependence/sender_dependence.dart';
import 'package:msmpusher/core/exceptions/exceptions.dart';
import 'package:msmpusher/core/interceptors/interceptors.dart';
import 'package:msmpusher/core/network/network.dart';
import 'package:msmpusher/core/util/permission_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

GetIt getIt = GetIt.instance;

Future<void> initGetIt() async {
  authDependenciesInit(getIt);
  contactDependenciesInit(getIt);
  accountBalanceDependenciesInit(getIt);
  senderDependenciesInit(getIt);
  messageDependenciesInit(getIt);

  // shared

  // exception mapper
  getIt.registerLazySingleton<ExceptionMapper>(() => ExceptionMapper());

  final sharedPreference = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreference);

  // contact permissions
  getIt.registerLazySingleton<PermissionHelper>(() => PermissionHelper());

  // interceptors
  getIt.registerLazySingleton<LoggingInterceptors>(() => LoggingInterceptors());
  getIt.registerLazySingleton<HeaderInterceptors>(() => HeaderInterceptors());

  // internet checker
  getIt.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(connectionChecker: getIt()));
  getIt.registerLazySingleton<InternetConnectionChecker>(
      () => InternetConnectionChecker());
}
