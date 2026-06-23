import 'package:dar_plus_app/core/network/api_constants.dart';
import 'package:dar_plus_app/features/assets/data/models/asset_item.dart';

String? resolveAssetVideoUrl(String? video) {
  if (video == null) return null;
  final trimmed = video.trim();
  if (trimmed.isEmpty) return null;
  if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
    return trimmed;
  }

  final normalized = trimmed.startsWith('/') ? trimmed.substring(1) : trimmed;
  if (normalized.startsWith('public/')) {
    return '${ApiConstants.baseUrl}$normalized';
  }
  return '${ApiConstants.baseUrl}public/storage/$normalized';
}

bool isYoutubeVideoUrl(String? url) {
  if (url == null || url.trim().isEmpty) return false;
  final lower = url.toLowerCase();
  return lower.contains('youtube.com') || lower.contains('youtu.be');
}

String? extractYoutubeVideoId(String url) {
  final uri = Uri.tryParse(url.trim());
  if (uri == null) return null;

  final host = uri.host.toLowerCase();
  if (host.contains('youtu.be') && uri.pathSegments.isNotEmpty) {
    return uri.pathSegments.first;
  }

  if (host.contains('youtube.com')) {
    if (uri.path == '/watch') {
      return uri.queryParameters['v'];
    }
    if (uri.pathSegments.length >= 2) {
      final first = uri.pathSegments.first;
      if (first == 'embed' || first == 'shorts' || first == 'live') {
        return uri.pathSegments[1];
      }
    }
  }

  return null;
}

String youtubeThumbnailUrl(String videoId) =>
    'https://img.youtube.com/vi/$videoId/hqdefault.jpg';

extension AssetItemVideo on AssetItem {
  String? get resolvedVideoUrl => resolveAssetVideoUrl(video);

  bool get hasVideo => resolvedVideoUrl != null;

  bool get hasYoutubeVideo =>
      hasVideo && isYoutubeVideoUrl(resolvedVideoUrl);
}
