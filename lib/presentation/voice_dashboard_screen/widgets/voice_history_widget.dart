import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class VoiceHistoryWidget extends StatefulWidget {
  final List<Map<String, dynamic>> voiceHistory;
  final bool isVisible;

  const VoiceHistoryWidget({
    super.key,
    required this.voiceHistory,
    required this.isVisible,
  });

  @override
  State<VoiceHistoryWidget> createState() => _VoiceHistoryWidgetState();
}

class _VoiceHistoryWidgetState extends State<VoiceHistoryWidget>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(VoiceHistoryWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible != oldWidget.isVisible) {
      widget.isVisible ? _fadeController.forward() : _fadeController.reverse();
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible || widget.voiceHistory.isEmpty) {
      return const SizedBox.shrink();
    }

    return Positioned(
      top: 15.h,
      right: 4.w,
      child: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: Transform.translate(
              offset: Offset(50 * (1 - _fadeAnimation.value), 0),
              child: Container(
                width: 70.w,
                constraints: BoxConstraints(maxHeight: 40.h),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: widget.voiceHistory
                        .take(3)
                        .map((command) => _buildHistoryBubble(command))
                        .toList(),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHistoryBubble(Map<String, dynamic> command) {
    final DateTime timestamp = command["timestamp"];
    final String status = command["status"];
    final String commandText = command["command"];
    final String response = command["response"];

    final Color statusColor = status == "completed"
        ? AppTheme.successGreen
        : status == "failed"
            ? AppTheme.errorRed
            : AppTheme.warningAmber;

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Command bubble
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark.withValues(alpha: 0.9),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(4),
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              border: Border.all(
                color: AppTheme.primaryCyan.withValues(alpha: 0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.shadowColor,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Command text
                Text(
                  commandText,
                  style: AppTheme.commandHistoryStyle.copyWith(
                    color: AppTheme.textPrimary,
                  ),
                ),

                SizedBox(height: 1.h),

                // Response text
                Text(
                  response,
                  style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                    color: statusColor,
                    fontStyle: FontStyle.italic,
                  ),
                ),

                SizedBox(height: 1.h),

                // Status and timestamp
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 2.w,
                          height: 2.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: statusColor,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          status.toUpperCase(),
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 8.sp,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      _formatTimestamp(timestamp),
                      style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                        fontSize: 8.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final Duration difference = DateTime.now().difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
