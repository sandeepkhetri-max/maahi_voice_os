import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SettingItemWidget extends StatefulWidget {
  final Map<String, dynamic> setting;
  final String categoryName;
  final bool isLast;
  final Function(dynamic) onChanged;
  final VoidCallback onActionTap;

  const SettingItemWidget({
    super.key,
    required this.setting,
    required this.categoryName,
    required this.isLast,
    required this.onChanged,
    required this.onActionTap,
  });

  @override
  State<SettingItemWidget> createState() => _SettingItemWidgetState();
}

class _SettingItemWidgetState extends State<SettingItemWidget> {
  void _showVoiceCommandHelp() {
    final String voiceCommand = widget.setting['voiceCommand'] ?? '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.surfaceDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
            side: BorderSide(color: AppTheme.borderColor),
          ),
          title: Row(
            children: [
              CustomIconWidget(
                iconName: 'mic',
                color: AppTheme.primaryCyan,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Voice Command',
                style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.primaryCyan,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Setting: ${widget.setting['title']}',
                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Voice Command Example:',
                style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
              SizedBox(height: 1.h),
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.backgroundBlack,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: AppTheme.primaryCyan.withValues(alpha: 0.3)),
                ),
                child: Text(
                  '"Hey Maahi, $voiceCommand"',
                  style: AppTheme.dataDisplayStyle.copyWith(
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Got it',
                style: TextStyle(color: AppTheme.primaryCyan),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSettingControl() {
    final String type = widget.setting['type'] ?? '';
    final dynamic value = widget.setting['value'];

    switch (type) {
      case 'toggle':
        return Switch(
          value: value ?? false,
          onChanged: (newValue) {
            HapticFeedback.lightImpact();
            widget.onChanged(newValue);
          },
          activeColor: AppTheme.primaryCyan,
          activeTrackColor: AppTheme.primaryCyan.withValues(alpha: 0.3),
          inactiveThumbColor: AppTheme.textSecondary,
          inactiveTrackColor: AppTheme.borderColor,
        );

      case 'slider':
        return SizedBox(
          width: 30.w,
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppTheme.primaryCyan,
              thumbColor: AppTheme.primaryCyan,
              overlayColor: AppTheme.primaryCyan.withValues(alpha: 0.2),
              inactiveTrackColor: AppTheme.borderColor,
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            ),
            child: Slider(
              value: (value ?? 0.0).toDouble(),
              min: 0.0,
              max: 1.0,
              divisions: 10,
              onChanged: (newValue) {
                HapticFeedback.selectionClick();
                widget.onChanged(newValue);
              },
            ),
          ),
        );

      case 'dropdown':
        final List<String> options =
            (widget.setting['options'] as List?)?.cast<String>() ?? [];
        return DropdownButton<String>(
          value: value?.toString(),
          dropdownColor: AppTheme.surfaceDark,
          style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.textPrimary,
          ),
          underline: Container(
            height: 1,
            color: AppTheme.primaryCyan,
          ),
          items: options.map((String option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(
                option,
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 10.sp,
                ),
              ),
            );
          }).toList(),
          onChanged: (newValue) {
            if (newValue != null) {
              HapticFeedback.selectionClick();
              widget.onChanged(newValue);
            }
          },
        );

      case 'action':
        return ElevatedButton(
          onPressed: () {
            HapticFeedback.mediumImpact();
            widget.onActionTap();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryCyan.withValues(alpha: 0.2),
            foregroundColor: AppTheme.primaryCyan,
            elevation: 0,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: AppTheme.primaryCyan),
            ),
          ),
          child: Text(
            'Execute',
            style: TextStyle(fontSize: 10.sp),
          ),
        );

      case 'indicator':
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: (value == true)
                ? AppTheme.successGreen.withValues(alpha: 0.2)
                : AppTheme.errorRed.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color:
                  (value == true) ? AppTheme.successGreen : AppTheme.errorRed,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (value == true)
                      ? AppTheme.successGreen
                      : AppTheme.errorRed,
                ),
              ),
              SizedBox(width: 2.w),
              Text(
                (value == true) ? 'Active' : 'Inactive',
                style: TextStyle(
                  color: (value == true)
                      ? AppTheme.successGreen
                      : AppTheme.errorRed,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );

      case 'info':
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: AppTheme.accentGlow.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.accentGlow),
          ),
          child: Text(
            value?.toString() ?? 'N/A',
            style: TextStyle(
              color: AppTheme.accentGlow,
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final String title = widget.setting['title'] ?? '';
    final String subtitle = widget.setting['subtitle'] ?? '';

    return InkWell(
      onLongPress: _showVoiceCommandHelp,
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          border: widget.isLast
              ? null
              : Border(
                  bottom: BorderSide(
                    color: AppTheme.dividerColor,
                    width: 0.5,
                  ),
                ),
        ),
        child: Row(
          children: [
            // Setting Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (subtitle.isNotEmpty) ...[
                    SizedBox(height: 0.5.h),
                    Text(
                      subtitle,
                      style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            SizedBox(width: 4.w),

            // Setting Control
            _buildSettingControl(),
          ],
        ),
      ),
    );
  }
}
