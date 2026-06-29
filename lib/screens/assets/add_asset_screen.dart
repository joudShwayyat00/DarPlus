import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dar_plus_app/core/network/asset_api_exception.dart';
import 'package:dar_plus_app/core/constants/app_currency.dart';
import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/controller/local_provider.dart';
import 'package:dar_plus_app/features/assets/data/models/amenity_item.dart';
import 'package:dar_plus_app/features/assets/data/models/asset_item.dart';
import 'package:dar_plus_app/features/assets/presentation/providers/assets_providers.dart';
import 'package:dar_plus_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:dar_plus_app/features/home/presentation/providers/home_providers.dart';
import 'package:dar_plus_app/features/location/data/models/city_item.dart';
import 'package:dar_plus_app/features/location/data/models/country_item.dart';
import 'package:dar_plus_app/features/location/data/models/region_item.dart';
import 'package:dar_plus_app/features/location/presentation/providers/location_providers.dart';
import 'package:dar_plus_app/main.dart';
import 'package:dar_plus_app/screens/assets/select_location_screen.dart';
import 'package:dar_plus_app/screens/profile/subscriptions_screen.dart';
import 'package:dar_plus_app/utils/helpers/asset_time_helper.dart';
import 'package:dar_plus_app/utils/ui/app_buttons.dart';
import 'package:dar_plus_app/utils/ui/app_phone_field.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:dar_plus_app/utils/widgets/location_selectors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

class AddAssetScreen extends ConsumerStatefulWidget {
  final int? assetId;

  const AddAssetScreen({super.key, this.assetId});

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
  final _daysCtrl = TextEditingController();
  final _dayPriceCtrl = TextEditingController();
  final _checkInTimeCtrl = TextEditingController();
  final _checkOutTimeCtrl = TextEditingController();
  final _spaceCtrl = TextEditingController();
  final _roomsCtrl = TextEditingController();

  // State
  int? _selectedCategoryId;
  String _type = 'rent'; // 'rent' | 'sale'
  String _rentType = 'monthly'; // 'monthly' | 'yearly'
  File? _imageFile;
  String? _existingImageUrl;
  final List<File> _galleryFiles = [];
  final List<String> _existingGalleryUrls = [];
  bool _isLoadingAsset = false;
  final Set<int> _selectedAmenityIds = {};
  String _completePhone = '';
  String? _countryName;
  int? _selectedCountryId;
  String? _cityName;
  int? _selectedCityId;
  String? _regionName;
  int? _selectedRegionId;
  bool _isProfileContactLoaded = false;

