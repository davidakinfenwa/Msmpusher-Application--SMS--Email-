import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:msmpusher/business/blocs/auth_blocs/signout_form_cubit/signout_form_cubit.dart';
import 'package:msmpusher/business/blocs/bloc_state.dart';
import 'package:msmpusher/core/constants.dart';
import 'package:msmpusher/core/dependence/dependence.dart';
import 'package:msmpusher/core/exceptions/exceptions.dart';
import 'package:msmpusher/core/route/app_router.dart';
import 'package:msmpusher/core/theme/custom_typography.dart';
import 'package:msmpusher/core/util/unit_impl.dart';
import 'package:msmpusher/core/util/width_constraints.dart';
import 'package:msmpusher/presentation/widget/widgets.dart';

class UserAccountScreen extends StatefulWidget implements AutoRouteWrapper {
  const UserAccountScreen({Key? key}) : super(key: key);

  @override
  State<UserAccountScreen> createState() => _UserAccountScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider<SignoutFormCubit>(
      create: (context) => getIt<SignoutFormCubit>(),
      child: this,
    );
  }
}

class _UserAccountScreenState extends State<UserAccountScreen> {
  Widget _buildProfileSection() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Hero(
            tag: 'profile_avatar',
            child: ProfileAvatar(
              radius: Sizing.kAvatarRadiusBig,
              imageUrl: 'assets/images/dav.jpg',
            ),
          ),
          SizedBox(height: (Sizing.kSizingMultiple).h),
          Text(
            'David Kayode',
            style: Theme.of(context).textTheme.headline3,
          ),
          Text(
            'A/C - BYHDJKSLM',
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ],
      ),
    );
  }

  Widget _buildActionSection() {
    return Column(
      children: [
        CustomListTile(
          onTap: () {
            context.router.push(const ProfileUpdateScreenRoute());
          },
          leading: const Icon(Icons.person_outline_rounded),
          title: 'Profile Information',
          trailing: const Icon(Icons.arrow_right_rounded),
        ),
        CustomListTile(
          onTap: () {
            context.router.push(const SecurityScreenRoute());
          },
          leading: const Icon(Icons.security_outlined),
          title: 'Security',
          trailing: const Icon(Icons.arrow_right_rounded),
        ),
        CustomListTile(
          onTap: () {
            // TODO: open msmpusher's whatsapp support chat
          },
          leading: const Icon(Icons.live_help_outlined),
          title: 'Help & Support',
          trailing: const Icon(Icons.arrow_right_rounded),
        ),
      ],
    );
  }

  Widget _buildSignoutButton() {
    return BlocConsumer<SignoutFormCubit,
        BlocState<Failure<ExceptionMessage>, UnitImpl>>(
      listener: (context, state) {
        state.maybeMap(
          orElse: () => null,
          success: (_) {
            context.router.replaceAll([
              const LoginScreenRoute(),
            ]);
          },
        );
      },
      builder: (context, state) {
        final _isLoading =
            state is Loading<Failure<ExceptionMessage>, UnitImpl>;

        return WidthConstraint(context).withHorizontalSymmetricalPadding(
          child: CustomButton(
            type: ButtonType.regularButton(
              onTap: () {
                HapticFeedback.vibrate();

                context.read<SignoutFormCubit>().signout();
              },
              label: 'Signout',
              isLoadingMode: _isLoading,
              backgroundColor: CustomTypography.kErrorColor,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: (Sizing.kSizingMultiple * 9.75).h),
          Flexible(
            child: Column(
              children: [
                _buildProfileSection(),
                SizedBox(height: (Sizing.kSizingMultiple * 6.25).h),
                _buildActionSection(),
              ],
            ),
          ),
          _buildSignoutButton(),
          SizedBox(height: (Sizing.kSizingMultiple * 2.5).h),
        ],
      ),
    );
  }
}
