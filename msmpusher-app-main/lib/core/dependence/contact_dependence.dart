import 'package:get_it/get_it.dart';
import 'package:msmpusher/business/blocs/contact_blocs/create_contact_group_cubit/create_contact_group_cubit.dart';
import 'package:msmpusher/business/blocs/contact_blocs/delete_contact_group_cubit/delete_contact_group_cubit.dart';
import 'package:msmpusher/business/blocs/contact_blocs/delete_group_contact_cubit/delete_group_contact_cubit.dart';
import 'package:msmpusher/business/blocs/contact_blocs/get_contact_groups_cubit/get_contact_groups_cubit.dart';
import 'package:msmpusher/business/blocs/contact_blocs/get_device_contacts_cubit/get_device_contacts_cubit.dart';
import 'package:msmpusher/business/blocs/contact_blocs/get_device_file_contacts_cubit/get_device_file_contacts_cubit.dart';
import 'package:msmpusher/business/snapshot_cache/snapshot_cache.dart';
import 'package:msmpusher/data/datasources/datasources.dart';
import 'package:msmpusher/data/repository_impl/contact_repository_impl.dart';
import 'package:msmpusher/domain/repositories/repositories.dart';

void contactDependenciesInit(GetIt getIt) {
  // blocs
  getIt.registerFactory(() =>
      GetDeviceContactsCubit(repository: getIt(), snapshotCache: getIt()));
  getIt.registerFactory(() =>
      GetDeviceFileContactsCubit(repository: getIt(), snapshotCache: getIt()));
  getIt.registerFactory(
      () => GetContactGroupsCubit(repository: getIt(), snapshotCache: getIt()));
  getIt.registerFactory(() =>
      CreateContactGroupCubit(repository: getIt(), snapshotCache: getIt()));
  getIt.registerFactory(() =>
      DeleteContactGroupCubit(repository: getIt(), snapshotCache: getIt()));
  getIt.registerFactory(() =>
      DeleteGroupContactCubit(repository: getIt(), snapshotCache: getIt()));

  // snapshot caches
  getIt.registerLazySingleton<ContactSnapshotCache>(
      () => ContactSnapshotCache());
  getIt.registerLazySingleton<GroupSnapshotCache>(() => GroupSnapshotCache());

  // repositories
  getIt.registerLazySingleton<ContactRepository>(
    () => ContactRepositoryImpl(
      deviceContactDataSource: getIt(),
      contactLocalDataSource: getIt(),
    ),
  );

  // data sources
  getIt.registerLazySingleton<DeviceContactDataSource>(
      () => DeviceContactDataSourceImpl(permissionHelper: getIt()));

  getIt.registerLazySingleton<ContactLocalDataSource>(
      () => ContactLocalDataSourceImpl(storage: getIt()));
}
