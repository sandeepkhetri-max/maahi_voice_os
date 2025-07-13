import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmergencyContactWidget extends StatelessWidget {
  final Map<String, dynamic> contact;
  final VoidCallback onCall;

  const EmergencyContactWidget({
    super.key,
    required this.contact,
    required this.onCall,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.errorRed.withValues(alpha: 0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.errorRed.withValues(alpha: 0.1),
            blurRadius: 12,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: AppTheme.shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onCall,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                // Emergency Icon with Pulsing Animation
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 15.w,
                      height: 15.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.errorRed.withValues(alpha: 0.2),
                        border: Border.all(
                          color: AppTheme.errorRed,
                          width: 2,
                        ),
                      ),
                      child: ClipOval(
                        child: CustomImageWidget(
                          imageUrl: contact["photo"] as String,
                          width: 15.w,
                          height: 15.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 6.w,
                        height: 6.w,
                        decoration: BoxDecoration(
                          color: AppTheme.errorRed,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: AppTheme.backgroundBlack, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.errorRed.withValues(alpha: 0.5),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: CustomIconWidget(
                          iconName: 'emergency',
                          color: AppTheme.textPrimary,
                          size: 3.w,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(width: 4.w),

                // Contact Information
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              contact["name"] as String,
                              style: AppTheme.darkTheme.textTheme.titleMedium
                                  ?.copyWith(
                                color: AppTheme.errorRed,
                                fontWeight: FontWeight.w700,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.errorRed.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: AppTheme.errorRed, width: 1),
                            ),
                            child: Text(
                              'EMERGENCY',
                              style: AppTheme.darkTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: AppTheme.errorRed,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        contact["relationship"] as String,
                        style:
                            AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'phone',
                            color: AppTheme.textSecondary,
                            size: 4.w,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            contact["phoneNumber"] as String,
                            style: AppTheme.dataDisplayStyle.copyWith(
                              color: AppTheme.textSecondary,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 2.w),

                // Emergency Call Button
                Container(
                  width: 15.w,
                  height: 15.w,
                  decoration: BoxDecoration(
                    color: AppTheme.errorRed,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.errorRed.withValues(alpha: 0.4),
                        blurRadius: 12,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onCall,
                      borderRadius: BorderRadius.circular(50),
                      child: Center(
                        child: CustomIconWidget(
                          iconName: 'phone',
                          color: AppTheme.textPrimary,
                          size: 6.w,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
