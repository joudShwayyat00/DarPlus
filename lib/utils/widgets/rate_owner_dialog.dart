import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/features/assets/data/models/asset_owner.dart';
import 'package:dar_plus_app/features/owners/presentation/providers/owners_providers.dart';
import 'package:dar_plus_app/features/rating/presentation/providers/rating_providers.dart';
import 'package:dar_plus_app/main.dart';
import 'package:dar_plus_app/screens/home/widgets/owner_avatar.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:dar_plus_app/utils/widgets/auth_required_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

Future<void> showRateOwnerDialog(
  BuildContext context, {
  required int ownerId,
  required AssetOwner owner,
}) async {
  if (!await requireAuth(
    context,
    message: tr.login_required_rate_owner,
    icon: Icons.star_rounded,
  )) {
    return;
  }
  if (!context.mounted) return;
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (_) => RateOwnerDialog(ownerId: ownerId, owner: owner),
  );
}

class RateOwnerDialog extends StatelessWidget {
  final int ownerId;
  final AssetOwner owner;

  const RateOwnerDialog({
    super.key,
    required this.ownerId,
    required this.owner,
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
          child: RateOwnerForm(
            ownerId: ownerId,
            owner: owner,
            onClose: () => Navigator.of(context).pop(),
          ),
        ),
      ),
    );
  }
}

class RateOwnerForm extends ConsumerStatefulWidget {
  final int ownerId;
  final AssetOwner owner;
  final VoidCallback onClose;

  const RateOwnerForm({
    super.key,
    required this.ownerId,
    required this.owner,
    required this.onClose,
  });

  @override
  ConsumerState<RateOwnerForm> createState() => _RateOwnerFormState();
}

class _RateOwnerFormState extends ConsumerState<RateOwnerForm> {
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
      await ref.read(ratingControllerProvider.notifier).submitOwner(
            ownerId: widget.ownerId,
            rating: _selectedRating,
            comment: _commentCtrl.text.trim().isEmpty
                ? null
                : _commentCtrl.text.trim(),
          );

      ref.invalidate(ownerDetailControllerProvider(widget.ownerId));
      ref.invalidate(ownersControllerProvider);

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
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            onPressed: isLoading ? null : widget.onClose,
            icon: Icon(Icons.close_rounded, color: Colors.black.withAlpha(140)),
          ),
        ),
        Center(child: OwnerAvatar(owner: widget.owner, size: 72)),
        SizedBox(height: 2.h),
        Text(
          tr.rate_this_owner,
          textAlign: TextAlign.center,
          style: appTextStyle(
            context,
            fontSize: 15.sp,
            fontWeight: FontWeight.w900,
            color: Colors.black.withAlpha(230),
          ),
        ),
        SizedBox(height: 0.6.h),
        Text(
          widget.owner.name,
          textAlign: TextAlign.center,
          style: appTextStyle(
            context,
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black.withAlpha(120),
          ),
        ),
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
        SizedBox(height: 0.8.h),
        TextField(
          controller: _commentCtrl,
          enabled: !isLoading,
          maxLines: 3,
          maxLength: 500,
          decoration: InputDecoration(
            hintText: tr.comment_hint,
            filled: true,
            fillColor: const Color(0xFFF8F7F4),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 4.w,
              vertical: 1.5.h,
            ),
          ),
        ),
        SizedBox(height: 2.h),
        SizedBox(
          height: 52,
          child: ElevatedButton(
            onPressed: isLoading ? null : _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.goldBrandColor,
              foregroundColor: Colors.white,
              disabledBackgroundColor:
                  AppColors.goldBrandColor.withAlpha(120),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
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
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
