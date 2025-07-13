import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AiOrbWidget extends StatelessWidget {
  final bool isListening;
  final Animation<double> orbPulseAnimation;
  final Animation<double> waveformAnimation;
  final VoidCallback onTap;

  const AiOrbWidget({
    super.key,
    required this.isListening,
    required this.orbPulseAnimation,
    required this.waveformAnimation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50.w,
        height: 50.w,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Outer glow ring
            AnimatedBuilder(
              animation: orbPulseAnimation,
              builder: (context, child) {
                return Container(
                  width: 50.w * orbPulseAnimation.value,
                  height: 50.w * orbPulseAnimation.value,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.primaryCyan.withValues(alpha: 0.3),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryCyan.withValues(alpha: 0.2),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                );
              },
            ),

            // Middle ring
            Container(
              width: 35.w,
              height: 35.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.primaryCyan.withValues(alpha: 0.5),
                  width: 1,
                ),
              ),
            ),

            // Core orb
            Container(
              width: 25.w,
              height: 25.w,
              decoration: AppTheme.aiOrbDecoration,
              child: Center(
                child: CustomIconWidget(
                  iconName: isListening ? 'mic' : 'mic_off',
                  color: AppTheme.backgroundBlack,
                  size: 8.w,
                ),
              ),
            ),

            // Waveform visualization
            if (isListening)
              Positioned(
                bottom: 0,
                child: AnimatedBuilder(
                  animation: waveformAnimation,
                  builder: (context, child) {
                    return Container(
                      width: 40.w,
                      height: 8.h,
                      child: CustomPaint(
                        painter: WaveformPainter(
                          amplitude: waveformAnimation.value,
                          color: AppTheme.primaryCyan,
                        ),
                      ),
                    );
                  },
                ),
              ),

            // Status indicator
            Positioned(
              top: 2.h,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: isListening
                      ? AppTheme.successGreen.withValues(alpha: 0.2)
                      : AppTheme.warningAmber.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isListening
                        ? AppTheme.successGreen
                        : AppTheme.warningAmber,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 2.w,
                      height: 2.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isListening
                            ? AppTheme.successGreen
                            : AppTheme.warningAmber,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      isListening ? 'LISTENING' : 'SLEEPING',
                      style: TextStyle(
                        color: isListening
                            ? AppTheme.successGreen
                            : AppTheme.warningAmber,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WaveformPainter extends CustomPainter {
  final double amplitude;
  final Color color;

  WaveformPainter({
    required this.amplitude,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.8)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    final centerY = size.height / 2;
    final waveLength = size.width / 4;

    for (int i = 0; i < 5; i++) {
      final x = (size.width / 4) * i;
      final height = (amplitude * size.height * 0.3) * (i % 2 == 0 ? 1 : -1);

      if (i == 0) {
        path.moveTo(x, centerY);
      } else {
        path.lineTo(x, centerY + height);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
