/// App-wide currency code. Always displayed as `JOD` regardless of locale.
const String kAppCurrency = 'JOD';

/// Formats a numeric amount with the static app currency.
String formatPrice(
  dynamic amount, {
  String? suffix,
  int? decimals,
}) {
  final amountStr = _formatAmount(amount, decimals: decimals);
  if (suffix == null || suffix.isEmpty) {
    return '$amountStr $kAppCurrency';
  }
  return '$amountStr $kAppCurrency$suffix';
}

String _formatAmount(dynamic amount, {int? decimals}) {
  if (amount is num) {
    if (decimals != null) return amount.toStringAsFixed(decimals);
    if (amount is int || amount == amount.roundToDouble()) {
      return amount.round().toString();
    }
    return amount.toStringAsFixed(2);
  }

  final raw = amount.toString().trim();
  final parsed = num.tryParse(raw.replaceAll(RegExp(r'[^\d.]'), ''));
  if (parsed == null) return raw;

  if (decimals != null) return parsed.toStringAsFixed(decimals);
  if (parsed == parsed.roundToDouble()) return parsed.round().toString();
  return parsed.toStringAsFixed(2);
}

/// Extracts the first numeric value from a free-form price string.
String? extractPriceDigits(String price) {
  return RegExp(r'\d+(?:\.\d+)?').firstMatch(price)?.group(0);
}
