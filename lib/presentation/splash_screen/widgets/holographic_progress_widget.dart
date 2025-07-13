import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class HolographicProgressWidget extends StatefulWidget {
  final Animation<double> progress;
  final int currentStep;
  final int totalSteps;

  const HolographicProgressWidget({
    Key? key,
    required this.progress,
    required this.currentStep,
    required this.totalSteps,
  }) : super(key: key);

  @override
  State<HolographicProgressWidget> createState() =>
      _HolographicProgressWidgetState();
}

class _HolographicProgressWidgetState extends State<HolographicProgressWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _glowAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));

    _glowController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([widget.progress, _glowAnimation]),
      builder: (context, child) {
        return Column(
          children: [
            // Holographic progress ring
            Container(
              width: 30.w,
              height: 30.w,
              child: CustomPaint(
                painter: HolographicRingPainter(
                  progress: widget.progress.value,
                  currentStep: widget.currentStep,
                  totalSteps: widget.totalSteps,
                  glowIntensity: _glowAnimation.value,
                ),
                size: Size.infinite,
              ),
            ),

            SizedBox(height: 2.h),

            // Progress percentage
            Text(
              '${(widget.progress.value * 100).toInt()}%',
              style: AppTheme.darkTheme.textTheme.headlineSmall?.copyWith(
                color: AppTheme.primaryCyan,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: AppTheme.primaryCyan.withAlpha(128),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),

            SizedBox(height: 1.h),

            // Step indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.totalSteps, (index) {
                final isActive = index <= widget.currentStep;
                final isCurrent = index == widget.currentStep;

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: isCurrent ? 12 : 8,
                  height: isCurrent ? 12 : 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive
                        ? AppTheme.primaryCyan
                        : AppTheme.textSecondary.withAlpha(77),
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: AppTheme.primaryCyan.withAlpha(128),
                              blurRadius: isCurrent ? 8 : 4,
                              spreadRadius: isCurrent ? 2 : 1,
                            ),
                          ]
                        : null,
                  ),
                );
              }),
            ),
          ],
        );
      },
    );
  }
}

class HolographicRingPainter extends CustomPainter {
  final double progress;
  final int currentStep;
  final int totalSteps;
  final double glowIntensity;

  HolographicRingPainter({
    required this.progress,
    required this.currentStep,
    required this.totalSteps,
    required this.glowIntensity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    // Draw background ring
    _drawBackgroundRing(canvas, center, radius);

    // Draw progress arc
    _drawProgressArc(canvas, center, radius);

    // Draw holographic segments
    _drawHolographicSegments(canvas, center, radius);

    // Draw center core
    _drawCenterCore(canvas, center);
  }

  void _drawBackgroundRing(Canvas canvas, Offset center, double radius) {
    final paint = Paint()
      ..color = AppTheme.borderColor.withAlpha(77)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, paint);
  }

  void _drawProgressArc(Canvas canvas, Offset center, double radius) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [
          AppTheme.primaryCyan,
          AppTheme.accentGlow,
          AppTheme.successGreen,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 2 * glowIntensity);

    final sweepAngle = 2 * math.pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2, // Start from top
      sweepAngle,
      false,
      paint,
    );
  }

  void _drawHolographicSegments(Canvas canvas, Offset center, double radius) {
    final segmentPaint = Paint()
      ..color = AppTheme.primaryCyan.withOpacity(0.3 * glowIntensity)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw segment dividers
    for (int i = 0; i < totalSteps; i++) {
      final angle = (2 * math.pi / totalSteps) * i - math.pi / 2;
      final startPoint = Offset(
        center.dx + math.cos(angle) * (radius - 15),
        center.dy + math.sin(angle) * (radius - 15),
      );
      final endPoint = Offset(
        center.dx + math.cos(angle) * (radius + 5),
        center.dy + math.sin(angle) * (radius + 5),
      );

      canvas.drawLine(startPoint, endPoint, segmentPaint);
    }

    // Draw outer holographic ring
    final outerRingPaint = Paint()
      ..color = AppTheme.primaryCyan.withOpacity(0.2 * glowIntensity)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius + 15, outerRingPaint);
  }

  void _drawCenterCore(Canvas canvas, Offset center) {
    // Inner core with pulsing effect
    final corePaint = Paint()
      ..shader = RadialGradient(
        colors: [
          AppTheme.primaryCyan.withOpacity(0.8 * glowIntensity),
          AppTheme.primaryCyan.withOpacity(0.4 * glowIntensity),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: 20));

    canvas.drawCircle(center, 20, corePaint);

    // Core border
    final borderPaint = Paint()
      ..color = AppTheme.primaryCyan.withOpacity(glowIntensity)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, 15, borderPaint);

    // Central dot
    final dotPaint = Paint()
      ..color = AppTheme.primaryCyan
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, 3, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
