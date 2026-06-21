import 'package:dar_plus_app/screens/assets/my_assets_screen.dart';
import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/controller/local_provider.dart';
import 'package:dar_plus_app/screens/auth/login_screen.dart';
import 'package:dar_plus_app/screens/auth/sign_up_screen.dart';
import 'package:dar_plus_app/screens/auth/welcome_screen.dart';
import 'package:dar_plus_app/screens/profile/about_screen.dart';
import 'package:dar_plus_app/screens/profile/contact_us_screen.dart';
import 'package:dar_plus_app/screens/profile/edit_profile_screen.dart';
import 'package:dar_plus_app/screens/profile/update_password_screen.dart';
import 'package:dar_plus_app/screens/profile/get_help_screen.dart';
import 'package:dar_plus_app/screens/profile/my_reservations_screen.dart';
import 'package:dar_plus_app/screens/profile/notifications_screen.dart';
import 'package:dar_plus_app/screens/profile/privacy_policy_screen.dart';
import 'package:dar_plus_app/screens/profile/subscriptions_screen.dart';
import 'package:dar_plus_app/screens/profile/terms_conditions_screen.dart';
import 'package:dar_plus_app/utils/helpers/app_navigation.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:dar_plus_app/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/auth/data/models/user_model.dart';
import '../../features/notifications/presentation/providers/notifications_providers.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final isLoggedIn = ref.watch(isLoggedInProvider);
    final notificationBadge = isLoggedIn
        ? ref
              .watch(notificationsControllerProvider)
              .maybeWhen(
                data: (notifications) {
                  if (notifications.isEmpty) return null;
                  return _buildNotificationBadge(context, notifications.length);
                },
                orElse: () => null,
              )
        : null;

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 2.h),

              // Profile Header
              ref
                  .watch(profileControllerProvider)
                  .when(
                    data: (user) => user == null
                        ? _buildGuestHeader(context)
                        : _buildProfileHeader(context, user),
                    loading: () => _buildProfileHeaderLoading(context),
                    error: (err, stack) =>
                        _buildProfileHeaderError(context, err),
                  ),

              SizedBox(height: 2.5.h),

              // Menu Sections
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Account Section
                    _buildSectionTitle(context, tr.account),
                    SizedBox(height: 1.2.h),
                    _buildMenuCard(
                      context,
                      items: [
                        if (isLoggedIn) ...[
                          _MenuItem(
                            icon: Icons.person_outline_rounded,
                            title: tr.edit_profile,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const EditProfileScreen(),
                                ),
                              );
                            },
                          ),
                          _MenuItem(
                            icon: Icons.lock_outline_rounded,
                            title: tr.change_password,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const UpdatePasswordScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                        if (isLoggedIn &&
                            ref
                                    .watch(profileControllerProvider)
                                    .value
                                    ?.isOwner ==
                                true)
                          _MenuItem(
                            icon: Icons.apartment_rounded,
                            title: tr.my_assets,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MyAssetsScreen(),
                                ),
                              );
                            },
                          ),
                        if (isLoggedIn)
                          _MenuItem(
                            icon: Icons.calendar_month_rounded,
                            title: tr.my_reservations,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const MyReservationsScreen(),
                                ),
                              );
                            },
                          ),
                        _MenuItem(
                          icon: Icons.card_membership_rounded,
                          title: tr.subscriptions,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const SubscriptionsScreen(),
                              ),
                            );
                          },
                        ),
                        _MenuItem(
                          icon: Icons.notifications_outlined,
                          title: tr.notifications,
                          trailing: notificationBadge,
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const NotificationsScreen(),
                              ),
                            );
                            if (ref.read(isLoggedInProvider)) {
                              ref.invalidate(notificationsControllerProvider);
                            }
                          },
                        ),
                      ],
                    ),

                    SizedBox(height: 2.5.h),

                    // Preferences Section
                    _buildSectionTitle(context, tr.preferences),
                    SizedBox(height: 1.2.h),
                    _buildMenuCard(
                      context,
                      items: [
                        _MenuItem(
                          icon: Icons.language_rounded,
                          title: tr.change_language,
                          trailing: Text(
                            tr.english,
                            style: appTextStyle(
                              context,
                              fontSize: 10.5.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.goldBrandColor,
                            ),
                          ),
                          onTap: () {
                            _showLanguageBottomSheet(context);
                          },
                        ),
                      ],
                    ),

                    SizedBox(height: 2.5.h),

                    // Support Section
                    _buildSectionTitle(context, tr.support),
                    SizedBox(height: 1.2.h),
                    _buildMenuCard(
                      context,
                      items: [
                        _MenuItem(
                          icon: Icons.help_outline_rounded,
                          title: tr.get_help,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const GetHelpScreen(),
                              ),
                            );
                          },
                        ),
                        _MenuItem(
                          icon: Icons.headset_mic_outlined,
                          title: tr.contact_us,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ContactUsScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),

                    SizedBox(height: 2.5.h),

                    // Legal Section
                    _buildSectionTitle(context, tr.legal),
                    SizedBox(height: 1.2.h),
                    _buildMenuCard(
                      context,
                      items: [
                        _MenuItem(
                          icon: Icons.info_outline_rounded,
                          title: tr.about,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AboutScreen(),
                              ),
                            );
                          },
                        ),
                        _MenuItem(
                          icon: Icons.privacy_tip_outlined,
                          title: tr.privacy_policy,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const PrivacyPolicyScreen(),
                              ),
                            );
                          },
                        ),
                        _MenuItem(
                          icon: Icons.description_outlined,
                          title: tr.terms_and_conditions,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const TermsConditionsScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),

                    SizedBox(height: 2.5.h),

                    // Danger Zone — only when logged in
                    if (isLoggedIn)
                      _buildMenuCard(
                        context,
                        items: [
                          _MenuItem(
                            icon: Icons.logout_rounded,
                            title: tr.logout,
                            iconColor: AppColors.goldBrandColor,
                            titleColor: AppColors.goldBrandColor,
                            onTap: () => _showLogoutDialog(context),
                          ),
                          _MenuItem(
                            icon: Icons.delete_outline_rounded,
                            title: tr.delete_account,
                            iconColor: Colors.red,
                            titleColor: Colors.red,
                            showDivider: false,
                            onTap: () {
                              _showDeleteAccountDialog(context);
                            },
                          ),
                        ],
                      )
                    else
                      _buildMenuCard(
                        context,
                        items: [
                          _MenuItem(
                            icon: Icons.login_rounded,
                            title: tr.login,
                            iconColor: AppColors.goldBrandColor,
                            titleColor: AppColors.goldBrandColor,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LoginScreen(),
                                ),
                              );
                            },
                          ),
                          _MenuItem(
                            icon: Icons.person_add_alt_1_rounded,
                            title: tr.create_account,
                            iconColor: AppColors.goldBrandColor,
                            titleColor: AppColors.goldBrandColor,
                            showDivider: false,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const SignUpScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),

                    SizedBox(height: 2.h),

                    // App Version
                    Center(
                      child: Text(
                        '${tr.version} 1.0.0',
                        style: appTextStyle(
                          context,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black.withAlpha(100),
                        ),
                      ),
                    ),

                    SizedBox(height: 3.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGuestHeader(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.w),
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.goldBrandColor.withAlpha(25), Colors.white],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.goldBrandColor.withAlpha(40)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.goldBrandColor.withAlpha(25),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person_outline_rounded,
              size: 36,
              color: AppColors.goldBrandColor,
            ),
          ),
          SizedBox(height: 1.8.h),
          Text(
            tr.sign_in_to_continue,
            textAlign: TextAlign.center,
            style: appTextStyle(
              context,
              fontSize: 14.sp,
              fontWeight: FontWeight.w900,
              color: Colors.black.withAlpha(230),
            ),
          ),
          SizedBox(height: 0.8.h),
          Text(
            tr.login_required_account,
            textAlign: TextAlign.center,
            style: appTextStyle(
              context,
              fontSize: 10.5.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black.withAlpha(120),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, UserModel user) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.goldBrandColor.withAlpha(60)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 18.w,
            height: 18.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.goldBrandColor.withAlpha(30),
            ),
            child: ClipOval(
              child: user.image != null
                  ? Image.network(
                      user.image!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildInitials(context, user.name),
                    )
                  : _buildInitials(context, user.name),
            ),
          ),

          SizedBox(width: 4.w),

          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: appTextStyle(
                    context,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w900,
                    color: Colors.black.withAlpha(230),
                  ),
                ),
                SizedBox(height: 0.4.h),
                Text(
                  user.email,
                  style: appTextStyle(
                    context,
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black.withAlpha(140),
                  ),
                ),
                SizedBox(height: 0.6.h),
                // Container(
                //   padding: EdgeInsets.symmetric(
                //     horizontal: 2.5.w,
                //     vertical: 0.4.h,
                //   ),
                //   decoration: BoxDecoration(
                //     color: AppColors.goldBrandColor.withAlpha(20),
                //     borderRadius: BorderRadius.circular(999),
                //   ),
                //   child: Text(
                //     tr.premium_member,
                //     style: appTextStyle(
                //       context,
                //       fontSize: 9.sp,
                //       fontWeight: FontWeight.w700,
                //       color: AppColors.goldBrandColor,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInitials(BuildContext context, String name) {
    final initials = name.isNotEmpty
        ? name.trim().split(' ').map((l) => l[0]).take(2).join().toUpperCase()
        : "U";
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.goldBrandColor.withAlpha(180),
            AppColors.goldBrandColor,
          ],
        ),
      ),
      child: Center(
        child: Text(
          initials,
          style: appTextStyle(
            context,
            fontSize: 16.sp,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeaderLoading(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.w),
      padding: EdgeInsets.all(4.w),
      height: 15.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black.withAlpha(10)),
      ),
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildProfileHeaderError(BuildContext context, Object error) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.red.withAlpha(10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.red.withAlpha(30)),
      ),
      child: Column(
        children: [
          Text(
            tr.error_occurred,
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                ref.read(profileControllerProvider.notifier).refreshProfile(),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: appTextStyle(
        context,
        fontSize: 13.sp,
        fontWeight: FontWeight.w900,
        color: Colors.black.withAlpha(240),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required List<_MenuItem> items,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black.withAlpha(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isLast = index == items.length - 1;

          return _buildMenuTile(
            context,
            item: item,
            showDivider: item.showDivider && !isLast,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMenuTile(
    BuildContext context, {
    required _MenuItem item,
    required bool showDivider,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: item.onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.6.h),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.5.w),
                  decoration: BoxDecoration(
                    color: (item.iconColor ?? Colors.black).withAlpha(15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    item.icon,
                    size: 20,
                    color: item.iconColor ?? Colors.black.withAlpha(180),
                  ),
                ),
                SizedBox(width: 3.5.w),
                Expanded(
                  child: Text(
                    item.title,
                    style: appTextStyle(
                      context,
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w700,
                      color: item.titleColor ?? Colors.black.withAlpha(210),
                    ),
                  ),
                ),
                if (item.trailing != null) item.trailing!,
                if (item.trailing == null && item.onTap != null)
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 22,
                    color: Colors.black.withAlpha(100),
                  ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Divider(height: 1, color: Colors.black.withAlpha(10)),
          ),
      ],
    );
  }

  Widget _buildNotificationBadge(BuildContext context, int count) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 0.4.h),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        count.toString(),
        style: appTextStyle(
          context,
          fontSize: 9.sp,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
    );
  }

  void _showLanguageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(5.w),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(40),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              tr.select_language,
              style: appTextStyle(
                context,
                fontSize: 14.sp,
                fontWeight: FontWeight.w900,
                color: Colors.black.withAlpha(230),
              ),
            ),
            SizedBox(height: 2.h),
            _LanguageOption(
              title: tr.english,
              isSelected: true,
              onTap: () {
                ref.read(localeProvider.notifier).setLocale(const Locale('en'));
                Navigator.pop(context);
              },
            ),
            SizedBox(height: 1.h),
            _LanguageOption(
              title: "العربية",
              isSelected: false,
              onTap: () {
                ref.read(localeProvider.notifier).setLocale(const Locale('ar'));
                Navigator.pop(context);
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.whiteColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          tr.logout,
          style: appTextStyle(
            context,
            fontSize: 14.sp,
            fontWeight: FontWeight.w900,
            color: Colors.black.withAlpha(230),
          ),
        ),
        content: Text(
          tr.logout_confirm_message,
          style: appTextStyle(
            context,
            fontSize: 11.5.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black.withAlpha(160),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              tr.cancel,
              style: appTextStyle(
                context,
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black.withAlpha(150),
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await ref.read(profileControllerProvider.notifier).logout();
              if (context.mounted) {
                AppNavigator.of(
                  context,
                ).pushAndRemoveUntil(const WelcomeScreen());
              }
            },
            child: Text(
              tr.logout,
              style: appTextStyle(
                context,
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.goldBrandColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.whiteColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          tr.delete_account,
          style: appTextStyle(
            context,
            fontSize: 14.sp,
            fontWeight: FontWeight.w900,
            color: Colors.red,
          ),
        ),
        content: Text(
          tr.delete_confirm_message,
          style: appTextStyle(
            context,
            fontSize: 11.5.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black.withAlpha(160),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              tr.cancel,
              style: appTextStyle(
                context,
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black.withAlpha(150),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              AppNavigator.of(context).push(WelcomeScreen());
            },
            child: Text(
              tr.delete,
              style: appTextStyle(
                context,
                fontSize: 11.sp,
                fontWeight: FontWeight.w800,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? titleColor;
  final bool showDivider;

  const _MenuItem({
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
    this.iconColor,
    this.titleColor,
    this.showDivider = true,
  });
}

class _LanguageOption extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.6.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.goldBrandColor.withAlpha(15)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? AppColors.goldBrandColor.withAlpha(80)
                : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: appTextStyle(
                  context,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: isSelected
                      ? AppColors.goldBrandColor
                      : Colors.black.withAlpha(180),
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle_rounded,
                color: AppColors.goldBrandColor,
                size: 22,
              ),
          ],
        ),
      ),
    );
  }
}
