import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/ai_orb_widget.dart';
import './widgets/quick_action_cards_widget.dart';
import './widgets/status_indicators_widget.dart';
import './widgets/system_dashboard_widget.dart';
import './widgets/voice_history_widget.dart';

class VoiceDashboardScreen extends StatefulWidget {
  const VoiceDashboardScreen({super.key});

  @override
  State<VoiceDashboardScreen> createState() => _VoiceDashboardScreenState();
}

class _VoiceDashboardScreenState extends State<VoiceDashboardScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _orbAnimationController;
  late AnimationController _waveformController;
  late Animation<double> _orbPulseAnimation;
  late Animation<double> _waveformAnimation;

  bool _isListening = true;
  bool _isSystemDashboardVisible = false;
  bool _isOfflineMode = false;
  double _voiceSensitivity = 0.7;

  // Mock system data
  final Map<String, dynamic> _systemData = {
    "batteryLevel": 87,
    "ramUsage": 68,
    "cpuTemperature": 42,
    "storageUsed": 156.7,
    "storageTotal": 256.0,
    "networkStatus": "WiFi Connected",
    "activeApps": 12,
    "isCharging": false,
    "lastCommand": "Hey Maahi, open WhatsApp",
    "commandTime": DateTime.now().subtract(const Duration(minutes: 2)),
  };

  final List<Map<String, dynamic>> _voiceHistory = [
    {
      "command": "Hey Maahi, set brightness to 80%",
      "timestamp": DateTime.now().subtract(const Duration(minutes: 1)),
      "status": "completed",
      "response": "Brightness set to 80%, Boss"
    },
    {
      "command": "Hey Maahi, open WhatsApp",
      "timestamp": DateTime.now().subtract(const Duration(minutes: 2)),
      "status": "completed",
      "response": "Opening WhatsApp for you, Boss"
    },
    {
      "command": "Hey Maahi, check battery level",
      "timestamp": DateTime.now().subtract(const Duration(minutes: 5)),
      "status": "completed",
      "response": "Battery is at 87%, Boss"
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    _orbAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _waveformController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);

    _orbPulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _orbAnimationController,
      curve: Curves.easeInOut,
    ));

    _waveformAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _waveformController,
      curve: Curves.easeInOut,
    ));

    _startListening();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _orbAnimationController.dispose();
    _waveformController.dispose();
    super.dispose();
  }

  void _startListening() {
    setState(() {
      _isListening = true;
    });
    _orbAnimationController.repeat(reverse: true);
    _waveformController.repeat(reverse: true);
  }

  void _stopListening() {
    setState(() {
      _isListening = false;
    });
    _orbAnimationController.stop();
    _waveformController.stop();
  }

  void _toggleSystemDashboard() {
    setState(() {
      _isSystemDashboardVisible = !_isSystemDashboardVisible;
    });
    HapticFeedback.lightImpact();
  }

  void _onOrbLongPress() {
    HapticFeedback.mediumImpact();
    _showVoiceSensitivityDialog();
  }

  void _showVoiceSensitivityDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Voice Sensitivity',
          style: AppTheme.darkTheme.textTheme.titleLarge,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Adjust voice recognition sensitivity',
              style: AppTheme.darkTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 3.h),
            Slider(
              value: _voiceSensitivity,
              onChanged: (value) {
                setState(() {
                  _voiceSensitivity = value;
                });
              },
              min: 0.1,
              max: 1.0,
              divisions: 9,
              label: '${(_voiceSensitivity * 100).round()}%',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              HapticFeedback.selectionClick();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _onManualVoiceInput() {
    HapticFeedback.mediumImpact();
    // Simulate voice input activation
    setState(() {
      _isListening = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundBlack,
      body: SafeArea(
        child: GestureDetector(
          onVerticalDragEnd: (details) {
            if (details.primaryVelocity != null &&
                details.primaryVelocity! < -500) {
              _toggleSystemDashboard();
            }
          },
          child: Stack(
            children: [
              // Background particle effects
              Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 1.5,
                    colors: [
                      AppTheme.primaryCyan.withValues(alpha: 0.05),
                      AppTheme.backgroundBlack,
                      AppTheme.backgroundBlack,
                    ],
                  ),
                ),
              ),

              // Main content
              Column(
                children: [
                  // Tab bar
                  Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceDark.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: AppTheme.borderColor,
                        width: 1,
                      ),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        color: AppTheme.primaryCyan.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      tabs: [
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomIconWidget(
                                iconName: 'dashboard',
                                color: AppTheme.primaryCyan,
                                size: 4.w,
                              ),
                              SizedBox(width: 1.w),
                              Text('Dashboard',
                                  style: TextStyle(fontSize: 10.sp)),
                            ],
                          ),
                        ),
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomIconWidget(
                                iconName: 'mic',
                                color: AppTheme.primaryCyan,
                                size: 4.w,
                              ),
                              SizedBox(width: 1.w),
                              Text('Commands',
                                  style: TextStyle(fontSize: 10.sp)),
                            ],
                          ),
                        ),
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomIconWidget(
                                iconName: 'settings',
                                color: AppTheme.primaryCyan,
                                size: 4.w,
                              ),
                              SizedBox(width: 1.w),
                              Text('Settings',
                                  style: TextStyle(fontSize: 10.sp)),
                            ],
                          ),
                        ),
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomIconWidget(
                                iconName: 'person',
                                color: AppTheme.primaryCyan,
                                size: 4.w,
                              ),
                              SizedBox(width: 1.w),
                              Text('Profile',
                                  style: TextStyle(fontSize: 10.sp)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Tab content
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildDashboardTab(),
                        _buildCommandsTab(),
                        _buildSettingsTab(),
                        _buildProfileTab(),
                      ],
                    ),
                  ),
                ],
              ),

              // System dashboard overlay
              if (_isSystemDashboardVisible)
                SystemDashboardWidget(
                  systemData: _systemData,
                  onClose: _toggleSystemDashboard,
                ),

              // Voice history overlay
              VoiceHistoryWidget(
                voiceHistory: _voiceHistory,
                isVisible: _isListening,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onManualVoiceInput,
        backgroundColor: AppTheme.primaryCyan,
        child: CustomIconWidget(
          iconName: _isListening ? 'mic' : 'mic_off',
          color: AppTheme.backgroundBlack,
          size: 6.w,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildDashboardTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        children: [
          SizedBox(height: 2.h),

          // AI Orb with waveform
          GestureDetector(
            onLongPress: _onOrbLongPress,
            child: AiOrbWidget(
              isListening: _isListening,
              orbPulseAnimation: _orbPulseAnimation,
              waveformAnimation: _waveformAnimation,
              onTap: () {
                HapticFeedback.lightImpact();
                setState(() {
                  _isListening = !_isListening;
                });
                _isListening ? _startListening() : _stopListening();
              },
            ),
          ),

          SizedBox(height: 3.h),

          // Status indicators
          StatusIndicatorsWidget(
            isListening: _isListening,
            batteryLevel: _systemData["batteryLevel"],
            ramUsage: _systemData["ramUsage"],
            networkStatus: _systemData["networkStatus"],
            isOfflineMode: _isOfflineMode,
            isCharging: _systemData["isCharging"],
          ),

          SizedBox(height: 3.h),

          // Quick action cards
          QuickActionCardsWidget(
            onAppLauncher: () =>
                Navigator.pushNamed(context, '/app-management-screen'),
            onSystemSettings: () =>
                Navigator.pushNamed(context, '/system-control-panel-screen'),
            onVoiceMacros: () =>
                Navigator.pushNamed(context, '/settings-and-privacy-screen'),
            onEmergencyMode: () {
              HapticFeedback.heavyImpact();
              // Emergency mode activation
            },
          ),

          SizedBox(height: 2.h),

          // Last command info
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: AppTheme.glassCardDecoration,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'history',
                      color: AppTheme.primaryCyan,
                      size: 5.w,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Last Command',
                      style: AppTheme.darkTheme.textTheme.titleMedium,
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Text(
                  _systemData["lastCommand"] ?? "No recent commands",
                  style: AppTheme.commandHistoryStyle,
                ),
                SizedBox(height: 1.h),
                Text(
                  _systemData["commandTime"] != null
                      ? '${DateTime.now().difference(_systemData["commandTime"]).inMinutes} minutes ago'
                      : '',
                  style: AppTheme.darkTheme.textTheme.bodySmall,
                ),
              ],
            ),
          ),

          SizedBox(height: 10.h), // Space for FAB
        ],
      ),
    );
  }

  Widget _buildCommandsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Voice Commands',
            style: AppTheme.darkTheme.textTheme.headlineSmall,
          ),
          SizedBox(height: 2.h),

          // Command categories
          _buildCommandCategory(
            'System Control',
            [
              'Hey Maahi, set brightness to 50%',
              'Hey Maahi, turn on WiFi',
              'Hey Maahi, enable Do Not Disturb',
              'Hey Maahi, take a screenshot',
            ],
          ),

          _buildCommandCategory(
            'App Management',
            [
              'Hey Maahi, open WhatsApp',
              'Hey Maahi, close all apps',
              'Hey Maahi, uninstall TikTok',
              'Hey Maahi, freeze Instagram',
            ],
          ),

          _buildCommandCategory(
            'Communication',
            [
              'Hey Maahi, read my messages',
              'Hey Maahi, call Mom',
              'Hey Maahi, send SMS to John',
              'Hey Maahi, check missed calls',
            ],
          ),

          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  Widget _buildCommandCategory(String title, List<String> commands) {
    return Container(
      margin: EdgeInsets.only(bottom: 3.h),
      padding: EdgeInsets.all(4.w),
      decoration: AppTheme.glassCardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.primaryCyan,
            ),
          ),
          SizedBox(height: 2.h),
          ...commands.map((command) => Padding(
                padding: EdgeInsets.only(bottom: 1.h),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'mic',
                      color: AppTheme.accentGlow,
                      size: 4.w,
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Text(
                        command,
                        style: AppTheme.commandHistoryStyle,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildSettingsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Voice Settings',
            style: AppTheme.darkTheme.textTheme.headlineSmall,
          ),
          SizedBox(height: 2.h),

          // Settings options
          _buildSettingsTile(
            'Voice Sensitivity',
            'Adjust microphone sensitivity',
            'tune',
            () => _showVoiceSensitivityDialog(),
          ),

          _buildSettingsTile(
            'Offline Mode',
            'Disable internet-dependent features',
            'wifi_off',
            () {
              setState(() {
                _isOfflineMode = !_isOfflineMode;
              });
            },
            trailing: Switch(
              value: _isOfflineMode,
              onChanged: (value) {
                setState(() {
                  _isOfflineMode = value;
                });
              },
            ),
          ),

          _buildSettingsTile(
            'Wake Word Training',
            'Improve "Hey Maahi" recognition',
            'record_voice_over',
            () {
              Navigator.pushNamed(context, '/settings-and-privacy-screen');
            },
          ),

          _buildSettingsTile(
            'Privacy Settings',
            'Manage data and permissions',
            'privacy_tip',
            () {
              Navigator.pushNamed(context, '/settings-and-privacy-screen');
            },
          ),

          _buildSettingsTile(
            'System Permissions',
            'Configure app permissions',
            'admin_panel_settings',
            () {
              Navigator.pushNamed(context, '/permission-setup-screen');
            },
          ),

          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(
    String title,
    String subtitle,
    String iconName,
    VoidCallback onTap, {
    Widget? trailing,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: AppTheme.glassCardDecoration,
      child: ListTile(
        leading: CustomIconWidget(
          iconName: iconName,
          color: AppTheme.primaryCyan,
          size: 6.w,
        ),
        title: Text(
          title,
          style: AppTheme.darkTheme.textTheme.titleMedium,
        ),
        subtitle: Text(
          subtitle,
          style: AppTheme.darkTheme.textTheme.bodySmall,
        ),
        trailing: trailing ??
            CustomIconWidget(
              iconName: 'chevron_right',
              color: AppTheme.textSecondary,
              size: 5.w,
            ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildProfileTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        children: [
          // Profile header
          Container(
            padding: EdgeInsets.all(6.w),
            decoration: AppTheme.glassCardDecoration,
            child: Column(
              children: [
                Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppTheme.primaryCyan,
                        AppTheme.accentGlow,
                      ],
                    ),
                  ),
                  child: CustomIconWidget(
                    iconName: 'person',
                    color: AppTheme.backgroundBlack,
                    size: 10.w,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'MAAHI User',
                  style: AppTheme.darkTheme.textTheme.titleLarge,
                ),
                Text(
                  'Voice Assistant Active',
                  style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.successGreen,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // Profile stats
          Row(
            children: [
              Expanded(
                child: _buildStatCard('Commands Today', '47'),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: _buildStatCard('Success Rate', '98%'),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: _buildStatCard('Uptime', '23h'),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Profile options
          _buildSettingsTile(
            'Voice Training',
            'Improve recognition accuracy',
            'school',
            () {},
          ),

          _buildSettingsTile(
            'Usage Analytics',
            'View detailed usage statistics',
            'analytics',
            () {},
          ),

          _buildSettingsTile(
            'Backup & Sync',
            'Manage voice macros backup',
            'backup',
            () {},
          ),

          _buildSettingsTile(
            'About MAAHI',
            'Version 1.0.0 - Voice OS',
            'info',
            () {},
          ),

          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: AppTheme.glassCardDecoration,
      child: Column(
        children: [
          Text(
            value,
            style: AppTheme.dataDisplayStyle.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            label,
            style: AppTheme.darkTheme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
