class AppSettings {
  final bool notificationsEnabled;
  final int defaultReminderMinutes;
  final String locationAccuracy;
  final String language;
  final String mapPreference;
  final bool hasCompletedOnboarding;

  const AppSettings({
    this.notificationsEnabled = true,
    this.defaultReminderMinutes = 120, // 2 hours default
    this.locationAccuracy = 'High',
    this.language = 'English',
    this.mapPreference = 'Default',
    this.hasCompletedOnboarding = false,
  });

  AppSettings copyWith({
    bool? notificationsEnabled,
    int? defaultReminderMinutes,
    String? locationAccuracy,
    String? language,
    String? mapPreference,
    bool? hasCompletedOnboarding,
  }) {
    return AppSettings(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      defaultReminderMinutes: defaultReminderMinutes ?? this.defaultReminderMinutes,
      locationAccuracy: locationAccuracy ?? this.locationAccuracy,
      language: language ?? this.language,
      mapPreference: mapPreference ?? this.mapPreference,
      hasCompletedOnboarding: hasCompletedOnboarding ?? this.hasCompletedOnboarding,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notificationsEnabled': notificationsEnabled,
      'defaultReminderMinutes': defaultReminderMinutes,
      'locationAccuracy': locationAccuracy,
      'language': language,
      'mapPreference': mapPreference,
      'hasCompletedOnboarding': hasCompletedOnboarding,
    };
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      defaultReminderMinutes: json['defaultReminderMinutes'] as int? ?? 120,
      locationAccuracy: json['locationAccuracy'] as String? ?? 'High',
      language: json['language'] as String? ?? 'English',
      mapPreference: json['mapPreference'] as String? ?? 'Default',
      hasCompletedOnboarding: json['hasCompletedOnboarding'] as bool? ?? false,
    );
  }
}
