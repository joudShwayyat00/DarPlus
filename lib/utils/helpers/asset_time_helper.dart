/// Formats API time values like `10:30:00` for display and form fields (`10:30`).
String? formatAssetTimeForDisplay(String? value) {
  if (value == null) return null;
  final trimmed = value.trim();
  if (trimmed.isEmpty) return null;

  final parts = trimmed.split(':');
  if (parts.length >= 2) {
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour != null && minute != null) {
      return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
    }
  }

  return trimmed;
}

bool hasAssetCheckTimes({
  String? checkInTime,
  String? checkOutTime,
}) {
  return formatAssetTimeForDisplay(checkInTime) != null ||
      formatAssetTimeForDisplay(checkOutTime) != null;
}
