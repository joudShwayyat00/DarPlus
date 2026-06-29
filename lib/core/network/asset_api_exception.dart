import 'dart:convert';

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

String? extractApiErrorMessage(dynamic data) {
  if (data == null) return null;

  if (data is String) {
    final trimmed = data.trim();
    if (trimmed.isEmpty) return null;
    if (trimmed.startsWith('{') || trimmed.startsWith('[')) {
      try {
        return extractApiErrorMessage(
          (jsonDecode(trimmed) as dynamic),
        );
      } catch (_) {
        return trimmed;
      }
    }
    return trimmed;
  }

  if (data is Map) {
    final message = data['message'];
    if (message is String && message.trim().isNotEmpty) {
      return message.trim();
    }
    if (message is List && message.isNotEmpty) {
      return message.map((item) => item.toString()).join('\n');
    }

    final errors = data['errors'];
    if (errors is List && errors.isNotEmpty) {
      return errors.map((item) => item.toString()).join('\n');
    }
    if (errors is Map && errors.isNotEmpty) {
      return errors.values.map((item) => item.toString()).join('\n');
    }
  }

  return null;
}

String formatAssetApiError(Object? error, {required String fallback}) {
  if (error == null) return fallback;
  if (error is AssetApiException) return error.message;
  final text = error.toString();
  const prefix = 'Exception: ';
  if (text.startsWith(prefix)) return text.substring(prefix.length);
  return text;
}
