import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:msmpusher/core/constants.dart';
import 'package:msmpusher/core/route/app_router.dart';
import 'package:msmpusher/presentation/screen/screens.dart';
import 'package:msmpusher/presentation/widget/widgets.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({Key? key}) : super(key: key);

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: Builder(builder: (context) {
        return Text(
          'Security',
          style: Theme.of(context).textTheme.headline5,
        );
      }),
    );
  }

  Widget _buildActionSection() {
    return Column(
      children: [
        const CustomDivider(),
        SizedBox(height: (Sizing.kSizingMultiple * 2.5).h),
        CustomListTile(
          onTap: () {
            context.router.push(ChangePasswordScreenRoute(
                source: ChangePasswordScreenSource.userAccount));
          },
          leading: const Icon(Icons.password_outlined),
          title: 'Change Password',
          trailing: const Icon(Icons.arrow_right_rounded),
        ),
        CustomListTile(
          onTap: () {
            context.router.push(const ChangePhoneNumberScreenRoute());
          },
          leading: const Icon(Icons.phone_android_sharp),
          title: 'Change Phone Number',
          trailing: const Icon(Icons.arrow_right_rounded),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildActionSection(),
    );
  }
}
