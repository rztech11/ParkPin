import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/location_provider.dart';
import '../../providers/parking_provider.dart';
import '../find_vehicle/find_vehicle_screen.dart';
import '../widgets/collision_warning_dialog.dart';
import '../widgets/radar_ripple_animation.dart';
import 'save_parking_form_screen.dart';

class FindingLocationScreen extends StatefulWidget {
  const FindingLocationScreen({super.key});

  @override
  State<FindingLocationScreen> createState() => _FindingLocationScreenState();
}

class _FindingLocationScreenState extends State<FindingLocationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkSessionAndLocate();
    });
  }

  Future<void> _checkSessionAndLocate() async {
    final parkingProvider = Provider.of<ParkingProvider>(context, listen: false);

    // Collision check: if a session is already active
    if (parkingProvider.hasActiveSession) {
      CollisionWarningDialog.show(
        context,
        onViewCurrent: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => FindVehicleScreen(session: parkingProvider.activeSession!),
            ),
          );
        },
        onEndCurrent: () async {
          await parkingProvider.endParkingSession();
          _startLocationFetch();
        },
      );
      return;
    }

    _startLocationFetch();
  }

  Future<void> _startLocationFetch() async {
    final locationProvider = Provider.of<LocationProvider>(context, listen: false);
    final result = await locationProvider.fetchLocation();

    if (!mounted) return;

    if (result != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => SaveParkingFormScreen(location: result),
        ),
      );
    } else {
      // Show snackbar error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(locationProvider.errorMessage ?? 'Could not acquire GPS location.'),
          backgroundColor: AppColors.error,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
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
        title: const Text(
          AppStrings.saveParking,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),

            // Radar Ripple Animation
            const Center(
              child: RadarRippleAnimation(size: 260),
            ),
            const SizedBox(height: 36),

            // Text
            const Text(
              AppStrings.findingLocation,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              AppStrings.findingLocationDesc,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 28),

            // Subtle Spinner
            const SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),

            const Spacer(),

            // Privacy Disclaimer
            Padding(
              padding: const EdgeInsets.only(bottom: 24, left: 24, right: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.lock_outline, size: 16, color: AppColors.textSecondary),
                  SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      AppStrings.locationDisclaimer,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
