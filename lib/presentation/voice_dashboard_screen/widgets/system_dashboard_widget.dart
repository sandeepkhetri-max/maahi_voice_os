import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SystemDashboardWidget extends StatelessWidget {
  final Map<String, dynamic> systemData;
  final VoidCallback onClose;

  const SystemDashboardWidget({
    super.key,
    required this.systemData,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppTheme.overlayColor,
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(4.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'System Dashboard',
                    style: AppTheme.darkTheme.textTheme.headlineSmall,
                  ),
                  GestureDetector(
                    onTap: onClose,
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceDark,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CustomIconWidget(
                        iconName: 'close',
                        color: AppTheme.textPrimary,
                        size: 5.w,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Dashboard content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  children: [
                    // Performance metrics
                    _buildMetricsGrid(),

                    SizedBox(height: 3.h),

                    // Storage info
                    _buildStorageCard(),

                    SizedBox(height: 3.h),

                    // Active apps
                    _buildActiveAppsCard(),

                    SizedBox(height: 3.h),

                    // System info
                    _buildSystemInfoCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 3.w,
      mainAxisSpacing: 2.h,
      childAspectRatio: 1.5,
      children: [
        _buildMetricCard(
          'CPU Temp',
          '${systemData["cpuTemperature"]}°C',
          'thermostat',
          _getTempColor(systemData["cpuTemperature"]),
        ),
        _buildMetricCard(
          'RAM Usage',
          '${systemData["ramUsage"]}%',
          'memory',
          _getRAMColor(systemData["ramUsage"]),
        ),
        _buildMetricCard(
          'Battery',
          '${systemData["batteryLevel"]}%',
          systemData["isCharging"] ? 'battery_charging_full' : 'battery_std',
          _getBatteryColor(systemData["batteryLevel"]),
        ),
        _buildMetricCard(
          'Active Apps',
          '${systemData["activeApps"]}',
          'apps',
          AppTheme.primaryCyan,
        ),
      ],
    );
  }

  Widget _buildMetricCard(
      String label, String value, String iconName, Color color) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: AppTheme.glassCardDecoration,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: color,
            size: 6.w,
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: AppTheme.dataDisplayStyle.copyWith(
              color: color,
              fontSize: 16.sp,
            ),
          ),
          Text(
            label,
            style: AppTheme.darkTheme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStorageCard() {
    final double usedGB = systemData["storageUsed"];
    final double totalGB = systemData["storageTotal"];
    final double usagePercentage = (usedGB / totalGB) * 100;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: AppTheme.glassCardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'storage',
                color: AppTheme.primaryCyan,
                size: 5.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'Storage',
                style: AppTheme.darkTheme.textTheme.titleMedium,
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Storage bar
          Container(
            height: 1.h,
            decoration: BoxDecoration(
              color: AppTheme.borderColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: usagePercentage / 100,
              child: Container(
                decoration: BoxDecoration(
                  color: _getStorageColor(usagePercentage),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),

          SizedBox(height: 1.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${usedGB.toStringAsFixed(1)} GB used',
                style: AppTheme.darkTheme.textTheme.bodySmall,
              ),
              Text(
                '${totalGB.toStringAsFixed(0)} GB total',
                style: AppTheme.darkTheme.textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActiveAppsCard() {
    final List<String> activeApps = [
      'WhatsApp',
      'Chrome',
      'Spotify',
      'Instagram',
      'Gmail',
      'Maps'
    ];

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: AppTheme.glassCardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'apps',
                color: AppTheme.primaryCyan,
                size: 5.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'Active Apps',
                style: AppTheme.darkTheme.textTheme.titleMedium,
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: activeApps
                .map((app) => Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryCyan.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppTheme.primaryCyan.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        app,
                        style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.primaryCyan,
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemInfoCard() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: AppTheme.glassCardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'info',
                color: AppTheme.primaryCyan,
                size: 5.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'System Information',
                style: AppTheme.darkTheme.textTheme.titleMedium,
              ),
            ],
          ),
          SizedBox(height: 2.h),
          _buildInfoRow('Network', systemData["networkStatus"]),
          _buildInfoRow('Uptime', '23h 45m'),
          _buildInfoRow('MAAHI Version', '1.0.0'),
          _buildInfoRow('Android Version', '13'),
          _buildInfoRow('Security Patch', 'December 2024'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTheme.darkTheme.textTheme.bodyMedium,
          ),
          Text(
            value,
            style: AppTheme.systemMetricsStyle,
          ),
        ],
      ),
    );
  }

  Color _getTempColor(int temp) {
    if (temp < 45) return AppTheme.successGreen;
    if (temp < 60) return AppTheme.warningAmber;
    return AppTheme.errorRed;
  }

  Color _getRAMColor(int usage) {
    if (usage < 70) return AppTheme.successGreen;
    if (usage < 85) return AppTheme.warningAmber;
    return AppTheme.errorRed;
  }

  Color _getBatteryColor(int level) {
    if (level > 50) return AppTheme.successGreen;
    if (level > 20) return AppTheme.warningAmber;
    return AppTheme.errorRed;
  }

  Color _getStorageColor(double usage) {
    if (usage < 70) return AppTheme.successGreen;
    if (usage < 85) return AppTheme.warningAmber;
    return AppTheme.errorRed;
  }
}
