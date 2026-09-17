import 'package:flutter/material.dart';
import '../core/services/storage_service.dart';
import '../models/app_settings.dart';

class SettingsProvider extends ChangeNotifier {
  AppSettings _settings = const AppSettings();
  bool _isLoading = true;

  AppSettings get settings => _settings;
  bool get isLoading => _isLoading;
  bool get hasCompletedOnboarding => _settings.hasCompletedOnboarding;
  bool get notificationsEnabled => _settings.notificationsEnabled;
  int get defaultReminderMinutes => _settings.defaultReminderMinutes;
  String get locationAccuracy => _settings.locationAccuracy;
  String get language => _settings.language;
  String get mapPreference => _settings.mapPreference;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _settings = await StorageService.getSettings();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> setOnboardingCompleted(bool completed) async {
    _settings = _settings.copyWith(hasCompletedOnboarding: completed);
    await StorageService.saveSettings(_settings);
    notifyListeners();
  }

  Future<void> toggleNotifications(bool enabled) async {
    _settings = _settings.copyWith(notificationsEnabled: enabled);
    await StorageService.saveSettings(_settings);
    notifyListeners();
  }

  Future<void> setDefaultReminder(int minutes) async {
    _settings = _settings.copyWith(defaultReminderMinutes: minutes);
    await StorageService.saveSettings(_settings);
    notifyListeners();
  }

  Future<void> setLocationAccuracy(String accuracy) async {
    _settings = _settings.copyWith(locationAccuracy: accuracy);
    await StorageService.saveSettings(_settings);
    notifyListeners();
  }

  Future<void> setLanguage(String lang) async {
    _settings = _settings.copyWith(language: lang);
    await StorageService.saveSettings(_settings);
    notifyListeners();
  }

  Future<void> setMapPreference(String pref) async {
    _settings = _settings.copyWith(mapPreference: pref);
    await StorageService.saveSettings(_settings);
    notifyListeners();
  }
}
