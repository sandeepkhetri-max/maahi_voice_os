import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickToggleWidget extends StatefulWidget {
  final String icon;
  final String label;
  final bool isEnabled;
  final VoidCallback onToggle;

  const QuickToggleWidget({
    super.key,
    required this.icon,
    required this.label,
    required this.isEnabled,
    required this.onToggle,
  });

  @override
  State<QuickToggleWidget> createState() => _QuickToggleWidgetState();
}

class _QuickToggleWidgetState extends State<QuickToggleWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _colorAnimation = ColorTween(
      begin: widget.isEnabled
          ? AppTheme.primaryCyan.withValues(alpha: 0.2)
          : AppTheme.surfaceDark,
      end: widget.isEnabled
          ? AppTheme.primaryCyan.withValues(alpha: 0.4)
          : AppTheme.borderColor,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(QuickToggleWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isEnabled != oldWidget.isEnabled) {
      _colorAnimation = ColorTween(
        begin: widget.isEnabled
            ? AppTheme.primaryCyan.withValues(alpha: 0.2)
            : AppTheme.surfaceDark,
        end: widget.isEnabled
            ? AppTheme.primaryCyan.withValues(alpha: 0.4)
            : AppTheme.borderColor,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ));
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap() {
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
    HapticFeedback.lightImpact();
    widget.onToggle();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTap: _handleTap,
            onTapDown: (_) => _animationController.forward(),
            onTapUp: (_) => _animationController.reverse(),
            onTapCancel: () => _animationController.reverse(),
            child: Container(
              width: 18.w,
              padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.w),
              decoration: BoxDecoration(
                color: widget.isEnabled
                    ? AppTheme.primaryCyan.withValues(alpha: 0.2)
                    : AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: widget.isEnabled
                      ? AppTheme.primaryCyan.withValues(alpha: 0.5)
                      : AppTheme.borderColor,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.shadowColor,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                  if (widget.isEnabled)
                    BoxShadow(
                      color: AppTheme.primaryCyan.withValues(alpha: 0.1),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: widget.icon,
                    color: widget.isEnabled
                        ? AppTheme.primaryCyan
                        : AppTheme.textSecondary,
                    size: 6.w,
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    widget.label,
                    style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                      color: widget.isEnabled
                          ? AppTheme.primaryCyan
                          : AppTheme.textSecondary,
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
