import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/image_helper.dart';
import '../widgets/custom_button.dart';

class ParkingPhotoScreen extends StatefulWidget {
  final String? initialPhotoPath;

  const ParkingPhotoScreen({super.key, this.initialPhotoPath});

  @override
  State<ParkingPhotoScreen> createState() => _ParkingPhotoScreenState();
}

class _ParkingPhotoScreenState extends State<ParkingPhotoScreen> {
  bool _isLoading = false;

  Future<void> _handleCamera() async {
    setState(() => _isLoading = true);
    final photoPath = await ImageHelper.capturePhoto();
    setState(() => _isLoading = false);

    if (photoPath != null && mounted) {
      Navigator.of(context).pop(photoPath);
    }
  }

  Future<void> _handleGallery() async {
    setState(() => _isLoading = true);
    final photoPath = await ImageHelper.pickFromGallery();
    setState(() => _isLoading = false);

    if (photoPath != null && mounted) {
      Navigator.of(context).pop(photoPath);
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
          AppStrings.parkingPhoto,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              const SizedBox(height: 16),
              // Main Card
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F5F0),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: AppColors.borderLight, width: 1.5),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Green Camera Outline Icon
                      Container(
                        width: 90,
                        height: 72,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.primary, width: 3.5),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned(
                              top: -6,
                              right: 18,
                              child: Container(
                                width: 18,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                            Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.primary, width: 3.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Title
                      const Text(
                        AppStrings.takePhotoTitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.5,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Subtitle
                      const Text(
                        AppStrings.takePhotoDesc,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Buttons
              ParkPinPrimaryButton(
                text: AppStrings.takePhoto,
                isLoading: _isLoading,
                onPressed: _handleCamera,
              ),
              const SizedBox(height: 14),

              ParkPinOutlineButton(
                text: AppStrings.chooseFromGallery,
                onPressed: _isLoading ? null : _handleGallery,
              ),
              const SizedBox(height: 20),

              const Text(
                AppStrings.photoOptional,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
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
