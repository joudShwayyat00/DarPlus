import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/features/content/data/models/content_page_item.dart';
import 'package:dar_plus_app/features/content/presentation/providers/content_providers.dart';
import 'package:dar_plus_app/main.dart';
import 'package:dar_plus_app/screens/profile/widgets/content_widgets.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class TermsConditionsScreen extends ConsumerWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(termsControllerProvider);

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
          tr.terms_and_conditions,
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
        data: (items) => _buildList(context, items),
        loading: () => Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(AppColors.goldBrandColor),
          ),
        ),
        error: (_, __) => Center(
          child: ContentErrorRetry(
            onRetry: () => ref.invalidate(termsControllerProvider),
          ),
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, List<ContentPageItem> items) {
    if (items.isEmpty) {
      return Center(
        child: Text(
          tr.terms_and_conditions,
          style: appTextStyle(
            context,
            fontSize: 12.sp,
            color: Colors.black.withAlpha(120),
          ),
        ),
      );
    }
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
