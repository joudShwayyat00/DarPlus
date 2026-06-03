import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/features/assets/data/models/amenity_item.dart';
import 'package:dar_plus_app/features/assets/presentation/providers/assets_providers.dart';
import 'package:dar_plus_app/features/home/presentation/providers/home_providers.dart';
import 'package:dar_plus_app/utils/ui/app_buttons.dart';
import 'package:dar_plus_app/utils/ui/app_phone_field.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

class AddAssetScreen extends ConsumerStatefulWidget {
  const AddAssetScreen({super.key});

  @override
  ConsumerState<AddAssetScreen> createState() => _AddAssetScreenState();
}

class _AddAssetScreenState extends ConsumerState<AddAssetScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameEnCtrl = TextEditingController();
  final _nameArCtrl = TextEditingController();
  final _descEnCtrl = TextEditingController();
  final _descArCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _videoCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _latCtrl = TextEditingController();
  final _lngCtrl = TextEditingController();
  final _rentPriceCtrl = TextEditingController();
  final _monthsCtrl = TextEditingController();
  final _yearsCtrl = TextEditingController();

  // State
  int? _selectedCategoryId;
  String _type = 'rent'; // 'rent' | 'sale'
  String _rentType = 'monthly'; // 'monthly' | 'yearly'
  File? _imageFile;
  bool _loadingLocation = false;
  final Set<int> _selectedAmenityIds = {};
  String _completePhone = '';

  @override
  void dispose() {
    _nameEnCtrl.dispose();
    _nameArCtrl.dispose();
    _descEnCtrl.dispose();
    _descArCtrl.dispose();
    _priceCtrl.dispose();
    _videoCtrl.dispose();
    _locationCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _latCtrl.dispose();
    _lngCtrl.dispose();
    _rentPriceCtrl.dispose();
    _monthsCtrl.dispose();
    _yearsCtrl.dispose();
    super.dispose();
  }

  // ── Image picker ──────────────────────────────────────────────────────────

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked != null) setState(() => _imageFile = File(picked.path));
  }

  // ── GPS Location ─────────────────────────────────────────────────────────

  Future<void> _getCurrentLocation() async {
    setState(() => _loadingLocation = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showSnack('Location services are disabled.');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showSnack('Location permission denied.');
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        _showSnack('Location permission permanently denied.');
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      setState(() {
        _latCtrl.text = pos.latitude.toStringAsFixed(6);
        _lngCtrl.text = pos.longitude.toStringAsFixed(6);
      });
    } catch (e) {
      _showSnack('Could not get location: $e');
    } finally {
      setState(() => _loadingLocation = false);
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  // ── Submit ────────────────────────────────────────────────────────────────

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_imageFile == null) {
      _showSnack('Please select an image.');
      return;
    }
    if (_selectedCategoryId == null) {
      _showSnack('Please select a category.');
      return;
    }

    final lat = double.tryParse(_latCtrl.text.trim());
    final lng = double.tryParse(_lngCtrl.text.trim());
    if (lat == null || lat < -90 || lat > 90) {
      _showSnack('Please enter a valid latitude (−90 to 90).');
      return;
    }
    if (lng == null || lng < -180 || lng > 180) {
      _showSnack('Please enter a valid longitude (−180 to 180).');
      return;
    }

    EasyLoading.show();
    final success = await ref
        .read(addAssetControllerProvider.notifier)
        .submit(
          nameEn: _nameEnCtrl.text.trim(),
          nameAr: _nameArCtrl.text.trim(),
          descriptionEn: _descEnCtrl.text.trim(),
          descriptionAr: _descArCtrl.text.trim(),
          categoryId: _selectedCategoryId!,
          price: double.tryParse(_priceCtrl.text.trim()) ?? 0,
          imagePath: _imageFile!.path,
          video: _videoCtrl.text.trim().isEmpty ? null : _videoCtrl.text.trim(),
          location: _locationCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
          phone: _completePhone.isNotEmpty
              ? _completePhone
              : _phoneCtrl.text.trim(),
          type: _type,
          rentType: _type == 'rent' ? _rentType : null,
          monthsCount:
              _type == 'rent' &&
                  _rentType == 'monthly' &&
                  _monthsCtrl.text.isNotEmpty
              ? int.tryParse(_monthsCtrl.text.trim())
              : null,
          yearsCount:
              _type == 'rent' &&
                  _rentType == 'yearly' &&
                  _yearsCtrl.text.isNotEmpty
              ? int.tryParse(_yearsCtrl.text.trim())
              : null,
          rentPrice: _type == 'rent' && _rentPriceCtrl.text.isNotEmpty
              ? double.tryParse(_rentPriceCtrl.text.trim())
              : null,
          latitude: lat,
          longitude: lng,
          amenityIds: _selectedAmenityIds.toList(),
        );
    EasyLoading.dismiss();

    if (success && mounted) {
      EasyLoading.showSuccess('Asset added successfully!');
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) Navigator.of(context).pop();
      // Optionally, you can also refresh the assets list after adding a new asset
      ref.read(assetsControllerProvider.notifier).refresh();
    } else if (mounted) {
      final err = ref.read(addAssetControllerProvider).error;
      _showSnack(err?.toString() ?? 'Something went wrong.');
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 5.w,
                    vertical: 1.5.h,
                  ),
                  children: [
                    _sectionTitle('Basic Information'),
                    SizedBox(height: 1.h),
                    _buildTextField(
                      controller: _nameEnCtrl,
                      hint: 'Name (English)',
                      icon: Icons.title_rounded,
                      validator: _requiredValidator,
                    ),
                    SizedBox(height: 1.5.h),
                    _buildTextField(
                      controller: _nameArCtrl,
                      hint: 'الاسم (عربي)',
                      icon: Icons.title_rounded,
                      validator: _requiredValidator,
                    ),
                    SizedBox(height: 1.5.h),
                    _buildTextField(
                      controller: _descEnCtrl,
                      hint: 'Description (English)',
                      icon: Icons.description_rounded,
                      maxLines: 3,
                      validator: _requiredValidator,
                    ),
                    SizedBox(height: 1.5.h),
                    _buildTextField(
                      controller: _descArCtrl,
                      hint: 'الوصف (عربي)',
                      icon: Icons.description_rounded,
                      maxLines: 3,
                      validator: _requiredValidator,
                    ),

                    SizedBox(height: 2.5.h),
                    _sectionTitle('Category & Type'),
                    SizedBox(height: 1.h),
                    _buildCategoryDropdown(),
                    SizedBox(height: 1.5.h),
                    _buildTypeToggle(),

                    SizedBox(height: 2.5.h),
                    _sectionTitle('Pricing'),
                    SizedBox(height: 1.h),
                    _buildTextField(
                      controller: _priceCtrl,
                      hint: 'Price',
                      icon: Icons.monetization_on_outlined,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: _requiredValidator,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                      ],
                    ),
                    if (_type == 'rent') ...[
                      SizedBox(height: 1.5.h),
                      _buildRentTypeToggle(),
                      if (_rentType == 'monthly') ...[
                        SizedBox(height: 1.5.h),
                        _buildTextField(
                          controller: _monthsCtrl,
                          hint: 'Months Count',
                          icon: Icons.calendar_month_rounded,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ],
                      if (_rentType == 'yearly') ...[
                        SizedBox(height: 1.5.h),
                        _buildTextField(
                          controller: _yearsCtrl,
                          hint: 'Years Count',
                          icon: Icons.calendar_today_rounded,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ],
                      SizedBox(height: 1.5.h),
                      _buildTextField(
                        controller: _rentPriceCtrl,
                        hint: 'Rent Price',
                        icon: Icons.price_change_outlined,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                        ],
                      ),
                    ],

                    SizedBox(height: 2.5.h),
                    _sectionTitle('Location'),
                    SizedBox(height: 1.h),
                    _buildTextField(
                      controller: _locationCtrl,
                      hint: 'Location (address / area)',
                      icon: Icons.place_rounded,
                      validator: _requiredValidator,
                    ),
                    SizedBox(height: 1.5.h),
                    _buildLocationCoords(),

                    SizedBox(height: 2.5.h),
                    _sectionTitle('Contact'),
                    SizedBox(height: 1.h),
                    _buildTextField(
                      controller: _emailCtrl,
                      hint: 'Email',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Required';
                        }
                        if (!RegExp(
                          r'^[^@]+@[^@]+\.[^@]+',
                        ).hasMatch(v.trim())) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 1.5.h),
                    AppPhoneField(
                      controller: _phoneCtrl,
                      onChangedCompleteNumber: (v) => _completePhone = v,
                    ),

                    SizedBox(height: 2.5.h),
                    _sectionTitle('Media'),
                    SizedBox(height: 1.h),
                    _buildImagePicker(),
                    SizedBox(height: 1.5.h),
                    _buildTextField(
                      controller: _videoCtrl,
                      hint: 'Video URL (optional)',
                      icon: Icons.videocam_outlined,
                    ),

                    SizedBox(height: 2.5.h),
                    _sectionTitle('Amenities'),
                    SizedBox(height: 1.h),
                    _buildAmenities(),

                    SizedBox(height: 3.h),
                    AppButton(
                      onPressed: _submit,
                      backgroundColor: AppColors.goldBrandColor,
                      child: Text(
                        'Publish Asset',
                        style: appTextStyle(
                          context,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.grayBrandColor.withAlpha(20),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: AppColors.blackColor,
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Text(
            'Add New Asset',
            style: appTextStyle(
              context,
              fontSize: 16.sp,
              fontWeight: FontWeight.w900,
              color: Colors.black.withAlpha(240),
            ),
          ),
        ],
      ),
    );
  }

  // ── Section title ─────────────────────────────────────────────────────────

  Widget _sectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: AppColors.goldBrandColor,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(width: 2.w),
        Text(
          title,
          style: appTextStyle(
            context,
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.blackColor,
          ),
        ),
      ],
    );
  }

  // ── Text field ────────────────────────────────────────────────────────────

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    IconData? icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      cursorColor: AppColors.goldBrandColor,
      style: appTextStyle(
        context,
        fontSize: 11.sp,
        color: AppColors.blackColor,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: appTextStyle(
          context,
          fontSize: 10.8.sp,
          color: AppColors.grayBrandColor.withAlpha(130),
        ),
        prefixIcon: icon != null
            ? Icon(icon, color: AppColors.grayBrandColor, size: 20)
            : null,
        filled: true,
        fillColor: AppColors.grayBrandColor.withAlpha(10),
        contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.6.h),
        border: _inputBorder(),
        focusedBorder: _inputBorder(color: AppColors.goldBrandColor),
        enabledBorder: _inputBorder(),
        errorBorder: _inputBorder(color: Colors.red),
        focusedErrorBorder: _inputBorder(color: Colors.red),
        errorStyle: appTextStyle(context, fontSize: 9.sp, color: Colors.red),
      ),
    );
  }

  OutlineInputBorder _inputBorder({Color? color}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(
        color: color ?? AppColors.grayBrandColor.withAlpha(80),
      ),
    );
  }

  // ── Category dropdown ─────────────────────────────────────────────────────

  Widget _buildCategoryDropdown() {
    final categoriesAsync = ref.watch(homeCategoryControllerProvider);
    return categoriesAsync.when(
      data: (categories) => DropdownButtonFormField<int>(
        initialValue: _selectedCategoryId,
        decoration: InputDecoration(
          hintText: 'Select Category',
          hintStyle: appTextStyle(
            context,
            fontSize: 10.8.sp,
            color: AppColors.grayBrandColor.withAlpha(130),
          ),
          prefixIcon: const Icon(
            Icons.category_outlined,
            color: AppColors.grayBrandColor,
            size: 20,
          ),
          filled: true,
          fillColor: AppColors.grayBrandColor.withAlpha(10),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 4.w,
            vertical: 1.6.h,
          ),
          border: _inputBorder(),
          focusedBorder: _inputBorder(color: AppColors.goldBrandColor),
          enabledBorder: _inputBorder(),
        ),
        dropdownColor: AppColors.whiteColor,
        style: appTextStyle(
          context,
          fontSize: 11.sp,
          color: AppColors.blackColor,
        ),
        items: categories
            .map((c) => DropdownMenuItem<int>(value: c.id, child: Text(c.name)))
            .toList(),
        onChanged: (v) => setState(() => _selectedCategoryId = v),
        validator: (_) =>
            _selectedCategoryId == null ? 'Please select a category' : null,
      ),
      loading: () => _skeletonField(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _skeletonField() {
    return Container(
      height: 6.h,
      decoration: BoxDecoration(
        color: AppColors.grayBrandColor.withAlpha(20),
        borderRadius: BorderRadius.circular(14),
      ),
    );
  }

  // ── Type toggle (sale / rent) ─────────────────────────────────────────────

  Widget _buildTypeToggle() {
    return Row(
      children: [
        _typeChip('For Rent', 'rent', Icons.key_outlined),
        SizedBox(width: 3.w),
        _typeChip('For Sale', 'sale', Icons.sell_outlined),
      ],
    );
  }

  Widget _typeChip(String label, String value, IconData icon) {
    final selected = _type == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _type = value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: 1.4.h),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.goldBrandColor
                : AppColors.grayBrandColor.withAlpha(15),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected
                  ? AppColors.goldBrandColor
                  : AppColors.grayBrandColor.withAlpha(60),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: selected
                    ? AppColors.whiteColor
                    : AppColors.grayBrandColor,
              ),
              SizedBox(width: 2.w),
              Text(
                label,
                style: appTextStyle(
                  context,
                  fontSize: 10.5.sp,
                  fontWeight: FontWeight.w600,
                  color: selected
                      ? AppColors.whiteColor
                      : AppColors.grayBrandColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Rent type toggle ──────────────────────────────────────────────────────

  Widget _buildRentTypeToggle() {
    return Row(
      children: [
        _rentChip('Daily', 'daily'),
        SizedBox(width: 2.w),
        _rentChip('Monthly', 'monthly'),
        SizedBox(width: 2.w),
        _rentChip('Yearly', 'yearly'),
      ],
    );
  }

  Widget _rentChip(String label, String value) {
    final selected = _rentType == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _rentType = value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: 1.2.h),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.goldBrandColor.withAlpha(30)
                : AppColors.grayBrandColor.withAlpha(10),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected
                  ? AppColors.goldBrandColor
                  : AppColors.grayBrandColor.withAlpha(50),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: appTextStyle(
                context,
                fontSize: 10.5.sp,
                fontWeight: FontWeight.w600,
                color: selected
                    ? AppColors.goldBrandColor
                    : AppColors.grayBrandColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Location coordinates ──────────────────────────────────────────────────

  Widget _buildLocationCoords() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _latCtrl,
                hint: 'Latitude',
                icon: Icons.my_location_rounded,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.\-]')),
                ],
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: _buildTextField(
                controller: _lngCtrl,
                hint: 'Longitude',
                icon: Icons.location_on_outlined,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.\-]')),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 1.2.h),
        GestureDetector(
          onTap: _loadingLocation ? null : _getCurrentLocation,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(vertical: 1.4.h),
            decoration: BoxDecoration(
              color: AppColors.goldBrandColor.withAlpha(20),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppColors.goldBrandColor.withAlpha(100),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_loadingLocation)
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.goldBrandColor,
                    ),
                  )
                else
                  const Icon(
                    Icons.gps_fixed_rounded,
                    color: AppColors.goldBrandColor,
                    size: 18,
                  ),
                SizedBox(width: 2.w),
                Text(
                  _loadingLocation
                      ? 'Getting location…'
                      : 'Use Current Location',
                  style: appTextStyle(
                    context,
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.goldBrandColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Image picker ──────────────────────────────────────────────────────────

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 20.h,
        decoration: BoxDecoration(
          color: AppColors.grayBrandColor.withAlpha(12),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: _imageFile != null
                ? AppColors.goldBrandColor
                : AppColors.grayBrandColor.withAlpha(70),
            width: _imageFile != null ? 2 : 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(17),
          child: _imageFile != null
              ? Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(_imageFile!, fit: BoxFit.cover),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () => setState(() => _imageFile = null),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.close_rounded,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.goldBrandColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Change',
                          style: appTextStyle(
                            context,
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.whiteColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_photo_alternate_outlined,
                      size: 36,
                      color: AppColors.grayBrandColor.withAlpha(140),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Tap to add property image',
                      style: appTextStyle(
                        context,
                        fontSize: 10.5.sp,
                        color: AppColors.grayBrandColor,
                      ),
                    ),
                    SizedBox(height: 0.4.h),
                    Text(
                      'JPG, PNG — high quality',
                      style: appTextStyle(
                        context,
                        fontSize: 9.sp,
                        color: AppColors.grayBrandColor.withAlpha(130),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  // ── Amenities ─────────────────────────────────────────────────────────────

  Widget _buildAmenities() {
    final amenitiesAsync = ref.watch(amenitiesProvider);
    return amenitiesAsync.when(
      data: (amenities) => Wrap(
        spacing: 2.w,
        runSpacing: 1.2.h,
        children: amenities.map((a) => _amenityChip(a)).toList(),
      ),
      loading: () => Wrap(
        spacing: 2.w,
        runSpacing: 1.2.h,
        children: List.generate(
          4,
          (_) => Container(
            width: 25.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColors.grayBrandColor.withAlpha(20),
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ),
      error: (_, __) => Text(
        'Could not load amenities',
        style: appTextStyle(
          context,
          fontSize: 10.sp,
          color: AppColors.grayBrandColor,
        ),
      ),
    );
  }

  Widget _amenityChip(AmenityItem amenity) {
    final selected = _selectedAmenityIds.contains(amenity.id);
    return GestureDetector(
      onTap: () => setState(() {
        if (selected) {
          _selectedAmenityIds.remove(amenity.id);
        } else {
          _selectedAmenityIds.add(amenity.id);
        }
      }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.9.h),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.goldBrandColor
              : AppColors.grayBrandColor.withAlpha(12),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: selected
                ? AppColors.goldBrandColor
                : AppColors.grayBrandColor.withAlpha(60),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: selected
                    ? Colors.white.withAlpha(40)
                    : AppColors.grayBrandColor.withAlpha(15),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: CachedNetworkImage(
                  imageUrl: amenity.icon,
                  width: 22,
                  height: 22,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => Icon(
                    Icons.spa_outlined,
                    size: 14,
                    color: selected
                        ? AppColors.whiteColor
                        : AppColors.grayBrandColor,
                  ),
                ),
              ),
            ),
            SizedBox(width: 1.8.w),
            Text(
              amenity.name,
              style: appTextStyle(
                context,
                fontSize: 9.5.sp,
                fontWeight: FontWeight.w600,
                color: selected ? AppColors.whiteColor : AppColors.blackColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Validator ─────────────────────────────────────────────────────────────

  String? _requiredValidator(String? v) =>
      (v == null || v.trim().isEmpty) ? 'This field is required' : null;
}
