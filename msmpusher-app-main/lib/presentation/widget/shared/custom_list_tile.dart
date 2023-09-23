import 'package:flutter/material.dart';
import 'package:msmpusher/core/theme/custom_typography.dart';
import 'package:msmpusher/core/util/width_constraints.dart';
import 'package:msmpusher/presentation/widget/widgets.dart';

class CustomListTile extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget? leading;
  final String title;
  final String? description;
  final Widget? trailing;

  const CustomListTile({
    Key? key,
    this.onTap,
    this.leading,
    required this.title,
    this.description,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          constraints: BoxConstraints(
            maxWidth: WidthConstraint(context).maxWidthConstraint,
          ),
          child: ListTile(
            onTap: onTap,
            contentPadding: EdgeInsets.symmetric(
              horizontal: WidthConstraint(context).contentPadding,
            ),
            leading: leading == null
                ? null
                : CircleAvatar(
                    backgroundColor: CustomTypography.kLightGreyColor,
                    foregroundColor: CustomTypography.kMidGreyColor,
                    child: leading,
                  ),
            title: Text(title, overflow: TextOverflow.ellipsis),
            subtitle: description == null
                ? null
                : Text(
                    description!,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
            trailing: trailing,
          ),
        ),
        const CustomDivider(),
      ],
    );
  }
}
