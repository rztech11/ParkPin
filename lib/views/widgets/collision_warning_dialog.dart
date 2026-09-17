import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import 'custom_button.dart';
import 'custom_pin_icon.dart';

class CollisionWarningDialog extends StatelessWidget {
  final VoidCallback onViewCurrent;
  final VoidCallback onEndCurrent;

  const CollisionWarningDialog({
    super.key,
    required this.onViewCurrent,
    required this.onEndCurrent,
  });

  static Future<void> show(
    BuildContext context, {
    required VoidCallback onViewCurrent,
    required VoidCallback onEndCurrent,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) => CollisionWarningDialog(
        onViewCurrent: onViewCurrent,
        onEndCurrent: onEndCurrent,
      ),
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
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Center(
                child: CustomPinIcon(
                  size: 38,
                  pinColor: AppColors.warning,
                  iconColor: AppColors.warning,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              AppStrings.alreadyTrackingTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              AppStrings.alreadyTrackingDesc,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            ParkPinPrimaryButton(
              text: AppStrings.viewCurrentParking,
              height: 50,
              onPressed: () {
                Navigator.of(context).pop();
                onViewCurrent();
              },
            ),
            const SizedBox(height: 10),
            ParkPinOutlineButton(
              text: AppStrings.endCurrentParking,
              height: 50,
              onPressed: () {
                Navigator.of(context).pop();
                onEndCurrent();
              },
            ),
            const SizedBox(height: 6),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                AppStrings.cancel,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
