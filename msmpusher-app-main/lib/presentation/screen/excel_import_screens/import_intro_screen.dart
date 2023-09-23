import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:msmpusher/business/blocs/bloc_state.dart';
import 'package:msmpusher/business/blocs/contact_blocs/get_device_file_contacts_cubit/get_device_file_contacts_cubit.dart';
import 'package:msmpusher/core/constants.dart';
import 'package:msmpusher/core/dependence/dependence.dart';
import 'package:msmpusher/core/exceptions/exceptions.dart';
import 'package:msmpusher/core/route/app_router.dart';
import 'package:msmpusher/core/theme/custom_typography.dart';
import 'package:msmpusher/core/util/toast_util.dart';
import 'package:msmpusher/core/util/width_constraints.dart';
import 'package:msmpusher/domain/model/models.dart';
import 'package:msmpusher/presentation/widget/widgets.dart';

class ImportIntroScreen extends StatelessWidget implements AutoRouteWrapper {
  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider<GetDeviceFileContactsCubit>(
      create: (context) => getIt<GetDeviceFileContactsCubit>(),
      child: this,
    );
  }

  const ImportIntroScreen({Key? key}) : super(key: key);

  Widget _buildContactListImage() {
    final _borderRadius = BorderRadius.circular(Sizing.kBorderRadius);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: (Sizing.kSizingMultiple).w),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: _borderRadius,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: CustomTypography.kSecondaryColor50,
              blurRadius: Sizing.kSizingMultiple,
              spreadRadius: Sizing.kSizingMultiple,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: _borderRadius,
          child: Image.asset(
            'assets/images/contact_list.png',
            color: CustomTypography.kLightGreyColor,
            colorBlendMode: BlendMode.darken,
          ),
        ),
      ),
    );
  }

  Widget _buildTopSection() {
    return Builder(builder: (context) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Uploading File Contacts',
            style: Theme.of(context).textTheme.headline3!.copyWith(
                  color: CustomTypography.kWhiteColor,
                ),
          ),
          SizedBox(height: (Sizing.kSizingMultiple * .5).h),
          Text(
            'To successfully import contacts from file, your excel file should specify all contact-numbers in the first column (as indicated below).',
            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                  color: CustomTypography.kGreyColor,
                ),
          ),
          SizedBox(height: (Sizing.kSizingMultiple * 4).h),
          _buildContactListImage(),
        ],
      );
    });
  }

  Widget _buildSelectFileButton() {
    return BlocConsumer<GetDeviceFileContactsCubit,
        BlocState<Failure<ExceptionMessage>, ContactModelList>>(
      listener: (context, state) {
        state.maybeMap(
          orElse: () => null,
          success: (_) {
            context.router.replace(const FileContactsViewScreenRoute());
          },
          error: (state) {
            ToastUtil.showToast(state.failure.exception.message.toString());
          },
        );
      },
      builder: (context, state) {
        final _isLoading =
            state is Loading<Failure<ExceptionMessage>, ContactModelList>;

        return CustomButton(
          type: ButtonType.regularButton(
            onTap: () {
              context
                  .read<GetDeviceFileContactsCubit>()
                  .getDeviceFileContacts();
            },
            label: 'Select Excel File',
            isLoadingMode: _isLoading,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomTypography.kDarkPrimaryColor,
      body: WidthConstraint(context).withHorizontalSymmetricalPadding(
        child: Column(
          children: [
            Expanded(child: _buildTopSection()),
            _buildSelectFileButton(),
            SizedBox(height: (Sizing.kSizingMultiple * 4).h),
          ],
        ),
      ),
    );
  }
}
