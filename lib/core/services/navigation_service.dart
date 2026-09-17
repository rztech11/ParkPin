import 'package:url_launcher/url_launcher.dart';

class NavigationService {
  /// Open external map / Google Maps for walking directions to parking spot
  static Future<bool> launchTurnByTurnNavigation({
    required double destinationLat,
    required double destinationLng,
    String? label,
  }) async {
    // 1. Try native Google Maps turn-by-turn navigation intent
    final String encodedLabel = Uri.encodeComponent(label ?? 'Parked Vehicle');
    final Uri navUri = Uri.parse('google.navigation:q=$destinationLat,$destinationLng&mode=w');
    final Uri geoUri = Uri.parse('geo:$destinationLat,$destinationLng?q=$destinationLat,$destinationLng($encodedLabel)');
    final Uri webMapsUri = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$destinationLat,$destinationLng&travelmode=walking');

    try {
      if (await canLaunchUrl(navUri)) {
        return await launchUrl(navUri, mode: LaunchMode.externalApplication);
      } else if (await canLaunchUrl(geoUri)) {
        return await launchUrl(geoUri, mode: LaunchMode.externalApplication);
      } else if (await canLaunchUrl(webMapsUri)) {
        return await launchUrl(webMapsUri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}

    // Fallback attempt
    try {
      return await launchUrl(webMapsUri, mode: LaunchMode.externalApplication);
    } catch (_) {
      return false;
    }
  }
}
