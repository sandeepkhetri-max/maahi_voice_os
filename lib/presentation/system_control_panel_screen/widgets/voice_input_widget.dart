import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VoiceInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final bool isListening;
  final String lastCommand;
  final double confidence;
  final Function(String) onCommandSubmitted;
  final VoidCallback onListeningToggle;

  const VoiceInputWidget({
    super.key,
    required this.controller,
    required this.isListening,
    required this.lastCommand,
    required this.confidence,
    required this.onCommandSubmitted,
    required this.onListeningToggle,
  });

  @override
  State<VoiceInputWidget> createState() => _VoiceInputWidgetState();
}

class _VoiceInputWidgetState extends State<VoiceInputWidget>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _pulseController;
  late Animation<double> _waveAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _waveAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _waveController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    if (widget.isListening) {
      _startAnimations();
    }
  }

  @override
  void didUpdateWidget(VoiceInputWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isListening != oldWidget.isListening) {
      if (widget.isListening) {
        _startAnimations();
      } else {
        _stopAnimations();
      }
    }
  }

  void _startAnimations() {
    _waveController.repeat();
    _pulseController.repeat(reverse: true);
  }

  void _stopAnimations() {
    _waveController.stop();
    _pulseController.stop();
  }

  @override
  void dispose() {
    _waveController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppTheme.waveformDecoration,
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: widget.isListening ? _pulseAnimation.value : 1.0,
                    child: GestureDetector(
                      onTap: () {
                        widget.onListeningToggle();
                        HapticFeedback.mediumImpact();
                      },
                      child: Container(
                        width: 12.w,
                        height: 12.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: widget.isListening
                              ? AppTheme.primaryCyan
                              : AppTheme.surfaceDark,
                          border: Border.all(
                            color: widget.isListening
                                ? AppTheme.primaryCyan
                                : AppTheme.borderColor,
                            width: 2,
                          ),
                          boxShadow: widget.isListening
                              ? [
                                  BoxShadow(
                                    color: AppTheme.primaryCyan
                                        .withValues(alpha: 0.3),
                                    blurRadius: 12,
                                    spreadRadius: 3,
                                  ),
                                ]
                              : null,
                        ),
                        child: CustomIconWidget(
                          iconName: widget.isListening ? 'mic' : 'mic_off',
                          color: widget.isListening
                              ? AppTheme.backgroundBlack
                              : AppTheme.textSecondary,
                          size: 6.w,
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: widget.isListening
                        ? "Listening for commands..."
                        : "Type or speak a command",
                    hintStyle:
                        AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textDisabled,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppTheme.borderColor,
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppTheme.borderColor,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppTheme.primaryCyan,
                        width: 2,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 2.h,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        if (widget.controller.text.isNotEmpty) {
                          widget.onCommandSubmitted(widget.controller.text);
                          widget.controller.clear();
                        }
                      },
                      icon: CustomIconWidget(
                        iconName: 'send',
                        color: AppTheme.primaryCyan,
                        size: 5.w,
                      ),
                    ),
                  ),
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      widget.onCommandSubmitted(value);
                      widget.controller.clear();
                    }
                  },
                ),
              ),
            ],
          ),
          if (widget.isListening) ...[
            SizedBox(height: 2.h),
            _buildVoiceWaveform(),
          ],
          if (widget.lastCommand.isNotEmpty) ...[
            SizedBox(height: 2.h),
            _buildLastCommandDisplay(),
          ],
        ],
      ),
    );
  }

  Widget _buildVoiceWaveform() {
    return Container(
      height: 6.h,
      child: AnimatedBuilder(
        animation: _waveAnimation,
        builder: (context, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(20, (index) {
              final height = (0.3 +
                      0.7 *
                          (0.5 +
                              0.5 *
                                  (index % 3 == 0
                                      ? _waveAnimation.value
                                      : index % 3 == 1
                                          ? (1 - _waveAnimation.value)
                                          : (_waveAnimation.value * 2) % 1))) *
                  6.h;

              return Container(
                width: 0.8.w,
                height: height,
                decoration: BoxDecoration(
                  color: AppTheme.primaryCyan.withValues(
                    alpha: 0.6 + 0.4 * _waveAnimation.value,
                  ),
                  borderRadius: BorderRadius.circular(0.4.w),
                ),
              );
            }),
          );
        },
      ),
    );
  }

  Widget _buildLastCommandDisplay() {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.primaryCyan.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'check_circle',
                color: AppTheme.successGreen,
                size: 4.w,
              ),
              SizedBox(width: 2.w),
              Text(
                "Last Command",
                style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: AppTheme.primaryCyan.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "${(widget.confidence * 100).round()}%",
                  style: AppTheme.systemMetricsStyle.copyWith(
                    fontSize: 8.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            widget.lastCommand,
            style: AppTheme.commandHistoryStyle.copyWith(
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
