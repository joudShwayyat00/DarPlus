import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/features/content/data/models/content_page_item.dart';
import 'package:dar_plus_app/features/content/presentation/providers/content_providers.dart';
import 'package:dar_plus_app/main.dart';
import 'package:dar_plus_app/screens/profile/widgets/content_widgets.dart';
import 'package:dar_plus_app/utils/ui/app_back_button.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class PrivacyPolicyScreen extends ConsumerWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(privacyPolicyControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leadingWidth: kAppBarBackLeadingWidth,
        leading: const AppBarBackButton(),
        title: Text(
          tr.privacy_policy,
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
        data: (items) => _buildContent(context, items),
        loading: () => Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(AppColors.goldBrandColor),
          ),
        ),
        error: (_, __) => Center(
          child: ContentErrorRetry(
            onRetry: () => ref.invalidate(privacyPolicyControllerProvider),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, List<ContentPageItem> items) {
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 3.h),
      itemCount: items.length,
      separatorBuilder: (_, __) => SizedBox(height: 1.5.h),
      itemBuilder: (context, index) => ContentCard(
        title: items[index].title,
        child: HtmlBody(html: items[index].description),
      ),
    );
  }
}
