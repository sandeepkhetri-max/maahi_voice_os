import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './setting_item_widget.dart';

class SettingsCategoryWidget extends StatefulWidget {
  final Map<String, dynamic> categoryData;
  final VoidCallback onToggle;
  final Function(String, String, dynamic) onSettingChanged;
  final Function(String) onActionTap;

  const SettingsCategoryWidget({
    super.key,
    required this.categoryData,
    required this.onToggle,
    required this.onSettingChanged,
    required this.onActionTap,
  });

  @override
  State<SettingsCategoryWidget> createState() => _SettingsCategoryWidgetState();
}

class _SettingsCategoryWidgetState extends State<SettingsCategoryWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _expandController;
  late Animation<double> _expandAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _expandController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _expandAnimation = CurvedAnimation(
      parent: _expandController,
      curve: Curves.easeInOut,
    );

    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _expandController,
      curve: Curves.easeInOut,
    ));

    if (widget.categoryData['expanded'] == true) {
      _expandController.forward();
    }
  }

  @override
  void didUpdateWidget(SettingsCategoryWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.categoryData['expanded'] != oldWidget.categoryData['expanded']) {
      if (widget.categoryData['expanded'] == true) {
        _expandController.forward();
      } else {
        _expandController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _expandController.dispose();
    super.dispose();
  }

  void _onCategoryTap() {
    HapticFeedback.lightImpact();
    widget.onToggle();
  }

  @override
  Widget build(BuildContext context) {
    final bool isExpanded = widget.categoryData['expanded'] ?? false;
    final String categoryName = widget.categoryData['category'] ?? '';
    final String iconName = widget.categoryData['icon'] ?? 'settings';
    final List<dynamic> settings = widget.categoryData['settings'] ?? [];

    return Container(
      margin: EdgeInsets.only(bottom: 3.h),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isExpanded
              ? AppTheme.primaryCyan.withValues(alpha: 0.3)
              : AppTheme.borderColor,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
          if (isExpanded)
            BoxShadow(
              color: AppTheme.primaryCyan.withValues(alpha: 0.1),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
        ],
      ),
      child: Column(
        children: [
          // Category Header
          InkWell(
            onTap: _onCategoryTap,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  // Category Icon with Glow Effect
                  AnimatedBuilder(
                    animation: _glowAnimation,
                    builder: (context, child) {
                      return Container(
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.primaryCyan.withValues(alpha: 0.1),
                          border: Border.all(
                            color: AppTheme.primaryCyan
                                .withValues(alpha: _glowAnimation.value),
                            width: 1,
                          ),
                          boxShadow: isExpanded
                              ? [
                                  BoxShadow(
                                    color: AppTheme.primaryCyan
                                        .withValues(alpha: 0.2),
                                    blurRadius: 12,
                                    spreadRadius: 2,
                                  ),
                                ]
                              : null,
                        ),
                        child: CustomIconWidget(
                          iconName: iconName,
                          color: AppTheme.primaryCyan
                              .withValues(alpha: _glowAnimation.value),
                          size: 24,
                        ),
                      );
                    },
                  ),

                  SizedBox(width: 4.w),

                  // Category Title and Subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          categoryName,
                          style: AppTheme.darkTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          '${settings.length} settings available',
                          style:
                              AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Expand/Collapse Icon
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: CustomIconWidget(
                      iconName: 'keyboard_arrow_down',
                      color: AppTheme.primaryCyan,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Settings List
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: AppTheme.borderColor,
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                children: settings.asMap().entries.map((entry) {
                  final int index = entry.key;
                  final Map<String, dynamic> setting = entry.value;

                  return SettingItemWidget(
                    setting: setting,
                    categoryName: categoryName,
                    isLast: index == settings.length - 1,
                    onChanged: (value) {
                      widget.onSettingChanged(
                        categoryName,
                        setting['title'] ?? '',
                        value,
                      );
                    },
                    onActionTap: () {
                      widget.onActionTap(setting['title'] ?? '');
                    },
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
