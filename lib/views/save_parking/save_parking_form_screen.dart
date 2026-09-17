import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/services/location_service.dart';
import '../../providers/parking_provider.dart';
import '../../providers/settings_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_pin_icon.dart';
import '../widgets/custom_text_field.dart';
import 'parking_photo_screen.dart';
import 'parking_saved_screen.dart';

class SaveParkingFormScreen extends StatefulWidget {
  final LocationResult location;

  const SaveParkingFormScreen({super.key, required this.location});

  @override
  State<SaveParkingFormScreen> createState() => _SaveParkingFormScreenState();
}

class _SaveParkingFormScreenState extends State<SaveParkingFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _placeNameController;
  late TextEditingController _floorController;
  late TextEditingController _sectionController;
  late TextEditingController _slotController;
  late TextEditingController _notesController;

  String? _photoPath;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _placeNameController = TextEditingController(text: widget.location.suggestedPlaceName ?? '');
    _floorController = TextEditingController();
    _sectionController = TextEditingController();
    _slotController = TextEditingController();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _placeNameController.dispose();
    _floorController.dispose();
    _sectionController.dispose();
    _slotController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _openPhotoPicker() async {
    final result = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (context) => ParkingPhotoScreen(initialPhotoPath: _photoPath),
      ),
    );

    if (result != null) {
      setState(() {
        _photoPath = result;
      });
    }
  }

  Future<void> _handleSave() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isSaving = true);
      final parkingProvider = Provider.of<ParkingProvider>(context, listen: false);
      final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);

      final session = await parkingProvider.saveParkingSession(
        latitude: widget.location.latitude,
        longitude: widget.location.longitude,
        accuracy: widget.location.accuracy,
        placeName: _placeNameController.text.trim().isNotEmpty
            ? _placeNameController.text.trim()
            : 'My Parking Spot',
        floor: _floorController.text.trim(),
        section: _sectionController.text.trim(),
        slot: _slotController.text.trim(),
        notes: _notesController.text.trim(),
        photoPath: _photoPath,
        reminderMinutes: settingsProvider.notificationsEnabled ? settingsProvider.defaultReminderMinutes : null,
      );

      setState(() => _isSaving = false);

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ParkingSavedScreen(session: session),
          ),
        );
      }
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
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Location Found Card (Top)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.borderLight, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const CustomPinIcon(size: 38, pinColor: AppColors.primary),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              AppStrings.locationFound,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                                letterSpacing: -0.3,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '${widget.location.latitude.toStringAsFixed(4)}, ${widget.location.longitude.toStringAsFixed(4)}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Accuracy: ${widget.location.accuracy.round()} meters',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Form Fields
                ParkPinTextField(
                  label: AppStrings.placeName,
                  hint: AppStrings.placeNameHint,
                  controller: _placeNameController,
                ),
                ParkPinTextField(
                  label: AppStrings.floor,
                  hint: AppStrings.floorHint,
                  controller: _floorController,
                ),
                ParkPinTextField(
                  label: AppStrings.section,
                  hint: AppStrings.sectionHint,
                  controller: _sectionController,
                ),
                ParkPinTextField(
                  label: AppStrings.parkingSlot,
                  hint: AppStrings.parkingSlotHint,
                  controller: _slotController,
                ),
                ParkPinTextField(
                  label: AppStrings.notes,
                  hint: AppStrings.notesHint,
                  controller: _notesController,
                  maxLines: 2,
                ),
                const SizedBox(height: 20),

                // Photo Button / Preview
                Center(
                  child: _photoPath != null && File(_photoPath!).existsSync()
                      ? Stack(
                          alignment: Alignment.topRight,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.file(
                                File(_photoPath!),
                                width: 140,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            IconButton(
                              icon: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                                child: const Icon(Icons.close, color: Colors.white, size: 16),
                              ),
                              onPressed: () => setState(() => _photoPath = null),
                            ),
                          ],
                        )
                      : OutlinedButton(
                          onPressed: _openPhotoPicker,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.textPrimary,
                            side: const BorderSide(color: AppColors.textPrimary, width: 1.4),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.camera_alt_outlined, color: AppColors.textPrimary, size: 20),
                              SizedBox(width: 8),
                              Text(
                                AppStrings.addPhoto,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
                const SizedBox(height: 28),

                // Save Parking Action
                ParkPinPrimaryButton(
                  text: AppStrings.saveParking,
                  isLoading: _isSaving,
                  onPressed: _handleSave,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
