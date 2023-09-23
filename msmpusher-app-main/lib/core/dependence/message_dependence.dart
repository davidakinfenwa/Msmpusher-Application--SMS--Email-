import 'package:get_it/get_it.dart';
import 'package:msmpusher/business/blocs/message_blocs/get_message_reports_cubit/get_message_reports_cubit.dart';
import 'package:msmpusher/business/blocs/message_blocs/send_message_cubit/send_message_cubit.dart';
import 'package:msmpusher/business/snapshot_cache/snapshot_cache.dart';
import 'package:msmpusher/data/datasources/datasources.dart';
import 'package:msmpusher/data/repository_impl/message_repository_impl.dart';
import 'package:msmpusher/domain/repositories/repositories.dart';

void messageDependenciesInit(GetIt getIt) {
  // blocs
  getIt.registerFactory(
      () => SendMessageCubit(repository: getIt(), snapshotCache: getIt()));
  getIt.registerFactory(() =>
      GetMessageReportsCubit(repository: getIt(), snapshotCache: getIt()));

  // snapshot caches
  getIt.registerLazySingleton<MessageSnapshotCache>(
      () => MessageSnapshotCache());

  // repository
  getIt.registerLazySingleton<MessageRepository>(
    () => MessageRepositoryImpl(
      networkInfo: getIt(),
      localDataSource: getIt(),
      remoteDataSource: getIt(),
    ),
  );

  // data-sources
  getIt.registerLazySingleton<MessageLocalDataSource>(
    () => MessageLocalDataSourceImpl(storage: getIt()),
  );
  getIt.registerLazySingleton<MessageRemoteDataSource>(
    () => MessageRemoteDataSourceImpl(exceptionMapper: getIt()),
  );
}
