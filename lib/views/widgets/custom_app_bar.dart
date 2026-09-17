import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'custom_pin_icon.dart';

class CustomParkPinAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showLogoCenter;
  final Widget? leading;
  final List<Widget>? actions;
  final VoidCallback? onSettingsPressed;
  final bool automaticallyImplyLeading;

  const CustomParkPinAppBar({
    super.key,
    this.title = 'ParkPin',
    this.showLogoCenter = true,
    this.leading,
    this.actions,
    this.onSettingsPressed,
    this.automaticallyImplyLeading = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: leading,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          if (showLogoCenter)
            const CustomPinIcon(size: 32, pinColor: AppColors.primary),
        ],
      ),
      actions: actions ??
          (onSettingsPressed != null
              ? [
                  IconButton(
                    icon: const Icon(Icons.settings_outlined, color: AppColors.textPrimary, size: 26),
                    onPressed: onSettingsPressed,
                  ),
                  const SizedBox(width: 8),
                ]
              : null),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
