import 'package:flutter/material.dart';
import 'package:msmpusher/core/constants.dart';

class ProfileAvatar extends StatelessWidget {
  final String imageUrl;
  final VoidCallback? onTap;
  final double? radius;

  const ProfileAvatar({
    Key? key,
    required this.imageUrl,
    this.onTap,
    this.radius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: radius ?? Sizing.kAvatarRadius,
        foregroundImage: AssetImage(imageUrl),
      ),
    );
  }
}
