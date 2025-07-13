import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickActionCardsWidget extends StatelessWidget {
  final VoidCallback onAppLauncher;
  final VoidCallback onSystemSettings;
  final VoidCallback onVoiceMacros;
  final VoidCallback onEmergencyMode;

  const QuickActionCardsWidget({
    super.key,
    required this.onAppLauncher,
    required this.onSystemSettings,
    required this.onVoiceMacros,
    required this.onEmergencyMode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.primaryCyan,
          ),
        ),
        SizedBox(height: 2.h),

        // First row
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                'App Launcher',
                'Launch any app by voice',
                'apps',
                AppTheme.primaryCyan,
                onAppLauncher,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: _buildActionCard(
                'System Settings',
                'Control device settings',
                'settings',
                AppTheme.accentGlow,
                onSystemSettings,
              ),
            ),
          ],
        ),

        SizedBox(height: 2.h),

        // Second row
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                'Voice Macros',
                'Custom voice commands',
                'record_voice_over',
                AppTheme.successGreen,
                onVoiceMacros,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: _buildActionCard(
                'Emergency Mode',
                'Quick emergency actions',
                'emergency',
                AppTheme.errorRed,
                onEmergencyMode,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
    String title,
    String subtitle,
    String iconName,
    Color accentColor,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.surfaceDark.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: accentColor.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: accentColor.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: iconName,
                    color: accentColor,
                    size: 5.w,
                  ),
                ),
                CustomIconWidget(
                  iconName: 'chevron_right',
                  color: AppTheme.textSecondary,
                  size: 4.w,
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Text(
              title,
              style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                color: accentColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 0.5.h),
            Text(
              subtitle,
              style: AppTheme.darkTheme.textTheme.bodySmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
