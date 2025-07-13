import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SystemControlCardWidget extends StatefulWidget {
  final String title;
  final String icon;
  final Widget child;
  final bool? isEnabled;
  final VoidCallback? onToggle;

  const SystemControlCardWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
    this.isEnabled,
    this.onToggle,
  });

  @override
  State<SystemControlCardWidget> createState() =>
      _SystemControlCardWidgetState();
}

class _SystemControlCardWidgetState extends State<SystemControlCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _colorAnimation = ColorTween(
      begin: AppTheme.surfaceDark,
      end: AppTheme.primaryCyan.withValues(alpha: 0.1),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.onToggle != null) {
      _animationController.forward().then((_) {
        _animationController.reverse();
      });
      HapticFeedback.mediumImpact();
      widget.onToggle!();
    }
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
              decoration: BoxDecoration(
                color: _colorAnimation.value,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: widget.isEnabled == true
                      ? AppTheme.primaryCyan.withValues(alpha: 0.5)
                      : AppTheme.borderColor,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.shadowColor,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                  if (widget.isEnabled == true)
                    BoxShadow(
                      color: AppTheme.primaryCyan.withValues(alpha: 0.1),
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomIconWidget(
                          iconName: widget.icon,
                          color: widget.isEnabled == true
                              ? AppTheme.primaryCyan
                              : AppTheme.textSecondary,
                          size: 6.w,
                        ),
                        if (widget.onToggle != null)
                          Container(
                            width: 12.w,
                            height: 3.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: widget.isEnabled == true
                                  ? AppTheme.primaryCyan
                                  : AppTheme.borderColor,
                            ),
                            child: AnimatedAlign(
                              duration: const Duration(milliseconds: 200),
                              alignment: widget.isEnabled == true
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                width: 5.w,
                                height: 2.5.h,
                                margin: EdgeInsets.all(0.5.w),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: widget.isEnabled == true
                                      ? AppTheme.backgroundBlack
                                      : AppTheme.textSecondary,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.shadowColor,
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      widget.title,
                      style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                        color: widget.isEnabled == true
                            ? AppTheme.primaryCyan
                            : AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Expanded(child: widget.child),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
