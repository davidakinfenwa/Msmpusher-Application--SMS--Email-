import 'package:get_it/get_it.dart';
import 'package:msmpusher/business/blocs/sender_blocs/create_sender_id_cubit/create_sender_id_cubit.dart';
import 'package:msmpusher/business/blocs/sender_blocs/delete_sender_id_cubit/delete_sender_id_cubit.dart';
import 'package:msmpusher/business/blocs/sender_blocs/get_sender_ids_cubit/get_sender_ids_cubit.dart';
import 'package:msmpusher/business/snapshot_cache/snapshot_cache.dart';
import 'package:msmpusher/data/datasources/datasources.dart';
import 'package:msmpusher/data/repository_impl/sender_repository_impl.dart';
import 'package:msmpusher/domain/repositories/repositories.dart';

void senderDependenciesInit(GetIt getIt) {
  // blocs
  getIt.registerFactory<GetSenderIdsCubit>(
    () => GetSenderIdsCubit(repository: getIt(), snapshotCache: getIt()),
  );
  getIt.registerFactory<CreateSenderIdCubit>(
    () => CreateSenderIdCubit(repository: getIt(), snapshotCache: getIt()),
  );
  getIt.registerFactory<DeleteSenderIdCubit>(
    () => DeleteSenderIdCubit(repository: getIt(), snapshotCache: getIt()),
  );

  // snapshot cache
  getIt.registerLazySingleton<SenderSnapshotCache>(() => SenderSnapshotCache());

  // repositories
  getIt.registerLazySingleton<SenderRepository>(
    () => SenderRepositoryImpl(
      networkInfo: getIt(),
      localDataSource: getIt(),
      remoteDataSource: getIt(),
    ),
  );

  // data-sources
  getIt.registerLazySingleton<SenderLocalDataSource>(
    () => SenderLocalDataSourceImpl(storage: getIt()),
  );

  getIt.registerLazySingleton<SenderRemoteDataSource>(
    () => SenderRemoteDataSourceImpl(exceptionMapper: getIt()),
  );
}
