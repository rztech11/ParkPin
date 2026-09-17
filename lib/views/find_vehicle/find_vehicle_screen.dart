import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' hide DistanceCalculator;
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/services/navigation_service.dart';
import '../../core/utils/distance_calculator.dart';
import '../../models/parking_session.dart';
import '../../providers/location_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_pin_icon.dart';

class FindVehicleScreen extends StatefulWidget {
  final ParkingSession session;

  const FindVehicleScreen({super.key, required this.session});

  @override
  State<FindVehicleScreen> createState() => _FindVehicleScreenState();
}

class _FindVehicleScreenState extends State<FindVehicleScreen> {
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final locProvider = Provider.of<LocationProvider>(context, listen: false);
      locProvider.startTracking();
      locProvider.fetchLocation();
    });
  }

  @override
  void dispose() {
    // stop tracking when exiting map screen
    Provider.of<LocationProvider>(context, listen: false).stopTracking();
    super.dispose();
  }

  void _zoomIn() {
    final currentZoom = _mapController.camera.zoom;
    _mapController.move(_mapController.camera.center, currentZoom + 1);
  }

  void _zoomOut() {
    final currentZoom = _mapController.camera.zoom;
    _mapController.move(_mapController.camera.center, currentZoom - 1);
  }

  void _recenter() {
    _mapController.move(
      LatLng(widget.session.latitude, widget.session.longitude),
      16.5,
    );
  }

  void _showPhotoDialog() {
    if (widget.session.photoPath == null || !File(widget.session.photoPath!).existsSync()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No parking photo attached.')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.file(File(widget.session.photoPath!), fit: BoxFit.contain),
            ),
            const SizedBox(height: 12),
            IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: const Icon(Icons.close, color: AppColors.textPrimary),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(context);
    final userPos = locationProvider.livePosition;

    final LatLng parkingLatLng = LatLng(widget.session.latitude, widget.session.longitude);
    // User live coordinate or slight offset for initial mockup preview
    final LatLng userLatLng = userPos != null
        ? LatLng(userPos.latitude, userPos.longitude)
        : LatLng(widget.session.latitude - 0.0028, widget.session.longitude - 0.0035);

    final distanceAndWalk = DistanceCalculator.formatDistanceAndWalkTime(
      startLat: userLatLng.latitude,
      startLng: userLatLng.longitude,
      endLat: parkingLatLng.latitude,
      endLng: parkingLatLng.longitude,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border, width: 1.5),
            ),
            child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              AppStrings.appName,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            CustomPinIcon(size: 32, pinColor: AppColors.primary),
          ],
        ),
      ),
      body: Stack(
        children: [
          // 1. Interactive Flutter Map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: parkingLatLng,
              initialZoom: 16.2,
              maxZoom: 19.0,
              minZoom: 4.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.parkpin.app',
              ),

              // Route Line connecting User & Parked Vehicle
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: [userLatLng, parkingLatLng],
                    color: AppColors.primary,
                    strokeWidth: 4.0,
                    pattern: const StrokePattern.dotted(spacingFactor: 2.0),
                  ),
                ],
              ),

              // Markers
              MarkerLayer(
                markers: [
                  // User Blue Dot Marker
                  Marker(
                    point: userLatLng,
                    width: 32,
                    height: 32,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.blue.withValues(alpha: 0.25),
                            shape: BoxShape.circle,
                          ),
                        ),
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2563EB),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2.5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withValues(alpha: 0.4),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Saved Parking Pin Marker
                  Marker(
                    point: parkingLatLng,
                    width: 52,
                    height: 68,
                    alignment: Alignment.topCenter,
                    child: const CustomPinIcon(
                      size: 48,
                      pinColor: AppColors.primary,
                      iconColor: AppColors.primary,
                      filled: false,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // 2. Map Control Buttons (Top Right)
          Positioned(
            top: 20,
            right: 16,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.add, color: AppColors.textPrimary),
                        onPressed: _zoomIn,
                      ),
                      const Divider(height: 1, color: AppColors.borderLight),
                      IconButton(
                        icon: const Icon(Icons.remove, color: AppColors.textPrimary),
                        onPressed: _zoomOut,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.my_location, color: AppColors.textPrimary),
                    onPressed: _recenter,
                  ),
                ),
              ],
            ),
          ),

          // 3. Bottom Sliding Vehicle Card (Design 9)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle bar
                    Center(
                      child: Container(
                        width: 44,
                        height: 5,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD1D5DB),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // "Your vehicle"
                    const Text(
                      AppStrings.yourVehicle,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // "420 m away • About 5 min walk"
                    Text(
                      distanceAndWalk,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // "Emporium Mall • Basement 2 • Section C"
                    Text(
                      widget.session.formattedDetails.isNotEmpty
                          ? '${widget.session.placeName} • ${widget.session.formattedDetails}'
                          : widget.session.placeName,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 20),

                    // "Start Navigation" Button
                    ParkPinPrimaryButton(
                      text: AppStrings.startNavigation,
                      height: 54,
                      onPressed: () {
                        NavigationService.launchTurnByTurnNavigation(
                          destinationLat: widget.session.latitude,
                          destinationLng: widget.session.longitude,
                          label: widget.session.placeName,
                        );
                      },
                    ),

                    // "View Parking Photo" Button
                    if (widget.session.photoPath != null && File(widget.session.photoPath!).existsSync()) ...[
                      const SizedBox(height: 12),
                      InkWell(
                        onTap: _showPhotoDialog,
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(widget.session.photoPath!),
                                  width: 44,
                                  height: 44,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 14),
                              const Text(
                                AppStrings.viewParkingPhoto,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
