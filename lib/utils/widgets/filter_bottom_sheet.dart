import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/features/home/presentation/providers/home_providers.dart';
import 'package:dar_plus_app/features/location/data/models/country_item.dart';
import 'package:dar_plus_app/features/location/presentation/providers/location_providers.dart';
import 'package:dar_plus_app/main.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:dar_plus_app/utils/ui/shimmer_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

// ─── Public Data Model ────────────────────────────────────────────────────────

/// Holds all selected filter values.
class FilterData {
  final String? listingType; // 'buy' | 'rent' | 'both'
  final Set<String> assetTypes;
  final String? country;
  final String? city;
  final String? area;
  final DateTime? checkIn;
  final DateTime? checkOut;

  const FilterData({
    this.listingType,
    this.assetTypes = const {},
    this.country,
    this.city,
    this.area,
    this.checkIn,
    this.checkOut,
  });

  static const FilterData empty = FilterData();

  /// Returns how many distinct filter categories are active.
  int get activeCount {
    int n = 0;
    if (listingType != null) n++;
    if (assetTypes.isNotEmpty) n++;
    if (country != null) n++;
    if (checkIn != null) n++;
    return n;
  }
}

// ─── Public API ───────────────────────────────────────────────────────────────

/// Opens the filter bottom sheet and returns the selected [FilterData],
/// or `null` if the user dismisses it.
Future<FilterData?> showFilterBottomSheet(
  BuildContext context, {
  FilterData? initial,
}) {
  return showModalBottomSheet<FilterData>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    useSafeArea: true,
    builder: (_) => FilterBottomSheet(initial: initial ?? FilterData.empty),
  );
}

// ─── Widget ───────────────────────────────────────────────────────────────────

class FilterBottomSheet extends ConsumerStatefulWidget {
  final FilterData initial;
  const FilterBottomSheet({super.key, required this.initial});

