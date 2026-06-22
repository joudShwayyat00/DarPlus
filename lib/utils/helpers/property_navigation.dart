import 'package:dar_plus_app/main.dart';
import 'package:dar_plus_app/models/property_item.dart';
import 'package:dar_plus_app/utils/helpers/booking_navigation.dart';
import 'package:dar_plus_app/utils/widgets/appointment_sheet.dart';
import 'package:flutter/material.dart';

/// Opens booking for rent listings or the appointment sheet for sale listings.
Future<void> openPropertyActionFlow(
  BuildContext context,
  PropertyItem item,
) async {
  if (item.listingType == ListingType.sale) {
    final assetId = item.assetId;
    if (assetId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(tr.error_occurred)),
      );
      return;
    }
    await showAppointmentSheet(
      context,
      assetId: assetId,
      assetName: item.title,
    );
    return;
  }
  await openBookingFlow(context, item);
}
