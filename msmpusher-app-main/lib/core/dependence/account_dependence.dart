import 'package:get_it/get_it.dart';
import 'package:msmpusher/business/blocs/account_blocs/get_account_balance_cubit/get_account_balance_cubit.dart';
import 'package:msmpusher/business/blocs/account_blocs/get_account_metrics_cubit/get_account_metrics_cubit.dart';
import 'package:msmpusher/business/snapshot_cache/snapshot_cache.dart';
import 'package:msmpusher/data/datasources/datasources.dart';
import 'package:msmpusher/data/repository_impl/account_repository_impl.dart';
import 'package:msmpusher/domain/repositories/repositories.dart';

void accountBalanceDependenciesInit(GetIt getIt) {
  // bloc
  getIt.registerFactory<GetAccountMetricsCubit>(
    () => GetAccountMetricsCubit(repository: getIt(), snapshotCache: getIt()),
  );
  getIt.registerFactory<GetAccountBalanceCubit>(
    () => GetAccountBalanceCubit(repository: getIt(), snapshotCache: getIt()),
  );

  // snapshot cache
  getIt.registerFactory<AccountDetailsSnapshotCache>(
    () => AccountDetailsSnapshotCache(),
  );

  // repository
  getIt.registerFactory<AccountRepository>(
    () => AccountRepositoryImpl(
      networkInfo: getIt(),
      localDataSource: getIt(),
      remoteDataSource: getIt(),
      contactLocalDataSource: getIt(),
      deviceContactDataSource: getIt(),
    ),
  );

  // data-sources
  getIt.registerFactory<AccountLocalDataSource>(
    () => AccountLocalDataSourceImpl(storage: getIt()),
  );
  getIt.registerFactory<AccountRemoteDataSource>(
    () => AccountRemoteDataSourceImpl(exceptionMapper: getIt()),
  );
}
