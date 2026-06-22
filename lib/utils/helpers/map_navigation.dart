import 'package:dar_plus_app/utils/helpers/external_link_launcher.dart';

Future<bool> launchGoogleMaps({
  required double latitude,
  required double longitude,
}) async {
  final query = '$latitude,$longitude';
  final uri =
      Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');
  return launchExternalLink(uri.toString());
}
