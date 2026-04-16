import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/screens/home/home_screen.dart';
import 'package:dar_plus_app/screens/profile/my_reservations_screen.dart';
import 'package:dar_plus_app/screens/profile/profile.dart';
import 'package:dar_plus_app/screens/search.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:sizer/sizer.dart';
import 'package:dar_plus_app/main.dart';

class BottomNavBarScreen extends StatefulWidget {
  const BottomNavBarScreen({super.key});

  @override
  State<BottomNavBarScreen> createState() => _BottomNavBarScreenState();
}

class _BottomNavBarScreenState extends State<BottomNavBarScreen> {
  int _index = 0;

  late final List<Widget> _pages = [
    HomeScreen(),
    SearchScreen(),
    MyReservationsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: IndexedStack(index: _index, children: _pages),

      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: EdgeInsets.fromLTRB(4.w, 1.2.h, 4.w, 1.4.h),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            border: Border(
              top: BorderSide(color: Colors.black.withAlpha(18), width: 1),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(12),
                blurRadius: 18,
                offset: const Offset(0, -6),
              ),
            ],
          ),
          child: GNav(
            selectedIndex: _index,
            onTabChange: (i) => setState(() => _index = i),
            gap: 8,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.2.h),
            tabBorderRadius: 16,
            duration: const Duration(milliseconds: 280),

            // color: Colors.black.withAlpha(140),
            color: AppColors.grayBrandColor,
            activeColor: AppColors.goldBrandColor,

            tabBackgroundColor: AppColors.goldBrandColor.withAlpha(25),

            iconSize: 22,

            textStyle: appTextStyle(
              context,
              fontSize: 10.2.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.goldBrandColor,
            ),

            tabs: [
              GButton(icon: Icons.home_rounded, text: tr.nav_home),
              GButton(icon: Icons.search_rounded, text: tr.nav_explore),
              GButton(icon: Icons.bookmark_rounded, text: tr.nav_bookings),
              GButton(icon: Icons.person_rounded, text: tr.nav_profile),
            ],
          ),
        ),
      ),
    );
  }
}
