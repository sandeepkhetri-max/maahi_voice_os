import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MessageBubbleWidget extends StatelessWidget {
  final Map<String, dynamic> message;
  final bool isOutgoing;

  const MessageBubbleWidget({
    super.key,
    required this.message,
    required this.isOutgoing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 4.w),
      child: Row(
        mainAxisAlignment:
            isOutgoing ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isOutgoing) ...[
            CircleAvatar(
              radius: 4.w,
              backgroundImage:
                  NetworkImage(message["senderPhoto"] as String? ?? ""),
              backgroundColor: AppTheme.primaryCyan.withValues(alpha: 0.2),
            ),
            SizedBox(width: 2.w),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(maxWidth: 70.w),
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: isOutgoing
                    ? AppTheme.primaryCyan.withValues(alpha: 0.2)
                    : AppTheme.surfaceDark,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isOutgoing ? 16 : 4),
                  bottomRight: Radius.circular(isOutgoing ? 4 : 16),
                ),
                border: Border.all(
                  color: isOutgoing
                      ? AppTheme.primaryCyan.withValues(alpha: 0.5)
                      : AppTheme.borderColor,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.shadowColor,
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                  if (isOutgoing)
                    BoxShadow(
                      color: AppTheme.primaryCyan.withValues(alpha: 0.1),
                      blurRadius: 12,
                      spreadRadius: 1,
                    ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isOutgoing && message["senderName"] != null)
                    Padding(
                      padding: EdgeInsets.only(bottom: 1.h),
                      child: Text(
                        message["senderName"] as String,
                        style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.primaryCyan,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  Text(
                    message["content"] as String,
                    style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textPrimary,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatTimestamp(message["timestamp"] as DateTime),
                        style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                          fontSize: 10.sp,
                        ),
                      ),
                      if (isOutgoing) ...[
                        SizedBox(width: 1.w),
                        CustomIconWidget(
                          iconName: _getMessageStatusIcon(
                              message["status"] as String? ?? "sent"),
                          color: _getMessageStatusColor(
                              message["status"] as String? ?? "sent"),
                          size: 3.w,
                        ),
                      ],
                      if (message["messageType"] != null) ...[
                        SizedBox(width: 1.w),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getMessageTypeColor(
                                    message["messageType"] as String)
                                .withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            message["messageType"] as String,
                            style: AppTheme.darkTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: _getMessageTypeColor(
                                  message["messageType"] as String),
                              fontSize: 8.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (isOutgoing) ...[
            SizedBox(width: 2.w),
            CircleAvatar(
              radius: 4.w,
              backgroundColor: AppTheme.primaryCyan.withValues(alpha: 0.2),
              child: CustomIconWidget(
                iconName: 'person',
                color: AppTheme.primaryCyan,
                size: 4.w,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else {
      return '${difference.inDays}d';
    }
  }

  String _getMessageStatusIcon(String status) {
    switch (status) {
      case 'sent':
        return 'check';
      case 'delivered':
        return 'done_all';
      case 'read':
        return 'done_all';
      case 'failed':
        return 'error';
      default:
        return 'schedule';
    }
  }

  Color _getMessageStatusColor(String status) {
    switch (status) {
      case 'sent':
        return AppTheme.textSecondary;
      case 'delivered':
        return AppTheme.primaryCyan;
      case 'read':
        return AppTheme.successGreen;
      case 'failed':
        return AppTheme.errorRed;
      default:
        return AppTheme.textSecondary;
    }
  }

  Color _getMessageTypeColor(String messageType) {
    switch (messageType) {
      case 'WhatsApp':
        return AppTheme.successGreen;
      case 'SMS':
        return AppTheme.secondaryBlue;
      case 'Telegram':
        return AppTheme.primaryCyan;
      default:
        return AppTheme.textSecondary;
    }
  }
}
