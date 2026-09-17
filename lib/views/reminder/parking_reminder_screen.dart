import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/parking_provider.dart';
import '../../providers/settings_provider.dart';
import '../widgets/custom_button.dart';

class ParkingReminderScreen extends StatefulWidget {
  final int? initialMinutes;

  const ParkingReminderScreen({super.key, this.initialMinutes});

  @override
  State<ParkingReminderScreen> createState() => _ParkingReminderScreenState();
}

class _ParkingReminderScreenState extends State<ParkingReminderScreen> {
  late int _selectedMinutes;
  final List<int> _presetOptions = [30, 60, 120, 180];

  @override
  void initState() {
    super.initState();
    _selectedMinutes = widget.initialMinutes ?? 120; // 2 hours default
  }

  String _getOptionLabel(int minutes) {
    if (minutes < 60) {
      return '$minutes minutes';
    } else {
      final hours = minutes ~/ 60;
      return '$hours hour${hours > 1 ? 's' : ''}';
    }
  }

  Future<void> _pickCustomTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 1, minute: 0),
      helpText: 'SELECT PARKING REMINDER DURATION',
    );

    if (picked != null) {
      final totalMins = (picked.hour * 60) + picked.minute;
      if (totalMins > 0) {
        setState(() {
          _selectedMinutes = totalMins;
        });
      }
    }
  }

  Future<void> _handleSetReminder() async {
    final parkingProvider = Provider.of<ParkingProvider>(context, listen: false);
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);

    // Save as default setting
    await settingsProvider.setDefaultReminder(_selectedMinutes);

    // If there is an active parking session, update its reminder
    if (parkingProvider.hasActiveSession) {
      await parkingProvider.updateActiveSessionReminder(_selectedMinutes);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Reminder set for ${_getOptionLabel(_selectedMinutes)}'),
          backgroundColor: AppColors.primary,
        ),
      );
      Navigator.of(context).pop(_selectedMinutes);
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
          AppStrings.parkingReminder,
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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              // Title
              const Text(
                AppStrings.howLongParking,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.6,
                ),
              ),
              const SizedBox(height: 8),
              // Subtitle
              const Text(
                AppStrings.reminderDesc,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 32),

              // Options
              ..._presetOptions.map((minutes) {
                final isSelected = _selectedMinutes == minutes;
                return _buildOptionCard(
                  label: _getOptionLabel(minutes),
                  isSelected: isSelected,
                  onTap: () {
                    setState(() {
                      _selectedMinutes = minutes;
                    });
                  },
                );
              }),

              // Custom option
              _buildOptionCard(
                label: !_presetOptions.contains(_selectedMinutes)
                    ? 'Custom (${_getOptionLabel(_selectedMinutes)})'
                    : 'Custom',
                isSelected: !_presetOptions.contains(_selectedMinutes),
                onTap: _pickCustomTime,
              ),

              const Spacer(),

              // Set Reminder Button
              ParkPinPrimaryButton(
                text: AppStrings.setReminder,
                onPressed: _handleSetReminder,
              ),
              const SizedBox(height: 12),

              const Text(
                AppStrings.reminderFooter,
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

  Widget _buildOptionCard({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: double.infinity,
          height: 62,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F5F0),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.transparent,
              width: 2.0,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons.check,
                  color: AppColors.primary,
                  size: 26,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
