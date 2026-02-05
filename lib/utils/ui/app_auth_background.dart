import 'dart:ui';
import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class AppAuthBackground extends StatelessWidget {
  final Widget child;

  const AppAuthBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.whiteColor,
        body: Stack(
          children: [
            Positioned(
              top: -8.h,
              right: -12.w,
              child: _BlurCircle(
                size: 34.w,
                color: AppColors.goldBrandColor.withAlpha(51),
              ),
            ),
            Positioned(
              bottom: -10.h,
              left: -18.w,
              child: _BlurCircle(
                size: 42.w,
                color: AppColors.goldBrandColor.withAlpha(31),
              ),
            ),
        
            // Screen content
            child,
          ],
        ),
      ),
    );
  }
}

/// Reusable blur circle
class _BlurCircle extends StatelessWidget {
  final double size;
  final Color color;

  const _BlurCircle({
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
        child: Container(
          width: size,
          height: size,
          color: color,
        ),
      ),
    );
  }
}
