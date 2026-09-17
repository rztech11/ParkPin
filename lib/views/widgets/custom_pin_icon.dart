import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class CustomPinIcon extends StatelessWidget {
  final double size;
  final Color pinColor;
  final Color iconColor;
  final bool hasCheckmark;
  final bool filled;

  const CustomPinIcon({
    super.key,
    this.size = 48,
    this.pinColor = AppColors.primary,
    this.iconColor = AppColors.primary,
    this.hasCheckmark = false,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size * 1.3,
      child: CustomPaint(
        painter: _ParkPinPainter(
          pinColor: pinColor,
          iconColor: iconColor,
          hasCheckmark: hasCheckmark,
          filled: filled,
        ),
      ),
    );
  }
}

class _ParkPinPainter extends CustomPainter {
  final Color pinColor;
  final Color iconColor;
  final bool hasCheckmark;
  final bool filled;

  _ParkPinPainter({
    required this.pinColor,
    required this.iconColor,
    required this.hasCheckmark,
    required this.filled,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final radius = w / 2;

    final pinPaint = Paint()
      ..color = pinColor
      ..style = filled ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeWidth = w * 0.08
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Outer Pin Teardrop Path
    final path = Path();
    path.moveTo(radius, h); // Bottom tip
    // Curve up left
    path.cubicTo(
      w * 0.05, h * 0.65,
      0, radius * 1.3,
      0, radius,
    );
    // Arc top
    path.arcToPoint(
      Offset(w, radius),
      radius: Radius.circular(radius),
      clockwise: true,
    );
    // Curve down right to tip
    path.cubicTo(
      w, radius * 1.3,
      w * 0.95, h * 0.65,
      radius, h,
    );
    path.close();

    if (filled) {
      canvas.drawPath(path, pinPaint);
    } else {
      // Background inner fill
      final fillPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      canvas.drawPath(path, fillPaint);
      canvas.drawPath(path, pinPaint);
    }

    // Inner symbol: Car silhouette or Checkmark
    if (hasCheckmark) {
      final checkPaint = Paint()
        ..color = filled ? Colors.white : iconColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.1
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      final checkPath = Path();
      checkPath.moveTo(w * 0.32, radius * 0.95);
      checkPath.lineTo(w * 0.46, radius * 1.25);
      checkPath.lineTo(w * 0.72, radius * 0.65);
      canvas.drawPath(checkPath, checkPaint);
    } else {
      // Car silhouette
      final carPaint = Paint()
        ..color = filled ? Colors.white : iconColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.065
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      final carFill = Paint()
        ..color = filled ? Colors.white : iconColor
        ..style = PaintingStyle.fill;

      final carCenterY = radius * 0.95;

      // Car body
      final carPath = Path();
      carPath.moveTo(w * 0.22, carCenterY + radius * 0.15);
      carPath.lineTo(w * 0.30, carCenterY + radius * 0.15);
      // Front wheel cutout
      carPath.arcToPoint(
        Offset(w * 0.44, carCenterY + radius * 0.15),
        radius: Radius.circular(radius * 0.12),
        clockwise: false,
      );
      carPath.lineTo(w * 0.58, carCenterY + radius * 0.15);
      // Rear wheel cutout
      carPath.arcToPoint(
        Offset(w * 0.72, carCenterY + radius * 0.15),
        radius: Radius.circular(radius * 0.12),
        clockwise: false,
      );
      carPath.lineTo(w * 0.80, carCenterY + radius * 0.15);
      // Rear trunk
      carPath.lineTo(w * 0.78, carCenterY - radius * 0.08);
      // Roof slope rear
      carPath.lineTo(w * 0.64, carCenterY - radius * 0.32);
      // Roof top
      carPath.lineTo(w * 0.42, carCenterY - radius * 0.32);
      // Windshield slope front
      carPath.lineTo(w * 0.28, carCenterY - radius * 0.05);
      // Hood front
      carPath.lineTo(w * 0.20, carCenterY + radius * 0.02);
      carPath.close();

      canvas.drawPath(carPath, carPaint);

      // Wheel circles
      canvas.drawCircle(Offset(w * 0.37, carCenterY + radius * 0.15), radius * 0.08, carFill);
      canvas.drawCircle(Offset(w * 0.65, carCenterY + radius * 0.15), radius * 0.08, carFill);
    }
  }

  @override
  bool shouldRepaint(covariant _ParkPinPainter oldDelegate) {
    return oldDelegate.pinColor != pinColor ||
        oldDelegate.iconColor != iconColor ||
        oldDelegate.hasCheckmark != hasCheckmark ||
        oldDelegate.filled != filled;
  }
}
