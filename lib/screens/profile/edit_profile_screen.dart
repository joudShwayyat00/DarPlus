import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/utils/ui/app_buttons.dart';
import 'package:dar_plus_app/utils/ui/app_input_field.dart';
import 'package:dar_plus_app/utils/ui/app_phone_field.dart';
import 'package:dar_plus_app/utils/ui/app_back_button.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:dar_plus_app/main.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  bool _isProfileLoaded = false;
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final FocusNode nameFocusNode = FocusNode();

  final phoneController = TextEditingController();
  final FocusNode phoneFocusNode = FocusNode();
  String _nationalPhoneNumber = '';

  final emailController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();

  String? _currentImageUrl;
  File? _pickedImageFile;

  @override
  void dispose() {
    nameController.dispose();
    nameFocusNode.dispose();
    phoneController.dispose();
    phoneFocusNode.dispose();
    emailController.dispose();
    emailFocusNode.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadImage() async {
    final source = await _showImageSourceSheet();
    if (source == null) return;

    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: source,
      imageQuality: 60,
      maxWidth: 800,
      maxHeight: 800,
    );
    if (picked == null) return;

    setState(() => _pickedImageFile = File(picked.path));
    ref.read(uploadImageControllerProvider.notifier).uploadImage(picked.path);
  }

  Future<ImageSource?> _showImageSourceSheet() async {
    return showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(40),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            ListTile(
              leading: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.goldBrandColor.withAlpha(25),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.photo_library_rounded,
                  color: AppColors.goldBrandColor,
                ),
              ),
              title: Text(
                tr.gallery,
                style: appTextStyle(
                  context,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black.withAlpha(220),
                ),
              ),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.goldBrandColor.withAlpha(25),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.camera_alt_rounded,
                  color: AppColors.goldBrandColor,
                ),
              ),
              title: Text(
                tr.camera,
                style: appTextStyle(
                  context,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black.withAlpha(220),
                ),
              ),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileControllerProvider);

    profileAsync.maybeWhen(
      data: (user) {
        if (user == null) return;
        if (!_isProfileLoaded) {
          nameController.text = user.name;
          phoneController.text = user.phoneNumber;
          emailController.text = user.email;
          _currentImageUrl = user.image;
          _isProfileLoaded = true;
        }
      },
      orElse: () {},
    );

    ref.listen<AsyncValue<dynamic>>(editProfileControllerProvider, (_, next) {
      next.when(
        data: (data) {
          if (data != null) {
            ref.read(profileControllerProvider.notifier).refreshProfile();
            EasyLoading.showSuccess(data.message ?? tr.save_changes);
            Navigator.pop(context);
          }
        },
        error: (e, _) {
          EasyLoading.showError(e.toString().replaceFirst('Exception: ', ''));
        },
        loading: () {},
      );
    });

    ref.listen<AsyncValue<dynamic>>(uploadImageControllerProvider, (_, next) {
      next.when(
        data: (data) {
          if (data != null) {
            setState(() {
              _currentImageUrl = data.image;
              _pickedImageFile = null;
            });
            ref.read(profileControllerProvider.notifier).refreshProfile();
            EasyLoading.showSuccess(tr.upload_photo);
          }
        },
        error: (e, _) {
          setState(() => _pickedImageFile = null);
          EasyLoading.showError(e.toString().replaceFirst('Exception: ', ''));
        },
        loading: () {},
      );
    });

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leadingWidth: kAppBarBackLeadingWidth,
        leading: const AppBarBackButton(),
        title: Text(
          tr.edit_profile,
          style: appTextStyle(
            context,
            fontSize: 14.sp,
            fontWeight: FontWeight.w800,
            color: Colors.black.withAlpha(220),
          ),
        ),
        centerTitle: true,
      ),
      body: profileAsync.when(
        data: (user) => SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Column(
            children: [
              SizedBox(height: 3.h),

              // ── Profile Avatar ──────────────────────────────────────
              _AvatarPicker(
                imageUrl: _currentImageUrl,
                pickedFile: _pickedImageFile,
                isUploading: ref.watch(uploadImageControllerProvider).isLoading,
                onTap: _pickAndUploadImage,
              ),

              SizedBox(height: 3.h),

              // ── Form ────────────────────────────────────────────────
              Container(
                padding: EdgeInsets.all(5.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black.withAlpha(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(8),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel(context, tr.full_name),
                      SizedBox(height: 1.h),
                      AppInputField(
                        controller: nameController,
                        focusNode: nameFocusNode,
                        hint: tr.full_name,
                        prefixIcon: Icons.person_outline,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(phoneFocusNode);
                        },
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return tr.name_required;
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 2.5.h),

                      _buildLabel(context, tr.phone_number),
                      SizedBox(height: 1.h),
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: AppPhoneField(
                          controller: phoneController,
                          focusNode: phoneFocusNode,
                          hint: tr.phone_number,
                          initialCountryCode: "JO",
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(emailFocusNode);
                          },
                          onChangedNationalNumber: (national) {
                            _nationalPhoneNumber = national;
                          },
                        ),
                      ),

                      SizedBox(height: 1.5.h),

                      _buildLabel(context, tr.email),
                      SizedBox(height: 1.h),
                      AppInputField(
                        controller: emailController,
                        focusNode: emailFocusNode,
                        hint: tr.email,
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).unfocus();
                        },
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return tr.email_required;
                          }
                          final pattern =
                              r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$';
                          if (!RegExp(pattern).hasMatch(value.trim())) {
                            return tr.enter_valid_email;
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 4.h),

              Consumer(
                builder: (context, ref, _) {
                  final isLoading = ref
                      .watch(editProfileControllerProvider)
                      .isLoading;
                  return AppButton(
                    backgroundColor: isLoading
                        ? AppColors.goldBrandColor.withAlpha(160)
                        : AppColors.goldBrandColor,
                    onPressed: isLoading
                        ? () {}
                        : () {
                            FocusScope.of(context).unfocus();
                            if (_formKey.currentState!.validate()) {
                              final phone = _nationalPhoneNumber.isNotEmpty
                                  ? _nationalPhoneNumber
                                  : phoneController.text.trim();
                              ref
                                  .read(editProfileControllerProvider.notifier)
                                  .editProfile(
                                    name: nameController.text.trim(),
                                    email: emailController.text.trim(),
                                    phoneNumber: phone,
                                  );
                            }
                          },
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
                            tr.save_changes,
                            style: appTextStyle(
                              context,
                              fontSize: 12.2.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.whiteColor,
                            ),
                          ),
                  );
                },
              ),

              SizedBox(height: 3.h),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              error.toString(),
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(BuildContext context, String label) {
    return Text(
      label,
      style: appTextStyle(
        context,
        fontSize: 11.sp,
        fontWeight: FontWeight.w700,
        color: Colors.black.withAlpha(180),
      ),
    );
  }
}

