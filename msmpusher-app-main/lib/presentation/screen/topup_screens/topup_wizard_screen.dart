import 'package:flutter/material.dart';
import 'package:msmpusher/core/constants.dart';
import 'package:msmpusher/core/theme/custom_typography.dart';
import 'package:msmpusher/core/util/width_constraints.dart';
import 'package:msmpusher/presentation/screen/topup_screens/purchase_summary_page.dart';
import 'package:msmpusher/presentation/screen/topup_screens/topup_plan_page.dart';
import 'package:msmpusher/presentation/screen/topup_screens/transaction_status_page.dart';
import 'package:msmpusher/presentation/widget/widgets.dart';

class TopUpWizardScreen extends StatefulWidget {
  const TopUpWizardScreen({Key? key}) : super(key: key);

  @override
  State<TopUpWizardScreen> createState() => _TopUpWizardScreenState();
}

class _TopUpWizardScreenState extends State<TopUpWizardScreen> {
  int _activePageIndex = 0;
  final int _totalPageCount = 3;

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

  void _gotoPreviousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: TimeDuration.kAnimationDuration),
      curve: TimeDuration.kAnimationCurve,
    );
  }

  void _gotoNextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: TimeDuration.kAnimationDuration),
      curve: TimeDuration.kAnimationCurve,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: Text('Top Up', style: Theme.of(context).textTheme.headline5),
    );
  }

  Widget _buildCustomStepper() {
    return WidthConstraint(context).withHorizontalSymmetricalPadding(
      child: CustomStepper(
        width: WidthConstraint(context).deviceWidth,
        curStep: _activePageIndex + 1,
        stepCompleteColor: CustomTypography.kPrimaryColor,
        totalSteps: _totalPageCount,
        inactiveColor: CustomTypography.kLightGreyColor,
        currentStepColor: CustomTypography.kPrimaryColor10,
        lineWidth: Sizing.kStepperLineWidth,
      ),
    );
  }

  Widget _buildPageView() {
    return Expanded(
      child: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (int index) {
          setState(() {
            _activePageIndex = index;
          });
        },
        children: [
          TopUpPlanPage(onGotoNextPage: _gotoNextPage),
          PurchaseSummary(onGotoNextPage: _gotoNextPage),
          const TransactionStatusPage(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_activePageIndex > 0) {
          _gotoPreviousPage();

          return false;
        }

        return true;
      },
      child: Scaffold(
        appBar: _buildAppBar(),
        body: Column(
          children: [
            _buildCustomStepper(),
            _buildPageView(),
          ],
        ),
      ),
    );
  }
}
