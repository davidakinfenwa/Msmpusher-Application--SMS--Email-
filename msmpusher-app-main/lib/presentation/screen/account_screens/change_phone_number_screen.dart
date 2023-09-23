import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:msmpusher/core/constants.dart';
import 'package:msmpusher/core/util/width_constraints.dart';
import 'package:msmpusher/presentation/widget/widgets.dart';

class ChangePhoneNumberScreen extends StatefulWidget {
  const ChangePhoneNumberScreen({Key? key}) : super(key: key);

  @override
  State<ChangePhoneNumberScreen> createState() =>
      _ChangePhoneNumberScreenState();
}

class _ChangePhoneNumberScreenState extends State<ChangePhoneNumberScreen> {
  late TextEditingController _phoneNumberTextFieldController;

  @override
  void initState() {
    super.initState();

    _phoneNumberTextFieldController = TextEditingController();
  }

  @override
  void dispose() {
    _phoneNumberTextFieldController.dispose();
    super.dispose();
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: Builder(builder: (context) {
        return Text(
          'Change Phone Number',
          style: Theme.of(context).textTheme.headline5,
        );
      }),
    );
  }

  Widget _buildTitleSection() {
    return const Text(
        'Edit your current phone number below to update update your phone number');
  }

  Widget _buildPhoneNumberTextField() {
    return TextFormField(
      controller: _phoneNumberTextFieldController,
      keyboardType: TextInputType.phone,
      textAlignVertical: TextAlignVertical.center,
      decoration: const InputDecoration(
        hintText: 'Phone Number',
      ),
      validator: (value) {
        return _phoneNumberTextFieldController.text.isEmpty
            ? 'Phone number is required!'
            : null;
      },
    );
  }

  Widget _buildChangePasswordButton() {
    return CustomButton(
      type:
          ButtonType.regularButton(onTap: () {}, label: 'Change Phone Number'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: WidthConstraint(context).withHorizontalSymmetricalPadding(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomDivider(),
                _buildTitleSection(),
                SizedBox(height: (Sizing.kSizingMultiple * 2.5).h),
                _buildPhoneNumberTextField(),
                SizedBox(height: (Sizing.kSizingMultiple * 6.75).h),
                _buildChangePasswordButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
