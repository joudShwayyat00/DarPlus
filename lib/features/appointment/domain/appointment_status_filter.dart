enum AppointmentStatusFilter {
  pending,
  approved,
  rejected,
  cancelled;

  String get apiValue => name;
}
