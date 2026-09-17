import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/settings_provider.dart';
import '../home/home_screen.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_pin_icon.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingItem> _pages = [
    const OnboardingItem(
      title: AppStrings.onboarding1Title,
      description: AppStrings.onboarding1Desc,
      iconType: OnboardingIconType.parkingCar,
    ),
    const OnboardingItem(
      title: AppStrings.onboarding2Title,
      description: AppStrings.onboarding2Desc,
      iconType: OnboardingIconType.mapNavigation,
    ),
    const OnboardingItem(
      title: AppStrings.onboarding3Title,
      description: AppStrings.onboarding3Desc,
      iconType: OnboardingIconType.notesAndPhotos,
    ),
  ];

  void _finishOnboarding() {
    Provider.of<SettingsProvider>(context, listen: false).setOnboardingCompleted(true);
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, _, _) => const HomeScreen(),
        transitionsBuilder: (_, a, _, c) => FadeTransition(opacity: a, child: c),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Mini Logo
            const SizedBox(height: 16),
            const Center(
              child: CustomPinIcon(size: 32, pinColor: AppColors.primary),
            ),

            // Page Carousel
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final item = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Illustration
                        _buildIllustration(item.iconType),
                        const SizedBox(height: 36),

                        // Title
                        Text(
                          item.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                            letterSpacing: -0.8,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Description
                        Text(
                          item.description,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textSecondary,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Dots Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 10 : 8,
                  height: _currentPage == index ? 10 : 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index ? AppColors.primary : const Color(0xFFD1D5DB),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Bottom Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  ParkPinPrimaryButton(
                    text: _currentPage == _pages.length - 1 ? AppStrings.getStarted : AppStrings.getStarted,
                    onPressed: () {
                      if (_currentPage == _pages.length - 1) {
                        _finishOnboarding();
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: _finishOnboarding,
                    child: const Text(
                      AppStrings.skip,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIllustration(OnboardingIconType type) {
    return Container(
      width: 240,
      height: 220,
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background soft backdrop circle
          Container(
            width: 200,
            height: 200,
            decoration: const BoxDecoration(
              color: Color(0xFFF3F4F6),
              shape: BoxShape.circle,
            ),
          ),
          if (type == OnboardingIconType.parkingCar)
            _buildCarPhoneIllustration()
          else if (type == OnboardingIconType.mapNavigation)
            _buildMapNavigationIllustration()
          else
            _buildNotesIllustration(),
        ],
      ),
    );
  }

  Widget _buildCarPhoneIllustration() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          top: 20,
          child: Container(
            width: 90,
            height: 140,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.textPrimary, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                const SizedBox(height: 8),
                Container(width: 24, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
                const SizedBox(height: 12),
                const CustomPinIcon(size: 24, pinColor: AppColors.primary),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 12,
          child: Container(
            width: 170,
            height: 75,
            decoration: BoxDecoration(
              color: const Color(0xFFE5D5C5),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(40),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              border: Border.all(color: AppColors.textPrimary, width: 2),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 10,
                  left: 30,
                  child: Container(
                    width: 40,
                    height: 25,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.textPrimary, width: 1.5),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 78,
                  child: Container(
                    width: 45,
                    height: 25,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.textPrimary, width: 1.5),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -2,
                  left: 24,
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: const Color(0xFF374151),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.textPrimary, width: 2),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -2,
                  right: 24,
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: const Color(0xFF374151),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.textPrimary, width: 2),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 35,
          right: 30,
          child: const CustomPinIcon(size: 36, pinColor: AppColors.primary),
        ),
      ],
    );
  }

  Widget _buildMapNavigationIllustration() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.textPrimary, width: 2),
          ),
          child: CustomPaint(
            painter: _MiniMapPainter(),
          ),
        ),
        const Positioned(
          top: 25,
          right: 30,
          child: CustomPinIcon(size: 38, pinColor: AppColors.primary),
        ),
        Positioned(
          bottom: 30,
          left: 35,
          child: Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: Colors.blue.shade600,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withValues(alpha: 0.4),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotesIllustration() {
    return Container(
      width: 140,
      height: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.textPrimary, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.camera_alt, color: AppColors.primary, size: 16),
              ),
              const SizedBox(width: 8),
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.alarm, color: Color(0xFFD97706), size: 16),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(width: 80, height: 8, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(4))),
          const SizedBox(height: 8),
          Container(width: 100, height: 8, decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(4))),
          const SizedBox(height: 8),
          Container(width: 60, height: 8, decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(4))),
        ],
      ),
    );
  }
}

enum OnboardingIconType { parkingCar, mapNavigation, notesAndPhotos }

class OnboardingItem {
  final String title;
  final String description;
  final OnboardingIconType iconType;

  const OnboardingItem({
    required this.title,
    required this.description,
    required this.iconType,
  });
}

class _MiniMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = const Color(0xFFE5E7EB)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    final routePaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final roadPath = Path();
    roadPath.moveTo(size.width * 0.2, size.height * 0.8);
    roadPath.lineTo(size.width * 0.5, size.height * 0.5);
    roadPath.lineTo(size.width * 0.8, size.height * 0.2);
    canvas.drawPath(roadPath, roadPaint);

    final routePath = Path();
    routePath.moveTo(size.width * 0.25, size.height * 0.75);
    routePath.lineTo(size.width * 0.5, size.height * 0.5);
    routePath.lineTo(size.width * 0.75, size.height * 0.25);
    canvas.drawPath(routePath, routePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
