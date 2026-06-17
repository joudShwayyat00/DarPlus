enum BookingStatusFilter {
  pending,
  approved,
  rejected,
  cancelled;

  String get apiValue => name;
}
