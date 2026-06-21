import 'package:dar_plus_app/main.dart';
import 'package:dar_plus_app/models/property_item.dart';
import 'package:dar_plus_app/screens/book_now_screen.dart';
import 'package:dar_plus_app/utils/helpers/app_navigation.dart';
import 'package:dar_plus_app/utils/widgets/auth_required_sheet.dart';
import 'package:flutter/material.dart';

Future<void> openBookingFlow(BuildContext context, PropertyItem item) async {
  if (!await requireAuth(
    context,
    message: tr.login_required_booking,
    icon: Icons.calendar_month_rounded,
  )) {
    return;
  }
  if (!context.mounted) return;
  AppNavigator.of(context).push(BookingScreen(item: item));
}
