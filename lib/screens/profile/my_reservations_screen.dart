import 'package:cached_network_image/cached_network_image.dart';
import 'package:dar_plus_app/core/constants/app_currency.dart';
import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/features/booking/data/models/my_booking_item.dart';
import 'package:dar_plus_app/features/booking/domain/booking_status_filter.dart';
import 'package:dar_plus_app/features/booking/presentation/providers/booking_providers.dart';
import 'package:dar_plus_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:dar_plus_app/main.dart';
import 'package:dar_plus_app/screens/profile/my_requested_appointments_screen.dart';
import 'package:dar_plus_app/utils/widgets/login_required_view.dart';
import 'package:dar_plus_app/screens/asset_details/asset_details_screen.dart';
import 'package:dar_plus_app/utils/helpers/app_navigation.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:dar_plus_app/utils/widgets/rate_asset_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class MyReservationsScreen extends ConsumerStatefulWidget {
  const MyReservationsScreen({super.key});

  @override
  ConsumerState<MyReservationsScreen> createState() =>
      _MyReservationsScreenState();
}

class _MyReservationsScreenState extends ConsumerState<MyReservationsScreen> {
  BookingStatusFilter _selectedStatus = BookingStatusFilter.pending;

  Future<void> _onRefresh() async {
    await ref
        .read(myBookingsControllerProvider(_selectedStatus).notifier)
        .refresh();
  }

  String _statusLabel(BookingStatusFilter status) {
    switch (status) {
      case BookingStatusFilter.pending:
        return tr.pending;
      case BookingStatusFilter.approved:
        return tr.approved;
      case BookingStatusFilter.rejected:
        return tr.rejected;
      case BookingStatusFilter.cancelled:
        return tr.cancelled;
    }
  }

