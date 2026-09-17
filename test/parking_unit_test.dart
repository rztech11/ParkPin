import 'package:flutter_test/flutter_test.dart';
import 'package:parkpin/models/parking_session.dart';
import 'package:parkpin/models/app_settings.dart';
import 'package:parkpin/core/utils/date_formatter.dart';
import 'package:parkpin/core/utils/distance_calculator.dart';

void main() {
  group('ParkingSession Model Tests', () {
    test('JSON serialization & deserialization', () {
      final now = DateTime.now();
      final session = ParkingSession(
        id: 'park_123',
        latitude: 31.5204,
        longitude: 74.3587,
        accuracy: 8.0,
        placeName: 'Emporium Mall',
        floor: 'Basement 2',
        section: 'C',
        slot: '42',
        notes: 'Near elevator',
        photoPath: '/mock/path/image.jpg',
        parkedAt: now,
        reminderMinutes: 120,
        isActive: true,
      );

      final json = session.toJson();
      final reconstructed = ParkingSession.fromJson(json);

      expect(reconstructed.id, 'park_123');
      expect(reconstructed.placeName, 'Emporium Mall');
      expect(reconstructed.floor, 'Basement 2');
      expect(reconstructed.section, 'C');
      expect(reconstructed.slot, '42');
      expect(reconstructed.notes, 'Near elevator');
      expect(reconstructed.photoPath, '/mock/path/image.jpg');
      expect(reconstructed.isActive, isTrue);
      expect(reconstructed.formattedDetails, 'Basement 2 • Section C • Slot 42');
    });

    test('Formatted details string handles empty fields', () {
      final session = ParkingSession(
        id: 'park_456',
        latitude: 0,
        longitude: 0,
        placeName: 'Outdoor Parking',
        floor: '',
        section: 'A',
        slot: '10',
        parkedAt: DateTime.now(),
      );

      expect(session.formattedDetails, 'Section A • Slot 10');
    });
  });

  group('AppSettings Model Tests', () {
    test('JSON serialization & deserialization', () {
      const settings = AppSettings(
        notificationsEnabled: true,
        defaultReminderMinutes: 60,
        locationAccuracy: 'High',
        language: 'English',
        mapPreference: 'Default',
        hasCompletedOnboarding: true,
      );

      final json = settings.toJson();
      final reconstructed = AppSettings.fromJson(json);

      expect(reconstructed.notificationsEnabled, isTrue);
      expect(reconstructed.defaultReminderMinutes, 60);
      expect(reconstructed.hasCompletedOnboarding, isTrue);
    });
  });

  group('Utilities Tests', () {
    test('DateFormatter formatTimer works correctly for duration', () {
      expect(DateFormatter.formatTimer(const Duration(minutes: 1, seconds: 42)), '01:42');
      expect(DateFormatter.formatTimer(const Duration(hours: 2, minutes: 15)), '02:15');
    });

    test('DateFormatter formatDurationReadable works correctly', () {
      expect(DateFormatter.formatDurationReadable(const Duration(hours: 1, minutes: 42)), '1 hr 42 min');
      expect(DateFormatter.formatDurationReadable(const Duration(minutes: 25)), '25 min');
    });

    test('DistanceCalculator formats distance and walking time', () {
      expect(DistanceCalculator.formatDistance(420), '420 m');
      expect(DistanceCalculator.formatDistance(1400), '1.4 km');
      expect(DistanceCalculator.estimatedWalkingTime(420), 'About 6 min walk');
    });
  });
}
