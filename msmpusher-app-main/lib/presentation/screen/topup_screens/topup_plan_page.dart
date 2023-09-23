import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:msmpusher/core/constants.dart';
import 'package:msmpusher/core/theme/custom_typography.dart';
import 'package:msmpusher/core/util/dialog_util.dart';
import 'package:msmpusher/core/util/width_constraints.dart';
import 'package:msmpusher/presentation/widget/shared/custom_button.dart';
import 'package:msmpusher/presentation/widget/shared/info_indicator.dart';
import 'package:msmpusher/presentation/widget/shared/page_indicator.dart';
import 'package:msmpusher/presentation/widget/topup_screens/topup_plan.dart';

class TopUpPlanPage extends StatefulWidget {
  final VoidCallback onGotoNextPage;

  const TopUpPlanPage({Key? key, required this.onGotoNextPage})
      : super(key: key);

  @override
  State<TopUpPlanPage> createState() => _TopUpPlanPageState();
}

class _TopUpPlanPageState extends State<TopUpPlanPage> {
  int _activePageIndex = 0;
  final _pageCount = 3;

  num _startingAmount = 0.0;

  late TextEditingController _amountTextFieldController;

  @override
  void initState() {
    super.initState();

    _amountTextFieldController = TextEditingController();
  }

  @override
  void dispose() {
    _amountTextFieldController.dispose();
    super.dispose();
  }

  Widget _buildSMSCountIndication() {
    return Flexible(
      child: CustomButton(
        type: ButtonType.regularButton(
          onTap: () {},
          label: '20000 SMS',
          backgroundColor: CustomTypography.kBlackColor,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(Sizing.kBorderRadius),
            bottomRight: Radius.circular(Sizing.kBorderRadius),
          ),
        ),
      ),
    );
  }

  Widget _buildAmountTextField() {
    const _borderRadius = BorderRadius.only(
      topLeft: Radius.circular(Sizing.kBorderRadius),
      bottomLeft: Radius.circular(Sizing.kBorderRadius),
    );

    _amountTextFieldController.text = _startingAmount.toString();

    // TODO: extract TextFormField to separate dedicated widget
    return Flexible(
      flex: 3,
      child: TextFormField(
        controller: _amountTextFieldController,
        keyboardType: TextInputType.number,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          hintText: 'Amount',
          prefixText: 'GHS ',
          enabledBorder: OutlineInputBorder(
            borderRadius: _borderRadius,
            borderSide: BorderSide(
              color: CustomTypography.kLightGreyColor,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: _borderRadius,
            borderSide: BorderSide(
              color: CustomTypography.kLightGreyColor,
            ),
          ),
        ),
        validator: (value) {
          return _amountTextFieldController.text.isEmpty
              ? 'Amount is required!'
              : null;
        },
      ),
    );
  }

  Widget _buildAmountTextFieldAndSMSCountRowSection() {
    return Row(
      children: [
        _buildAmountTextField(),
        _buildSMSCountIndication(),
      ],
    );
  }

  Widget _buildBuyUnitButton() {
    return CustomButton(
      type: ButtonType.regularButton(
        onTap: () async {
          // TODO:

          // pop bottom-sheet and goto next page
          await context.router.pop();
          widget.onGotoNextPage();
        },
        label: 'Buy SMS Unit',
      ),
    );
  }

  Widget _buildAmountFormSection() {
    return WidthConstraint(context).withHorizontalSymmetricalPadding(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: (Sizing.kSizingMultiple * 2.5).h),
          const Text('Enter SMS unit amount to buy'),
          SizedBox(height: Sizing.kSizingMultiple.h),
          _buildAmountTextFieldAndSMSCountRowSection(),
          SizedBox(height: (Sizing.kSizingMultiple * 2.5).h),
          _buildBuyUnitButton(),
          SizedBox(height: (Sizing.kSizingMultiple * 2.5).h),
        ],
      ),
    );
  }

  void _showAmountFormModalBottomSheet() {
    DialogUtil(context).bottomModal(
      child: _buildAmountFormSection(),
    );
  }

  Widget _buildPageView() {
    return Flexible(
      child: PageView.builder(
        itemCount: _pageCount,
        onPageChanged: (int index) {
          setState(() {
            _activePageIndex = index;
          });
        },
        itemBuilder: (context, index) {
          return Column(
            children: [
              const SizedBox(height: Sizing.kSizingMultiple * 2.5),
              TopUpPlan(
                onSelectPlan: () {
                  HapticFeedback.vibrate();
                  _showAmountFormModalBottomSheet();

                  // set starting-amount from package
                  setState(() {
                    _startingAmount = 5.0;
                  });
                },
                currency: 'c',
                startAmount: 5.00,
                packageName: 'promo',
                packageColor: CustomTypography.kSecondaryColor,
                validity: '30 days',
                pricePerUnit: '0.0022 per sms',
                minimumAmount: 'c5.00',
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: (Sizing.kSizingMultiple * 5).h),
        const InfoIndicator(
          label: 'Select a package and enter amount to continue',
        ),
        _buildPageView(),
        // const SizedBox(height: Sizing.kSizingMultiple * 2.5),
        PageIndicator(
          pageCount: _pageCount,
          activePageIndex: _activePageIndex,
          dotColor: CustomTypography.kLightGreyColor,
        ),
        SizedBox(height: (Sizing.kSizingMultiple * 15).h),
        // _buildFormSection(),
      ],
    );
  }
}
