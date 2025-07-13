import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class AiOrbLoadingWidget extends StatefulWidget {
  const AiOrbLoadingWidget({Key? key}) : super(key: key);

  @override
  State<AiOrbLoadingWidget> createState() => _AiOrbLoadingWidgetState();
}

class _AiOrbLoadingWidgetState extends State<AiOrbLoadingWidget>
    with TickerProviderStateMixin {
  late AnimationController _orbController;
  late AnimationController _waveformController;
  late Animation<double> _orbPulseAnimation;
  late Animation<double> _waveformAnimation;

  @override
  void initState() {
    super.initState();

    _orbController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _waveformController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _orbPulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _orbController,
      curve: Curves.easeInOut,
    ));

    _waveformAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_waveformController);

    _orbController.repeat(reverse: true);
    _waveformController.repeat();
  }

  @override
  void dispose() {
    _orbController.dispose();
    _waveformController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // AI Orb with pulsing glow
        AnimatedBuilder(
          animation: _orbPulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _orbPulseAnimation.value,
              child: Container(
                width: 20.w,
                height: 20.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppTheme.primaryCyan,
                      AppTheme.primaryCyan.withAlpha(153),
                      AppTheme.primaryCyan.withAlpha(51),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.3, 0.7, 1.0],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryCyan.withAlpha(102),
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                    BoxShadow(
                      color: AppTheme.primaryCyan.withAlpha(51),
                      blurRadius: 50,
                      spreadRadius: 20,
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.primaryCyan,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryCyan.withAlpha(204),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),

        SizedBox(height: 3.h),

        // Voice waveform visualization
        AnimatedBuilder(
          animation: _waveformAnimation,
          builder: (context, child) {
            return Container(
              width: 60.w,
              height: 6.h,
              child: CustomPaint(
                painter: WaveformPainter(
                  animationValue: _waveformAnimation.value,
                ),
                size: Size.infinite,
              ),
            );
          },
        ),
      ],
    );
  }
}

class WaveformPainter extends CustomPainter {
  final double animationValue;

  WaveformPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.primaryCyan
      ..strokeWidth = 2.0
      ..style = PaintingStyle.fill;

    final centerY = size.height / 2;
    final barWidth = size.width / 20;
    final spacing = barWidth * 0.3;

    for (int i = 0; i < 20; i++) {
      final x = i * (barWidth + spacing);
      final heightMultiplier =
          math.sin((i * 0.5) + (animationValue * math.pi * 4)).abs();

      final barHeight = (size.height * 0.8) * heightMultiplier;

      // Create gradient effect
      final opacity = 0.3 + (heightMultiplier * 0.7);
      paint.color = AppTheme.primaryCyan.withOpacity(opacity);

      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          x,
          centerY - (barHeight / 2),
          barWidth,
          barHeight,
        ),
        const Radius.circular(2),
      );

      canvas.drawRRect(rect, paint);

      // Add glow effect for taller bars
      if (heightMultiplier > 0.6) {
        final glowPaint = Paint()
          ..color = AppTheme.primaryCyan.withAlpha(77)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

        canvas.drawRRect(rect, glowPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
