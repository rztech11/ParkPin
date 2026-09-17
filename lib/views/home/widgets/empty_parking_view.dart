import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../providers/parking_provider.dart';
import '../../history/parking_details_screen.dart';
import '../../save_parking/finding_location_screen.dart';
import 'recent_history_card.dart';

class EmptyParkingView extends StatelessWidget {
  final VoidCallback onNavigateToHistory;

  const EmptyParkingView({
    super.key,
    required this.onNavigateToHistory,
  });

  @override
  Widget build(BuildContext context) {
    final parkingProvider = Provider.of<ParkingProvider>(context);
    final history = parkingProvider.history;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 12),
          // Headline
          const Text(
            AppStrings.readyToPark,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 6),
          // Subtitle
          const Text(
            AppStrings.readyToParkDesc,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 24),

          // Circular Parking Space Illustration
          _buildParkingIllustration(),
          const SizedBox(height: 28),

          // Big "Park Here" Button
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const FindingLocationScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.location_on,
                          color: AppColors.primary,
                          size: 22,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Text(
                      AppStrings.parkHere,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Label under button
          const Text(
            AppStrings.saveCurrentLocation,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 28),

          // Recent Parking Card Section
          RecentHistoryCard(
            history: history,
            onSeeAll: onNavigateToHistory,
            onItemTap: (session) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ParkingDetailsScreen(session: session),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildParkingIllustration() {
    return Container(
      width: 230,
      height: 230,
      decoration: const BoxDecoration(
        color: Color(0xFFF1EFE9),
        shape: BoxShape.circle,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Parking lines & Trees Canvas
          CustomPaint(
            size: const Size(230, 230),
            painter: _ParkingSpotsPainter(),
          ),
        ],
      ),
    );
  }
}

class _ParkingSpotsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = const Color(0xFFD6D3CC)
      ..style = PaintingStyle.fill;

    // Angled parking stripes in foreground
    final p1 = Path()
      ..moveTo(size.width * 0.28, size.height * 0.72)
      ..lineTo(size.width * 0.45, size.height * 0.60)
      ..lineTo(size.width * 0.58, size.height * 0.67)
      ..lineTo(size.width * 0.36, size.height * 0.85)
      ..close();
    canvas.drawPath(p1, linePaint);

    final p2 = Path()
      ..moveTo(size.width * 0.46, size.height * 0.60)
      ..lineTo(size.width * 0.63, size.height * 0.48)
      ..lineTo(size.width * 0.76, size.height * 0.55)
      ..lineTo(size.width * 0.55, size.height * 0.74)
      ..close();
    canvas.drawPath(p2, linePaint);

    // Tree trunks & trees in background
    final treePaint = Paint()
      ..color = const Color(0xFFD9D4C7)
      ..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..color = const Color(0xFF78716C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Tree 1
    canvas.drawOval(
      Rect.fromCenter(center: Offset(size.width * 0.28, size.height * 0.36), width: 32, height: 44),
      treePaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(size.width * 0.28, size.height * 0.36), width: 32, height: 44),
      strokePaint,
    );
    canvas.drawLine(Offset(size.width * 0.28, size.height * 0.44), Offset(size.width * 0.28, size.height * 0.52), strokePaint);

    // Tree 2
    canvas.drawOval(
      Rect.fromCenter(center: Offset(size.width * 0.52, size.height * 0.32), width: 28, height: 38),
      treePaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(size.width * 0.52, size.height * 0.32), width: 28, height: 38),
      strokePaint,
    );
    canvas.drawLine(Offset(size.width * 0.52, size.height * 0.40), Offset(size.width * 0.52, size.height * 0.48), strokePaint);

    // Tree 3
    canvas.drawOval(
      Rect.fromCenter(center: Offset(size.width * 0.76, size.height * 0.35), width: 34, height: 46),
      treePaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(size.width * 0.76, size.height * 0.35), width: 34, height: 46),
      strokePaint,
    );
    canvas.drawLine(Offset(size.width * 0.76, size.height * 0.44), Offset(size.width * 0.76, size.height * 0.54), strokePaint);

    // Bench
    final benchPaint = Paint()
      ..color = const Color(0xFF78716C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;
    canvas.drawRect(Rect.fromLTWH(size.width * 0.38, size.height * 0.42, 30, 10), benchPaint);
    canvas.drawLine(Offset(size.width * 0.40, size.height * 0.47), Offset(size.width * 0.40, size.height * 0.53), benchPaint);
    canvas.drawLine(Offset(size.width * 0.48, size.height * 0.47), Offset(size.width * 0.48, size.height * 0.53), benchPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
