import 'package:url_launcher/url_launcher.dart';

Future<bool> launchPhoneCall(String phone) async {
  final digits = phone.replaceAll(RegExp(r'[^\d+]'), '');
  if (digits.isEmpty) return false;
  return _launch(Uri(scheme: 'tel', path: digits), external: true);
}

Future<bool> launchEmail(String email) async {
  final address = email.trim();
  if (address.isEmpty) return false;
  return _launch(Uri(scheme: 'mailto', path: address), external: true);
}

Future<bool> launchExternalLink(String url) async {
  final uri = Uri.tryParse(url.trim());
  if (uri == null || !uri.hasScheme) return false;
  return _launch(uri, external: true);
}

Future<bool> _launch(Uri uri, {bool external = false}) async {
  final mode = external
      ? LaunchMode.externalApplication
      : LaunchMode.platformDefault;
  try {
    return await launchUrl(uri, mode: mode);
  } catch (_) {
    return false;
  }
}
