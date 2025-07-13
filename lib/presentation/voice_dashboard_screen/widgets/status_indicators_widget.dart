import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class StatusIndicatorsWidget extends StatelessWidget {
  final bool isListening;
  final int batteryLevel;
  final int ramUsage;
  final String networkStatus;
  final bool isOfflineMode;
  final bool isCharging;

  const StatusIndicatorsWidget({
    super.key,
    required this.isListening,
    required this.batteryLevel,
    required this.ramUsage,
    required this.networkStatus,
    required this.isOfflineMode,
    required this.isCharging,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: AppTheme.glassCardDecoration,
      child: Column(
        children: [
          // Top row - Battery and RAM
          Row(
            children: [
              Expanded(
                child: _buildStatusCard(
                  'Battery',
                  '$batteryLevel%',
                  isCharging ? 'battery_charging_full' : 'battery_std',
                  _getBatteryColor(batteryLevel),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildStatusCard(
                  'RAM',
                  '$ramUsage%',
                  'memory',
                  _getRAMColor(ramUsage),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Bottom row - Network and Mode
          Row(
            children: [
              Expanded(
                child: _buildStatusCard(
                  'Network',
                  isOfflineMode ? 'Offline' : networkStatus,
                  isOfflineMode ? 'wifi_off' : 'wifi',
                  isOfflineMode ? AppTheme.warningAmber : AppTheme.successGreen,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildStatusCard(
                  'Voice',
                  isListening ? 'Active' : 'Inactive',
                  isListening ? 'mic' : 'mic_off',
                  isListening ? AppTheme.successGreen : AppTheme.warningAmber,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(
      String label, String value, String iconName, Color color) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: AppTheme.darkTheme.textTheme.bodySmall,
              ),
              CustomIconWidget(
                iconName: iconName,
                color: color,
                size: 4.w,
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: AppTheme.dataDisplayStyle.copyWith(
                color: color,
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getBatteryColor(int level) {
    if (level > 50) return AppTheme.successGreen;
    if (level > 20) return AppTheme.warningAmber;
    return AppTheme.errorRed;
  }

  Color _getRAMColor(int usage) {
    if (usage < 70) return AppTheme.successGreen;
    if (usage < 85) return AppTheme.warningAmber;
    return AppTheme.errorRed;
  }
}
