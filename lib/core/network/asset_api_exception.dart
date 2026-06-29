/// Thrown when add/update/delete asset API calls fail.
class AssetApiException implements Exception {
  final String message;
  final bool isSubscriptionRequired;

  const AssetApiException(
    this.message, {
    this.isSubscriptionRequired = false,
  });

  @override
  String toString() => message;
}

String formatAssetApiError(Object? error, {required String fallback}) {
  if (error == null) return fallback;
  if (error is AssetApiException) return error.message;
  final text = error.toString();
  const prefix = 'Exception: ';
  if (text.startsWith(prefix)) return text.substring(prefix.length);
  return text;
}
