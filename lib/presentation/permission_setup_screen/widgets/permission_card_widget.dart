import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PermissionCardWidget extends StatefulWidget {
  final Map<String, dynamic> permission;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const PermissionCardWidget({
    super.key,
    required this.permission,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  State<PermissionCardWidget> createState() => _PermissionCardWidgetState();
}

class _PermissionCardWidgetState extends State<PermissionCardWidget>
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

  void _handleTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _animationController.reverse();
  }

  void _handleTapCancel() {
    _animationController.reverse();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isGranted = widget.permission["isGranted"] ?? false;
    final bool isMandatory = widget.permission["isMandatory"] ?? false;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              widget.onTap();
            },
            onLongPress: () {
              HapticFeedback.mediumImpact();
              widget.onLongPress();
            },
            onTapDown: _handleTapDown,
            onTapUp: _handleTapUp,
            onTapCancel: _handleTapCancel,
            child: Container(
              padding: EdgeInsets.all(5.w),
              decoration: BoxDecoration(
                color: _colorAnimation.value,
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(
                  color: isGranted
                      ? AppTheme.successGreen.withValues(alpha: 0.5)
                      : isMandatory
                          ? AppTheme.primaryCyan.withValues(alpha: 0.3)
                          : AppTheme.borderColor,
                  width: isGranted ? 2 : 1,
                ),
                boxShadow: [
                  if (isGranted)
                    BoxShadow(
                      color: AppTheme.successGreen.withValues(alpha: 0.2),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  BoxShadow(
                    color: AppTheme.shadowColor,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Permission icon
                      Container(
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isGranted
                              ? AppTheme.successGreen.withValues(alpha: 0.2)
                              : AppTheme.primaryCyan.withValues(alpha: 0.1),
                          border: Border.all(
                            color: isGranted
                                ? AppTheme.successGreen
                                : AppTheme.primaryCyan,
                            width: 1,
                          ),
                        ),
                        child: CustomIconWidget(
                          iconName: widget.permission["icon"] ?? "security",
                          color: isGranted
                              ? AppTheme.successGreen
                              : AppTheme.primaryCyan,
                          size: 6.w,
                        ),
                      ),
                      SizedBox(width: 4.w),

                      // Permission details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.permission["name"] ?? "Permission",
                                    style: AppTheme
                                        .darkTheme.textTheme.titleMedium
                                        ?.copyWith(
                                      color: AppTheme.textPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                if (isMandatory)
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 2.w,
                                      vertical: 0.5.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppTheme.warningAmber
                                          .withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(8.0),
                                      border: Border.all(
                                        color: AppTheme.warningAmber
                                            .withValues(alpha: 0.5),
                                      ),
                                    ),
                                    child: Text(
                                      "Required",
                                      style: AppTheme
                                          .darkTheme.textTheme.labelSmall
                                          ?.copyWith(
                                        color: AppTheme.warningAmber,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              widget.permission["purpose"] ??
                                  "Permission purpose",
                              style: AppTheme.darkTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.textSecondary,
                                height: 1.4,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),

                      // Status indicator
                      Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isGranted
                              ? AppTheme.successGreen.withValues(alpha: 0.2)
                              : AppTheme.borderColor.withValues(alpha: 0.3),
                        ),
                        child: CustomIconWidget(
                          iconName: isGranted ? "check" : "close",
                          color: isGranted
                              ? AppTheme.successGreen
                              : AppTheme.textDisabled,
                          size: 4.w,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 3.h),

                  // Action button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: widget.onTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isGranted
                            ? AppTheme.successGreen
                            : AppTheme.primaryCyan,
                        foregroundColor: AppTheme.backgroundBlack,
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        elevation: isGranted ? 2 : 4,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: isGranted ? "verified" : "security",
                            color: AppTheme.backgroundBlack,
                            size: 4.w,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            isGranted
                                ? "Permission Granted"
                                : "Grant Permission",
                            style: AppTheme.darkTheme.textTheme.labelLarge
                                ?.copyWith(
                              color: AppTheme.backgroundBlack,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Long press hint
                  SizedBox(height: 2.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: "info_outline",
                        color: AppTheme.textDisabled,
                        size: 3.w,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        "Long press for technical details",
                        style:
                            AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.textDisabled,
                          fontSize: 10.sp,
                        ),
                      ),
                    ],
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
