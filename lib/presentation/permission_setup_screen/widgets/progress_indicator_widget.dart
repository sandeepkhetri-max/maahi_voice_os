import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProgressIndicatorWidget extends StatefulWidget {
  final int current;
  final int total;

  const ProgressIndicatorWidget({
    super.key,
    required this.current,
    required this.total,
  });

  @override
  State<ProgressIndicatorWidget> createState() =>
      _ProgressIndicatorWidgetState();
}

class _ProgressIndicatorWidgetState extends State<ProgressIndicatorWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.current / widget.total,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _glowAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  @override
  void didUpdateWidget(ProgressIndicatorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.current != widget.current) {
      _progressAnimation = Tween<double>(
        begin: _progressAnimation.value,
        end: widget.current / widget.total,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ));
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double progressPercentage = (widget.current / widget.total) * 100;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: AppTheme.primaryCyan.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryCyan.withValues(alpha: 0.1),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Setup Progress",
                style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              AnimatedBuilder(
                animation: _glowAnimation,
                builder: (context, child) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 3.w,
                      vertical: 1.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryCyan
                          .withValues(alpha: 0.2 * _glowAnimation.value),
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(
                        color: AppTheme.primaryCyan
                            .withValues(alpha: 0.5 * _glowAnimation.value),
                      ),
                    ),
                    child: Text(
                      "${widget.current}/${widget.total}",
                      style: AppTheme.dataDisplayStyle.copyWith(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Progress bar
          Container(
            height: 1.h,
            decoration: BoxDecoration(
              color: AppTheme.borderColor,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: AnimatedBuilder(
              animation: _progressAnimation,
              builder: (context, child) {
                return Stack(
                  children: [
                    // Background track
                    Container(
                      width: double.infinity,
                      height: 1.h,
                      decoration: BoxDecoration(
                        color: AppTheme.borderColor,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),

                    // Progress fill
                    FractionallySizedBox(
                      widthFactor: _progressAnimation.value,
                      child: Container(
                        height: 1.h,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.primaryCyan,
                              AppTheme.accentGlow,
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  AppTheme.primaryCyan.withValues(alpha: 0.4),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          SizedBox(height: 2.h),

          // Progress details
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${progressPercentage.toStringAsFixed(0)}% Complete",
                      style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      widget.current == widget.total
                          ? "All permissions configured!"
                          : "${widget.total - widget.current} permissions remaining",
                      style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                        color: widget.current == widget.total
                            ? AppTheme.successGreen
                            : AppTheme.textDisabled,
                      ),
                    ),
                  ],
                ),
              ),

              // Status icon
              if (widget.current == widget.total)
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.successGreen.withValues(alpha: 0.2),
                    border: Border.all(
                      color: AppTheme.successGreen,
                      width: 2,
                    ),
                  ),
                  child: CustomIconWidget(
                    iconName: "check_circle",
                    color: AppTheme.successGreen,
                    size: 5.w,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
