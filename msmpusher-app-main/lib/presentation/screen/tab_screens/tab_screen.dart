import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:msmpusher/business/blocs/account_blocs/get_account_balance_cubit/get_account_balance_cubit.dart';
import 'package:msmpusher/business/blocs/account_blocs/get_account_metrics_cubit/get_account_metrics_cubit.dart';
import 'package:msmpusher/business/blocs/contact_blocs/create_contact_group_cubit/create_contact_group_cubit.dart';
import 'package:msmpusher/business/blocs/message_blocs/send_message_cubit/send_message_cubit.dart';
import 'package:msmpusher/business/snapshot_cache/snapshot_cache.dart';
import 'package:msmpusher/core/constants.dart';
import 'package:msmpusher/core/dependence/dependence.dart';
import 'package:msmpusher/core/theme/custom_typography.dart';
import 'package:msmpusher/core/util/dialog_util.dart';
import 'package:msmpusher/domain/form_params/form_params.dart';
import 'package:msmpusher/presentation/screen/tab_screens/contacts_tab.dart';
import 'package:msmpusher/presentation/screen/tab_screens/dashboard_tab.dart';
import 'package:msmpusher/presentation/screen/tab_screens/send_message_tab.dart';
import 'package:msmpusher/presentation/screen/tab_screens/transaction_tab.dart';
import 'package:msmpusher/presentation/widget/shared/custom_button.dart';

class TabScreen extends StatefulWidget implements AutoRouteWrapper {
  const TabScreen({Key? key}) : super(key: key);

  @override
  State<TabScreen> createState() => _TabScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    final _authSnapshotCache = context.read<AuthSnapshotCache>();

    final _getAccountDetailsFormParams = GetAccountDetailsFormParams(
      userId: _authSnapshotCache.userInfoContext.uid,
      accountNumber: _authSnapshotCache.userInfoContext.accountNumber!,
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider<CreateContactGroupCubit>(
          create: (context) => getIt<CreateContactGroupCubit>(),
        ),
        BlocProvider<SendMessageCubit>(
            create: (context) => getIt<SendMessageCubit>()),
        BlocProvider<GetAccountMetricsCubit>(
          create: (context) => getIt<GetAccountMetricsCubit>()
            ..getAccountMetrics(
                getAccountDetailsFormParams: _getAccountDetailsFormParams),
        ),
        BlocProvider<GetAccountBalanceCubit>(
          create: (context) => getIt<GetAccountBalanceCubit>()
            ..getAccountBalance(
                getAccountDetailsFormParams: _getAccountDetailsFormParams),
        ),
      ],
      child: this,
    );
  }
}

class _TabScreenState extends State<TabScreen> {
  int _activePageIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onGetDashboardMetricsCallback() {
    final _authSnapshotCache = context.read<AuthSnapshotCache>();

    final _getAccountDetailsFormParams = GetAccountDetailsFormParams(
      userId: _authSnapshotCache.userInfo.uid,
      accountNumber: _authSnapshotCache.userInfo.accountNumber!,
    );

    context.read<GetAccountMetricsCubit>().getAccountMetrics(
        getAccountDetailsFormParams: _getAccountDetailsFormParams);
    context.read<GetAccountBalanceCubit>().getAccountBalance(
        getAccountDetailsFormParams: _getAccountDetailsFormParams);
  }

  void _onPageViewPageChangedCallback(int index) {
    setState(() {
      _activePageIndex = index;
    });

    if (_activePageIndex == 0) {
      _onGetDashboardMetricsCallback();
    }
  }

  Widget _buildPageView() {
    return PageView(
      controller: _pageController,
      onPageChanged: _onPageViewPageChangedCallback,
      children: [
        const DashboardTab(),
        const SendMessageTab(),
        ContactsTab(),
        const TransactionTab(),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _activePageIndex,
      onTap: (int index) {
        _pageController.animateToPage(
          index,
          duration:
              const Duration(milliseconds: TimeDuration.kAnimationDuration),
          curve: TimeDuration.kAnimationCurve,
        );
      },
      showUnselectedLabels: true,
      selectedItemColor: CustomTypography.kPrimaryColor,
      unselectedItemColor: CustomTypography.kMidGreyColor,
      items: const [
        BottomNavigationBarItem(
          label: 'Dashboard',
          icon: Icon(Icons.widgets),
        ),
        BottomNavigationBarItem(
          label: 'Send SMS',
          icon: Icon(Icons.sms_outlined),
        ),
        BottomNavigationBarItem(
          label: 'Contacts',
          icon: Icon(Icons.people_alt_outlined),
        ),
        BottomNavigationBarItem(
          label: 'Transactions',
          icon: Icon(Icons.list_alt_outlined),
        ),
      ],
    );
  }

  Future<bool> _showClearSelectedContactsWarning() async {
    final _result = await DialogUtil(context).openDialog(
      child: AlertDialog(
        contentPadding: const EdgeInsets.only(
          top: Sizing.kSizingMultiple * 1.5,
          left: Sizing.kSizingMultiple * 3,
          right: Sizing.kSizingMultiple * 3,
        ),
        title: const Text('Exit Application?'),
        content: const Text(
            'Closing the application will clear all selected contacts!'),
        actions: [
          Row(
            children: [
              Flexible(
                child: CustomButton(
                  type: ButtonType.regularFlatButton(
                    onTap: () {
                      context.router.pop(false);
                    },
                    label: 'Cancel',
                    textColor: CustomTypography.kPrimaryColor,
                  ),
                ),
              ),
              SizedBox(width: (Sizing.kSizingMultiple).w),
              Flexible(
                child: CustomButton(
                  type: ButtonType.regularFlatButton(
                    onTap: () {
                      context.router.pop(true);
                    },
                    label: 'Exit Application',
                    textColor: CustomTypography.kPrimaryColor,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );

    return _result;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_activePageIndex == 2) {
          final _selectedContacts =
              context.read<ContactSnapshotCache>().selectedContacts;

          if (_selectedContacts.contacts.isNotEmpty) {
            final _result = await _showClearSelectedContactsWarning();

            if (_result) return true;
            return false;
          }
        }

        return true;
      },
      child: Scaffold(
        // floatingActionButton: _buildFloatingActionButton(),
        bottomNavigationBar: _buildBottomNavigationBar(),
        body: SafeArea(
          child: _buildPageView(),
        ),
      ),
    );
  }
}