  String _formatDate(String rawDate) {
    final date = _parseBookingDate(rawDate);
    if (date == null) return rawDate;
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  DateTime? _parseBookingDate(String raw) {
    final trimmed = raw.trim();
    final ddMmYyyy = RegExp(r'^(\d{1,2})-(\d{1,2})-(\d{4})$');
    final match = ddMmYyyy.firstMatch(trimmed);
    if (match != null) {
      return DateTime(
        int.parse(match.group(3)!),
        int.parse(match.group(2)!),
        int.parse(match.group(1)!),
      );
    }
    try {
      return DateTime.parse(trimmed);
    } catch (_) {
      return null;
    }
  }

  String _formatBookingPrice(MyBookingItem booking) {
    final amount = booking.finalPrice;
    final amountStr = amount == amount.roundToDouble()
        ? amount.round().toString()
        : amount.toStringAsFixed(2);
    final currency = booking.currencySymbol.trim();
    if (currency.isEmpty) return formatPrice(amount);
    return '$amountStr $currency';
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = ref.watch(isLoggedInProvider);

    if (!isLoggedIn) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8F7F4),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF8F7F4),
          elevation: 0,
          scrolledUnderElevation: 0,
          leadingWidth: 0,
          automaticallyImplyLeading: false,
          title: Text(
            tr.my_bookings,
            style: appTextStyle(
              context,
              fontSize: 14.sp,
              fontWeight: FontWeight.w800,
              color: Colors.black.withAlpha(220),
            ),
          ),
          centerTitle: false,
        ),
        body: LoginRequiredView(
          icon: Icons.bookmark_rounded,
          title: tr.sign_in_to_continue,
          message: tr.login_required_bookings,
        ),
      );
    }

    final bookingsAsync =
        ref.watch(myBookingsControllerProvider(_selectedStatus));

    return Scaffold(
      backgroundColor: const Color(0xFFF8F7F4),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F7F4),
        elevation: 0,
        scrolledUnderElevation: 0,
        leadingWidth: 0,
        automaticallyImplyLeading: false,
        title: Text(
          tr.my_bookings,
          style: appTextStyle(
            context,
            fontSize: 14.sp,
            fontWeight: FontWeight.w800,
            color: Colors.black.withAlpha(220),
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatusFilters(),
          _buildAppointmentsLink(),
          Expanded(
            child: bookingsAsync.when(
              data: (bookings) => _buildDataState(bookings),
              loading: () => _buildLoadingState(),
              error: (_, __) => _buildErrorState(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentsLink() {
    return Padding(
      padding: EdgeInsets.fromLTRB(5.w, 0, 5.w, 1.2.h),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const MyRequestedAppointmentsScreen(),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.3.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.goldBrandColor.withAlpha(50)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(6),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.5.w),
                decoration: BoxDecoration(
                  color: AppColors.goldBrandColor.withAlpha(18),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.event_available_rounded,
                  size: 18,
                  color: AppColors.goldBrandColor,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  tr.view_my_appointments,
                  style: appTextStyle(
                    context,
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black.withAlpha(200),
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 22,
                color: AppColors.goldBrandColor.withAlpha(180),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.fromLTRB(5.w, 0, 5.w, 1.5.h),
      child: Row(
        children: BookingStatusFilter.values.map((status) {
          final isSelected = _selectedStatus == status;
          return Padding(
            padding: EdgeInsets.only(right: 2.5.w),
            child: GestureDetector(
              onTap: () => setState(() => _selectedStatus = status),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                padding: EdgeInsets.symmetric(horizontal: 4.5.w, vertical: 1.1.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.goldBrandColor
                      : Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.goldBrandColor
                        : Colors.black.withAlpha(18),
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.goldBrandColor.withAlpha(70),
                            blurRadius: 14,
                            offset: const Offset(0, 5),
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: Colors.black.withAlpha(6),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _statusIcon(status),
                      size: 15,
                      color: isSelected
                          ? Colors.white
                          : AppColors.goldBrandColor,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      _statusLabel(status),
                      style: appTextStyle(
                        context,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                        color: isSelected
                            ? Colors.white
                            : Colors.black.withAlpha(180),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  IconData _statusIcon(BookingStatusFilter status) {
    switch (status) {
      case BookingStatusFilter.pending:
        return Icons.hourglass_top_rounded;
      case BookingStatusFilter.approved:
        return Icons.verified_rounded;
      case BookingStatusFilter.rejected:
        return Icons.block_rounded;
      case BookingStatusFilter.cancelled:
        return Icons.cancel_outlined;
    }
  }

  Widget _buildDataState(List<MyBookingItem> bookings) {
    if (bookings.isEmpty) {
      return RefreshIndicator(
        color: AppColors.goldBrandColor,
        onRefresh: _onRefresh,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: _buildEmptyState(),
              ),
            );
          },
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.goldBrandColor,
      onRefresh: _onRefresh,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(5.w, 0.5.h, 5.w, 2.h),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          return _buildBookingCard(bookings[index]);
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(AppColors.goldBrandColor),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: AppColors.goldBrandColor.withAlpha(15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.event_busy_rounded,
                size: 52,
                color: AppColors.goldBrandColor.withAlpha(180),
              ),
            ),
            SizedBox(height: 2.5.h),
            Text(
              tr.no_bookings_found,
              textAlign: TextAlign.center,
              style: appTextStyle(
                context,
                fontSize: 13.sp,
                fontWeight: FontWeight.w800,
                color: Colors.black.withAlpha(200),
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              tr.no_bookings_for_status(_statusLabel(_selectedStatus)),
              textAlign: TextAlign.center,
              style: appTextStyle(
                context,
                fontSize: 10.5.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black.withAlpha(100),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(5.w),
              decoration: BoxDecoration(
                color: Colors.red.withAlpha(15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.wifi_off_rounded,
                size: 48,
                color: Colors.red.withAlpha(180),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              tr.error_occurred,
              textAlign: TextAlign.center,
              style: appTextStyle(
                context,
                fontSize: 13.sp,
                fontWeight: FontWeight.w800,
                color: Colors.black.withAlpha(200),
              ),
            ),
            SizedBox(height: 2.h),
            GestureDetector(
              onTap: _onRefresh,
              child: Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 8.w, vertical: 1.4.h),
                decoration: BoxDecoration(
                  color: AppColors.goldBrandColor,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.goldBrandColor.withAlpha(60),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  tr.try_again,
                  style: appTextStyle(
                    context,
                    fontSize: 11.sp,
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

  Widget _buildBookingCard(MyBookingItem booking) {
    final asset = booking.asset;
    final canRate = booking.status.toLowerCase() == 'approved';
    final durationChips = _durationChips(booking);

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.black.withAlpha(8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              AppNavigator.of(context).push(
                AssetDetailsScreen(
                  assetId: asset.id,
                  initialAsset: asset,
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(22)),
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: asset.image,
                    height: 16.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      height: 16.h,
                      color: Colors.grey.shade200,
                    ),
                    errorWidget: (_, __, ___) => Container(
                      height: 16.h,
                      color: Colors.grey.shade200,
                      child: Icon(
                        Icons.image_outlined,
                        size: 40,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withAlpha(120),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 1.5.h,
                    right: 3.w,
                    child: _buildStatusBadge(booking.status),
                  ),
                  Positioned(
                    left: 4.w,
                    right: 4.w,
                    bottom: 1.5.h,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          asset.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: appTextStyle(
                            context,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 0.4.h),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_rounded,
                              size: 13,
                              color: Colors.white70,
                            ),
                            SizedBox(width: 1.w),
                            Expanded(
                              child: Text(
                                asset.location,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: appTextStyle(
                                  context,
                                  fontSize: 9.5.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white.withAlpha(220),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 3.5.w,
                      vertical: 1.2.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F7F4),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildDateColumn(
                            tr.check_in,
                            _formatDate(booking.checkInDate),
                            Icons.login_rounded,
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 4.h,
                          color: Colors.black.withAlpha(15),
                        ),
                        Expanded(
                          child: _buildDateColumn(
                            tr.check_out_label,
                            _formatDate(booking.checkOutDate),
                            Icons.logout_rounded,
                            alignEnd: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 1.5.h),
                  Row(
                    children: [
                      ...durationChips,
                      if (booking.guests > 0) ...[
                        if (durationChips.isNotEmpty) SizedBox(width: 2.w),
                        _buildInfoChip(
                          Icons.people_alt_rounded,
                          '${booking.guests} ${tr.guests}',
                        ),
                      ],
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            tr.total_label,
                            style: appTextStyle(
                              context,
                              fontSize: 8.5.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black.withAlpha(100),
                            ),
                          ),
                          Text(
                            _formatBookingPrice(booking),
                            style: appTextStyle(
                              context,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w900,
                              color: AppColors.goldBrandColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
              ],
            ),
          ),
          if (canRate) ...[
            Padding(
              padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 4.w),
              child: GestureDetector(
                onTap: () => showRateAssetDialog(
                  context,
                  assetId: asset.id,
                  assetName: asset.name,
                  imageUrl: asset.image,
                  bookingsFilter: _selectedStatus,
                ),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 1.3.h),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.goldBrandColor.withAlpha(25),
                        AppColors.goldBrandColor.withAlpha(10),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppColors.goldBrandColor.withAlpha(80),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.star_rounded,
                        size: 18,
                        color: AppColors.goldBrandColor,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        tr.rate_your_stay,
                        style: appTextStyle(
                          context,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.goldBrandColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  List<Widget> _durationChips(MyBookingItem booking) {
    final chips = <Widget>[];

    void addChip(IconData icon, String text) {
      if (chips.isNotEmpty) chips.add(SizedBox(width: 2.w));
      chips.add(_buildInfoChip(icon, text));
    }

    if (booking.nights > 0) {
      addChip(Icons.nights_stay_rounded, '${booking.nights} ${tr.nights}');
    }
    if (booking.monthsCount > 0) {
      addChip(
        Icons.calendar_month_rounded,
        '${booking.monthsCount} ${tr.months}',
      );
    }
    if (booking.yearsCount > 0) {
      addChip(
        Icons.calendar_today_rounded,
        '${booking.yearsCount} ${tr.years}',
      );
    }

    return chips;
  }

  Widget _buildDateColumn(
    String label,
    String date,
    IconData icon, {
    bool alignEnd = false,
  }) {
    return Column(
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: appTextStyle(
            context,
            fontSize: 8.5.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black.withAlpha(100),
          ),
        ),
        SizedBox(height: 0.4.h),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!alignEnd) ...[
              Icon(icon, size: 13, color: AppColors.goldBrandColor),
              SizedBox(width: 1.w),
            ],
            Flexible(
              child: Text(
                date,
                style: appTextStyle(
                  context,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black.withAlpha(200),
                ),
              ),
            ),
            if (alignEnd) ...[
              SizedBox(width: 1.w),
              Icon(icon, size: 13, color: AppColors.goldBrandColor),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 0.6.h),
      decoration: BoxDecoration(
        color: AppColors.goldBrandColor.withAlpha(18),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppColors.goldBrandColor),
          SizedBox(width: 1.w),
          Text(
            text,
            style: appTextStyle(
              context,
              fontSize: 9.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.goldBrandColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor;
    Color textColor;
    String text;

    switch (status.toLowerCase()) {
      case 'approved':
        bgColor = Colors.green.withAlpha(230);
        textColor = Colors.white;
        text = tr.approved;
        break;
      case 'rejected':
        bgColor = Colors.red.withAlpha(230);
        textColor = Colors.white;
        text = tr.rejected;
        break;
      case 'cancelled':
        bgColor = Colors.grey.withAlpha(230);
        textColor = Colors.white;
        text = tr.cancelled;
        break;
      case 'pending':
      default:
        bgColor = Colors.orange.withAlpha(230);
        textColor = Colors.white;
        text = tr.pending;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: appTextStyle(
          context,
          fontSize: 9.sp,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }
}
