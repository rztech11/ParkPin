import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import 'custom_button.dart';
import 'custom_pin_icon.dart';

class EndParkingDialog extends StatelessWidget {
  final VoidCallback onConfirmEnd;

  const EndParkingDialog({
    super.key,
    required this.onConfirmEnd,
  });

  static Future<bool?> show(BuildContext context, {required VoidCallback onConfirmEnd}) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => EndParkingDialog(onConfirmEnd: onConfirmEnd),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Top Green Rounded Badge Icon
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Center(
                child: CustomPinIcon(
                  size: 38,
                  pinColor: Colors.white,
                  iconColor: Colors.white,
                  filled: false,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Title
            const Text(
              AppStrings.endParkingConfirmTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 10),

            // Subtitle
            const Text(
              AppStrings.endParkingConfirmDesc,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 28),

            // "Not Yet" Button (Grey filled pill)
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE5E7EB),
                  foregroundColor: AppColors.textPrimary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                ),
                child: const Text(
                  AppStrings.notYet,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // "End Parking" Button (Green filled pill)
            ParkPinPrimaryButton(
              text: AppStrings.endParking,
              height: 52,
              onPressed: () {
                Navigator.of(context).pop(true);
                onConfirmEnd();
              },
            ),
          ],
        ),
      ),
    );
  }
}
