import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/models/property_item.dart';
import 'package:dar_plus_app/screens/property_details/property_details_screen.dart';
import 'package:dar_plus_app/utils/helpers/app_navigation.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:dar_plus_app/main.dart';

class MyReservationsScreen extends StatefulWidget {
  const MyReservationsScreen({super.key});

  @override
  State<MyReservationsScreen> createState() => _MyReservationsScreenState();
}

class _MyReservationsScreenState extends State<MyReservationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<_ReservationItem> _upcomingReservations = [
    _ReservationItem(
      propertyName: "Luxury Villa Marina",
      location: "Dubai Marina, UAE",
      checkIn: "Feb 15, 2026",
      checkOut: "Feb 20, 2026",
      status: ReservationStatus.confirmed,
      imageUrl: "https://images.unsplash.com/photo-1613490493576-7fde63acd811",
      price: "\$1,250",
    ),
    _ReservationItem(
      propertyName: "Penthouse Suite",
      location: "Downtown, Dubai",
      checkIn: "Mar 05, 2026",
      checkOut: "Mar 10, 2026",
      status: ReservationStatus.pending,
      imageUrl: "https://images.unsplash.com/photo-1600596542815-ffad4c1539a9",
      price: "\$2,100",
    ),
  ];

  final List<_ReservationItem> _pastReservations = [
    _ReservationItem(
      propertyName: "Beach Resort Apartment",
      location: "JBR, Dubai",
      checkIn: "Jan 10, 2026",
      checkOut: "Jan 15, 2026",
      status: ReservationStatus.completed,
      imageUrl: "https://images.unsplash.com/photo-1560448204-e02f11c3d0e2",
      price: "\$980",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        scrolledUnderElevation: 0,

        title: Text(
          tr.my_bookings,
          style: appTextStyle(
            context,
            fontSize: 14.sp,
            fontWeight: FontWeight.w800,
            color: Colors.black.withAlpha(220),
          ),
        ),

        //remove the back button space
        leadingWidth: 0,
        // remove default back arrow
        automaticallyImplyLeading: false,

        centerTitle: false,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.goldBrandColor,
          unselectedLabelColor: Colors.black.withAlpha(120),
          indicatorColor: AppColors.goldBrandColor,
          indicatorWeight: 3,
          labelStyle: appTextStyle(
            context,
            fontSize: 11.sp,
            fontWeight: FontWeight.w700,
          ),
          unselectedLabelStyle: appTextStyle(
            context,
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
          ),
          tabs: [
            Tab(text: tr.upcoming),
            Tab(text: tr.past),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildReservationsList(_upcomingReservations, isUpcoming: true),
          _buildReservationsList(_pastReservations, isUpcoming: false),
        ],
      ),
    );
  }

  Widget _buildReservationsList(
    List<_ReservationItem> reservations, {
    required bool isUpcoming,
  }) {
    if (reservations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 60,
              color: Colors.black.withAlpha(60),
            ),
            SizedBox(height: 2.h),
            Text(
              isUpcoming
                  ? tr.no_upcoming_reservations
                  : tr.no_past_reservations,
              style: appTextStyle(
                context,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black.withAlpha(120),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(5.w),
      itemCount: reservations.length,
      itemBuilder: (context, index) {
        final reservation = reservations[index];
        return InkWell(
          onTap: () {
            // Create a PropertyItem from reservation data
            final propertyItem = PropertyItem(
              title: reservation.propertyName,
              location: reservation.location,
              price: reservation.price,
              rating: 4.5,
              images: [reservation.imageUrl],
              description:
                  "Reservation from ${reservation.checkIn} to ${reservation.checkOut}",
              guests: 4,
              bedrooms: 2,
              bathrooms: 2,
              size: 120,
              hasPool: true,
              hasBbq: false,
              hasWifi: true,
            );
            AppNavigator.of(
              context,
            ).push(PropertyDetailsScreen(item: propertyItem));
          },
          child: _buildReservationCard(reservation),
        );
      },
    );
  }

  Widget _buildReservationCard(_ReservationItem reservation) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black.withAlpha(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            child: Stack(
              children: [
                Image.network(
                  reservation.imageUrl,
                  height: 15.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 15.h,
                    color: Colors.grey.shade200,
                    child: Icon(
                      Icons.image_outlined,
                      size: 40,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
                Positioned(
                  top: 1.5.h,
                  right: 3.w,
                  child: _buildStatusBadge(reservation.status),
                ),
              ],
            ),
          ),

          // Details
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reservation.propertyName == "Luxury Villa Marina"
                      ? tr.sample_luxury_villa_marina
                      : reservation.propertyName == "Penthouse Suite"
                      ? tr.sample_penthouse_suite
                      : reservation.propertyName == "Beach Resort Apartment"
                      ? tr.sample_beach_resort_apartment
                      : reservation.propertyName,
                  style: appTextStyle(
                    context,
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.black.withAlpha(220),
                  ),
                ),
                SizedBox(height: 0.5.h),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: Colors.black.withAlpha(120),
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      reservation.location,
                      style: appTextStyle(
                        context,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black.withAlpha(120),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.5.h),
                Row(
                  children: [
                    _buildDateInfo(
                      tr.check_in,
                      reservation.checkIn,
                      Icons.login_rounded,
                    ),
                    SizedBox(width: 5.w),
                    _buildDateInfo(
                      tr.check_out_label,
                      reservation.checkOut,
                      Icons.logout_rounded,
                    ),
                    const Spacer(),
                    Text(
                      reservation.price,
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
          ),
        ],
      ),
    );
  }

  Widget _buildDateInfo(String label, String date, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: appTextStyle(
            context,
            fontSize: 9.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black.withAlpha(100),
          ),
        ),
        SizedBox(height: 0.3.h),
        Row(
          children: [
            Icon(icon, size: 12, color: AppColors.goldBrandColor),
            SizedBox(width: 1.w),
            Text(
              date,
              style: appTextStyle(
                context,
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black.withAlpha(180),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusBadge(ReservationStatus status) {
    Color bgColor;
    Color textColor;
    String text;

    switch (status) {
      case ReservationStatus.confirmed:
        bgColor = Colors.green.withAlpha(220);
        textColor = Colors.white;
        text = tr.confirmed;
        break;
      case ReservationStatus.pending:
        bgColor = Colors.orange.withAlpha(220);
        textColor = Colors.white;
        text = tr.pending;
        break;
      case ReservationStatus.completed:
        bgColor = Colors.blue.withAlpha(220);
        textColor = Colors.white;
        text = tr.completed;
        break;
      case ReservationStatus.cancelled:
        bgColor = Colors.red.withAlpha(220);
        textColor = Colors.white;
        text = tr.cancelled;
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

enum ReservationStatus { confirmed, pending, completed, cancelled }

class _ReservationItem {
  final String propertyName;
  final String location;
  final String checkIn;
  final String checkOut;
  final ReservationStatus status;
  final String imageUrl;
  final String price;

  const _ReservationItem({
    required this.propertyName,
    required this.location,
    required this.checkIn,
    required this.checkOut,
    required this.status,
    required this.imageUrl,
    required this.price,
  });
}
