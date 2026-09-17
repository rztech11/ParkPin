import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/app_settings.dart';
import '../../models/parking_session.dart';

class StorageService {
  static const String _keyActiveSession = 'parkpin_active_session';
  static const String _keyHistory = 'parkpin_history';
  static const String _keySettings = 'parkpin_settings';

  /// Save current active parking session (or null if ended)
  static Future<void> saveActiveSession(ParkingSession? session) async {
    final prefs = await SharedPreferences.getInstance();
    if (session == null) {
      await prefs.remove(_keyActiveSession);
    } else {
      await prefs.setString(_keyActiveSession, jsonEncode(session.toJson()));
    }
  }

  /// Get active parking session from storage
  static Future<ParkingSession?> getActiveSession() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_keyActiveSession);
    if (jsonStr == null || jsonStr.isEmpty) return null;
    try {
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      return ParkingSession.fromJson(map);
    } catch (e) {
      return null;
    }
  }

  /// Save history list
  static Future<void> saveHistory(List<ParkingSession> history) async {
    final prefs = await SharedPreferences.getInstance();
    final list = history.map((s) => s.toJson()).toList();
    await prefs.setString(_keyHistory, jsonEncode(list));
  }

  /// Get history list
  static Future<List<ParkingSession>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_keyHistory);
    if (jsonStr == null || jsonStr.isEmpty) return [];
    try {
      final list = jsonDecode(jsonStr) as List<dynamic>;
      return list.map((item) => ParkingSession.fromJson(item as Map<String, dynamic>)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Save App Settings
  static Future<void> saveSettings(AppSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keySettings, jsonEncode(settings.toJson()));
  }

  /// Get App Settings
  static Future<AppSettings> getSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_keySettings);
    if (jsonStr == null || jsonStr.isEmpty) return const AppSettings();
    try {
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      return AppSettings.fromJson(map);
    } catch (e) {
      return const AppSettings();
    }
  }
}
