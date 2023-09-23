import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:msmpusher/business/blocs/account_blocs/get_account_balance_cubit/get_account_balance_cubit.dart';
import 'package:msmpusher/business/blocs/account_blocs/get_account_metrics_cubit/get_account_metrics_cubit.dart';
import 'package:msmpusher/business/blocs/bloc_state.dart';
import 'package:msmpusher/business/snapshot_cache/snapshot_cache.dart';
import 'package:msmpusher/core/constants.dart';
import 'package:msmpusher/core/exceptions/exceptions.dart';
import 'package:msmpusher/core/route/app_router.dart';
import 'package:msmpusher/core/theme/custom_typography.dart';
import 'package:msmpusher/core/util/width_constraints.dart';
import 'package:msmpusher/domain/form_params/account/get_account_details_form_params.dart';
import 'package:msmpusher/domain/model/models.dart';
import 'package:msmpusher/presentation/widget/widgets.dart';

class DashboardTab extends StatefulWidget {
  const DashboardTab({Key? key}) : super(key: key);

  @override
  State<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> {
  Widget _buildSalutationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Hello'),
        Text(
          'David Kayode!',
          style: Theme.of(context).textTheme.headline3,
        ),
        Text(
          'A/C - BYHDJKSLM',
          style: Theme.of(context).textTheme.subtitle2,
        ),
      ],
    );
  }

  Widget _buildSalutationAndProfileAvatarRowSection() {
    return WidthConstraint(context).withHorizontalSymmetricalPadding(
      child: Row(
        children: [
          Expanded(child: _buildSalutationSection()),
          Hero(
            tag: 'profile_avatar',
            child: ProfileAvatar(
              onTap: () {
                HapticFeedback.vibrate();

                context.router.push(const UserAccountScreenRoute());
              },
              imageUrl: 'assets/images/dav.jpg',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopUpButton() {
    return FloatingActionButton(
      onPressed: () {
        context.router.push(const TopUpWizardScreenRoute());
      },
      mini: true,
      heroTag: 'top-up',
      tooltip: 'Top up account',
      elevation: Sizing.kButtonElevation,
      backgroundColor: CustomTypography.kPrimaryColor,
      child: const Icon(Icons.add),
    );
  }

  Widget _buildCurrentBalanceRowSection(
      BlocState<Failure<ExceptionMessage>, AccountBalance> state) {
    final _isLoadingState =
        state is Loading<Failure<ExceptionMessage>, AccountBalance>;

    final _accountDetailsSnapshotCache =
        context.watch<AccountDetailsSnapshotCache>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  _accountDetailsSnapshotCache.accountBalance.unitBalance
                      .toString(),
                  style: Theme.of(context).textTheme.headline3!.copyWith(
                        fontWeight: FontWeight.normal,
                      ),
                ),
                if (_isLoadingState) ...[
                  const SizedBox(width: Sizing.kSizingMultiple * .5),
                  LoadingIndicator(
                    type: LoadingIndicatorType.circularProgressIndicator(
                        isMiniSize: true),
                  ),
                ],
              ],
            ),
            Text(
              'Current SMS Balance',
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ],
        ),
        _buildTopUpButton()
      ],
    );
  }

  Widget _buildAmountOverviewSection() {
    final _accountDetailsSnapshotCache =
        context.watch<AccountDetailsSnapshotCache>();

    // TODO: include bonus in account-balance model
    return Text(
        'Wallet: ${_accountDetailsSnapshotCache.accountBalance.walletBalance.toStringAsFixed(Sizing.kAmountFractionDigits)} | Bonus: 0');
  }

  Widget _buildAccountOverviewSection(
      {required BlocState<Failure<ExceptionMessage>, AccountBalance> state}) {
    final _isErrorState =
        state is Error<Failure<ExceptionMessage>, AccountBalance>;

    final _borderRadius = BorderRadius.circular(Sizing.kBorderRadius);

    return WidthConstraint(context).withHorizontalSymmetricalPadding(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              text: 'Account Overview',
              children: [
                if (_isErrorState) ...[
                  const TextSpan(text: ' \u00b7'),
                  TextSpan(
                    text: ' Tap on card to retry!',
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: CustomTypography.kErrorColor,
                        ),
                  )
                ],
              ],
            ),
          ),
          SizedBox(height: Sizing.kSizingMultiple.h),
          if (_isErrorState) ...[
            Row(
              children: [
                Expanded(
                  child: InfoIndicator(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(Sizing.kBorderRadius),
                      topRight: Radius.circular(Sizing.kBorderRadius),
                    ),
                    label: state.failure.exception.message.toString(),
                    // '${state.failure.exception.message.toString()} Tap to refresh',
                  ),
                ),
              ],
            ),
          ],
          Material(
            borderRadius: _borderRadius,
            elevation: Sizing.kCardElevation,
            child: InkWell(
              onTap: () {
                HapticFeedback.vibrate();

                final _authSnapshotCache = context.read<AuthSnapshotCache>();

                final _getAccountDetailsFormParams =
                    GetAccountDetailsFormParams(
                  userId: _authSnapshotCache.userInfo.uid,
                  accountNumber: _authSnapshotCache.userInfo.accountNumber!,
                );

                context.read<GetAccountBalanceCubit>().getAccountBalance(
                    getAccountDetailsFormParams: _getAccountDetailsFormParams);
              },
              borderRadius: _borderRadius,
              child: Container(
                padding: EdgeInsets.all((Sizing.kSizingMultiple * 2).h),
                decoration: BoxDecoration(borderRadius: _borderRadius),
                child: Column(
                  children: [
                    _buildCurrentBalanceRowSection(state),
                    SizedBox(height: (Sizing.kSizingMultiple * 2).h),
                    Divider(
                      height: Sizing.kZeroValue,
                      color: CustomTypography.kLightGreyColor,
                    ),
                    SizedBox(height: (Sizing.kSizingMultiple * 2).h),
                    _buildAmountOverviewSection(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountOverviewBuilder() {
    return BlocConsumer<GetAccountBalanceCubit,
        BlocState<Failure<ExceptionMessage>, AccountBalance>>(
      listener: (context, state) {
        state.maybeMap(
          orElse: () => null,
          success: (state) {
            context.read<AccountDetailsSnapshotCache>().notifyAllListeners();
          },
        );
      },
      builder: (context, state) {
        return _buildAccountOverviewSection(state: state);
      },
    );
  }

  Widget _buildMetricItem({
    required String imageUrl,
    required String label,
    required String value,
  }) {
    final _borderRadius = BorderRadius.circular(Sizing.kBorderRadius);

    return Container(
      padding: EdgeInsets.only(
        bottom: Sizing.kSizingMultiple.h,
      ),
      child: Material(
        borderRadius: _borderRadius,
        elevation: Sizing.kCardElevation,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: (Sizing.kSizingMultiple * 1.625).h,
            horizontal: (Sizing.kSizingMultiple * 3.125).w,
          ),
          decoration: BoxDecoration(
            // border: Border.all(
            //   color: CustomTypography.kLightGreyColor,
            // ),
            borderRadius: _borderRadius,
          ),
          child: Row(
            children: [
              Image.asset(imageUrl, height: Sizing.kIconImagesHeightSize),
              SizedBox(width: (Sizing.kSizingMultiple * 2.5).w),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricsSection() {
    final _accountDetailsSnapshotCache =
        context.watch<AccountDetailsSnapshotCache>();

    return GridView.count(
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 2,
      childAspectRatio: 165 / 73,
      crossAxisSpacing: (Sizing.kSizingMultiple * 1.5).w,
      mainAxisSpacing: (Sizing.kSizingMultiple * .5).h,
      children: [
        Container(
          margin:
              EdgeInsets.only(left: WidthConstraint(context).contentPadding),
          child: _buildMetricItem(
            imageUrl: 'assets/icons/sms.png',
            label: 'SMS',
            value: _accountDetailsSnapshotCache
                .accountMetric.accountSmsMetric.totalSMSSentToday
                .toString(),
          ),
        ),
        Container(
          margin:
              EdgeInsets.only(right: WidthConstraint(context).contentPadding),
          child: _buildMetricItem(
            imageUrl: 'assets/icons/contact.png',
            label: 'Contacts',
            value: _accountDetailsSnapshotCache
                .accountMetric.contactModelList.LENGTH
                .toString(),
          ),
        ),
        Container(
          margin:
              EdgeInsets.only(left: WidthConstraint(context).contentPadding),
          child: _buildMetricItem(
            imageUrl: 'assets/icons/networking.png',
            label: 'Groups',
            value: _accountDetailsSnapshotCache
                .accountMetric.contactGroupList.LENGTH
                .toString(),
          ),
        ),
        Container(
          margin:
              EdgeInsets.only(right: WidthConstraint(context).contentPadding),
          child: _buildMetricItem(
            imageUrl: 'assets/icons/marketing.png',
            label: 'Sender ID',
            value: '0',
          ),
        ),
      ],
    );
  }

  Widget _buildTodaysMetricsSection(
      {required BlocState<Failure<ExceptionMessage>, AccountMetric> state}) {
    final _isErrorState =
        state is Error<Failure<ExceptionMessage>, AccountMetric>;
    final _isLoadingState =
        state is Loading<Failure<ExceptionMessage>, AccountMetric>;

    return GestureDetector(
      onTap: () {
        HapticFeedback.vibrate();

        final _authSnapshotCache = context.read<AuthSnapshotCache>();

        final _getAccountDetailsFormParams = GetAccountDetailsFormParams(
          userId: _authSnapshotCache.userInfo.uid,
          accountNumber: _authSnapshotCache.userInfo.accountNumber!,
        );

        context.read<GetAccountMetricsCubit>().getAccountMetrics(
            getAccountDetailsFormParams: _getAccountDetailsFormParams);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: (Sizing.kSizingMultiple * 3.75).h),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: WidthConstraint(context).contentPadding),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text.rich(
                  TextSpan(
                    text: 'Today\'s Metrics',
                    children: [
                      // if (_isErrorState) ...[
                      const TextSpan(text: ' \u00b7'),
                      TextSpan(
                        text: ' Tap here to refresh!',
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              color: CustomTypography.kGreyColor,
                            ),
                      )
                      // ],
                    ],
                  ),
                ),
                if (_isLoadingState) ...[
                  const SizedBox(width: Sizing.kSizingMultiple * .5),
                  LoadingIndicator(
                    type: LoadingIndicatorType.circularProgressIndicator(
                        isMiniSize: true),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(height: Sizing.kSizingMultiple.h),
          if (_isErrorState) ...[
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: WidthConstraint(context).contentPadding),
              child: Row(
                children: [
                  Expanded(
                    child: InfoIndicator(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(Sizing.kBorderRadius),
                        topRight: Radius.circular(Sizing.kBorderRadius),
                      ),
                      label: state.failure.exception.message.toString(),
                    ),
                  ),
                ],
              ),
            ),
          ],
          Flexible(
            child: _buildMetricsSection(),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsSectionBuilder() {
    return BlocConsumer<GetAccountMetricsCubit,
        BlocState<Failure<ExceptionMessage>, AccountMetric>>(
      listener: (context, state) {
        state.maybeMap(
          orElse: () => null,
          success: (state) {
            context.read<AccountDetailsSnapshotCache>().notifyAllListeners();
          },
        );
      },
      builder: (context, state) {
        return _buildTodaysMetricsSection(state: state);
      },
    );
  }

  Widget _buildFeatureItem({
    required VoidCallback onTap,
    required String imageUrl,
    required String label,
  }) {
    final _borderRadius = BorderRadius.circular(Sizing.kBorderRadius);

    return Expanded(
      child: Material(
        borderRadius: _borderRadius,
        elevation: Sizing.kCardElevation,
        child: InkWell(
          onTap: onTap,
          borderRadius: _borderRadius,
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: (Sizing.kSizingMultiple * 1.25).h,
              horizontal: (Sizing.kSizingMultiple * 1.25).w,
            ),
            decoration: BoxDecoration(
              // border: Border.all(
              //   color: CustomTypography.kLightGreyColor,
              // ),
              borderRadius: _borderRadius,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(imageUrl, height: Sizing.kIconImagesHeightSize),
                SizedBox(height: Sizing.kSizingMultiple.h),
                Text(label),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturesRowSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildFeatureItem(
          onTap: () {
            HapticFeedback.vibrate();
            context.router.push(const SenderIdScreenRoute());
          },
          imageUrl: 'assets/icons/real-time.png',
          label: 'Sender ID',
        ),
        SizedBox(width: (Sizing.kSizingMultiple * 1.5).w),
        _buildFeatureItem(
          onTap: () {
            HapticFeedback.vibrate();
            context.router.push(const ReportScreenRoute());
          },
          imageUrl: 'assets/icons/business-report.png',
          label: 'Reports',
        ),
        SizedBox(width: (Sizing.kSizingMultiple * 1.5).w),
        _buildFeatureItem(
          onTap: () {
            HapticFeedback.vibrate();
            // TODO:
          },
          imageUrl: 'assets/icons/api.png',
          label: 'API Doc',
        ),
      ],
    );
  }

  Widget _buildFeaturesSection() {
    return WidthConstraint(context).withHorizontalSymmetricalPadding(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: (Sizing.kSizingMultiple * 3.75).h),
          const Text('Features'),
          SizedBox(height: Sizing.kSizingMultiple.h),
          _buildFeaturesRowSection(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: (Sizing.kSizingMultiple * 3).h),
              _buildSalutationAndProfileAvatarRowSection(),
              SizedBox(height: (Sizing.kSizingMultiple * 2.5).h),
              _buildAccountOverviewBuilder(),
              _buildMetricsSectionBuilder(),
              _buildFeaturesSection(),
              SizedBox(height: (Sizing.kSizingMultiple * 2.5).h),
            ],
          ),
        ),
      ),
    );
  }
}