  @override
  ConsumerState<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends ConsumerState<FilterBottomSheet> {
  // Filter state
  String? _listingType;
  final Set<String> _assetTypes = {};
  String? _country;
  int? _selectedCountryId;
  String? _city;
  String? _area;
  DateTime? _checkIn;
  DateTime? _checkOut;

  // Calendar display month
  late DateTime _displayMonth;

  @override
  void initState() {
    super.initState();
    final f = widget.initial;
    _listingType = f.listingType;
    _assetTypes.addAll(f.assetTypes);
    _country = f.country;
    _selectedCountryId = null; // ID not persisted in FilterData
    _city = f.city;
    _area = f.area;
    _checkIn = f.checkIn;
    _checkOut = f.checkOut;
    final now = DateTime.now();
    _displayMonth = DateTime(now.year, now.month);
  }

  // ── Helpers ────────────────────────────────────────────────────────────

  bool get _showRentalPeriod =>
      _listingType == 'rent' || _listingType == 'both';

  void _reset() {
    setState(() {
      _listingType = null;
      _assetTypes.clear();
      _country = null;
      _selectedCountryId = null;
      _city = null;
      _area = null;
      _checkIn = null;
      _checkOut = null;
    });
  }

  void _apply() {
    Navigator.of(context).pop(
      FilterData(
        listingType: _listingType,
        assetTypes: Set<String>.from(_assetTypes),
        country: _country,
        city: _city,
        area: _area,
        checkIn: _checkIn,
        checkOut: _checkOut,
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 94.h,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          _buildHandle(),
          _buildHeader(),
          Divider(height: 1, color: Colors.black.withAlpha(12)),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2.2.h),

                  // ── Looking To ──────────────────────────────────────
                  _buildLookingToSection(),
                  _buildDivider(),

                  // Owner type removed

                  // ── Property Type ───────────────────────────────────
                  _buildPropertyTypeSection(),
                  _buildDivider(),

                  // ── Location ────────────────────────────────────────
                  _buildLocationSection(),

                  // ── Rental Period (visible when rent/both selected) ─
                  AnimatedSize(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeOut,
                    child: _showRentalPeriod
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildDivider(),
                              _buildRentalPeriodSection(),
                            ],
                          )
                        : const SizedBox.shrink(),
                  ),

                  SizedBox(height: 12.h),
                ],
              ),
            ),
          ),

          // ── Apply Button ────────────────────────────────────────────
          _buildApplyButton(),
        ],
      ),
    );
  }

  // ─── Section builders ──────────────────────────────────────────────────────

  Widget _buildHandle() {
    return Padding(
      padding: EdgeInsets.only(top: 1.2.h, bottom: 0.8.h),
      child: Container(
        width: 12.w,
        height: 5,
        decoration: BoxDecoration(
          color: Colors.black.withAlpha(40),
          borderRadius: BorderRadius.circular(99),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(5.w, 0.4.h, 3.w, 1.2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            tr.filter_title,
            style: appTextStyle(
              context,
              fontSize: 16.sp,
              fontWeight: FontWeight.w900,
              color: AppColors.blackColor,
            ),
          ),
          TextButton(
            onPressed: _reset,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.goldBrandColor,
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.4.h),
            ),
            child: Text(
              tr.filter_reset,
              style: appTextStyle(
                context,
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.goldBrandColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.4.h),
      child: Text(
        title,
        style: appTextStyle(
          context,
          fontSize: 12.sp,
          fontWeight: FontWeight.w800,
          color: AppColors.blackColor,
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.2.h),
      child: Divider(height: 1, color: Colors.black.withAlpha(10)),
    );
  }

  // ── Looking To ─────────────────────────────────────────────────────────────

  Widget _buildLookingToSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel(tr.filter_looking_to),
        Row(
          children: [
            _FilterChip(
              label: tr.buy,
              isSelected: _listingType == 'buy',
              onTap: () => setState(
                () => _listingType = _listingType == 'buy' ? null : 'buy',
              ),
            ),
            SizedBox(width: 2.5.w),
            _FilterChip(
              label: tr.rent,
              isSelected: _listingType == 'rent',
              onTap: () => setState(
                () => _listingType = _listingType == 'rent' ? null : 'rent',
              ),
            ),
            SizedBox(width: 2.5.w),
            _FilterChip(
              label: tr.both,
              isSelected: _listingType == 'both',
              onTap: () => setState(
                () => _listingType = _listingType == 'both' ? null : 'both',
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── Owner Type ─────────────────────────────────────────────────────────────

  // ── Property Type ──────────────────────────────────────────────────────────

  Widget _buildPropertyTypeSection() {
    final categoriesAsync = ref.watch(homeCategoryControllerProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel(tr.filter_property_type),
        categoriesAsync.when(
          data: (categories) => Wrap(
            spacing: 2.5.w,
            runSpacing: 1.2.h,
            children: categories.map((cat) {
              final key = cat.id.toString();
              return _FilterChip(
                label: cat.name,
                isSelected: _assetTypes.contains(key),
                onTap: () => setState(() {
                  if (_assetTypes.contains(key)) {
                    _assetTypes.remove(key);
                  } else {
                    _assetTypes.add(key);
                  }
                }),
              );
            }).toList(),
          ),
          loading: () => Wrap(
            spacing: 2.5.w,
            runSpacing: 1.2.h,
            children: List.generate(
              4,
              (_) => ShimmerPlaceholder(
                width: 25.w,
                height: 4.5.h,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          error: (_, __) => const SizedBox.shrink(),
        ),
      ],
    );
  }

  // ── Location ───────────────────────────────────────────────────────────────

  Widget _buildLocationSection() {
    final countriesAsync = ref.watch(countriesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel(tr.filter_location),

        // ── Country ──────────────────────────────────────────────────
        countriesAsync.when(
          data: (countries) => _LocationSelector(
            icon: Icons.public_rounded,
            hint: tr.filter_select_country,
            value: _country,
            items: countries.map((c) => c.name).toList(),
            onChanged: (name) {
              if (name == null) {
                setState(() {
                  _country = null;
                  _selectedCountryId = null;
                  _city = null;
                });
                return;
              }
              final selected = countries.firstWhere((c) => c.name == name);
              setState(() {
                _country = selected.name;
                _selectedCountryId = selected.id;
                _city = null;
              });
            },
          ),
          loading: () => _buildSelectorSkeleton(),
          error: (_, __) => const SizedBox.shrink(),
        ),

        // ── City (appears after country selected) ────────────────────
        AnimatedSize(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOut,
          child: _selectedCountryId == null
              ? const SizedBox.shrink()
              : Padding(
                  padding: EdgeInsets.only(top: 1.4.h),
                  child: _CitiesDropdown(
                    countryId: _selectedCountryId!,
                    selectedCity: _city,
                    onChanged: (city) => setState(() => _city = city),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildSelectorSkeleton() {
    return ShimmerPlaceholder(
      width: double.infinity,
      height: 6.h,
      borderRadius: BorderRadius.circular(14),
    );
  }

  // ── Rental Period ──────────────────────────────────────────────────────────

  Widget _buildRentalPeriodSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel(tr.filter_rental_period),

        // Selected dates summary
        if (_checkIn != null || _checkOut != null) ...[
          _SelectedDatesCard(checkIn: _checkIn, checkOut: _checkOut),
          SizedBox(height: 1.5.h),
        ],

        // Inline calendar
        _InlineCalendar(
          displayMonth: _displayMonth,
          checkIn: _checkIn,
          checkOut: _checkOut,
          onDaySelected: (date) {
            setState(() {
              // Reset if both already selected, or new date is before check-in
              if (_checkIn == null ||
                  (_checkIn != null && _checkOut != null) ||
                  date.isBefore(_checkIn!)) {
                _checkIn = date;
                _checkOut = null;
              } else if (date.isAtSameMomentAs(_checkIn!)) {
                // Tap same day → clear
                _checkIn = null;
              } else {
                _checkOut = date;
              }
            });
          },
          onPrevMonth: () {
            final prev = DateTime(_displayMonth.year, _displayMonth.month - 1);
            final now = DateTime(DateTime.now().year, DateTime.now().month);
            if (!prev.isBefore(now)) {
              setState(() => _displayMonth = prev);
            }
          },
          onNextMonth: () => setState(
            () => _displayMonth = DateTime(
              _displayMonth.year,
              _displayMonth.month + 1,
            ),
          ),
        ),
      ],
    );
  }

  // ── Apply Button ───────────────────────────────────────────────────────────

  Widget _buildApplyButton() {
    return Container(
      padding: EdgeInsets.fromLTRB(5.w, 1.5.h, 5.w, 2.8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 14,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 6.5.h,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xFFE07B00), Color(0xFFB35700)],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.goldBrandColor.withAlpha(80),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _apply,
              borderRadius: BorderRadius.circular(16),
              splashColor: Colors.white.withAlpha(30),
              child: Center(
                child: Text(
                  tr.filter_apply_filters,
                  style: appTextStyle(
                    context,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Private: _FilterChip ─────────────────────────────────────────────────────

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(999);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        splashColor: AppColors.goldBrandColor.withAlpha(30),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: EdgeInsets.symmetric(horizontal: 3.8.w, vertical: 1.1.h),
          decoration: BoxDecoration(
            borderRadius: radius,
            gradient: isSelected
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.goldBrandColor.withAlpha(42),
                      AppColors.goldBrandColor.withAlpha(16),
                    ],
                  )
                : null,
            color: isSelected ? null : Colors.white,
            border: Border.all(
              color: isSelected
                  ? AppColors.goldBrandColor.withAlpha(160)
                  : Colors.black.withAlpha(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(isSelected ? 14 : 8),
                blurRadius: isSelected ? 12 : 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: appTextStyle(
                  context,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                  color: isSelected
                      ? AppColors.goldBrandColor
                      : AppColors.blackColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Private: _CitiesDropdown ────────────────────────────────────────────────

/// Isolated ConsumerWidget so `citiesProvider(countryId)` is watched
/// unconditionally within its own build scope — avoids conditional ref.watch.
class _CitiesDropdown extends ConsumerWidget {
  final int countryId;
  final String? selectedCity;
  final ValueChanged<String?> onChanged;

  const _CitiesDropdown({
    required this.countryId,
    required this.selectedCity,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final citiesAsync = ref.watch(citiesProvider(countryId));
    return citiesAsync.when(
      data: (cities) => _LocationSelector(
        icon: Icons.location_city_rounded,
        hint: tr.filter_select_city,
        value: selectedCity,
        items: cities.map((c) => c.name).toList(),
        onChanged: onChanged,
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

// ─── Private: _LocationSelector ──────────────────────────────────────────────

class _LocationSelector extends StatelessWidget {
  final IconData icon;
  final String hint;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _LocationSelector({
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

// ─── Private: _SelectedDatesCard ─────────────────────────────────────────────

class _SelectedDatesCard extends StatelessWidget {
  final DateTime? checkIn;
  final DateTime? checkOut;

  const _SelectedDatesCard({this.checkIn, this.checkOut});

  String _fmt(DateTime? d) =>
      d != null ? '${d.day} / ${d.month} / ${d.year}' : '—';

  @override
  Widget build(BuildContext context) {
    final nights = checkIn != null && checkOut != null
        ? checkOut!.difference(checkIn!).inDays
        : 0;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.4.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.goldBrandColor.withAlpha(22),
            AppColors.goldBrandColor.withAlpha(8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.goldBrandColor.withAlpha(60)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _DateColumn(label: tr.check_in, value: _fmt(checkIn)),
          ),
          Container(
            width: 1,
            height: 4.2.h,
            color: AppColors.goldBrandColor.withAlpha(60),
          ),
          if (nights > 0) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.5.w),
              child: Column(
                children: [
                  Text(
                    '$nights',
                    style: appTextStyle(
                      context,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w900,
                      color: AppColors.goldBrandColor,
                    ),
                  ),
                  Text(
                    tr.nights,
                    style: appTextStyle(
                      context,
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.grayBrandColor,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 1,
              height: 4.2.h,
              color: AppColors.goldBrandColor.withAlpha(60),
            ),
          ],
          Expanded(
            child: _DateColumn(label: tr.check_out, value: _fmt(checkOut)),
          ),
        ],
      ),
    );
  }
}

class _DateColumn extends StatelessWidget {
  final String label;
  final String value;

  const _DateColumn({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: appTextStyle(
            context,
            fontSize: 8.5.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.grayBrandColor,
          ),
        ),
        SizedBox(height: 0.3.h),
        Text(
          value,
          style: appTextStyle(
            context,
            fontSize: 10.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.blackColor,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// ─── Private: _InlineCalendar ─────────────────────────────────────────────────

class _InlineCalendar extends StatelessWidget {
  final DateTime displayMonth;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final ValueChanged<DateTime> onDaySelected;
  final VoidCallback onPrevMonth;
  final VoidCallback onNextMonth;

  // Short day names (Mon-first)
  static const _weekDayLabels = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];

  static const _monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  const _InlineCalendar({
    required this.displayMonth,
    required this.checkIn,
    required this.checkOut,
    required this.onDaySelected,
    required this.onPrevMonth,
    required this.onNextMonth,
  });

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateTime(
      displayMonth.year,
      displayMonth.month + 1,
      0,
    ).day;
    // weekday: 1=Mon … 7=Sun  →  offset 0-based
    final firstWeekday =
        DateTime(displayMonth.year, displayMonth.month, 1).weekday - 1;

    final today = DateTime.now();
    final todayNorm = DateTime(today.year, today.month, today.day);
    final currentMonthNorm = DateTime(
      DateTime.now().year,
      DateTime.now().month,
    );
    final isCurrentMonth = displayMonth.isAtSameMomentAs(currentMonthNorm);

    return Container(
      padding: EdgeInsets.all(3.5.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black.withAlpha(10)),
      ),
      child: Column(
        children: [
          // ── Month navigation ──────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _CalNavButton(
                icon: Icons.chevron_left_rounded,
                onTap: isCurrentMonth ? null : onPrevMonth,
              ),
              Text(
                '${_monthNames[displayMonth.month - 1]} ${displayMonth.year}',
                style: appTextStyle(
                  context,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w900,
                  color: AppColors.blackColor,
                ),
              ),
              _CalNavButton(
                icon: Icons.chevron_right_rounded,
                onTap: onNextMonth,
              ),
            ],
          ),

          SizedBox(height: 1.8.h),

          // ── Weekday headers ───────────────────────────────────────
          Row(
            children: _weekDayLabels
                .map(
                  (d) => Expanded(
                    child: Center(
                      child: Text(
                        d,
                        style: appTextStyle(
                          context,
                          fontSize: 8.5.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.grayBrandColor,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),

          SizedBox(height: 0.8.h),

          // ── Day grid ──────────────────────────────────────────────
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1.05,
            ),
            itemCount: firstWeekday + daysInMonth,
            itemBuilder: (context, index) {
              if (index < firstWeekday) return const SizedBox.shrink();

              final day = index - firstWeekday + 1;
              final date = DateTime(displayMonth.year, displayMonth.month, day);
              final isPast = date.isBefore(todayNorm);
              final isCheckIn = checkIn != null && _sameDay(date, checkIn!);
              final isCheckOut = checkOut != null && _sameDay(date, checkOut!);
              final isInRange =
                  checkIn != null &&
                  checkOut != null &&
                  date.isAfter(checkIn!) &&
                  date.isBefore(checkOut!);
              final isToday = _sameDay(date, todayNorm);

              return _DayCell(
                day: day,
                isPast: isPast,
                isCheckIn: isCheckIn,
                isCheckOut: isCheckOut,
                isInRange: isInRange,
                isToday: isToday,
                onTap: isPast ? null : () => onDaySelected(date),
              );
            },
          ),
        ],
      ),
    );
  }

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

// ─── Private: _CalNavButton ───────────────────────────────────────────────────

class _CalNavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _CalNavButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 150),
        opacity: enabled ? 1.0 : 0.3,
        child: Container(
          padding: EdgeInsets.all(1.8.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black.withAlpha(15)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(8),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, size: 18, color: AppColors.blackColor),
        ),
      ),
    );
  }
}

// ─── Private: _DayCell ───────────────────────────────────────────────────────

class _DayCell extends StatelessWidget {
  final int day;
  final bool isPast;
  final bool isCheckIn;
  final bool isCheckOut;
  final bool isInRange;
  final bool isToday;
  final VoidCallback? onTap;

  const _DayCell({
    required this.day,
    required this.isPast,
    required this.isCheckIn,
    required this.isCheckOut,
    required this.isInRange,
    required this.isToday,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isEndpoint = isCheckIn || isCheckOut;

    Color? bgColor;
    Color textColor;
    double opacity = 1.0;

    if (isEndpoint) {
      bgColor = AppColors.goldBrandColor;
      textColor = Colors.white;
    } else if (isInRange) {
      bgColor = AppColors.goldBrandColor.withAlpha(38);
      textColor = AppColors.blackColor;
    } else if (isPast) {
      bgColor = null;
      textColor = AppColors.grayBrandColor;
      opacity = 0.45;
    } else {
      bgColor = null;
      textColor = AppColors.blackColor;
    }

    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: opacity,
        child: Container(
          margin: const EdgeInsets.all(1.5),
          decoration: BoxDecoration(
            color: bgColor,
            shape: isEndpoint ? BoxShape.circle : BoxShape.rectangle,
            borderRadius: isEndpoint
                ? null
                : isInRange
                ? BorderRadius.circular(6)
                : null,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text(
                '$day',
                style: appTextStyle(
                  context,
                  fontSize: 9.5.sp,
                  fontWeight: isEndpoint ? FontWeight.w900 : FontWeight.w600,
                  color: textColor,
                ),
              ),
              // Today indicator dot
              if (isToday && !isEndpoint)
                Positioned(
                  bottom: 3,
                  child: Container(
                    width: 4,
                    height: 4,
                    decoration: const BoxDecoration(
                      color: AppColors.goldBrandColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
