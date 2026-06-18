import 'package:cached_network_image/cached_network_image.dart';
import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/configuration/app_images.dart';
import 'package:dar_plus_app/features/assets/data/models/asset_owner.dart';
import 'package:flutter/material.dart';

class OwnerAvatar extends StatelessWidget {
  final AssetOwner owner;
  final double size;
  final bool showRing;

  const OwnerAvatar({
    super.key,
    required this.owner,
    this.size = 52,
    this.showRing = true,
  });

  bool get _hasImage =>
      owner.image != null && owner.image!.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final inner = size - 6;

    Widget avatar = Container(
      width: inner,
      height: inner,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: ClipOval(
        child: _hasImage
            ? CachedNetworkImage(
                imageUrl: owner.image!,
                fit: BoxFit.cover,
                placeholder: (_, __) => _logoAvatar(inner),
                errorWidget: (_, __, ___) => _logoAvatar(inner),
              )
            : _logoAvatar(inner),
      ),
    );

    if (!showRing) return avatar;

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: SweepGradient(
              colors: [
                AppColors.goldBrandColor,
                AppColors.goldBrandColor.withAlpha(80),
                AppColors.goldBrandColor,
              ],
            ),
          ),
        ),
        avatar,
      ],
    );
  }

  Widget _logoAvatar(double avatarSize) {
    return Padding(
      padding: EdgeInsets.all(avatarSize * 0.15),
      child: Image.asset(appLogo, fit: BoxFit.contain),
    );
  }
}
