import 'package:dar_plus_app/utils/helpers/app_navigation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

/// Circular back button used consistently across the app.
class AppBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? backgroundColor;

  const AppBackButton({
    super.key,
    this.onPressed,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed ?? () => AppNavigator.of(context).pop(),
      icon: Icon(
        Icons.arrow_back_ios_new_rounded,
        color: Colors.black.withAlpha(200),
        size: 18,
      ),
      iconSize: 18,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
      style: IconButton.styleFrom(
        backgroundColor: backgroundColor ?? Colors.grey.shade100,
        shape: const CircleBorder(),
        elevation: 0,
      ),
    );
  }
}

/// Standard [AppBar.leading] wrapper with left padding.
class AppBarBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? backgroundColor;

  const AppBarBackButton({
    super.key,
    this.onPressed,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 3.w),
      child: AppBackButton(
        onPressed: onPressed,
        backgroundColor: backgroundColor,
      ),
    );
  }
}

/// Preferred [AppBar.leadingWidth] when using [AppBarBackButton].
const double kAppBarBackLeadingWidth = 52;
