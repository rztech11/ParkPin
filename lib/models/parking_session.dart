class ParkingSession {
  final String id;
  final double latitude;
  final double longitude;
  final double accuracy;
  final String placeName;
  final String floor;
  final String section;
  final String slot;
  final String notes;
  final String? photoPath;
  final DateTime parkedAt;
  final DateTime? endedAt;
  final int? totalDurationSeconds;
  final int? reminderMinutes;
  final bool isActive;

  ParkingSession({
    required this.id,
    required this.latitude,
    required this.longitude,
    this.accuracy = 0.0,
    required this.placeName,
    this.floor = '',
    this.section = '',
    this.slot = '',
    this.notes = '',
    this.photoPath,
    required this.parkedAt,
    this.endedAt,
    this.totalDurationSeconds,
    this.reminderMinutes,
    this.isActive = true,
  });

  /// Duration of the parking session
  Duration get duration {
    if (totalDurationSeconds != null) {
      return Duration(seconds: totalDurationSeconds!);
    }
    if (endedAt != null) {
      return endedAt!.difference(parkedAt);
    }
    return DateTime.now().difference(parkedAt);
  }

  /// Formatted compact details line (e.g. 'Basement 2 • Section C • Slot 42')
  String get formattedDetails {
    final List<String> parts = [];
    if (floor.isNotEmpty) parts.add(floor.startsWith('Floor') || floor.startsWith('Basement') ? floor : 'Floor $floor');
    if (section.isNotEmpty) parts.add(section.startsWith('Section') ? section : 'Section $section');
    if (slot.isNotEmpty) parts.add(slot.startsWith('Slot') ? slot : 'Slot $slot');
    return parts.join(' • ');
  }

  ParkingSession copyWith({
    String? id,
    double? latitude,
    double? longitude,
    double? accuracy,
    String? placeName,
    String? floor,
    String? section,
    String? slot,
    String? notes,
    String? photoPath,
    DateTime? parkedAt,
    DateTime? endedAt,
    int? totalDurationSeconds,
    int? reminderMinutes,
    bool? isActive,
  }) {
    return ParkingSession(
      id: id ?? this.id,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      accuracy: accuracy ?? this.accuracy,
      placeName: placeName ?? this.placeName,
      floor: floor ?? this.floor,
      section: section ?? this.section,
      slot: slot ?? this.slot,
      notes: notes ?? this.notes,
      photoPath: photoPath ?? this.photoPath,
      parkedAt: parkedAt ?? this.parkedAt,
      endedAt: endedAt ?? this.endedAt,
      totalDurationSeconds: totalDurationSeconds ?? this.totalDurationSeconds,
      reminderMinutes: reminderMinutes ?? this.reminderMinutes,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'accuracy': accuracy,
      'placeName': placeName,
      'floor': floor,
      'section': section,
      'slot': slot,
      'notes': notes,
      'photoPath': photoPath,
      'parkedAt': parkedAt.toIso8601String(),
      'endedAt': endedAt?.toIso8601String(),
      'totalDurationSeconds': totalDurationSeconds ?? (endedAt?.difference(parkedAt).inSeconds),
      'reminderMinutes': reminderMinutes,
      'isActive': isActive,
    };
  }

  factory ParkingSession.fromJson(Map<String, dynamic> json) {
    return ParkingSession(
      id: json['id'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      accuracy: (json['accuracy'] as num?)?.toDouble() ?? 0.0,
      placeName: json['placeName'] as String? ?? 'Parking Spot',
      floor: json['floor'] as String? ?? '',
      section: json['section'] as String? ?? '',
      slot: json['slot'] as String? ?? '',
      notes: json['notes'] as String? ?? '',
      photoPath: json['photoPath'] as String?,
      parkedAt: DateTime.parse(json['parkedAt'] as String),
      endedAt: json['endedAt'] != null ? DateTime.parse(json['endedAt'] as String) : null,
      totalDurationSeconds: json['totalDurationSeconds'] as int?,
      reminderMinutes: json['reminderMinutes'] as int?,
      isActive: json['isActive'] as bool? ?? false,
    );
  }
}
