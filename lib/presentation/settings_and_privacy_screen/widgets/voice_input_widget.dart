import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VoiceInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final bool isActive;
  final VoidCallback onToggle;
  final Function(String) onSubmit;

  const VoiceInputWidget({
    super.key,
    required this.controller,
    required this.isActive,
    required this.onToggle,
    required this.onSubmit,
  });

  @override
  State<VoiceInputWidget> createState() => _VoiceInputWidgetState();
}

class _VoiceInputWidgetState extends State<VoiceInputWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _waveController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _waveController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _waveAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _waveController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(VoiceInputWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _pulseController.repeat(reverse: true);
        _waveController.repeat();
      } else {
        _pulseController.stop();
        _waveController.stop();
        _pulseController.reset();
        _waveController.reset();
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (widget.controller.text.trim().isNotEmpty) {
      widget.onSubmit(widget.controller.text.trim());
      HapticFeedback.mediumImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.isActive
              ? AppTheme.primaryCyan.withValues(alpha: 0.5)
              : AppTheme.borderColor,
          width: widget.isActive ? 2 : 1,
        ),
        boxShadow: widget.isActive
            ? [
                BoxShadow(
                  color: AppTheme.primaryCyan.withValues(alpha: 0.2),
                  blurRadius: 16,
                  spreadRadius: 4,
                ),
              ]
            : [
                BoxShadow(
                  color: AppTheme.shadowColor,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        children: [
          // Voice Input Header
          Row(
            children: [
              // Voice Status Indicator
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: widget.isActive ? _pulseAnimation.value : 1.0,
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.isActive
                            ? AppTheme.primaryCyan.withValues(alpha: 0.2)
                            : AppTheme.borderColor.withValues(alpha: 0.2),
                        border: Border.all(
                          color: widget.isActive
                              ? AppTheme.primaryCyan
                              : AppTheme.borderColor,
                          width: 2,
                        ),
                      ),
                      child: CustomIconWidget(
                        iconName: widget.isActive ? 'mic' : 'mic_off',
                        color: widget.isActive
                            ? AppTheme.primaryCyan
                            : AppTheme.textSecondary,
                        size: 20,
                      ),
                    ),
                  );
                },
              ),

              SizedBox(width: 3.w),

              // Voice Input Title
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.isActive
                          ? 'Voice Command Active'
                          : 'Voice Command Input',
                      style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                        color: widget.isActive
                            ? AppTheme.primaryCyan
                            : AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      widget.isActive
                          ? 'Listening for commands...'
                          : 'Tap to activate voice input',
                      style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              // Toggle Button
              Switch(
                value: widget.isActive,
                onChanged: (value) {
                  HapticFeedback.lightImpact();
                  widget.onToggle();
                },
                activeColor: AppTheme.primaryCyan,
                activeTrackColor: AppTheme.primaryCyan.withValues(alpha: 0.3),
                inactiveThumbColor: AppTheme.textSecondary,
                inactiveTrackColor: AppTheme.borderColor,
              ),
            ],
          ),

          // Voice Waveform Visualization
          if (widget.isActive) ...[
            SizedBox(height: 3.h),
            AnimatedBuilder(
              animation: _waveAnimation,
              builder: (context, child) {
                return Container(
                  height: 6.h,
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundBlack,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.primaryCyan.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(20, (index) {
                      final double height = (0.2 +
                              0.8 *
                                  (0.5 +
                                      0.5 *
                                          (index / 20) *
                                          _waveAnimation.value)) *
                          4.h;

                      return Container(
                        width: 2,
                        height: height,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryCyan.withValues(
                            alpha: 0.3 + 0.7 * _waveAnimation.value,
                          ),
                          borderRadius: BorderRadius.circular(1),
                        ),
                      );
                    }),
                  ),
                );
              },
            ),
          ],

          // Text Input Field
          if (widget.isActive) ...[
            SizedBox(height: 3.h),
            TextField(
              controller: widget.controller,
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Type your voice command here...',
                hintStyle: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textDisabled,
                ),
                filled: true,
                fillColor: AppTheme.backgroundBlack,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppTheme.borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppTheme.borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppTheme.primaryCyan, width: 2),
                ),
                suffixIcon: IconButton(
                  onPressed: _handleSubmit,
                  icon: CustomIconWidget(
                    iconName: 'send',
                    color: AppTheme.primaryCyan,
                    size: 20,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 2.h,
                ),
              ),
              onSubmitted: (value) => _handleSubmit(),
            ),
          ],

          // Voice Command Examples
          if (!widget.isActive) ...[
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.backgroundBlack.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.accentGlow.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Voice Command Examples:',
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.accentGlow,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  ...[
                    'Turn on privacy mode',
                    'Increase wake word sensitivity',
                    'Enable developer options'
                  ].map((command) => Padding(
                        padding: EdgeInsets.only(bottom: 0.5.h),
                        child: Text(
                          '• "$command"',
                          style:
                              AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
