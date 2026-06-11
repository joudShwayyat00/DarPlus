import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/features/content/data/models/contact_data_item.dart';
import 'package:dar_plus_app/features/content/presentation/providers/content_providers.dart';
import 'package:dar_plus_app/main.dart';
import 'package:dar_plus_app/screens/profile/widgets/content_widgets.dart';
import 'package:dar_plus_app/utils/helpers/external_link_launcher.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';

class ContactUsScreen extends ConsumerWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(contactDataControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black.withAlpha(200),
            size: 20,
          ),
        ),
        title: Text(
          tr.contact_us,
          style: appTextStyle(
            context,
            fontSize: 14.sp,
            fontWeight: FontWeight.w800,
            color: Colors.black.withAlpha(220),
          ),
        ),
        centerTitle: true,
      ),
      body: async.when(
        data: (item) => _ContactBody(item: item),
        loading: () => Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(AppColors.goldBrandColor),
          ),
        ),
        error: (_, __) => Center(
          child: ContentErrorRetry(
            onRetry: () => ref.invalidate(contactDataControllerProvider),
          ),
        ),
      ),
    );
  }
}

class _ContactBody extends StatelessWidget {
  final ContactDataItem item;

  const _ContactBody({required this.item});

  @override
  Widget build(BuildContext context) {
    final contactMethods = _buildContactMethods(context);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 2.h),
          if (contactMethods.isNotEmpty) ...[
            ..._chunked(contactMethods, 2).map(
              (row) => Padding(
                padding: EdgeInsets.only(bottom: 2.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var i = 0; i < row.length; i++) ...[
                      if (i > 0) SizedBox(width: 3.w),
                      Expanded(child: row[i]),
                    ],
                    if (row.length == 1) const Spacer(),
                  ],
                ),
              ),
            ),
          ],
          if (item.hasSocialLinks) ...[
            if (contactMethods.isNotEmpty) SizedBox(height: 2.h),
            _buildSocialSection(context),
          ],
          if (!item.hasContactInfo && !item.hasSocialLinks)
            Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: Center(
                child: Text(
                  tr.no_results_found,
                  style: appTextStyle(
                    context,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black.withAlpha(100),
                  ),
                ),
              ),
            ),
          SizedBox(height: 3.h),
        ],
      ),
    );
  }

  List<Widget> _buildContactMethods(BuildContext context) {
    final methods = <Widget>[];

    if (item.displayPhone != null) {
      methods.add(
        _ContactMethodCard(
          icon: Icons.phone_rounded,
          title: tr.phone,
          subtitle: item.displayPhone!,
          onTap: () => launchPhoneCall(item.displayPhone!),
        ),
      );
    }

    if (item.displayEmail != null) {
      methods.add(
        _ContactMethodCard(
          icon: Icons.email_rounded,
          title: tr.email,
          subtitle: item.displayEmail!,
          onTap: () => launchEmail(item.displayEmail!),
        ),
      );
    }

    if (item.displayAddress != null) {
      methods.add(
        _ContactMethodCard(
          icon: Icons.location_on_rounded,
          title: tr.address,
          subtitle: item.displayAddress!,
          onTap: null,
        ),
      );
    }

    return methods;
  }

  Widget _buildSocialSection(BuildContext context) {
    final links = <_SocialLink>[
      if (item.instagramUrl != null)
        _SocialLink(
          icon: FontAwesomeIcons.instagram,
          color: const Color(0xFFE4405F),
          url: item.instagramUrl!,
        ),
      if (item.facebookUrl != null)
        _SocialLink(
          icon: FontAwesomeIcons.facebook,
          color: const Color(0xFF1877F2),
          url: item.facebookUrl!,
        ),
      if (item.xUrl != null)
        _SocialLink(
          icon: FontAwesomeIcons.xTwitter,
          color: Colors.black87,
          url: item.xUrl!,
        ),
      if (item.youtubeUrl != null)
        _SocialLink(
          icon: FontAwesomeIcons.youtube,
          color: const Color(0xFFFF0000),
          url: item.youtubeUrl!,
        ),
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 3.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Text(
            tr.connect_with_us,
            style: appTextStyle(
              context,
              fontSize: 13.sp,
              fontWeight: FontWeight.w800,
              color: Colors.black.withAlpha(180),
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            tr.follow_us_on_social_media,
            style: appTextStyle(
              context,
              fontSize: 9.5.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black.withAlpha(100),
            ),
          ),
          SizedBox(height: 2.5.h),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 3.w,
            runSpacing: 1.5.h,
            children: links
                .map(
                  (link) => _SocialButton(
                    icon: link.icon,
                    iconColor: link.color,
                    onTap: () => launchExternalLink(link.url),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  List<List<T>> _chunked<T>(List<T> items, int size) {
    final chunks = <List<T>>[];
    for (var i = 0; i < items.length; i += size) {
      chunks.add(items.sublist(i, i + size > items.length ? items.length : i + size));
    }
    return chunks;
  }
}

class _SocialLink {
  final FaIconData icon;
  final Color color;
  final String url;

  const _SocialLink({
    required this.icon,
    required this.color,
    required this.url,
  });
}

class _ContactMethodCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _ContactMethodCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black.withAlpha(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(6),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(2.5.w),
              decoration: BoxDecoration(
                color: AppColors.goldBrandColor.withAlpha(15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.goldBrandColor, size: 20),
            ),
            SizedBox(height: 1.5.h),
            Text(
              title,
              style: appTextStyle(
                context,
                fontSize: 11.sp,
                fontWeight: FontWeight.w800,
                color: Colors.black.withAlpha(200),
              ),
            ),
            SizedBox(height: 0.3.h),
            Text(
              subtitle,
              style: appTextStyle(
                context,
                fontSize: 9.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black.withAlpha(120),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final FaIconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const _SocialButton({
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(3.8.w),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          shape: BoxShape.circle,
        ),
        child: FaIcon(icon, color: iconColor, size: 22),
      ),
    );
  }
}
