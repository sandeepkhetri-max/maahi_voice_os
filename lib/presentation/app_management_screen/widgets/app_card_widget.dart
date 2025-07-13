import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AppCardWidget extends StatelessWidget {
  final Map<String, dynamic> app;
  final bool isSelected;
  final bool isBatchMode;
  final bool isSystemApp;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onSwipeRight;
  final VoidCallback onSwipeLeft;

  const AppCardWidget({
    super.key,
    required this.app,
    required this.isSelected,
    required this.isBatchMode,
    this.isSystemApp = false,
    required this.onTap,
    required this.onLongPress,
    required this.onSwipeRight,
    required this.onSwipeLeft,
  });

  Color _getStatusColor() {
    switch (app['status'] as String) {
      case 'running':
        return AppTheme.successGreen;
      case 'frozen':
        return AppTheme.errorRed;
      case 'recently_used':
        return AppTheme.warningAmber;
      default:
        return AppTheme.textSecondary;
    }
  }

  String _getStatusText() {
    switch (app['status'] as String) {
      case 'running':
        return 'Running';
      case 'frozen':
        return 'Frozen';
      case 'recently_used':
        return 'Recent';
      default:
        return 'Idle';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Dismissible(
        key: Key(app['id'] as String),
        background: Container(
          decoration: BoxDecoration(
            color: AppTheme.successGreen.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.successGreen,
              width: 1,
            ),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 4.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'launch',
                    color: AppTheme.successGreen,
                    size: 6.w,
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    'Launch',
                    style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.successGreen,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        secondaryBackground: isSystemApp
            ? null
            : Container(
                decoration: BoxDecoration(
                  color: AppTheme.errorRed.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.errorRed,
                    width: 1,
                  ),
                ),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 4.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'delete',
                          color: AppTheme.errorRed,
                          size: 6.w,
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          'Uninstall',
                          style:
                              AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                            color: AppTheme.errorRed,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        onDismissed: (direction) {
          if (direction == DismissDirection.startToEnd) {
            onSwipeRight();
          } else if (direction == DismissDirection.endToStart && !isSystemApp) {
            onSwipeLeft();
          }
        },
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.endToStart && !isSystemApp) {
            return await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Uninstall ${app['name']}?'),
                content: const Text('This action cannot be undone.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.errorRed,
                    ),
                    child: const Text('Uninstall'),
                  ),
                ],
              ),
            );
          }
          return false;
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.primaryCyan.withValues(alpha: 0.1)
                : AppTheme.surfaceDark,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? AppTheme.primaryCyan
                  : isSystemApp
                      ? AppTheme.warningAmber.withValues(alpha: 0.3)
                      : AppTheme.borderColor,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: AppTheme.primaryCyan.withValues(alpha: 0.2),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(3.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Selection indicator
                if (isBatchMode)
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      width: 5.w,
                      height: 5.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected
                            ? AppTheme.primaryCyan
                            : Colors.transparent,
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.primaryCyan
                              : AppTheme.borderColor,
                          width: 2,
                        ),
                      ),
                      child: isSelected
                          ? CustomIconWidget(
                              iconName: 'check',
                              color: AppTheme.backgroundBlack,
                              size: 3.w,
                            )
                          : null,
                    ),
                  ),

                // App icon
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.shadowColor,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CustomImageWidget(
                      imageUrl: app['icon'] as String,
                      width: 12.w,
                      height: 12.w,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                SizedBox(height: 1.h),

                // App name
                Text(
                  app['name'] as String,
                  style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: 0.5.h),

                // Status indicator
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 2.w,
                    vertical: 0.5.h,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor().withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _getStatusColor(),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    _getStatusText(),
                    style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                      color: _getStatusColor(),
                      fontSize: 8.sp,
                    ),
                  ),
                ),

                // System app indicator
                if (isSystemApp) ...[
                  SizedBox(height: 0.5.h),
                  CustomIconWidget(
                    iconName: 'security',
                    color: AppTheme.warningAmber,
                    size: 3.w,
                  ),
                ],

                // Additional info for non-batch mode
                if (!isBatchMode && !isSystemApp) ...[
                  SizedBox(height: 0.5.h),
                  Text(
                    app['size'] as String,
                    style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.textSecondary,
                      fontSize: 7.sp,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
