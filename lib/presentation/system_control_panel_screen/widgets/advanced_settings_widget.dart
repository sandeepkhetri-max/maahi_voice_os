import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AdvancedSettingsWidget extends StatefulWidget {
  final VoidCallback? onDeveloperOptionsPressed;
  final VoidCallback? onAccessibilityPressed;
  final VoidCallback? onPrivacyPressed;

  const AdvancedSettingsWidget({
    super.key,
    this.onDeveloperOptionsPressed,
    this.onAccessibilityPressed,
    this.onPrivacyPressed,
  });

  @override
  State<AdvancedSettingsWidget> createState() => _AdvancedSettingsWidgetState();
}

class _AdvancedSettingsWidgetState extends State<AdvancedSettingsWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _expandController;
  late Animation<double> _expandAnimation;
  late Animation<double> _rotationAnimation;
  
  bool _isExpanded = false;

  final List<Map<String, dynamic>> _advancedOptions = [
    {
      "title": "Developer Options",
      "subtitle": "USB debugging, animation scale",
      "icon": "code",
      "onTap": null, // Will be set in initState
    },
    {
      "title": "Accessibility",
      "subtitle": "Voice control, screen reader",
      "icon": "accessibility",
      "onTap": null, // Will be set in initState
    },
    {
      "title": "Privacy Controls",
      "subtitle": "App permissions, data usage",
      "icon": "security",
      "onTap": null, // Will be set in initState
    },
    {
      "title": "System Information",
      "subtitle": "Device specs, build info",
      "icon": "info",
      "onTap": null,
    },
    {
      "title": "Performance Monitor",
      "subtitle": "CPU, RAM, temperature",
      "icon": "speed",
      "onTap": null,
    },
  ];

  @override
  void initState() {
    super.initState();
    
    // Set callbacks
    _advancedOptions[0]["onTap"] = widget.onDeveloperOptionsPressed;
    _advancedOptions[1]["onTap"] = widget.onAccessibilityPressed;
    _advancedOptions[2]["onTap"] = widget.onPrivacyPressed;
    
    _expandController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _expandAnimation = CurvedAnimation(
      parent: _expandController,
      curve: Curves.easeInOut,
    );

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.5,
    ).animate(CurvedAnimation(
      parent: _expandController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _expandController.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
    
    if (_isExpanded) {
      _expandController.forward();
    } else {
      _expandController.reverse();
    }
    
    HapticFeedback.mediumImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppTheme.glassCardDecoration,
      child: Column(
        children: [
          _buildHeader(),
          AnimatedBuilder(
            animation: _expandAnimation,
            builder: (context, child) {
              return ClipRect(
                child: Align(
                  alignment: Alignment.topCenter,
                  heightFactor: _expandAnimation.value,
                  child: child,
                ),
              );
            },
            child: _buildAdvancedOptionsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return GestureDetector(
      onTap: _toggleExpansion,
      child: Container(
        padding: EdgeInsets.all(4.w),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.primaryCyan.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: 'settings_applications',
                color: AppTheme.primaryCyan,
                size: 6.w,
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Advanced Settings",
                    style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    "Developer options, accessibility, and more",
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedBuilder(
              animation: _rotationAnimation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _rotationAnimation.value * 3.14159,
                  child: CustomIconWidget(
                    iconName: 'expand_more',
                    color: AppTheme.primaryCyan,
                    size: 6.w,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedOptionsList() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        children: [
          Container(
            height: 1,
            color: AppTheme.dividerColor,
            margin: EdgeInsets.only(bottom: 2.h),
          ),
          ..._advancedOptions.map((option) => _buildAdvancedOptionItem(option)).toList(),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildAdvancedOptionItem(Map<String, dynamic> option) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (option["onTap"] != null) {
              HapticFeedback.lightImpact();
              option["onTap"]();
            } else {
              _showComingSoonDialog(option["title"]);
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.borderColor.withValues(alpha: 0.5),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: AppTheme.accentGlow.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: option["icon"],
                    color: AppTheme.accentGlow,
                    size: 5.w,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        option["title"],
                        style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        option["subtitle"],
                        style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                          fontSize: 10.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                CustomIconWidget(
                  iconName: 'chevron_right',
                  color: AppTheme.textSecondary,
                  size: 5.w,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showComingSoonDialog(String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppTheme.borderColor),
        ),
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'construction',
              color: AppTheme.warningAmber,
              size: 6.w,
            ),
            SizedBox(width: 3.w),
            Text(
              "Coming Soon",
              style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
        content: Text(
          "$feature is currently under development and will be available in a future update.",
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "OK",
              style: TextStyle(color: AppTheme.primaryCyan),
            ),
          ),
        ],
      ),
    );
  }
}