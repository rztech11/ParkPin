import 'package:geolocator/geolocator.dart';

class DistanceCalculator {
  /// Calculate distance between two lat/lng points in meters
  static double calculateDistanceInMeters({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
  }) {
    return Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
  }

  /// Formatted distance: '420 m' or '1.4 km'
  static String formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.round()} m';
    } else {
      final km = meters / 1000;
      return '${km.toStringAsFixed(1)} km';
    }
  }

  /// Estimated walking time based on average walking speed (approx. 80m/min or 4.8 km/h)
  static String estimatedWalkingTime(double meters) {
    final minutes = (meters / 80).ceil();
    if (minutes <= 1) {
      return 'About 1 min walk';
    } else if (minutes < 60) {
      return 'About $minutes min walk';
    } else {
      final hours = minutes ~/ 60;
      final remainingMins = minutes % 60;
      return 'About $hours hr ${remainingMins > 0 ? '$remainingMins min ' : ''}walk';
    }
  }

  /// Combined string: '420 m away • About 5 min walk'
  static String formatDistanceAndWalkTime({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
  }) {
    final meters = calculateDistanceInMeters(
      startLat: startLat,
      startLng: startLng,
      endLat: endLat,
      endLng: endLng,
    );
    final distStr = formatDistance(meters);
    final walkTime = estimatedWalkingTime(meters);
    return '$distStr away • $walkTime';
  }
}
