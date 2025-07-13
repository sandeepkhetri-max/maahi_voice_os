import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VoiceSearchBarWidget extends StatefulWidget {
  final TextEditingController controller;
  final bool isListening;
  final VoidCallback onVoicePressed;
  final ValueChanged<String> onSearchChanged;

  const VoiceSearchBarWidget({
    super.key,
    required this.controller,
    required this.isListening,
    required this.onVoicePressed,
    required this.onSearchChanged,
  });

  @override
  State<VoiceSearchBarWidget> createState() => _VoiceSearchBarWidgetState();
}

class _VoiceSearchBarWidgetState extends State<VoiceSearchBarWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    if (widget.isListening) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(VoiceSearchBarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isListening != oldWidget.isListening) {
      if (widget.isListening) {
        _pulseController.repeat(reverse: true);
      } else {
        _pulseController.stop();
        _pulseController.reset();
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:
              widget.isListening ? AppTheme.primaryCyan : AppTheme.borderColor,
          width: widget.isListening ? 2 : 1,
        ),
        boxShadow: [
          if (widget.isListening)
            BoxShadow(
              color: AppTheme.primaryCyan.withValues(alpha: 0.2),
              blurRadius: 12,
              spreadRadius: 2,
            ),
        ],
      ),
      child: Row(
        children: [
          // Search icon
          Padding(
            padding: EdgeInsets.only(left: 4.w),
            child: CustomIconWidget(
              iconName: 'search',
              color: AppTheme.textSecondary,
              size: 5.w,
            ),
          ),

          // Search input
          Expanded(
            child: TextField(
              controller: widget.controller,
              onChanged: widget.onSearchChanged,
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: widget.isListening
                    ? 'Listening... Say "Open WhatsApp" or "Show games"'
                    : 'Search apps or say voice command',
                hintStyle: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  color: widget.isListening
                      ? AppTheme.primaryCyan
                      : AppTheme.textDisabled,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 3.w,
                  vertical: 2.h,
                ),
              ),
            ),
          ),

          // Voice button
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: widget.isListening ? _pulseAnimation.value : 1.0,
                child: Container(
                  margin: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: widget.isListening
                        ? AppTheme.primaryCyan
                        : AppTheme.primaryCyan.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                    boxShadow: [
                      if (widget.isListening)
                        BoxShadow(
                          color: AppTheme.primaryCyan.withValues(alpha: 0.4),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: widget.onVoicePressed,
                    icon: CustomIconWidget(
                      iconName: widget.isListening ? 'mic' : 'mic_none',
                      color: widget.isListening
                          ? AppTheme.backgroundBlack
                          : AppTheme.primaryCyan,
                      size: 5.w,
                    ),
                  ),
                ),
              );
            },
          ),

          // Clear button
          if (widget.controller.text.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(right: 2.w),
              child: IconButton(
                onPressed: () {
                  widget.controller.clear();
                  widget.onSearchChanged('');
                },
                icon: CustomIconWidget(
                  iconName: 'clear',
                  color: AppTheme.textSecondary,
                  size: 4.w,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
