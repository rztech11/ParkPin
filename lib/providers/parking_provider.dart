import 'dart:async';
import 'package:flutter/material.dart';
import '../core/services/notification_service.dart';
import '../core/services/storage_service.dart';
import '../core/utils/image_helper.dart';
import '../models/parking_session.dart';

class ParkingProvider extends ChangeNotifier {
  ParkingSession? _activeSession;
  List<ParkingSession> _history = [];
  bool _isLoading = true;
  Timer? _durationTimer;
  bool _hasTriggeredReminder = false;

  ParkingSession? get activeSession => _activeSession;
  List<ParkingSession> get history => _history;
  bool get isLoading => _isLoading;
  bool get hasActiveSession => _activeSession != null;

  ParkingProvider() {
    _init();
  }

  Future<void> _init() async {
    _activeSession = await StorageService.getActiveSession();
    _history = await StorageService.getHistory();
    _isLoading = false;

    if (_activeSession != null) {
      if (_activeSession!.reminderMinutes != null &&
          _activeSession!.duration.inMinutes >= _activeSession!.reminderMinutes!) {
        _hasTriggeredReminder = true;
      }
      _startDurationTimer();
    }
    notifyListeners();
  }

  void _startDurationTimer() {
    _durationTimer?.cancel();
    _durationTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      // In-app backup reminder trigger
      if (_activeSession != null &&
          _activeSession!.reminderMinutes != null &&
          _activeSession!.reminderMinutes! > 0 &&
          !_hasTriggeredReminder) {
        if (_activeSession!.duration.inMinutes >= _activeSession!.reminderMinutes!) {
          _hasTriggeredReminder = true;
          NotificationService().showReminderNow(
            id: _activeSession!.id.hashCode,
            placeName: _activeSession!.placeName,
            minutes: _activeSession!.reminderMinutes!,
          );
        }
      }
      notifyListeners();
    });
  }

  void _stopDurationTimer() {
    _durationTimer?.cancel();
    _durationTimer = null;
  }

  /// Save new parking session
  Future<ParkingSession> saveParkingSession({
    required double latitude,
    required double longitude,
    required double accuracy,
    required String placeName,
    String floor = '',
    String section = '',
    String slot = '',
    String notes = '',
    String? photoPath,
    int? reminderMinutes,
  }) async {
    final String id = 'park_${DateTime.now().millisecondsSinceEpoch}';
    final ParkingSession newSession = ParkingSession(
      id: id,
      latitude: latitude,
      longitude: longitude,
      accuracy: accuracy,
      placeName: placeName.trim().isEmpty ? 'My Parking Spot' : placeName.trim(),
      floor: floor.trim(),
      section: section.trim(),
      slot: slot.trim(),
      notes: notes.trim(),
      photoPath: photoPath,
      parkedAt: DateTime.now(),
      reminderMinutes: reminderMinutes,
      isActive: true,
    );

    _activeSession = newSession;
    _hasTriggeredReminder = false;
    await StorageService.saveActiveSession(newSession);

    // Schedule notification if reminderMinutes is set
    if (reminderMinutes != null && reminderMinutes > 0) {
      await NotificationService().scheduleParkingReminder(
        id: newSession.id.hashCode,
        placeName: newSession.placeName,
        duration: Duration(minutes: reminderMinutes),
      );
    }

    _startDurationTimer();
    notifyListeners();
    return newSession;
  }

  /// End active parking session and move to history
  Future<void> endParkingSession() async {
    if (_activeSession == null) return;

    final now = DateTime.now();
    final totalSeconds = now.difference(_activeSession!.parkedAt).inSeconds;

    final endedSession = _activeSession!.copyWith(
      isActive: false,
      endedAt: now,
      totalDurationSeconds: totalSeconds,
    );

    // Cancel notification
    await NotificationService().cancelReminder(_activeSession!.id.hashCode);

    // Add to history at top
    _history.insert(0, endedSession);
    _activeSession = null;
    _stopDurationTimer();

    // Persist changes
    await StorageService.saveActiveSession(null);
    await StorageService.saveHistory(_history);

    notifyListeners();
  }

  /// Delete a historical session record
  Future<void> deleteHistorySession(String id) async {
    final index = _history.indexWhere((s) => s.id == id);
    if (index != -1) {
      final session = _history[index];
      if (session.photoPath != null) {
        await ImageHelper.deleteImage(session.photoPath);
      }
      _history.removeAt(index);
      await StorageService.saveHistory(_history);
      notifyListeners();
    }
  }

  /// Update active session reminder
  Future<void> updateActiveSessionReminder(int minutes) async {
    if (_activeSession == null) return;

    _hasTriggeredReminder = false;
    _activeSession = _activeSession!.copyWith(reminderMinutes: minutes);
    await StorageService.saveActiveSession(_activeSession);

    // Reschedule notification
    await NotificationService().cancelReminder(_activeSession!.id.hashCode);
    if (minutes > 0) {
      await NotificationService().scheduleParkingReminder(
        id: _activeSession!.id.hashCode,
        placeName: _activeSession!.placeName,
        duration: Duration(minutes: minutes),
      );
    }

    notifyListeners();
  }

  @override
  void dispose() {
    _durationTimer?.cancel();
    super.dispose();
  }
}
