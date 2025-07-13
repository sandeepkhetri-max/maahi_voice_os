import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/permission_card_widget.dart';
import './widgets/progress_indicator_widget.dart';

class PermissionSetupScreen extends StatefulWidget {
  const PermissionSetupScreen({super.key});

  @override
  State<PermissionSetupScreen> createState() => _PermissionSetupScreenState();
}

class _PermissionSetupScreenState extends State<PermissionSetupScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _progressController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _progressAnimation;

  final List<Map<String, dynamic>> permissions = [
    {
      "id": "microphone",
      "name": "Microphone Access",
      "purpose":
          "Continuous voice listening for 'Hey Maahi' wake word detection",
      "icon": "mic",
      "isGranted": false,
      "isMandatory": true,
      "technicalDetails":
          "Required for 24/7 background voice processing and wake word detection using advanced audio streaming pipeline",
    },
    {
      "id": "accessibility",
      "name": "Accessibility Service",
      "purpose": "System control and automation for voice commands",
      "icon": "accessibility",
      "isGranted": false,
      "isMandatory": true,
      "technicalDetails":
          "Enables deep system integration for app launching, settings control, and touch simulation without root access",
    },
    {
      "id": "device_admin",
      "name": "Device Administrator",
      "purpose": "Advanced device management and security features",
      "icon": "admin_panel_settings",
      "isGranted": false,
      "isMandatory": true,
      "technicalDetails":
          "Provides device policy management, screen locking, and enhanced security controls for voice-activated operations",
    },
    {
      "id": "camera",
      "name": "Camera Access",
      "purpose": "Intruder detection and security monitoring",
      "icon": "camera_alt",
      "isGranted": false,
      "isMandatory": false,
      "technicalDetails":
          "Front camera capture for unauthorized access detection and security photo capture during voice authentication",
    },
    {
      "id": "phone",
      "name": "Phone Access",
      "purpose": "Voice-controlled calling and contact management",
      "icon": "phone",
      "isGranted": false,
      "isMandatory": false,
      "technicalDetails":
          "Enables voice dialing, call management, and emergency contact features through natural language commands",
    },
    {
      "id": "sms",
      "name": "SMS Access",
      "purpose": "Read and send messages via voice commands",
      "icon": "sms",
      "isGranted": false,
      "isMandatory": false,
      "technicalDetails":
          "Allows voice-controlled message reading, composition, and sending with WhatsApp and SMS integration",
    },
    {
      "id": "storage",
      "name": "Storage Access",
      "purpose": "File management and voice macro storage",
      "icon": "storage",
      "isGranted": false,
      "isMandatory": false,
      "technicalDetails":
          "Required for voice macro recording, system file access, and temporary data storage for offline operations",
    },
  ];

  int get grantedCount =>
      permissions.where((p) => p["isGranted"] == true).length;
  int get mandatoryGrantedCount => permissions
      .where((p) => p["isMandatory"] == true && p["isGranted"] == true)
      .length;
  bool get canContinue => mandatoryGrantedCount >= 3;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.elasticOut,
    ));
  }

  void _startAnimations() {
    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _progressController.forward();
    });
  }

  void _handlePermissionTap(String permissionId) {
    HapticFeedback.lightImpact();
    setState(() {
      final permission = permissions.firstWhere((p) => p["id"] == permissionId);
      permission["isGranted"] = !permission["isGranted"];
    });

    // Simulate permission dialog
    _showPermissionDialog(permissionId);
  }

  void _showPermissionDialog(String permissionId) {
    final permission = permissions.firstWhere((p) => p["id"] == permissionId);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: AppTheme.surfaceDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
            side:
                BorderSide(color: AppTheme.primaryCyan.withValues(alpha: 0.3)),
          ),
          child: Container(
            padding: EdgeInsets.all(6.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.primaryCyan.withValues(alpha: 0.1),
                    border: Border.all(
                      color: AppTheme.primaryCyan.withValues(alpha: 0.3),
                    ),
                  ),
                  child: CustomIconWidget(
                    iconName: permission["icon"],
                    color: AppTheme.primaryCyan,
                    size: 8.w,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  "Grant ${permission["name"]}?",
                  style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                    color: AppTheme.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 2.h),
                Text(
                  permission["purpose"],
                  style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          setState(() {
                            permission["isGranted"] = false;
                          });
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            side: BorderSide(color: AppTheme.errorRed),
                          ),
                        ),
                        child: Text(
                          "Deny",
                          style:
                              AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                            color: AppTheme.errorRed,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          setState(() {
                            permission["isGranted"] = true;
                          });
                          _showSuccessAnimation();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                          backgroundColor: AppTheme.primaryCyan,
                          foregroundColor: AppTheme.backgroundBlack,
                        ),
                        child: Text(
                          "Allow",
                          style:
                              AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                            color: AppTheme.backgroundBlack,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSuccessAnimation() {
    HapticFeedback.mediumImpact();
    // Success animation would be implemented here
  }

  void _showSkipWarning() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: AppTheme.surfaceDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
            side:
                BorderSide(color: AppTheme.warningAmber.withValues(alpha: 0.3)),
          ),
          child: Container(
            padding: EdgeInsets.all(6.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: "warning",
                  color: AppTheme.warningAmber,
                  size: 12.w,
                ),
                SizedBox(height: 3.h),
                Text(
                  "Limited Functionality",
                  style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                    color: AppTheme.warningAmber,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 2.h),
                Text(
                  "Skipping permissions will limit voice assistant capabilities. Some features may not work properly.",
                  style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text("Go Back"),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.pushNamed(
                              context, '/voice-dashboard-screen');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.warningAmber,
                          foregroundColor: AppTheme.backgroundBlack,
                        ),
                        child: Text("Continue Anyway"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showTechnicalDetails(Map<String, dynamic> permission) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: AppTheme.surfaceDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
            side: BorderSide(color: AppTheme.accentGlow.withValues(alpha: 0.3)),
          ),
          child: Container(
            padding: EdgeInsets.all(6.w),
            constraints: BoxConstraints(maxHeight: 70.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: permission["icon"],
                      color: AppTheme.accentGlow,
                      size: 6.w,
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Text(
                        permission["name"],
                        style:
                            AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: CustomIconWidget(
                        iconName: "close",
                        color: AppTheme.textSecondary,
                        size: 5.w,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3.h),
                Flexible(
                  child: SingleChildScrollView(
                    child: Text(
                      permission["technicalDetails"],
                      style: AppTheme.commandHistoryStyle.copyWith(
                        color: AppTheme.textSecondary,
                        height: 1.6,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 3.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text("Got it"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundBlack,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              // Header with progress
              Container(
                padding: EdgeInsets.all(6.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: "security",
                          color: AppTheme.primaryCyan,
                          size: 8.w,
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            "Permission Setup",
                            style: AppTheme.darkTheme.textTheme.headlineSmall
                                ?.copyWith(
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      "Grant essential permissions for voice assistant functionality",
                      style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    AnimatedBuilder(
                      animation: _progressAnimation,
                      child: ProgressIndicatorWidget(
                        current: grantedCount,
                        total: permissions.length,
                      ),
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _progressAnimation.value,
                          child: child,
                        );
                      },
                    ),
                  ],
                ),
              ),

              // Permission cards list
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  itemCount: permissions.length,
                  itemBuilder: (context, index) {
                    final permission = permissions[index];
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 300 + (index * 100)),
                      curve: Curves.easeOutBack,
                      margin: EdgeInsets.only(bottom: 3.h),
                      child: PermissionCardWidget(
                        permission: permission,
                        onTap: () => _handlePermissionTap(permission["id"]),
                        onLongPress: () => _showTechnicalDetails(permission),
                      ),
                    );
                  },
                ),
              ),

              // Bottom action buttons
              Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceDark.withValues(alpha: 0.8),
                  border: Border(
                    top: BorderSide(
                      color: AppTheme.borderColor,
                      width: 1,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    if (!canContinue)
                      Container(
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: AppTheme.warningAmber.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                            color: AppTheme.warningAmber.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            CustomIconWidget(
                              iconName: "info",
                              color: AppTheme.warningAmber,
                              size: 5.w,
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: Text(
                                "Grant all mandatory permissions to continue",
                                style: AppTheme.darkTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme.warningAmber,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (!canContinue) SizedBox(height: 3.h),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: _showSkipWarning,
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 2.h),
                            ),
                            child: Text("Skip for Now"),
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: canContinue
                                ? () {
                                    HapticFeedback.mediumImpact();
                                    Navigator.pushNamed(
                                        context, '/voice-dashboard-screen');
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 2.h),
                              backgroundColor: canContinue
                                  ? AppTheme.primaryCyan
                                  : AppTheme.surfaceDark,
                              foregroundColor: canContinue
                                  ? AppTheme.backgroundBlack
                                  : AppTheme.textDisabled,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Continue to Setup",
                                  style: AppTheme.darkTheme.textTheme.labelLarge
                                      ?.copyWith(
                                    color: canContinue
                                        ? AppTheme.backgroundBlack
                                        : AppTheme.textDisabled,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 2.w),
                                CustomIconWidget(
                                  iconName: "arrow_forward",
                                  color: canContinue
                                      ? AppTheme.backgroundBlack
                                      : AppTheme.textDisabled,
                                  size: 5.w,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
