import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SettingsSearchWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  const SettingsSearchWidget({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  State<SettingsSearchWidget> createState() => _SettingsSearchWidgetState();
}

class _SettingsSearchWidgetState extends State<SettingsSearchWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isFocused
                  ? AppTheme.primaryCyan.withValues(alpha: _glowAnimation.value)
                  : AppTheme.borderColor,
              width: _isFocused ? 2 : 1,
            ),
            boxShadow: _isFocused
                ? [
                    BoxShadow(
                      color: AppTheme.primaryCyan.withValues(alpha: 0.2),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: TextField(
            controller: widget.controller,
            onChanged: widget.onChanged,
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textPrimary,
            ),
            decoration: InputDecoration(
              hintText:
                  'Search settings or say "Hey Maahi, find privacy settings"',
              hintStyle: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.textDisabled,
              ),
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'search',
                  color: _isFocused
                      ? AppTheme.primaryCyan
                      : AppTheme.textSecondary,
                  size: 20,
                ),
              ),
              suffixIcon: widget.controller.text.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        widget.controller.clear();
                        widget.onChanged('');
                      },
                      icon: CustomIconWidget(
                        iconName: 'clear',
                        color: AppTheme.textSecondary,
                        size: 18,
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.all(3.w),
                      child: CustomIconWidget(
                        iconName: 'mic',
                        color: AppTheme.accentGlow,
                        size: 18,
                      ),
                    ),
              filled: true,
              fillColor: AppTheme.surfaceDark.withValues(alpha: 0.8),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 4.w,
                vertical: 2.h,
              ),
            ),
            onTap: () {
              setState(() {
                _isFocused = true;
              });
            },
            onTapOutside: (event) {
              setState(() {
                _isFocused = false;
              });
            },
          ),
        );
      },
    );
  }
}
