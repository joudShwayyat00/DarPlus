import 'package:cached_network_image/cached_network_image.dart';
import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/features/assets/presentation/providers/assets_providers.dart';
import 'package:dar_plus_app/features/booking/domain/booking_status_filter.dart';
import 'package:dar_plus_app/features/booking/presentation/providers/booking_providers.dart';
import 'package:dar_plus_app/features/rating/presentation/providers/rating_providers.dart';
import 'package:dar_plus_app/main.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:dar_plus_app/utils/widgets/auth_required_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

Future<void> showRateAssetSheet(
  BuildContext context, {
  required int assetId,
  String? assetName,
  String? imageUrl,
}) async {
  if (!await requireAuth(
    context,
    message: tr.login_required_rate_asset,
    icon: Icons.star_rounded,
  )) {
    return;
  }
  if (!context.mounted) return;
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => RateAssetSheet(
      assetId: assetId,
      assetName: assetName,
      imageUrl: imageUrl,
    ),
  );
}

Future<void> showRateAssetDialog(
  BuildContext context, {
  required int assetId,
  String? assetName,
  String? imageUrl,
  BookingStatusFilter? bookingsFilter,
}) async {
  if (!await requireAuth(
    context,
    message: tr.login_required_rate_asset,
    icon: Icons.star_rounded,
  )) {
    return;
  }
  if (!context.mounted) return;
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (_) => RateAssetDialog(
      assetId: assetId,
      assetName: assetName,
      imageUrl: imageUrl,
      bookingsFilter: bookingsFilter,
    ),
  );
}

class RateAssetSheet extends StatelessWidget {
  final int assetId;
  final String? assetName;
  final String? imageUrl;

  const RateAssetSheet({
    super.key,
    required this.assetId,
    this.assetName,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 3.h),
        child: RateAssetForm(
          assetId: assetId,
          assetName: assetName,
          imageUrl: imageUrl,
          onClose: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }
}

class RateAssetDialog extends StatelessWidget {
  final int assetId;
  final String? assetName;
  final String? imageUrl;
  final BookingStatusFilter? bookingsFilter;

  const RateAssetDialog({
    super.key,
    required this.assetId,
    this.assetName,
    this.imageUrl,
    this.bookingsFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Container(
        constraints: BoxConstraints(maxHeight: 75.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(40),
              blurRadius: 32,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(5.w, 2.5.h, 5.w, 3.h),
          child: RateAssetForm(
            assetId: assetId,
            assetName: assetName,
            imageUrl: imageUrl,
            bookingsFilter: bookingsFilter,
            showHeaderImage: true,
            onClose: () => Navigator.of(context).pop(),
          ),
        ),
      ),
    );
  }
}

class RateAssetForm extends ConsumerStatefulWidget {
  final int assetId;
  final String? assetName;
  final String? imageUrl;
  final BookingStatusFilter? bookingsFilter;
  final bool showHeaderImage;
  final VoidCallback onClose;

  const RateAssetForm({
    super.key,
    required this.assetId,
    this.assetName,
    this.imageUrl,
    this.bookingsFilter,
    this.showHeaderImage = false,
    required this.onClose,
  });

  @override
  ConsumerState<RateAssetForm> createState() => _RateAssetFormState();
}

class _RateAssetFormState extends ConsumerState<RateAssetForm> {
  int _selectedRating = 0;
  final _commentCtrl = TextEditingController();

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  String get _ratingLabel {
    switch (_selectedRating) {
      case 1:
        return tr.rating_label_poor;
      case 2:
        return tr.rating_label_fair;
      case 3:
        return tr.rating_label_good;
      case 4:
        return tr.rating_label_great;
      case 5:
        return tr.rating_label_excellent;
      default:
        return tr.how_was_your_experience;
    }
  }

  Future<void> _submit() async {
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
      if (widget.bookingsFilter != null) {
        ref.invalidate(myBookingsControllerProvider(widget.bookingsFilter!));
      } else {
        for (final status in BookingStatusFilter.values) {
          ref.invalidate(myBookingsControllerProvider(status));
        }
      }

      if (!mounted) return;
      EasyLoading.dismiss();
      EasyLoading.showSuccess(tr.rating_saved);
      widget.onClose();
    } catch (e) {
      EasyLoading.dismiss();
      if (!mounted) return;
      final msg = e.toString().replaceFirst('Exception: ', '');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(ratingControllerProvider).isLoading;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!widget.showHeaderImage)
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
        if (widget.showHeaderImage && widget.imageUrl != null) ...[
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: isLoading ? null : widget.onClose,
              icon: Icon(Icons.close_rounded, color: Colors.black.withAlpha(140)),
            ),
          ),
          Center(
            child: Container(
              width: 22.w,
              height: 22.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: AppColors.goldBrandColor.withAlpha(80),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.goldBrandColor.withAlpha(40),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: CachedNetworkImage(
                imageUrl: widget.imageUrl!,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => ColoredBox(
                  color: AppColors.grayBrandColor.withAlpha(30),
                  child: Icon(
                    Icons.home_rounded,
                    color: AppColors.goldBrandColor,
                    size: 28,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 2.h),
        ],
        Text(
          tr.rate_your_stay,
          textAlign: widget.showHeaderImage ? TextAlign.center : TextAlign.start,
          style: appTextStyle(
            context,
            fontSize: 15.sp,
            fontWeight: FontWeight.w900,
            color: Colors.black.withAlpha(230),
          ),
        ),
        if (widget.assetName != null && widget.assetName!.isNotEmpty) ...[
          SizedBox(height: 0.6.h),
          Text(
            widget.assetName!,
            textAlign: widget.showHeaderImage ? TextAlign.center : TextAlign.start,
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
          _ratingLabel,
          textAlign: TextAlign.center,
          style: appTextStyle(
            context,
            fontSize: 11.5.sp,
            fontWeight: FontWeight.w700,
            color: _selectedRating > 0
                ? AppColors.goldBrandColor
                : Colors.black.withAlpha(140),
          ),
        ),
        SizedBox(height: 1.2.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            final star = index + 1;
            final selected = star <= _selectedRating;
            return GestureDetector(
              onTap: isLoading
                  ? null
                  : () => setState(() => _selectedRating = star),
              child: AnimatedScale(
                scale: selected ? 1.08 : 1.0,
                duration: const Duration(milliseconds: 180),
                child: Icon(
                  selected ? Icons.star_rounded : Icons.star_outline_rounded,
                  color: selected
                      ? AppColors.goldBrandColor
                      : Colors.black.withAlpha(50),
                  size: 38,
                ),
              ),
            );
          }),
        ),
        SizedBox(height: 2.h),
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
          style: appTextStyle(context, fontSize: 11.sp),
          decoration: InputDecoration(
            hintText: tr.comment_hint,
            hintStyle: appTextStyle(
              context,
              fontSize: 10.5.sp,
              color: Colors.black.withAlpha(80),
            ),
            filled: true,
            fillColor: const Color(0xFFF8F7F4),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.goldBrandColor),
            ),
          ),
        ),
        SizedBox(height: 2.5.h),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: isLoading ? null : widget.onClose,
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 1.4.h),
                  side: BorderSide(color: Colors.black.withAlpha(30)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  tr.cancel,
                  style: appTextStyle(
                    context,
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black.withAlpha(160),
                  ),
                ),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.goldBrandColor,
                  disabledBackgroundColor:
                      AppColors.goldBrandColor.withAlpha(140),
                  padding: EdgeInsets.symmetric(vertical: 1.4.h),
                  elevation: 0,
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
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
