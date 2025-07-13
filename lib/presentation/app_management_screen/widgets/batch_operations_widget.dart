import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BatchOperationsWidget extends StatefulWidget {
  final List<String> selectedApps;
  final List<Map<String, dynamic>> apps;
  final VoidCallback onOperationComplete;

  const BatchOperationsWidget({
    super.key,
    required this.selectedApps,
    required this.apps,
    required this.onOperationComplete,
  });

  @override
  State<BatchOperationsWidget> createState() => _BatchOperationsWidgetState();
}

class _BatchOperationsWidgetState extends State<BatchOperationsWidget> {
  bool _isProcessing = false;
  String _currentOperation = '';

  List<Map<String, dynamic>> get _selectedAppData {
    return widget.apps
        .where((app) => widget.selectedApps.contains(app['id']))
        .toList();
  }

  Future<void> _performBatchOperation(String operation) async {
    setState(() {
      _isProcessing = true;
      _currentOperation = operation;
    });

    // Simulate operation delay
    await Future.delayed(const Duration(seconds: 2));

    switch (operation) {
      case 'freeze_all':
        for (var appId in widget.selectedApps) {
          final app = widget.apps.firstWhere((a) => a['id'] == appId);
          app['status'] = 'frozen';
        }
        break;
      case 'unfreeze_all':
        for (var appId in widget.selectedApps) {
          final app = widget.apps.firstWhere((a) => a['id'] == appId);
          app['status'] = 'recently_used';
        }
        break;
      case 'force_stop_all':
        for (var appId in widget.selectedApps) {
          final app = widget.apps.firstWhere((a) => a['id'] == appId);
          app['status'] = 'frozen';
        }
        break;
      case 'uninstall_all':
        widget.apps
            .removeWhere((app) => widget.selectedApps.contains(app['id']));
        break;
    }

    setState(() {
      _isProcessing = false;
      _currentOperation = '';
    });

    if (mounted) {
      Navigator.pop(context);
      widget.onOperationComplete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Batch operation completed for ${widget.selectedApps.length} apps'),
          backgroundColor: AppTheme.successGreen,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            width: 10.w,
            height: 0.5.h,
            margin: EdgeInsets.symmetric(vertical: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.borderColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'build',
                  color: AppTheme.primaryCyan,
                  size: 6.w,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    'Batch Operations',
                    style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.textSecondary,
                    size: 5.w,
                  ),
                ),
              ],
            ),
          ),

          Divider(color: AppTheme.borderColor),

          // Selected apps preview
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.selectedApps.length} Apps Selected',
                  style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.textPrimary,
                  ),
                ),
                SizedBox(height: 2.h),
                SizedBox(
                  height: 12.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _selectedAppData.length,
                    separatorBuilder: (context, index) => SizedBox(width: 2.w),
                    itemBuilder: (context, index) {
                      final app = _selectedAppData[index];
                      return Column(
                        children: [
                          Container(
                            width: 12.w,
                            height: 12.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppTheme.primaryCyan,
                                width: 2,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: CustomImageWidget(
                                imageUrl: app['icon'] as String,
                                width: 12.w,
                                height: 12.w,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          SizedBox(height: 1.h),
                          SizedBox(
                            width: 15.w,
                            child: Text(
                              app['name'] as String,
                              style: AppTheme.darkTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: AppTheme.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          Divider(color: AppTheme.borderColor),

          // Operations
          Expanded(
            child:
                _isProcessing ? _buildProcessingView() : _buildOperationsView(),
          ),
        ],
      ),
    );
  }

  Widget _buildProcessingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 15.w,
            height: 15.w,
            child: CircularProgressIndicator(
              color: AppTheme.primaryCyan,
              strokeWidth: 3,
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            'Processing $_currentOperation...',
            style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Please wait while we perform the operation',
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildOperationsView() {
    return ListView(
      padding: EdgeInsets.all(4.w),
      children: [
        _buildOperationTile(
          icon: 'pause',
          title: 'Freeze All Apps',
          subtitle: 'Stop all selected apps from running',
          color: AppTheme.warningAmber,
          onTap: () => _performBatchOperation('freeze_all'),
        ),
        SizedBox(height: 2.h),
        _buildOperationTile(
          icon: 'play_arrow',
          title: 'Unfreeze All Apps',
          subtitle: 'Allow all selected apps to run normally',
          color: AppTheme.successGreen,
          onTap: () => _performBatchOperation('unfreeze_all'),
        ),
        SizedBox(height: 2.h),
        _buildOperationTile(
          icon: 'stop',
          title: 'Force Stop All',
          subtitle: 'Immediately stop all selected apps',
          color: AppTheme.errorRed,
          onTap: () => _performBatchOperation('force_stop_all'),
        ),
        SizedBox(height: 2.h),
        _buildOperationTile(
          icon: 'delete_forever',
          title: 'Uninstall All Apps',
          subtitle: 'Permanently remove all selected apps',
          color: AppTheme.errorRed,
          isDestructive: true,
          onTap: () => _showUninstallConfirmation(),
        ),
        SizedBox(height: 2.h),
        _buildOperationTile(
          icon: 'info',
          title: 'Show Apps Info',
          subtitle: 'View detailed information for selected apps',
          color: AppTheme.primaryCyan,
          onTap: () => _showAppsInfo(),
        ),
      ],
    );
  }

  Widget _buildOperationTile({
    required String icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundBlack,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDestructive
              ? AppTheme.errorRed.withValues(alpha: 0.3)
              : AppTheme.borderColor,
          width: 1,
        ),
      ),
      child: ListTile(
        leading: Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color, width: 1),
          ),
          child: CustomIconWidget(
            iconName: icon,
            color: color,
            size: 6.w,
          ),
        ),
        title: Text(
          title,
          style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
            color: isDestructive ? AppTheme.errorRed : AppTheme.textPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        trailing: CustomIconWidget(
          iconName: 'arrow_forward_ios',
          color: AppTheme.textSecondary,
          size: 4.w,
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _showUninstallConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Batch Uninstall'),
        content: Text(
          'Are you sure you want to uninstall ${widget.selectedApps.length} apps? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _performBatchOperation('uninstall_all');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorRed,
            ),
            child: const Text('Uninstall All'),
          ),
        ],
      ),
    );
  }

  void _showAppsInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Selected Apps Information'),
        content: SizedBox(
          width: 80.w,
          height: 40.h,
          child: ListView.separated(
            itemCount: _selectedAppData.length,
            separatorBuilder: (context, index) =>
                Divider(color: AppTheme.borderColor),
            itemBuilder: (context, index) {
              final app = _selectedAppData[index];
              return ListTile(
                leading: CustomImageWidget(
                  imageUrl: app['icon'] as String,
                  width: 10.w,
                  height: 10.w,
                  fit: BoxFit.contain,
                ),
                title: Text(
                  app['name'] as String,
                  style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                    color: AppTheme.textPrimary,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Size: ${app['size']}'),
                    Text('Category: ${app['category']}'),
                    Text('Status: ${app['status']}'),
                  ],
                ),
                isThreeLine: true,
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
