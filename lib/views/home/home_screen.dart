import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/parking_provider.dart';
import '../history/history_screen.dart';
import '../settings/settings_screen.dart';
import '../widgets/custom_app_bar.dart';
import 'widgets/active_parking_view.dart';
import 'widgets/empty_parking_view.dart';

class HomeScreen extends StatefulWidget {
  final int initialTabIndex;

  const HomeScreen({super.key, this.initialTabIndex = 0});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTabIndex;
  }

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final parkingProvider = Provider.of<ParkingProvider>(context);

    final List<Widget> pages = [
      // Home Tab
      parkingProvider.hasActiveSession
          ? ActiveParkingView(session: parkingProvider.activeSession!)
          : EmptyParkingView(
              onNavigateToHistory: () => _onTabSelected(1),
            ),
      // History Tab
      const HistoryScreen(isEmbedded: true),
      // Settings Tab
      const SettingsScreen(isEmbedded: true),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomParkPinAppBar(
        title: _currentIndex == 0
            ? AppStrings.appName
            : _currentIndex == 1
                ? AppStrings.parkingHistory
                : AppStrings.settings,
        showLogoCenter: _currentIndex == 0,
        onSettingsPressed: _currentIndex == 0 ? () => _onTabSelected(2) : null,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabSelected,
          elevation: 0,
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textTertiary,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.location_on_outlined, size: 26),
              activeIcon: Icon(Icons.location_on, size: 26),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history_outlined, size: 26),
              activeIcon: Icon(Icons.history, size: 26),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined, size: 26),
              activeIcon: Icon(Icons.settings, size: 26),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