// ── Avatar Picker Widget ──────────────────────────────────────────────────────

class _AvatarPicker extends StatelessWidget {
  const _AvatarPicker({
    required this.imageUrl,
    required this.pickedFile,
    required this.isUploading,
    required this.onTap,
  });

  final String? imageUrl;
  final File? pickedFile;
  final bool isUploading;
  final VoidCallback onTap;

  static const double _size = 110;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: isUploading ? null : onTap,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              // Circle avatar
              Container(
                width: _size,
                height: _size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.goldBrandColor.withAlpha(30),
                  border: Border.all(
                    color: AppColors.goldBrandColor.withAlpha(80),
                    width: 2.5,
                  ),
                ),
                child: ClipOval(child: _buildImage(context)),
              ),

              // Camera badge
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.goldBrandColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: isUploading
                    ? const Padding(
                        padding: EdgeInsets.all(7),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
              ),
            ],
          ),
        ),

        SizedBox(height: 1.h),

        Text(
          tr.change_photo,
          style: appTextStyle(
            context,
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.goldBrandColor,
          ),
        ),
      ],
    );
  }

  Widget _buildImage(BuildContext context) {
    if (pickedFile != null) {
      return Image.file(pickedFile!, fit: BoxFit.cover);
    }
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: imageUrl!,
        fit: BoxFit.cover,
        placeholder: (_, __) =>
            const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        errorWidget: (_, __, ___) => _buildInitials(context),
      );
    }
    return _buildInitials(context);
  }

  Widget _buildInitials(BuildContext context) {
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
        child: Icon(
          Icons.person_rounded,
          color: Colors.white,
          size: _size * 0.45,
        ),
      ),
    );
  }
}
