import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ConversationCardWidget extends StatelessWidget {
  final Map<String, dynamic> conversation;
  final VoidCallback onTap;
  final VoidCallback onReply;
  final VoidCallback onCall;

  const ConversationCardWidget({
    super.key,
    required this.conversation,
    required this.onTap,
    required this.onReply,
    required this.onCall,
  });

  @override
  Widget build(BuildContext context) {
    final unreadCount = conversation["unreadCount"] as int;
    final isEmergency = conversation["isEmergencyContact"] as bool;
    final messageType = conversation["messageType"] as String;

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isEmergency
              ? AppTheme.errorRed.withValues(alpha: 0.3)
              : AppTheme.borderColor,
          width: isEmergency ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
          if (unreadCount > 0)
            BoxShadow(
              color: AppTheme.primaryCyan.withValues(alpha: 0.1),
              blurRadius: 16,
              spreadRadius: 2,
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                // Contact Photo with Status Indicator
                Stack(
                  children: [
                    Container(
                      width: 15.w,
                      height: 15.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isEmergency
                              ? AppTheme.errorRed
                              : AppTheme.primaryCyan,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: (isEmergency
                                    ? AppTheme.errorRed
                                    : AppTheme.primaryCyan)
                                .withValues(alpha: 0.3),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: CustomImageWidget(
                          imageUrl: conversation["contactPhoto"] as String,
                          width: 15.w,
                          height: 15.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // Message Type Indicator
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 5.w,
                        height: 5.w,
                        decoration: BoxDecoration(
                          color: messageType == "WhatsApp"
                              ? AppTheme.successGreen
                              : AppTheme.secondaryBlue,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: AppTheme.backgroundBlack, width: 2),
                        ),
                        child: CustomIconWidget(
                          iconName: messageType == "WhatsApp" ? 'chat' : 'sms',
                          color: AppTheme.textPrimary,
                          size: 3.w,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(width: 4.w),

                // Message Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              conversation["contactName"] as String,
                              style: AppTheme.darkTheme.textTheme.titleMedium
                                  ?.copyWith(
                                color: isEmergency
                                    ? AppTheme.errorRed
                                    : AppTheme.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isEmergency)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppTheme.errorRed.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: AppTheme.errorRed, width: 1),
                              ),
                              child: Text(
                                'SOS',
                                style: AppTheme.darkTheme.textTheme.labelSmall
                                    ?.copyWith(
                                  color: AppTheme.errorRed,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        conversation["lastMessage"] as String,
                        style:
                            AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                          color: unreadCount > 0
                              ? AppTheme.textPrimary
                              : AppTheme.textSecondary,
                          fontWeight: unreadCount > 0
                              ? FontWeight.w500
                              : FontWeight.w400,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 1.h),
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'access_time',
                            color: AppTheme.textSecondary,
                            size: 3.w,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            _formatTimestamp(
                                conversation["timestamp"] as DateTime),
                            style: AppTheme.darkTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          const Spacer(),
                          if (unreadCount > 0)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryCyan,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.primaryCyan
                                        .withValues(alpha: 0.3),
                                    blurRadius: 6,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: Text(
                                unreadCount.toString(),
                                style: AppTheme.darkTheme.textTheme.labelSmall
                                    ?.copyWith(
                                  color: AppTheme.backgroundBlack,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 2.w),

                // Action Buttons
                Column(
                  children: [
                    Container(
                      width: 10.w,
                      height: 10.w,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryCyan.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: AppTheme.primaryCyan, width: 1),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: onReply,
                          borderRadius: BorderRadius.circular(50),
                          child: Center(
                            child: CustomIconWidget(
                              iconName: 'reply',
                              color: AppTheme.primaryCyan,
                              size: 5.w,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Container(
                      width: 10.w,
                      height: 10.w,
                      decoration: BoxDecoration(
                        color: AppTheme.successGreen.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: AppTheme.successGreen, width: 1),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: onCall,
                          borderRadius: BorderRadius.circular(50),
                          child: Center(
                            child: CustomIconWidget(
                              iconName: 'phone',
                              color: AppTheme.successGreen,
                              size: 5.w,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
