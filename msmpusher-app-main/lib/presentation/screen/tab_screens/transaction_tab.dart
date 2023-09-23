import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:msmpusher/core/constants.dart';
import 'package:msmpusher/core/route/app_router.dart';
import 'package:msmpusher/core/theme/custom_typography.dart';
import 'package:msmpusher/core/util/width_constraints.dart';
import 'package:msmpusher/presentation/widget/widgets.dart';

class TransactionTab extends StatefulWidget {
  const TransactionTab({Key? key}) : super(key: key);

  @override
  State<TransactionTab> createState() => _TransactionTabState();
}

class _TransactionTabState extends State<TransactionTab> {
  late TextEditingController _searchTextFieldController;

  @override
  void initState() {
    super.initState();
    _searchTextFieldController = TextEditingController();
  }

  @override
  void dispose() {
    _searchTextFieldController.dispose();
    super.dispose();
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      pinned: true,
      centerTitle: true,
      elevation: Sizing.kButtonElevation,
      title: Text('Transactions', style: Theme.of(context).textTheme.headline5),
    );
  }

  Widget _buildTransactionList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return Column(
            children: [
              CustomListTile(
                onTap: () {
                  context.router.push(const TransactionDetailScreenRoute());
                },
                leading: Icon(
                  (index % 2) > 0
                      ? Icons.phone_android_rounded
                      : Icons.credit_card,
                ),
                title: 'GHS 10.00',
                description: '2 days ago',
                trailing: CustomChip(
                  label: index == 0 ? 'PENDING' : 'COMPLETED',
                  foregroundColor: index == 0
                      ? CustomTypography.kMidGreyColor
                      : CustomTypography.kIndicationColor,
                  backgroundColor: index == 0
                      ? CustomTypography.kLightGreyColor
                      : CustomTypography.kIndicationColor10,
                ),
              ),
              const CustomDivider(),
            ],
          );
        },
        childCount: 3,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        _buildAppBar(),
        SliverToBoxAdapter(
          child: SizedBox(height: (Sizing.kSizingMultiple * 2).h),
        ),
        SliverToBoxAdapter(
          child: WidthConstraint(context).withHorizontalSymmetricalPadding(
            child: const Text('All Transactions'),
          ),
        ),
        _buildTransactionList(),
      ],
    );
  }
}
