import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/services/navigation_service.dart';
import '../../core/utils/date_formatter.dart';
import '../../models/parking_session.dart';
import '../../providers/parking_provider.dart';
import '../find_vehicle/find_vehicle_screen.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_pin_icon.dart';

class ParkingDetailsScreen extends StatelessWidget {
  final ParkingSession session;

  const ParkingDetailsScreen({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    final parkingProvider = Provider.of<ParkingProvider>(context, listen: false);

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
          AppStrings.parkingDetails,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Photo Preview (Rounded Card)
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1EFE9),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.borderLight, width: 1.5),
                  ),
                  child: session.photoPath != null && File(session.photoPath!).existsSync()
                      ? Image.file(
                          File(session.photoPath!),
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            CustomPinIcon(size: 54, pinColor: AppColors.primary),
                            SizedBox(height: 12),
                            Text(
                              'No photo attached',
                              style: TextStyle(
                                fontSize: 15,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 24),

              // 2. Location Info Header
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Icon(Icons.location_on, color: AppColors.primary, size: 24),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          session.placeName,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                            letterSpacing: -0.4,
                          ),
                        ),
                        if (session.floor.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            session.floor.startsWith('Floor') || session.floor.startsWith('Basement')
                                ? session.floor
                                : 'Floor ${session.floor}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                        if (session.section.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            session.section.startsWith('Section') ? session.section : 'Section ${session.section}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                        if (session.slot.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            session.slot.startsWith('Parking Slot') || session.slot.startsWith('Slot')
                                ? session.slot
                                : 'Parking Slot ${session.slot}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              const Divider(color: AppColors.divider, thickness: 1),
              const SizedBox(height: 16),

              // 3. Parked Timestamp
              _buildDetailSection(
                title: AppStrings.parkedAt,
                value: DateFormatter.formatFullDateTime(session.parkedAt),
              ),

              // 4. Parking Duration
              _buildDetailSection(
                title: AppStrings.parkingDuration,
                value: DateFormatter.formatDurationReadable(session.duration),
              ),

              // 5. Notes
              if (session.notes.isNotEmpty)
                _buildDetailSection(
                  title: 'Notes',
                  value: session.notes,
                ),

              const SizedBox(height: 24),

              // 6. Action Buttons
              ParkPinPrimaryButton(
                text: AppStrings.viewOnMap,
                height: 56,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => FindVehicleScreen(session: session),
                    ),
                  );
                },
              ),
              const SizedBox(height: 14),

              ParkPinOutlineButton(
                text: AppStrings.startNavigation,
                height: 56,
                onPressed: () {
                  NavigationService.launchTurnByTurnNavigation(
                    destinationLat: session.latitude,
                    destinationLng: session.longitude,
                    label: session.placeName,
                  );
                },
              ),
              const SizedBox(height: 16),

              // Delete Record Action (if historical)
              if (!session.isActive)
                Center(
                  child: TextButton(
                    onPressed: () {
                      _showDeleteConfirmation(context, parkingProvider);
                    },
                    child: const Text(
                      AppStrings.deleteRecord,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSection({required String title, required String value}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, ParkingProvider provider) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Parking Record?'),
        content: const Text('Are you sure you want to delete this parking history record?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(dialogCtx).pop();
              await provider.deleteHistorySession(session.id);
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
            child: const Text('Delete', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
