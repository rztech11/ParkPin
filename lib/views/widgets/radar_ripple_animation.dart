import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'custom_pin_icon.dart';

class RadarRippleAnimation extends StatefulWidget {
  final double size;
  final Widget? centerChild;
  final bool hasCheckmark;

  const RadarRippleAnimation({
    super.key,
    this.size = 280,
    this.centerChild,
    this.hasCheckmark = false,
  });

  @override
  State<RadarRippleAnimation> createState() => _RadarRippleAnimationState();
}

class _RadarRippleAnimationState extends State<RadarRippleAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Animated Concentric Radar Rings
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                size: Size(widget.size, widget.size),
                painter: _RipplePainter(
                  animationValue: _controller.value,
                  hasCheckmark: widget.hasCheckmark,
                ),
              );
            },
          ),
          // Center Icon / Pin
          widget.centerChild ??
              CustomPinIcon(
                size: widget.size * 0.32,
                pinColor: AppColors.primary,
                iconColor: AppColors.primary,
                hasCheckmark: widget.hasCheckmark,
              ),
        ],
      ),
    );
  }
}

class _RipplePainter extends CustomPainter {
  final double animationValue;
  final bool hasCheckmark;

  _RipplePainter({
    required this.animationValue,
    required this.hasCheckmark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;

    // Static background tinted circle
    final bgPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.06)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, maxRadius * 0.78, bgPaint);

    // Dynamic wave pulses
    const int ringCount = 3;
    for (int i = 0; i < ringCount; i++) {
      final double progress = (animationValue + (i / ringCount)) % 1.0;
      final double radius = (maxRadius * 0.35) + (maxRadius * 0.65 * progress);
      final double opacity = math.max(0.0, (1.0 - progress) * 0.45);

      final ringPaint = Paint()
        ..color = AppColors.primary.withValues(alpha: opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      canvas.drawCircle(center, radius, ringPaint);
    }

    // Concentric subtle static guide rings (as seen in mockup)
    final staticGuidePaint = Paint()
      ..color = AppColors.border.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawCircle(center, maxRadius * 0.45, staticGuidePaint);
    canvas.drawCircle(center, maxRadius * 0.65, staticGuidePaint);
    canvas.drawCircle(center, maxRadius * 0.85, staticGuidePaint);
    canvas.drawCircle(center, maxRadius * 0.98, staticGuidePaint);
  }

  @override
  bool shouldRepaint(covariant _RipplePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
