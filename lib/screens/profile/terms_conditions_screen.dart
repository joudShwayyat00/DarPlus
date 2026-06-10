import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/features/content/data/models/content_page_item.dart';
import 'package:dar_plus_app/features/content/presentation/providers/content_providers.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:dar_plus_app/main.dart';

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
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: EdgeInsets.all(5.w),
            child: Text(
              e.toString().replaceFirst('Exception: ', ''),
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        data: (items) => items.isEmpty
            ? Center(
                child: Text(
                  tr.terms_and_conditions,
                  style: appTextStyle(
                    context,
                    fontSize: 12.sp,
                    color: Colors.black.withAlpha(120),
                  ),
                ),
              )
            : ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                itemCount: items.length,
                separatorBuilder: (_, __) => SizedBox(height: 1.5.h),
                itemBuilder: (context, index) =>
                    _ContentCard(item: items[index]),
              ),
      ),
    );
  }
}

class _ContentCard extends StatelessWidget {
  const _ContentCard({required this.item});

  final ContentPageItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(4.w, 3.h, 4.w, 1.h),
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
          Text(
            item.title,
            style: appTextStyle(
              context,
              fontSize: 13.sp,
              fontWeight: FontWeight.w800,
              color: Colors.black.withAlpha(220),
            ),
          ),
          Html(
            data: item.description,
            style: {
              'body': Style(
                fontSize: FontSize(10.5.sp),
                fontWeight: FontWeight.w500,
                color: Colors.black.withAlpha(150),
                lineHeight: const LineHeight(1.6),
                margin: Margins.zero,
                padding: HtmlPaddings.zero,
              ),
              'p': Style(margin: Margins.only(top: 4, bottom: 4)),
            },
          ),
        ],
      ),
    );
  }
}

