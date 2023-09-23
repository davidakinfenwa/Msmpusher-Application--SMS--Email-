import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:msmpusher/core/constants.dart';
import 'package:msmpusher/core/util/width_constraints.dart';
import 'package:msmpusher/presentation/widget/widgets.dart';

class ProfileUpdateScreen extends StatefulWidget {
  const ProfileUpdateScreen({Key? key}) : super(key: key);

  @override
  State<ProfileUpdateScreen> createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  late TextEditingController _fullNameTextFieldController;
  late TextEditingController _phoneNumberTextFieldController;
  late TextEditingController _emailTextFieldController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _fullNameTextFieldController = TextEditingController();
    _phoneNumberTextFieldController = TextEditingController();
    _emailTextFieldController = TextEditingController();
  }

  @override
  void dispose() {
    _fullNameTextFieldController.dispose();
    _phoneNumberTextFieldController.dispose();
    _emailTextFieldController.dispose();
    super.dispose();
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: Text(
        'Profile Information',
        style: Theme.of(context).textTheme.headline5,
      ),
    );
  }

  Widget _buildTopSection() {
    return const Text(
        'Change profile information details and save to update your profile');
  }

  Widget _buildFullNameTextField() {
    return TextFormField(
      controller: _fullNameTextFieldController,
      textAlignVertical: TextAlignVertical.center,
      decoration: const InputDecoration(
        hintText: 'Fullname',
      ),
      validator: (value) {
        return _fullNameTextFieldController.text.isEmpty
            ? 'Full name is required!'
            : null;
      },
    );
  }

  Widget _buildPhoneNumberTextField() {
    return TextFormField(
      controller: _phoneNumberTextFieldController,
      keyboardType: TextInputType.phone,
      textAlignVertical: TextAlignVertical.center,
      decoration: const InputDecoration(
        hintText: 'Phone number',
      ),
      validator: (value) {
        return _phoneNumberTextFieldController.text.isEmpty
            ? 'Phone number is required!'
            : null;
      },
    );
  }

  Widget _buildEmailTextField() {
    return TextFormField(
      controller: _emailTextFieldController,
      keyboardType: TextInputType.emailAddress,
      textAlignVertical: TextAlignVertical.center,
      decoration: const InputDecoration(
        hintText: 'Email',
      ),
      validator: (value) {
        return _phoneNumberTextFieldController.text.isEmpty
            ? 'Email is required!'
            : null;
      },
    );
  }

  Widget _buildFormSection() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildFullNameTextField(),
          SizedBox(height: (Sizing.kSizingMultiple * 1.5).h),
          _buildPhoneNumberTextField(),
          SizedBox(height: (Sizing.kSizingMultiple * 1.5).h),
          _buildEmailTextField(),
        ],
      ),
    );
  }

  Widget _buildUpdateProfileButton() {
    return CustomButton(
      type: ButtonType.regularButton(onTap: () {}, label: 'Update Profile'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: WidthConstraint(context).withHorizontalSymmetricalPadding(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomDivider(),
              SizedBox(height: (Sizing.kSizingMultiple * 2.5).h),
              _buildTopSection(),
              SizedBox(height: (Sizing.kSizingMultiple * 2.5).h),
              _buildFormSection(),
              SizedBox(height: (Sizing.kSizingMultiple * 6.25).h),
              _buildUpdateProfileButton(),
            ],
          ),
        ),
      ),
    );
  }
}
