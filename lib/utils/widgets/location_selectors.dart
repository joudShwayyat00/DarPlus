import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/features/location/data/models/city_item.dart';
import 'package:dar_plus_app/features/location/data/models/region_item.dart';
import 'package:dar_plus_app/features/location/presentation/providers/location_providers.dart';
import 'package:dar_plus_app/main.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:dar_plus_app/utils/ui/shimmer_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class LocationSelector extends StatelessWidget {
  final IconData icon;
  final String hint;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const LocationSelector({
    super.key,
    required this.icon,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: value != null
            ? AppColors.goldBrandColor.withAlpha(8)
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: value != null
              ? AppColors.goldBrandColor.withAlpha(100)
              : Colors.black.withAlpha(18),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Row(
            children: [
              Icon(icon, size: 16, color: AppColors.grayBrandColor),
              SizedBox(width: 2.w),
              Text(
                hint,
                style: appTextStyle(
                  context,
                  fontSize: 10.5.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.grayBrandColor,
                ),
              ),
            ],
          ),
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: value != null
                ? AppColors.goldBrandColor
                : AppColors.grayBrandColor,
            size: 20,
          ),
          isExpanded: true,
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(14),
          selectedItemBuilder: (ctx) => items.map((item) {
            return Row(
              children: [
                Icon(icon, size: 16, color: AppColors.goldBrandColor),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    item,
                    style: appTextStyle(
                      ctx,
                      fontSize: 10.5.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.blackColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            );
          }).toList(),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: appTextStyle(
                  context,
                  fontSize: 10.5.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blackColor,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class CitiesDropdown extends ConsumerWidget {
  final int countryId;
  final String? selectedCity;
  final ValueChanged<CityItem?> onChanged;

  const CitiesDropdown({
    super.key,
    required this.countryId,
    required this.selectedCity,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final citiesAsync = ref.watch(citiesProvider(countryId));
    return citiesAsync.when(
      data: (cities) => LocationSelector(
        icon: Icons.location_city_rounded,
        hint: tr.filter_select_city,
        value: selectedCity,
        items: cities.map((c) => c.name).toList(),
        onChanged: (name) {
          if (name == null) {
            onChanged(null);
            return;
          }
          onChanged(cities.firstWhere((c) => c.name == name));
        },
      ),
      loading: () => ShimmerPlaceholder(
        width: double.infinity,
        height: 6.h,
        borderRadius: BorderRadius.circular(14),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class RegionsDropdown extends ConsumerWidget {
  final int cityId;
  final String? selectedRegion;
  final ValueChanged<RegionItem?> onChanged;

  const RegionsDropdown({
    super.key,
    required this.cityId,
    required this.selectedRegion,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final regionsAsync = ref.watch(regionsProvider(cityId));
    return regionsAsync.when(
      data: (regions) => LocationSelector(
        icon: Icons.map_rounded,
        hint: tr.filter_select_area,
        value: selectedRegion,
        items: regions.map((r) => r.name).toList(),
        onChanged: (name) {
          if (name == null) {
            onChanged(null);
            return;
          }
          onChanged(regions.firstWhere((r) => r.name == name));
        },
      ),
      loading: () => ShimmerPlaceholder(
        width: double.infinity,
        height: 6.h,
        borderRadius: BorderRadius.circular(14),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
