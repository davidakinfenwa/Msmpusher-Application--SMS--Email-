import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:msmpusher/core/constants.dart';
import 'package:msmpusher/core/route/app_router.dart';
import 'package:msmpusher/core/theme/custom_typography.dart';
import 'package:msmpusher/core/util/width_constraints.dart';
import 'package:msmpusher/presentation/widget/widgets.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  int _activePageIndex = 0;
  final _totalPageCount = 3;

  Color get _dynamicCreateAccountButtonColor => _activePageIndex == 2
      ? CustomTypography.kBlackColor
      : CustomTypography.kWhiteColor;

  Color get _dynamicSignInButtonBackgroundColor => _activePageIndex > 0
      ? CustomTypography.kDarkPrimaryColor
      : CustomTypography.kSecondaryColor;
  Color get _dynamicSignInButtonForegroundColor => _activePageIndex > 0
      ? CustomTypography.kWhiteColor
      : CustomTypography.kBlackColor;

  Widget _buildPageView() {
    return PageView(
      onPageChanged: (int page) {
        setState(() {
          _activePageIndex = page;
        });
      },
      children: [
        PageItem(
          imageUrl: 'assets/start/start-0.png',
          title: 'Reach and engage with your Customer',
          description:
              'Reach more people on the go with our simple-to-use marketing tools',
          backgroundColor: CustomTypography.kDarkPrimaryColor,
        ),
        PageItem(
          reversed: true,
          textAlign: TextAlign.left,
          imageUrl: 'assets/start/start-1.png',
          title: 'Find, connect and grow your business',
          description:
              'Want to reach customers and businesses around you and beyond? We are here for you',
          backgroundColor: CustomTypography.kIndicationColor,
        ),
        PageItem(
          textColor: CustomTypography.kBlackColor,
          imageUrl: 'assets/start/start-2.png',
          title: 'Increase your daily sales',
          description:
              'With as low as 0.019p, you can easily reach your potential and buying customers.',
          backgroundColor: CustomTypography.kSecondaryColor,
        ),
      ],
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PageIndicator(
          dotIndicatorColor: _dynamicSignInButtonBackgroundColor,
          pageCount: _totalPageCount,
          activePageIndex: _activePageIndex,
        ),
      ],
    );
  }

  Widget _buildButtonSection() {
    return WidthConstraint(context).withHorizontalSymmetricalPadding(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomButton(
            type: ButtonType.withBorderButton(
              onTap: () => context.router.push(const SignUpScreenRoute()),
              label: 'Create Account',
              textColor: _dynamicCreateAccountButtonColor,
              borderColor: _dynamicCreateAccountButtonColor,
            ),
          ),
          SizedBox(height: (Sizing.kSizingMultiple * 1.5).h),
          CustomButton(
            type: ButtonType.regularButton(
              onTap: () => context.router.push(const LoginScreenRoute()),
              label: 'Sign In',
              textColor: _dynamicSignInButtonForegroundColor,
              backgroundColor: _dynamicSignInButtonBackgroundColor,
            ),
          ),
          SizedBox(height: (Sizing.kSizingMultiple * 2.5).h),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildPageView(),
          Positioned(
            right: 0,
            left: 0,
            bottom: (Sizing.kSizingMultiple * 21.75).h,
            child: _buildPageIndicator(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildButtonSection(),
          ),
        ],
      ),
    );
  }
}
