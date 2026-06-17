import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/controller/shared_prefs.dart';
import 'package:dar_plus_app/features/assets/presentation/providers/assets_providers.dart';
import 'package:dar_plus_app/features/rating/presentation/providers/rating_providers.dart';
import 'package:dar_plus_app/main.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

Future<void> showRateAssetSheet(
  BuildContext context, {
  required int assetId,
  String? assetName,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => RateAssetSheet(assetId: assetId, assetName: assetName),
  );
}

class RateAssetSheet extends ConsumerStatefulWidget {
  final int assetId;
  final String? assetName;

  const RateAssetSheet({
    super.key,
    required this.assetId,
    this.assetName,
  });

  @override
  ConsumerState<RateAssetSheet> createState() => _RateAssetSheetState();
}

class _RateAssetSheetState extends ConsumerState<RateAssetSheet> {
  int _selectedRating = 0;
  final _commentCtrl = TextEditingController();

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!SharedPerfManager().isLoggedIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(tr.login_to_rate)),
      );
      return;
    }
    if (_selectedRating < 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(tr.please_select_rating)),
      );
      return;
    }

    EasyLoading.show();
    try {
      await ref.read(ratingControllerProvider.notifier).submit(
            assetId: widget.assetId,
            rating: _selectedRating,
            comment: _commentCtrl.text.trim().isEmpty
                ? null
                : _commentCtrl.text.trim(),
          );

      ref.invalidate(topRatedAssetsControllerProvider);
      ref.invalidate(assetsControllerProvider);
      ref.invalidate(myAssetsControllerProvider);
      ref.invalidate(assetDetailControllerProvider(widget.assetId));

      if (!mounted) return;
      EasyLoading.showSuccess(tr.rating_saved);
      Navigator.of(context).pop();
    } catch (e) {
      EasyLoading.dismiss();
      if (!mounted) return;
      final msg = e.toString().replaceFirst('Exception: ', '');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final isLoading = ref.watch(ratingControllerProvider).isLoading;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 3.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(30),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              tr.rate_asset,
              style: appTextStyle(
                context,
                fontSize: 14.sp,
                fontWeight: FontWeight.w900,
                color: Colors.black.withAlpha(230),
              ),
            ),
            if (widget.assetName != null && widget.assetName!.isNotEmpty) ...[
              SizedBox(height: 0.6.h),
              Text(
                widget.assetName!,
                style: appTextStyle(
                  context,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black.withAlpha(120),
                ),
              ),
            ],
            SizedBox(height: 2.h),
            Text(
              tr.your_rating,
              style: appTextStyle(
                context,
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black.withAlpha(180),
              ),
            ),
            SizedBox(height: 1.2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                final star = index + 1;
                final selected = star <= _selectedRating;
                return IconButton(
                  onPressed: isLoading
                      ? null
                      : () => setState(() => _selectedRating = star),
                  icon: Icon(
                    selected ? Icons.star_rounded : Icons.star_outline_rounded,
                    color: AppColors.goldBrandColor,
                    size: 34,
                  ),
                );
              }),
            ),
            SizedBox(height: 1.5.h),
            Text(
              tr.comment_optional,
              style: appTextStyle(
                context,
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black.withAlpha(180),
              ),
            ),
            SizedBox(height: 1.h),
            TextField(
              controller: _commentCtrl,
              maxLines: 3,
              enabled: !isLoading,
              cursorColor: AppColors.goldBrandColor,
              decoration: InputDecoration(
                hintText: tr.comment_hint,
                filled: true,
                fillColor: AppColors.grayBrandColor.withAlpha(12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.goldBrandColor),
                ),
              ),
            ),
            SizedBox(height: 2.5.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.goldBrandColor,
                  disabledBackgroundColor:
                      AppColors.goldBrandColor.withAlpha(140),
                  padding: EdgeInsets.symmetric(vertical: 1.5.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        tr.submit_rating,
                        style: appTextStyle(
                          context,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
