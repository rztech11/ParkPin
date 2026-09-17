import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../models/parking_session.dart';
import '../../../providers/parking_provider.dart';
import '../../find_vehicle/find_vehicle_screen.dart';
import '../../history/parking_details_screen.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/end_parking_dialog.dart';

class ActiveParkingView extends StatelessWidget {
  final ParkingSession session;

  const ActiveParkingView({
    super.key,
    required this.session,
  });

  @override
  Widget build(BuildContext context) {
    final parkingProvider = Provider.of<ParkingProvider>(context);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 12),

          // Active Parking Session Main Card
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.primary, width: 2.2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                // Top Green Banner
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(21),
                      topRight: Radius.circular(21),
                    ),
                  ),
                  child: const Text(
                    AppStrings.vehicleParked,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),

                // Card Body
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: Column(
                    children: [
                      // Running Timer
                      Text(
                        DateFormatter.formatTimer(session.duration),
                        style: const TextStyle(
                          fontSize: 56,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                          letterSpacing: -1.5,
                          fontFeatures: [FontFeature.tabularFigures()],
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        AppStrings.parkingDuration,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Location details & photo thumbnail row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 2),
                            child: Icon(Icons.location_on, color: AppColors.primary, size: 22),
                          ),
                          const SizedBox(width: 8),
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
                                    letterSpacing: -0.3,
                                  ),
                                ),
                                if (session.formattedDetails.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    session.formattedDetails,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: AppColors.textSecondary,
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          // Photo thumbnail if available
                          if (session.photoPath != null && File(session.photoPath!).existsSync()) ...[
                            const SizedBox(width: 12),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                File(session.photoPath!),
                                width: 68,
                                height: 68,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // Primary Button: "Find My Vehicle"
          ParkPinPrimaryButton(
            text: AppStrings.findMyVehicle,
            height: 58,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => FindVehicleScreen(session: session),
                ),
              );
            },
          ),
          const SizedBox(height: 16),

          // Outline Button: "Parking Details"
          ParkPinOutlineButton(
            text: AppStrings.parkingDetails,
            height: 58,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ParkingDetailsScreen(session: session),
                ),
              );
            },
          ),
          const SizedBox(height: 24),

          // Danger Button: "✕ End Parking"
          ParkPinDangerButton(
            text: AppStrings.endParking,
            icon: Icons.close,
            onPressed: () {
              EndParkingDialog.show(
                context,
                onConfirmEnd: () async {
                  await parkingProvider.endParkingSession();
                },
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
