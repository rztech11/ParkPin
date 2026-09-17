import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/date_formatter.dart';
import '../../models/parking_session.dart';
import '../find_vehicle/find_vehicle_screen.dart';
import '../home/home_screen.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_pin_icon.dart';
import '../widgets/radar_ripple_animation.dart';

class ParkingSavedScreen extends StatelessWidget {
  final ParkingSession session;

  const ParkingSavedScreen({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              // Top Mini Logo
              const SizedBox(height: 12),
              const Center(
                child: CustomPinIcon(size: 32, pinColor: AppColors.primary),
              ),
              const SizedBox(height: 24),

              // Concentric Checkmark Rings
              const Center(
                child: RadarRippleAnimation(
                  size: 200,
                  hasCheckmark: true,
                ),
              ),
              const SizedBox(height: 28),

              // Title & Subtitle
              const Text(
                AppStrings.parkingSavedTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.6,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                AppStrings.parkingSavedDesc,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 28),

              // Summary Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F5F0),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.borderLight, width: 1.5),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Icon(Icons.location_on, color: AppColors.primary, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            session.placeName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          if (session.formattedDetails.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              session.formattedDetails,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                          const SizedBox(height: 4),
                          Text(
                            'Parked at ${DateFormatter.formatTime(session.parkedAt)}',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Buttons
              ParkPinPrimaryButton(
                text: AppStrings.findMyVehicle,
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => FindVehicleScreen(session: session),
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),

              TextButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (route) => false,
                  );
                },
                child: const Text(
                  AppStrings.done,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
