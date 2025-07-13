import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/ai_orb_loading_widget.dart';
import './widgets/holographic_progress_widget.dart';
import './widgets/particle_animation_widget.dart';
import './widgets/typewriter_text_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _orbAnimationController;
  late AnimationController _backgroundAnimationController;
  late AnimationController _progressAnimationController;

  late Animation<double> _logoFadeAnimation;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _orbPulseAnimation;
  late Animation<double> _backgroundGradientAnimation;
  late Animation<double> _progressAnimation;

  Timer? _navigationTimer;
  int _currentLoadingStep = 0;
  final List<String> _loadingSteps = [
    'Initializing Voice Engine...',
    'Loading Neural Networks...',
    'Securing Protocols...',
    'Integrating Systems...',
    'MAAHI Voice OS Ready',
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimationSequence();
    _startLoadingProgress();
    _startNavigationTimer();

    // Hide status bar for immersive experience
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  void _initializeAnimations() {
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _orbAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _backgroundAnimationController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );

    _progressAnimationController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
    ));

    _logoScaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
    ));

    _orbPulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _orbAnimationController,
      curve: Curves.easeInOut,
    ));

    _backgroundGradientAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_backgroundAnimationController);

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  void _startAnimationSequence() {
    _logoAnimationController.forward();
    _backgroundAnimationController.repeat();

    Future.delayed(const Duration(milliseconds: 500), () {
      _orbAnimationController.repeat(reverse: true);
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      _progressAnimationController.forward();
    });
  }

  void _startLoadingProgress() {
    Timer.periodic(const Duration(milliseconds: 600), (timer) {
      if (_currentLoadingStep < _loadingSteps.length - 1) {
        setState(() {
          _currentLoadingStep++;
        });

        // Haptic feedback for each loading milestone
        HapticFeedback.lightImpact();
      } else {
        timer.cancel();
      }
    });
  }

  void _startNavigationTimer() {
    _navigationTimer = Timer(const Duration(seconds: 4), () {
      _navigateToNextScreen();
    });
  }

  void _navigateToNextScreen() {
    // Show status bar again
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );

    // Navigate to Permission Setup for new users or Voice Dashboard for returning users
    // For now, navigating to Voice Dashboard (this could be enhanced with user preference logic)
    Navigator.pushReplacementNamed(context, AppRoutes.voiceDashboardScreen);
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _orbAnimationController.dispose();
    _backgroundAnimationController.dispose();
    _progressAnimationController.dispose();
    _navigationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundBlack,
      body: Stack(
        children: [
          // Animated background with deep space gradient and circuit patterns
          _buildAnimatedBackground(),

          // Particle system overlay
          const ParticleAnimationWidget(),

          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // MAAHI 2.0 ULTRA Logo with holographic glow
                _buildAnimatedLogo(),

                SizedBox(height: 8.h),

                // AI Orb with voice waveform visualization
                const AiOrbLoadingWidget(),

                SizedBox(height: 6.h),

                // Holographic progress ring
                HolographicProgressWidget(
                  progress: _progressAnimation,
                  currentStep: _currentLoadingStep,
                  totalSteps: _loadingSteps.length,
                ),

                SizedBox(height: 4.h),

                // Loading status text
                _buildLoadingStatus(),
              ],
            ),
          ),

          // Bottom initialization text
          Positioned(
            bottom: 8.h,
            left: 0,
            right: 0,
            child: TypewriterTextWidget(
              text: _currentLoadingStep < _loadingSteps.length
                  ? _loadingSteps[_currentLoadingStep]
                  : 'Initializing MAAHI Voice OS',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _backgroundGradientAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 1.5,
              colors: [
                AppTheme.backgroundBlack,
                Color.lerp(
                  AppTheme.backgroundBlack,
                  AppTheme.primaryCyan.withAlpha(26),
                  _backgroundGradientAnimation.value * 0.3,
                )!,
                AppTheme.backgroundBlack,
              ],
              stops: const [0.0, 0.6, 1.0],
            ),
          ),
          child: CustomPaint(
            painter: CircuitPatternPainter(
              animationValue: _backgroundGradientAnimation.value,
            ),
            size: Size.infinite,
          ),
        );
      },
    );
  }

  Widget _buildAnimatedLogo() {
    return AnimatedBuilder(
      animation: Listenable.merge([_logoFadeAnimation, _logoScaleAnimation]),
      builder: (context, child) {
        return Opacity(
          opacity: _logoFadeAnimation.value,
          child: Transform.scale(
            scale: _logoScaleAnimation.value,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppTheme.primaryCyan.withAlpha(77),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryCyan.withAlpha(51),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'MAAHI',
                    style: AppTheme.darkTheme.textTheme.displayMedium?.copyWith(
                      color: AppTheme.primaryCyan,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 4.0,
                      shadows: [
                        Shadow(
                          color: AppTheme.primaryCyan.withAlpha(128),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '2.0 ULTRA',
                    style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                      color: AppTheme.textSecondary,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 2.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingStatus() {
    return AnimatedBuilder(
      animation: _orbPulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _orbPulseAnimation.value,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark.withAlpha(204),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: AppTheme.primaryCyan.withAlpha(77),
                width: 1,
              ),
            ),
            child: Text(
              'Voice OS',
              style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.primaryCyan,
                letterSpacing: 1.5,
              ),
            ),
          ),
        );
      },
    );
  }
}

class CircuitPatternPainter extends CustomPainter {
  final double animationValue;

  CircuitPatternPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.primaryCyan.withAlpha(26)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Draw flowing energy lines
    for (int i = 0; i < 5; i++) {
      final path = Path();
      final startX = size.width * 0.1 * i;
      final startY = size.height * 0.2;

      path.moveTo(startX, startY);

      for (double t = 0; t <= 1; t += 0.1) {
        final x = startX + (size.width * 0.8 * t);
        final y = startY +
            math.sin((t * math.pi * 2) + (animationValue * math.pi * 2)) * 50;
        path.lineTo(x, y);
      }

      canvas.drawPath(path, paint);
    }

    // Draw circuit nodes
    for (int i = 0; i < 8; i++) {
      final x = (size.width / 8) * i + (animationValue * 50);
      final y =
          size.height * 0.7 + math.sin(animationValue * math.pi * 2 + i) * 30;

      canvas.drawCircle(
        Offset(x % size.width, y),
        2.0,
        Paint()..color = AppTheme.accentGlow.withAlpha(153),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
