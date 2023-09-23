import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:msmpusher/business/blocs/contact_blocs/get_contact_groups_cubit/get_contact_groups_cubit.dart';
import 'package:msmpusher/business/blocs/contact_blocs/get_device_contacts_cubit/get_device_contacts_cubit.dart';
import 'package:msmpusher/business/snapshot_cache/snapshot_cache.dart';
import 'package:msmpusher/core/dependence/dependence.dart';
import 'package:msmpusher/core/interceptors/interceptors.dart';
import 'package:msmpusher/core/network/network.dart';
import 'package:msmpusher/core/route/app_router.dart';
import 'package:msmpusher/core/theme/custom_typography.dart';
import 'package:provider/provider.dart';

void _setupDioInterceptors() {
  dioClient.interceptors.add(getIt<LoggingInterceptors>());
  dioClient.interceptors.add(getIt<HeaderInterceptors>());
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initGetIt();
  _setupDioInterceptors();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (_) => runApp(const MyApp()),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthSnapshotCache>(
            create: (_) => AuthSnapshotCache()),
        ChangeNotifierProvider<ContactSnapshotCache>(
            create: (_) => ContactSnapshotCache()),
        ChangeNotifierProvider<GroupSnapshotCache>(
            create: (_) => GroupSnapshotCache()),
        ChangeNotifierProvider<AccountDetailsSnapshotCache>(
            create: (_) => AccountDetailsSnapshotCache()),
        ChangeNotifierProvider<MessageSnapshotCache>(
            create: (_) => MessageSnapshotCache()),
        ChangeNotifierProvider<SenderSnapshotCache>(
            create: (_) => SenderSnapshotCache()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<GetDeviceContactsCubit>(
            create: (context) =>
                getIt<GetDeviceContactsCubit>()..getDeviceContacts(),
          ),
          BlocProvider<GetContactGroupsCubit>(
            create: (context) =>
                getIt<GetContactGroupsCubit>()..getContactGroups(),
          ),
        ],
        child: ScreenUtilInit(
          designSize: const Size(390, 844),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (_) {
            return KeyboardVisibilityProvider(
              child: MaterialApp.router(
                title: 'MSMPUSHER',
                debugShowCheckedModeBanner: false,
                theme: CustomTypography.themeDataModifications,
                routerDelegate: _appRouter.delegate(),
                routeInformationParser: _appRouter.defaultRouteParser(),
              ),
            );
          },
        ),
      ),
    );
  }
}
