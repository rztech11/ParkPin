import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../core/services/location_service.dart';

class LocationProvider extends ChangeNotifier {
  LocationResult? _currentLocation;
  bool _isLocating = false;
  String? _errorMessage;
  Position? _livePosition;
  StreamSubscription<Position>? _positionSubscription;

  LocationResult? get currentLocation => _currentLocation;
  bool get isLocating => _isLocating;
  String? get errorMessage => _errorMessage;
  Position? get livePosition => _livePosition;

  /// Fetch GPS location (used when user taps 'Park Here')
  Future<LocationResult?> fetchLocation() async {
    _isLocating = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await LocationService.getCurrentLocation();
      _currentLocation = result;
      if (result != null) {
        _livePosition = Position(
          longitude: result.longitude,
          latitude: result.latitude,
          timestamp: DateTime.now(),
          accuracy: result.accuracy,
          altitude: 0.0,
          altitudeAccuracy: 0.0,
          heading: 0.0,
          headingAccuracy: 0.0,
          speed: 0.0,
          speedAccuracy: 0.0,
        );
      }
      _isLocating = false;
      notifyListeners();
      return result;
    } catch (e) {
      _errorMessage = 'Could not obtain location. Please check your GPS.';
      _isLocating = false;
      notifyListeners();
      return null;
    }
  }

  /// Start live position tracking for the Find My Vehicle map screen
  void startTracking() {
    _positionSubscription?.cancel();
    _positionSubscription = LocationService.getPositionStream().listen(
      (Position position) {
        _livePosition = position;
        notifyListeners();
      },
      onError: (_) {},
    );
  }

  /// Stop position tracking
  void stopTracking() {
    _positionSubscription?.cancel();
    _positionSubscription = null;
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    super.dispose();
  }
}
