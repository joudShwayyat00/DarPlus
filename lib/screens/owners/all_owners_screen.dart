import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/features/assets/data/models/asset_owner.dart';
import 'package:dar_plus_app/features/owners/presentation/providers/owners_providers.dart';
import 'package:dar_plus_app/main.dart';
import 'package:dar_plus_app/screens/home/widgets/owner_avatar.dart';
import 'package:dar_plus_app/screens/owners/owner_profile_screen.dart';
import 'package:dar_plus_app/utils/helpers/app_navigation.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:dar_plus_app/utils/ui/shimmer_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

String _ownerStatusLabel(String status) {
  if (status.isEmpty) return '';
  return status[0].toUpperCase() + status.substring(1);
}

class AllOwnersScreen extends ConsumerWidget {
  const AllOwnersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ownersAsync = ref.watch(ownersControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F7F4),
      body: SafeArea(
        child: Column(
          children: [
            _Header(
              onRefresh: () =>
                  ref.read(ownersControllerProvider.notifier).refresh(),
            ),
            Expanded(
              child: ownersAsync.when(
                data: (owners) => _OwnersList(owners: owners),
                loading: () => _buildShimmer(),
                error: (_, __) => _ErrorState(
                  onRetry: () =>
                      ref.read(ownersControllerProvider.notifier).refresh(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(5.w, 1.h, 5.w, 3.h),
      itemCount: 6,
      separatorBuilder: (_, __) => SizedBox(height: 1.5.h),
      itemBuilder: (_, __) => ShimmerPlaceholder(
        width: double.infinity,
        height: 10.h,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final VoidCallback onRefresh;

  const _Header({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(4.w, 1.h, 4.w, 1.5.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(8),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: AppColors.blackColor,
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              tr.all_owners,
              style: appTextStyle(
                context,
                fontSize: 15.sp,
                fontWeight: FontWeight.w900,
                color: Colors.black.withAlpha(230),
              ),
            ),
          ),
          IconButton(
            onPressed: onRefresh,
            icon: Icon(
              Icons.refresh_rounded,
              color: AppColors.goldBrandColor,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}

class _OwnersList extends ConsumerWidget {
  final List<AssetOwner> owners;

  const _OwnersList({required this.owners});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (owners.isEmpty) {
      return Center(
        child: Text(
          tr.no_owners_found,
          style: appTextStyle(
            context,
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.grayBrandColor,
          ),
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.goldBrandColor,
      onRefresh: () =>
          ref.read(ownersControllerProvider.notifier).refresh(),
      child: ListView.separated(
        padding: EdgeInsets.fromLTRB(5.w, 0.5.h, 5.w, 3.h),
        itemCount: owners.length,
        separatorBuilder: (_, __) => SizedBox(height: 1.5.h),
        itemBuilder: (context, index) {
          final owner = owners[index];
          return _OwnerListTile(
            owner: owner,
            statusLabel: _ownerStatusLabel(owner.status),
            onTap: () => AppNavigator.of(context).push(
              OwnerProfileScreen(ownerId: owner.id, initialOwner: owner),
            ),
          );
        },
      ),
    );
  }
}

class _OwnerListTile extends StatelessWidget {
  final AssetOwner owner;
  final String statusLabel;
  final VoidCallback onTap;

  const _OwnerListTile({
    required this.owner,
    required this.statusLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(3.5.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black.withAlpha(8)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            OwnerAvatar(owner: owner, size: 58),
            SizedBox(width: 3.5.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    owner.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: appTextStyle(
                      context,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.black.withAlpha(230),
                    ),
                  ),
                  SizedBox(height: 0.4.h),
                  Text(
                    owner.email,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: appTextStyle(
                      context,
                      fontSize: 9.5.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black.withAlpha(120),
                    ),
                  ),
                  SizedBox(height: 0.6.h),
                  Row(
                    children: [
                      if (statusLabel.isNotEmpty)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 2.5.w,
                            vertical: 0.35.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.goldBrandColor.withAlpha(20),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            statusLabel,
                            style: appTextStyle(
                              context,
                              fontSize: 8.5.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.goldBrandColor,
                            ),
                          ),
                        ),
                      if (owner.rating != null) ...[
                        SizedBox(width: 2.w),
                        Icon(
                          Icons.star_rounded,
                          size: 14,
                          color: AppColors.goldBrandColor,
                        ),
                        SizedBox(width: 0.5.w),
                        Text(
                          owner.rating!.toStringAsFixed(1),
                          style: appTextStyle(
                            context,
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.goldBrandColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.black.withAlpha(80),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final VoidCallback onRetry;

  const _ErrorState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            tr.error_occurred,
            style: appTextStyle(
              context,
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black.withAlpha(180),
            ),
          ),
          SizedBox(height: 2.h),
          TextButton(
            onPressed: onRetry,
            child: Text(
              tr.try_again,
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
}