  bool get _isEditMode => widget.assetId != null;

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadAssetForEdit());
    }
  }

  Future<void> _loadAssetForEdit() async {
    setState(() => _isLoadingAsset = true);
    try {
      final lang = ref.read(apiLanguageCodeProvider);
      final asset = await ref
          .read(assetsRepositoryProvider)
          .getAssetDetail(id: widget.assetId!, lang: lang);
      if (!mounted) return;
      await _populateFromAsset(asset);
    } catch (_) {
      if (mounted) _showSnack(tr.error_occurred);
    } finally {
      if (mounted) setState(() => _isLoadingAsset = false);
    }
  }

  Future<void> _populateFromAsset(AssetItem asset) async {
    _nameEnCtrl.text = asset.name;
    _nameArCtrl.text = asset.name;
    _descEnCtrl.text = asset.description ?? '';
    _descArCtrl.text = asset.description ?? '';
    _locationCtrl.text = asset.location;
    _emailCtrl.text = asset.email ?? asset.owner.email;
    _phoneCtrl.text = asset.phone ?? asset.owner.phoneNumber;
    _completePhone = _phoneCtrl.text;
    _videoCtrl.text = asset.video ?? '';
    _selectedCategoryId = asset.category.id;
    _type = asset.type;
    _rentType = asset.rentType ?? 'monthly';
    _existingImageUrl = asset.image;

    if (asset.isForSale) {
      _priceCtrl.text = asset.displayPrice;
    } else {
      _rentPriceCtrl.text = asset.rentPrice?.toString() ?? asset.displayPrice;
    }
    if (asset.rentPrice != null) {
      _rentPriceCtrl.text = asset.rentPrice.toString();
    }
    if (asset.monthsCount != null) {
      _monthsCtrl.text = asset.monthsCount.toString();
    }
    if (asset.yearsCount != null) {
      _yearsCtrl.text = asset.yearsCount.toString();
    }
    if (asset.daysCount != null) {
      _daysCtrl.text = asset.daysCount.toString();
    }
    if (asset.dayPrice != null) {
      _dayPriceCtrl.text = asset.dayPrice!.toStringAsFixed(2);
    }
    if (asset.checkInTime != null && asset.checkInTime!.isNotEmpty) {
      _checkInTimeCtrl.text =
          formatAssetTimeForDisplay(asset.checkInTime) ?? asset.checkInTime!;
    }
    if (asset.checkOutTime != null && asset.checkOutTime!.isNotEmpty) {
      _checkOutTimeCtrl.text =
          formatAssetTimeForDisplay(asset.checkOutTime) ?? asset.checkOutTime!;
    }
    if (asset.latitude != null) {
      _latCtrl.text = asset.latitude!.toString();
    }
    if (asset.longitude != null) {
      _lngCtrl.text = asset.longitude!.toString();
    }
    if (asset.space != null) {
      _spaceCtrl.text = asset.space.toString();
    }
    if (asset.rooms != null) {
      _roomsCtrl.text = asset.rooms.toString();
    }
    _existingGalleryUrls
      ..clear()
      ..addAll(asset.images?.map((item) => item.image) ?? const []);

    _selectedAmenityIds
      ..clear()
      ..addAll(asset.amenities?.map((a) => a.id) ?? const []);

    await _resolveLocationFromAsset(asset);
    setState(() {});
  }

  Future<void> _resolveLocationFromAsset(AssetItem asset) async {
    if (asset.countryId != null) {
      _selectedCountryId = asset.countryId;
      _countryName = asset.country;
      if (asset.cityId != null) {
        _selectedCityId = asset.cityId;
        _cityName = asset.city;
        if (asset.regionId != null) {
          _selectedRegionId = asset.regionId;
          _regionName = asset.region;
        }
      }
      return;
    }

    final countries = await ref.read(countriesProvider.future);
    CountryItem? country;
    for (final item in countries) {
      if (item.name == asset.country) {
        country = item;
        break;
      }
    }
    if (country == null) return;

    _selectedCountryId = country.id;
    _countryName = country.name;

    if (asset.city == null) return;
    final cities = await ref.read(citiesProvider(country.id).future);
    CityItem? city;
    for (final item in cities) {
      if (item.name == asset.city) {
        city = item;
        break;
      }
    }
    if (city == null) return;

    _selectedCityId = city.id;
    _cityName = city.name;

    if (asset.region == null) return;
    final regions = await ref.read(regionsProvider(city.id).future);
    RegionItem? region;
    for (final item in regions) {
      if (item.name == asset.region) {
        region = item;
        break;
      }
    }
    if (region == null) return;

    _selectedRegionId = region.id;
    _regionName = region.name;
  }

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
    _daysCtrl.dispose();
    _dayPriceCtrl.dispose();
    _checkInTimeCtrl.dispose();
    _checkOutTimeCtrl.dispose();
    _spaceCtrl.dispose();
    _roomsCtrl.dispose();
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

  Future<void> _pickGalleryImages() async {
    final picker = ImagePicker();
    final picked = await picker.pickMultiImage(imageQuality: 85);
    if (picked.isEmpty) return;
    setState(() {
      _galleryFiles.addAll(picked.map((file) => File(file.path)));
    });
  }

  // ── Map location picker ───────────────────────────────────────────────────

  Future<void> _openLocationPicker() async {
    final initialLat = double.tryParse(_latCtrl.text.trim());
    final initialLng = double.tryParse(_lngCtrl.text.trim());

    final result = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (_) => SelectLocationScreen(
          initialLatitude: initialLat,
          initialLongitude: initialLng,
        ),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        _latCtrl.text = result.latitude.toStringAsFixed(6);
        _lngCtrl.text = result.longitude.toStringAsFixed(6);
      });
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _showAssetError(Object? error) {
    if (error is AssetApiException && error.isSubscriptionRequired) {
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(tr.subscription_required_title),
          content: Text(error.message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(tr.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const SubscriptionsScreen(),
                  ),
                );
              },
              child: Text(tr.renew_now),
            ),
          ],
        ),
      );
      return;
    }

    _showSnack(formatAssetApiError(error, fallback: tr.something_went_wrong));
  }

  // ── Submit ────────────────────────────────────────────────────────────────

  String _rentPriceHint() {
    switch (_rentType) {
      case 'daily':
        return tr.rent_price_per_day;
      case 'yearly':
        return tr.rent_price_per_year;
      case 'monthly':
      default:
        return tr.rent_price_per_month;
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_imageFile == null && _existingImageUrl == null) {
      _showSnack(tr.please_select_image);
      return;
    }
    if (_selectedCategoryId == null) {
      _showSnack(tr.please_select_category);
      return;
    }
    if (_selectedCountryId == null) {
      _showSnack(tr.please_select_country);
      return;
    }
    if (_selectedCityId == null) {
      _showSnack(tr.please_select_city);
      return;
    }
    if (_selectedRegionId == null) {
      _showSnack(tr.please_select_region);
      return;
    }

    final lat = double.tryParse(_latCtrl.text.trim());
    final lng = double.tryParse(_lngCtrl.text.trim());
    if (lat == null || lat < -90 || lat > 90) {
      _showSnack(tr.valid_latitude);
      return;
    }
    if (lng == null || lng < -180 || lng > 180) {
      _showSnack(tr.valid_longitude);
      return;
    }

    final salePrice = double.tryParse(_priceCtrl.text.trim()) ?? 0;
    final rentPrice = double.tryParse(_rentPriceCtrl.text.trim());
    final space = int.tryParse(_spaceCtrl.text.trim());
    final rooms = int.tryParse(_roomsCtrl.text.trim());
    final galleryImagePaths = _galleryFiles.map((file) => file.path).toList();

    EasyLoading.show();
    final payload = (
      nameEn: _nameEnCtrl.text.trim(),
      nameAr: _nameArCtrl.text.trim(),
      descriptionEn: _descEnCtrl.text.trim(),
      descriptionAr: _descArCtrl.text.trim(),
      categoryId: _selectedCategoryId!,
      price: _type == 'sale' ? salePrice : (rentPrice ?? 0),
      imagePath: _imageFile?.path,
      galleryImagePaths: galleryImagePaths,
      video: _videoCtrl.text.trim().isEmpty ? null : _videoCtrl.text.trim(),
      location: _locationCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      phone: _completePhone.isNotEmpty
          ? _completePhone
          : _phoneCtrl.text.trim(),
      type: _type,
      rentType: _rentType,
      monthsCount: _monthsCtrl.text.isNotEmpty
          ? int.tryParse(_monthsCtrl.text.trim())
          : null,
      yearsCount: _yearsCtrl.text.isNotEmpty
          ? int.tryParse(_yearsCtrl.text.trim())
          : null,
      daysCount: _daysCtrl.text.isNotEmpty
          ? int.tryParse(_daysCtrl.text.trim())
          : null,
      dayPrice: _dayPriceCtrl.text.isNotEmpty
          ? double.tryParse(_dayPriceCtrl.text.trim())
          : null,
      checkInTime: _checkInTimeCtrl.text.trim().isEmpty
          ? null
          : _checkInTimeCtrl.text.trim(),
      checkOutTime: _checkOutTimeCtrl.text.trim().isEmpty
          ? null
          : _checkOutTimeCtrl.text.trim(),
      space: space,
      rooms: rooms,
      rentPrice: _rentPriceCtrl.text.isNotEmpty
          ? double.tryParse(_rentPriceCtrl.text.trim())
          : null,
      latitude: lat,
      longitude: lng,
      amenityIds: _selectedAmenityIds.toList(),
      countryId: _selectedCountryId!,
      cityId: _selectedCityId!,
      regionId: _selectedRegionId!,
    );

    final bool success;
    if (_isEditMode) {
      success = await ref.read(updateAssetControllerProvider.notifier).submit(
            assetId: widget.assetId!,
            nameEn: payload.nameEn,
            nameAr: payload.nameAr,
            descriptionEn: payload.descriptionEn,
            descriptionAr: payload.descriptionAr,
            categoryId: payload.categoryId,
            price: payload.price,
            imagePath: payload.imagePath,
            galleryImagePaths: payload.galleryImagePaths,
            video: payload.video,
            location: payload.location,
            email: payload.email,
            phone: payload.phone,
            type: payload.type,
            rentType: payload.rentType,
            monthsCount: payload.monthsCount,
            yearsCount: payload.yearsCount,
            daysCount: payload.daysCount,
            rentPrice: payload.rentPrice,
            dayPrice: payload.dayPrice,
            checkInTime: payload.checkInTime,
            checkOutTime: payload.checkOutTime,
            space: payload.space,
            rooms: payload.rooms,
            latitude: payload.latitude,
            longitude: payload.longitude,
            amenityIds: payload.amenityIds,
            countryId: payload.countryId,
            cityId: payload.cityId,
            regionId: payload.regionId,
          );
    } else {
      if (payload.imagePath == null) {
        EasyLoading.dismiss();
        _showSnack(tr.please_select_image);
        return;
      }
      success = await ref.read(addAssetControllerProvider.notifier).submit(
            nameEn: payload.nameEn,
            nameAr: payload.nameAr,
            descriptionEn: payload.descriptionEn,
            descriptionAr: payload.descriptionAr,
            categoryId: payload.categoryId,
            price: payload.price,
            imagePath: payload.imagePath!,
            galleryImagePaths: payload.galleryImagePaths,
            video: payload.video,
            location: payload.location,
            email: payload.email,
            phone: payload.phone,
            type: payload.type,
            rentType: payload.rentType,
            monthsCount: payload.monthsCount,
            yearsCount: payload.yearsCount,
            daysCount: payload.daysCount,
            rentPrice: payload.rentPrice,
            dayPrice: payload.dayPrice,
            checkInTime: payload.checkInTime,
            checkOutTime: payload.checkOutTime,
            space: payload.space,
            rooms: payload.rooms,
            latitude: payload.latitude,
            longitude: payload.longitude,
            amenityIds: payload.amenityIds,
            countryId: payload.countryId,
            cityId: payload.cityId,
            regionId: payload.regionId,
          );
    }
    EasyLoading.dismiss();

    if (success && mounted) {
      EasyLoading.showSuccess(
        _isEditMode ? tr.asset_updated_successfully : tr.asset_added_successfully,
      );
      ref.invalidate(assetsControllerProvider);
      ref.invalidate(myAssetsControllerProvider);
      if (_isEditMode) {
        ref.invalidate(assetDetailControllerProvider(widget.assetId!));
      }
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) Navigator.of(context).pop();
    } else if (mounted) {
      final err = _isEditMode
          ? ref.read(updateAssetControllerProvider).error
          : ref.read(addAssetControllerProvider).error;
      _showAssetError(err);
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (!_isEditMode) {
      ref.watch(profileControllerProvider).maybeWhen(
        data: (user) {
          if (user == null) return;
          if (!_isProfileContactLoaded) {
            _emailCtrl.text = user.email;
            _phoneCtrl.text = user.phoneNumber;
            _completePhone = user.phoneNumber;
            _isProfileContactLoaded = true;
          }
        },
        orElse: () {},
      );
    }

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            if (_isLoadingAsset)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.goldBrandColor,
                  ),
                ),
              )
            else
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 5.w,
                    vertical: 1.5.h,
                  ),
                  children: [
                    _sectionTitle(tr.basic_information),
                    SizedBox(height: 1.h),
                    _buildTextField(
                      controller: _nameEnCtrl,
                      hint: tr.name_english,
                      icon: Icons.title_rounded,
                      validator: _requiredValidator,
                    ),
                    SizedBox(height: 1.5.h),
                    _buildTextField(
                      controller: _nameArCtrl,
                      hint: tr.name_arabic,
                      icon: Icons.title_rounded,
                      validator: _requiredValidator,
                    ),
                    SizedBox(height: 1.5.h),
                    _buildTextField(
                      controller: _descEnCtrl,
                      hint: tr.description_english,
                      icon: Icons.description_rounded,
                      maxLines: 3,
                      validator: _requiredValidator,
                    ),
                    SizedBox(height: 1.5.h),
                    _buildTextField(
                      controller: _descArCtrl,
                      hint: tr.description_arabic,
                      icon: Icons.description_rounded,
                      maxLines: 3,
                      validator: _requiredValidator,
                    ),

                    SizedBox(height: 2.5.h),
                    _sectionTitle(tr.category_and_type),
                    SizedBox(height: 1.h),
                    _buildCategoryDropdown(),
                    SizedBox(height: 1.5.h),
                    _buildTypeToggle(),

                    SizedBox(height: 2.5.h),
                    _sectionTitle(tr.property_details_section),
                    SizedBox(height: 1.h),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _spaceCtrl,
                            hint: tr.property_space,
                            icon: Icons.square_foot_rounded,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: _buildTextField(
                            controller: _roomsCtrl,
                            hint: tr.rooms,
                            icon: Icons.meeting_room_outlined,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 2.5.h),
                    _sectionTitle(tr.pricing_section),
                    SizedBox(height: 1.h),
                    if (_type == 'sale')
                      _buildTextField(
                        controller: _priceCtrl,
                        hint: tr.price_label,
                        icon: Icons.monetization_on_outlined,
                        showCurrencySuffix: true,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: _requiredValidator,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                        ],
                      )
                    else ...[
                      _buildRentTypeToggle(),
                      if (_rentType == 'daily') ...[
                        SizedBox(height: 1.5.h),
                        _buildTextField(
                          controller: _daysCtrl,
                          hint: tr.days_count,
                          icon: Icons.today_rounded,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ],
                      if (_rentType == 'monthly') ...[
                        SizedBox(height: 1.5.h),
                        _buildTextField(
                          controller: _monthsCtrl,
                          hint: tr.months_count,
                          icon: Icons.calendar_month_rounded,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                        SizedBox(height: 1.5.h),
                        _buildTextField(
                          controller: _dayPriceCtrl,
                          hint: tr.day_price,
                          icon: Icons.payments_outlined,
                          showCurrencySuffix: true,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9.]'),
                            ),
                          ],
                        ),
                      ],
                      if (_rentType == 'yearly') ...[
                        SizedBox(height: 1.5.h),
                        _buildTextField(
                          controller: _yearsCtrl,
                          hint: tr.years_count,
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
                        hint: _rentPriceHint(),
                        icon: Icons.price_change_outlined,
                        showCurrencySuffix: true,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: _requiredValidator,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                        ],
                      ),
                    ],

                    SizedBox(height: 1.5.h),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTimeField(
                            controller: _checkInTimeCtrl,
                            hint: tr.check_in_time,
                            icon: Icons.login_rounded,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: _buildTimeField(
                            controller: _checkOutTimeCtrl,
                            hint: tr.check_out_time,
                            icon: Icons.logout_rounded,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 2.5.h),
                    _sectionTitle(tr.location_section),
                    SizedBox(height: 1.h),
                    _buildLocationDropdowns(),
                    SizedBox(height: 1.5.h),
                    _buildTextField(
                      controller: _locationCtrl,
                      hint: tr.location_address_hint,
                      icon: Icons.place_rounded,
                      validator: _requiredValidator,
                    ),
                    SizedBox(height: 1.5.h),
                    _buildLocationCoords(),

                    SizedBox(height: 2.5.h),
                    _sectionTitle(tr.contact_section),
                    SizedBox(height: 1.h),
                    _buildTextField(
                      controller: _emailCtrl,
                      hint: tr.email,
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return tr.field_required;
                        }
                        if (!RegExp(
                          r'^[^@]+@[^@]+\.[^@]+',
                        ).hasMatch(v.trim())) {
                          return tr.enter_valid_email;
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
                    _sectionTitle(tr.media_section),
                    SizedBox(height: 1.h),
                    Text(
                      tr.main_property_image,
                      style: appTextStyle(
                        context,
                        fontSize: 9.5.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.grayBrandColor,
                      ),
                    ),
                    SizedBox(height: 0.8.h),
                    _buildImagePicker(),
                    SizedBox(height: 1.5.h),
                    Text(
                      tr.gallery_images,
                      style: appTextStyle(
                        context,
                        fontSize: 9.5.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.grayBrandColor,
                      ),
                    ),
                    SizedBox(height: 0.8.h),
                    _buildGalleryPicker(),
                    SizedBox(height: 1.5.h),
                    _buildTextField(
                      controller: _videoCtrl,
                      hint: tr.video_url_optional,
                      icon: Icons.videocam_outlined,
                    ),

                    SizedBox(height: 2.5.h),
                    _sectionTitle(tr.amenities),
                    SizedBox(height: 1.h),
                    _buildAmenities(),

                    SizedBox(height: 3.h),
                    AppButton(
                      onPressed: _submit,
                      backgroundColor: AppColors.goldBrandColor,
                      child: Text(
                        _isEditMode ? tr.update_asset : tr.publish_asset,
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
            _isEditMode ? tr.edit_asset : tr.add_new_asset,
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

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  TimeOfDay? _parseTimeValue(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;

    final parts = trimmed.split(':');
    if (parts.length == 2) {
      final hour = int.tryParse(parts[0]);
      final minute = int.tryParse(parts[1]);
      if (hour != null && minute != null) {
        return TimeOfDay(hour: hour.clamp(0, 23), minute: minute.clamp(0, 59));
      }
    }

    final hourOnly = int.tryParse(trimmed);
    if (hourOnly != null) {
      return TimeOfDay(hour: hourOnly.clamp(0, 23), minute: 0);
    }
    return null;
  }

  Future<void> _pickTime(TextEditingController controller) async {
    final initial = _parseTimeValue(controller.text) ?? TimeOfDay.now();
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.goldBrandColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked == null || !mounted) return;
    setState(() => controller.text = _formatTimeOfDay(picked));
  }

  Widget _buildTimeField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: () => _pickTime(controller),
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
        prefixIcon: Icon(icon, color: AppColors.grayBrandColor, size: 20),
        suffixIcon: Icon(
          Icons.access_time_rounded,
          color: AppColors.goldBrandColor,
          size: 20,
        ),
        filled: true,
        fillColor: AppColors.grayBrandColor.withAlpha(10),
        contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.6.h),
        border: _inputBorder(),
        focusedBorder: _inputBorder(color: AppColors.goldBrandColor),
        enabledBorder: _inputBorder(),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    IconData? icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
    bool showCurrencySuffix = false,
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
        suffixIcon: showCurrencySuffix
            ? Padding(
                padding: EdgeInsets.only(right: 3.w),
                child: Align(
                  alignment: Alignment.centerRight,
                  widthFactor: 1,
                  child: Text(
                    kAppCurrency,
                    style: appTextStyle(
                      context,
                      fontSize: 10.5.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.goldBrandColor,
                    ),
                  ),
                ),
              )
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
          hintText: tr.select_category,
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
            _selectedCategoryId == null ? tr.please_select_category : null,
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
        _typeChip(tr.for_rent, 'rent', Icons.key_outlined),
        SizedBox(width: 3.w),
        _typeChip(tr.for_sale, 'sale', Icons.sell_outlined),
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
        _rentChip(tr.daily, 'daily'),
        SizedBox(width: 2.w),
        _rentChip(tr.monthly, 'monthly'),
        SizedBox(width: 2.w),
        _rentChip(tr.yearly, 'yearly'),
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

  // ── Location dropdowns ───────────────────────────────────────────────────

  Widget _buildLocationDropdowns() {
    final countriesAsync = ref.watch(countriesProvider);

    return Column(
      children: [
        countriesAsync.when(
          data: (countries) => LocationSelector(
            icon: Icons.public_rounded,
            hint: tr.filter_select_country,
            value: _countryName,
            items: countries.map((c) => c.name).toList(),
            onChanged: (name) {
              if (name == null) {
                setState(() {
                  _countryName = null;
                  _selectedCountryId = null;
                  _cityName = null;
                  _selectedCityId = null;
                  _regionName = null;
                  _selectedRegionId = null;
                });
                return;
              }
              final selected = countries.firstWhere((c) => c.name == name);
              setState(() {
                _countryName = selected.name;
                _selectedCountryId = selected.id;
                _cityName = null;
                _selectedCityId = null;
                _regionName = null;
                _selectedRegionId = null;
              });
            },
          ),
          loading: () => _skeletonField(),
          error: (_, __) => const SizedBox.shrink(),
        ),
        if (_selectedCountryId != null) ...[
          SizedBox(height: 1.5.h),
          CitiesDropdown(
            countryId: _selectedCountryId!,
            selectedCity: _cityName,
            onChanged: (city) => setState(() {
              _cityName = city?.name;
              _selectedCityId = city?.id;
              _regionName = null;
              _selectedRegionId = null;
            }),
          ),
        ],
        if (_selectedCityId != null) ...[
          SizedBox(height: 1.5.h),
          RegionsDropdown(
            cityId: _selectedCityId!,
            selectedRegion: _regionName,
            onChanged: (region) => setState(() {
              _regionName = region?.name;
              _selectedRegionId = region?.id;
            }),
          ),
        ],
      ],
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
                hint: tr.latitude,
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
                hint: tr.longitude,
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
          onTap: _openLocationPicker,
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
                const Icon(
                  Icons.map_outlined,
                  color: AppColors.goldBrandColor,
                  size: 18,
                ),
                SizedBox(width: 2.w),
                Text(
                  tr.select_location,
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
    final hasImage = _imageFile != null || _existingImageUrl != null;

    return GestureDetector(
      onTap: _pickImage,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 20.h,
        decoration: BoxDecoration(
          color: AppColors.grayBrandColor.withAlpha(12),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: hasImage
                ? AppColors.goldBrandColor
                : AppColors.grayBrandColor.withAlpha(70),
            width: hasImage ? 2 : 1,
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
                        onTap: () => setState(() {
                          _imageFile = null;
                          if (!_isEditMode) _existingImageUrl = null;
                        }),
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
                          tr.change,
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
              : _existingImageUrl != null
              ? Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: _existingImageUrl!,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      bottom: 8,
                      left: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          tr.keep_image_hint,
                          textAlign: TextAlign.center,
                          style: appTextStyle(
                            context,
                            fontSize: 8.5.sp,
                            fontWeight: FontWeight.w600,
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
                          tr.change,
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
                      tr.tap_add_property_image,
                      style: appTextStyle(
                        context,
                        fontSize: 10.5.sp,
                        color: AppColors.grayBrandColor,
                      ),
                    ),
                    SizedBox(height: 0.4.h),
                    Text(
                      tr.image_format_hint,
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

  Widget _buildGalleryPicker() {
    final totalCount = _galleryFiles.length + _existingGalleryUrls.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 12.h,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              GestureDetector(
                onTap: _pickGalleryImages,
                child: Container(
                  width: 24.w,
                  margin: EdgeInsets.only(right: 2.5.w),
                  decoration: BoxDecoration(
                    color: AppColors.goldBrandColor.withAlpha(18),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.goldBrandColor.withAlpha(80),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.add_photo_alternate_outlined,
                        color: AppColors.goldBrandColor,
                      ),
                      SizedBox(height: 0.6.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2.w),
                        child: Text(
                          tr.add_gallery_photos,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: appTextStyle(
                            context,
                            fontSize: 8.5.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.goldBrandColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ...List.generate(_existingGalleryUrls.length, (index) {
                final url = _existingGalleryUrls[index];
                return _galleryThumb(
                  child: CachedNetworkImage(
                    imageUrl: url,
                    fit: BoxFit.cover,
                  ),
                  onRemove: () => setState(() {
                    _existingGalleryUrls.removeAt(index);
                  }),
                );
              }),
              ...List.generate(_galleryFiles.length, (index) {
                final file = _galleryFiles[index];
                return _galleryThumb(
                  child: Image.file(file, fit: BoxFit.cover),
                  onRemove: () => setState(() {
                    _galleryFiles.removeAt(index);
                  }),
                );
              }),
            ],
          ),
        ),
        if (totalCount > 0)
          Padding(
            padding: EdgeInsets.only(top: 0.8.h),
            child: Text(
              '$totalCount ${tr.gallery_images.toLowerCase()}',
              style: appTextStyle(
                context,
                fontSize: 9.sp,
                color: AppColors.grayBrandColor,
              ),
            ),
          ),
      ],
    );
  }

  Widget _galleryThumb({
    required Widget child,
    required VoidCallback onRemove,
  }) {
    return Container(
      width: 24.w,
      margin: EdgeInsets.only(right: 2.5.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withAlpha(18)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          fit: StackFit.expand,
          children: [
            child,
            Positioned(
              top: 6,
              right: 6,
              child: GestureDetector(
                onTap: onRemove,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    size: 14,
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
        tr.could_not_load_amenities,
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
      (v == null || v.trim().isEmpty) ? tr.field_required : null;
}
