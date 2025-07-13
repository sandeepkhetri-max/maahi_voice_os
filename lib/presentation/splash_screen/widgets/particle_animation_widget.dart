import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class ParticleAnimationWidget extends StatefulWidget {
  const ParticleAnimationWidget({Key? key}) : super(key: key);

  @override
  State<ParticleAnimationWidget> createState() =>
      _ParticleAnimationWidgetState();
}

class _ParticleAnimationWidgetState extends State<ParticleAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = [];
  final int _particleCount = 50;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );

    _initializeParticles();
    _controller.repeat();
  }

  void _initializeParticles() {
    final random = math.Random();

    for (int i = 0; i < _particleCount; i++) {
      _particles.add(
        Particle(
          x: random.nextDouble(),
          y: random.nextDouble(),
          size: random.nextDouble() * 3 + 1,
          speed: random.nextDouble() * 0.02 + 0.005,
          opacity: random.nextDouble() * 0.6 + 0.2,
          angle: random.nextDouble() * math.pi * 2,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: ParticlePainter(
            particles: _particles,
            animationValue: _controller.value,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class Particle {
  double x;
  double y;
  final double size;
  final double speed;
  final double opacity;
  final double angle;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
    required this.angle,
  });

  void update() {
    x += math.cos(angle) * speed;
    y += math.sin(angle) * speed;

    // Wrap around screen edges
    if (x > 1.0) x = 0.0;
    if (x < 0.0) x = 1.0;
    if (y > 1.0) y = 0.0;
    if (y < 0.0) y = 1.0;
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double animationValue;

  ParticlePainter({
    required this.particles,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < particles.length; i++) {
      final particle = particles[i];
      particle.update();

      // Calculate dynamic opacity based on distance from center
      final centerX = 0.5;
      final centerY = 0.5;
      final distanceFromCenter = math.sqrt(math.pow(particle.x - centerX, 2) +
          math.pow(particle.y - centerY, 2));

      final dynamicOpacity = particle.opacity * (1 - distanceFromCenter * 0.8);

      // Create different particle types
      if (i % 3 == 0) {
        // Glowing dots
        _drawGlowingDot(canvas, size, particle, dynamicOpacity);
      } else if (i % 3 == 1) {
        // Energy sparks
        _drawEnergySpark(canvas, size, particle, dynamicOpacity);
      } else {
        // Floating circuits
        _drawFloatingCircuit(canvas, size, particle, dynamicOpacity);
      }
    }

    // Draw connecting lines between nearby particles
    _drawConnections(canvas, size);
  }

  void _drawGlowingDot(
      Canvas canvas, Size size, Particle particle, double opacity) {
    final paint = Paint()
      ..color = AppTheme.primaryCyan.withOpacity(opacity)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

    canvas.drawCircle(
      Offset(particle.x * size.width, particle.y * size.height),
      particle.size,
      paint,
    );
  }

  void _drawEnergySpark(
      Canvas canvas, Size size, Particle particle, double opacity) {
    final paint = Paint()
      ..color = AppTheme.accentGlow.withOpacity(opacity)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final center = Offset(particle.x * size.width, particle.y * size.height);
    final sparkLength = particle.size * 2;

    for (int i = 0; i < 4; i++) {
      final angle = (math.pi / 2) * i + (animationValue * math.pi * 2);
      final end = Offset(
        center.dx + math.cos(angle) * sparkLength,
        center.dy + math.sin(angle) * sparkLength,
      );
      canvas.drawLine(center, end, paint);
    }
  }

  void _drawFloatingCircuit(
      Canvas canvas, Size size, Particle particle, double opacity) {
    final paint = Paint()
      ..color = AppTheme.successGreen.withOpacity(opacity * 0.5)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    final center = Offset(particle.x * size.width, particle.y * size.height);
    canvas.drawRect(
      Rect.fromCenter(
        center: center,
        width: particle.size * 2,
        height: particle.size * 2,
      ),
      paint,
    );
  }

  void _drawConnections(Canvas canvas, Size size) {
    final connectionPaint = Paint()
      ..color = AppTheme.primaryCyan.withAlpha(26)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < particles.length; i++) {
      for (int j = i + 1; j < particles.length; j++) {
        final particle1 = particles[i];
        final particle2 = particles[j];

        final distance = math.sqrt(
            math.pow((particle1.x - particle2.x) * size.width, 2) +
                math.pow((particle1.y - particle2.y) * size.height, 2));

        // Only draw connections for nearby particles
        if (distance < 100) {
          final opacity = (1 - distance / 100) * 0.3;
          connectionPaint.color = AppTheme.primaryCyan.withOpacity(opacity);

          canvas.drawLine(
            Offset(particle1.x * size.width, particle1.y * size.height),
            Offset(particle2.x * size.width, particle2.y * size.height),
            connectionPaint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
