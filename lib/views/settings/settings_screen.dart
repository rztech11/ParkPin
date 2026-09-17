import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/settings_provider.dart';
import '../reminder/parking_reminder_screen.dart';

class SettingsScreen extends StatelessWidget {
  final bool isEmbedded;

  const SettingsScreen({super.key, this.isEmbedded = false});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: isEmbedded
          ? null
          : AppBar(
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
                AppStrings.settings,
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
              if (isEmbedded) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    AppStrings.settings,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.6,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],

              // 1. GENERAL SECTION
              _buildSectionHeader(AppStrings.general),
              const SizedBox(height: 8),
              _buildSettingCard(
                icon: Icons.notifications_none_rounded,
                title: AppStrings.notifications,
                trailing: Switch(
                  value: settingsProvider.notificationsEnabled,
                  activeThumbColor: Colors.white,
                  activeTrackColor: AppColors.primary,
                  onChanged: (val) => settingsProvider.toggleNotifications(val),
                ),
              ),
              const SizedBox(height: 10),
              _buildSettingCard(
                icon: Icons.timer_outlined,
                title: AppStrings.defaultReminder,
                trailingPill: _formatReminderMinutes(settingsProvider.defaultReminderMinutes),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ParkingReminderScreen(
                        initialMinutes: settingsProvider.defaultReminderMinutes,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              _buildSettingCard(
                icon: Icons.location_on_outlined,
                title: AppStrings.locationAccuracy,
                trailingPill: settingsProvider.locationAccuracy,
                onTap: () => _showAccuracyDialog(context, settingsProvider),
              ),
              const SizedBox(height: 24),

              // 2. APP SECTION
              _buildSectionHeader(AppStrings.app),
              const SizedBox(height: 8),
              _buildSettingCard(
                icon: Icons.language_outlined,
                title: AppStrings.language,
                trailingPill: settingsProvider.language,
                onTap: () => _showLanguageDialog(context, settingsProvider),
              ),
              const SizedBox(height: 10),
              _buildSettingCard(
                icon: Icons.map_outlined,
                title: AppStrings.mapPreferences,
                onTap: () => _showMapPreferencesDialog(context, settingsProvider),
              ),
              const SizedBox(height: 24),

              // 3. ABOUT SECTION
              _buildSectionHeader(AppStrings.about),
              const SizedBox(height: 8),
              _buildSettingCard(
                icon: Icons.info_outline_rounded,
                title: AppStrings.aboutParkPin,
                onTap: () => _showAboutDialog(context),
              ),
              const SizedBox(height: 10),
              _buildSettingCard(
                icon: Icons.lock_outline_rounded,
                title: AppStrings.privacy,
                onTap: () => _showPrivacyDialog(context),
              ),
              const SizedBox(height: 10),
              _buildSettingCard(
                icon: Icons.help_outline_rounded,
                title: AppStrings.helpSupport,
                onTap: () => _showSupportDialog(context),
              ),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppColors.textSecondary,
        letterSpacing: 1.1,
      ),
    );
  }

  Widget _buildSettingCard({
    required IconData icon,
    required String title,
    String? trailingPill,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7F5F0),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderLight, width: 1.2),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            child: Row(
              children: [
                Icon(icon, color: AppColors.textPrimary, size: 24),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                if (trailingPill != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEBE8E1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      trailingPill,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                if (trailing != null)
                  trailing
                else
                  const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primary, size: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatReminderMinutes(int minutes) {
    if (minutes < 60) {
      return '$minutes min';
    } else {
      final hours = minutes ~/ 60;
      return '$hours hours';
    }
  }

  void _showAccuracyDialog(BuildContext context, SettingsProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Location Accuracy'),
        children: ['High', 'Balanced', 'Battery Saving'].map((acc) {
          return SimpleDialogOption(
            onPressed: () {
              provider.setLocationAccuracy(acc);
              Navigator.of(ctx).pop();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Text(acc, style: const TextStyle(fontSize: 16)),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, SettingsProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Select Language'),
        children: ['English', 'Spanish', 'French', 'German', 'Arabic', 'Urdu'].map((lang) {
          return SimpleDialogOption(
            onPressed: () {
              provider.setLanguage(lang);
              Navigator.of(ctx).pop();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Text(lang, style: const TextStyle(fontSize: 16)),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showMapPreferencesDialog(BuildContext context, SettingsProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Map Provider Preferences'),
        children: ['Standard OpenStreetMap', 'Satellite / Terrain', 'Dark Mode Map'].map((pref) {
          return SimpleDialogOption(
            onPressed: () {
              provider.setMapPreference(pref);
              Navigator.of(ctx).pop();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Text(pref, style: const TextStyle(fontSize: 16)),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('About ParkPin'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('ParkPin v1.0.0', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Tagline: "Park it. Pin it. Find it."'),
            SizedBox(height: 8),
            Text(
              'A fast, offline-first personal parking location assistant built with Flutter.',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Privacy & Security'),
        content: const Text(
          'ParkPin stores all your parking records, locations, and photos locally on your device. No personal data or location coordinates are uploaded to external cloud databases.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSupportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Help & Support'),
        content: const Text(
          'Need help? Simply save your location before walking away from your parking spot. You can add a photo of a nearby pillar or landmark and set a parking reminder timer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}
