import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/advanced_settings_widget.dart';
import './widgets/quick_toggle_widget.dart';
import './widgets/system_control_card_widget.dart';
import './widgets/voice_input_widget.dart';

class SystemControlPanelScreen extends StatefulWidget {
  const SystemControlPanelScreen({super.key});

  @override
  State<SystemControlPanelScreen> createState() =>
      _SystemControlPanelScreenState();
}

class _SystemControlPanelScreenState extends State<SystemControlPanelScreen>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late AnimationController _pulseController;
  late Animation<double> _glowAnimation;
  late Animation<double> _pulseAnimation;

  final TextEditingController _voiceInputController = TextEditingController();
  bool _isListening = false;
  String _lastCommand = "";
  double _commandConfidence = 0.0;

  // System state variables
  double _brightness = 0.7;
  String _volumeProfile = "ring";
  bool _wifiEnabled = true;
  bool _bluetoothEnabled = false;
  bool _doNotDisturb = false;
  bool _flashlight = false;
  bool _autoRotation = true;
  bool _mobileData = true;
  bool _hotspot = false;
  bool _airplaneMode = false;

  final List<Map<String, dynamic>> _wifiNetworks = [
    {
      "name": "MAAHI_Home_5G",
      "signalStrength": 4,
      "isConnected": true,
      "isSecured": true,
    },
    {
      "name": "Office_WiFi",
      "signalStrength": 3,
      "isConnected": false,
      "isSecured": true,
    },
    {
      "name": "Guest_Network",
      "signalStrength": 2,
      "isConnected": false,
      "isSecured": false,
    },
  ];

  final List<Map<String, dynamic>> _bluetoothDevices = [
    {
      "name": "AirPods Pro",
      "isConnected": true,
      "batteryLevel": 85,
      "deviceType": "headphones",
    },
    {
      "name": "Smart Watch",
      "isConnected": false,
      "batteryLevel": 60,
      "deviceType": "watch",
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadSystemState();
  }

  void _initializeAnimations() {
    _glowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  void _loadSystemState() {
    // Simulate loading current system state
    setState(() {
      _brightness = 0.7;
      _volumeProfile = "ring";
      _wifiEnabled = true;
      _bluetoothEnabled = false;
    });
  }

  void _processVoiceCommand(String command) {
    setState(() {
      _lastCommand = command.toLowerCase();
      _commandConfidence = 0.95;
    });

    // Process voice commands
    if (_lastCommand.contains("brightness") && _lastCommand.contains("%")) {
      final match = RegExp(r'(\d+)%').firstMatch(_lastCommand);
      if (match != null) {
        final value = int.parse(match.group(1)!);
        _setBrightness(value / 100.0);
      }
    } else if (_lastCommand.contains("wifi") && _lastCommand.contains("on")) {
      _toggleWifi(true);
    } else if (_lastCommand.contains("wifi") && _lastCommand.contains("off")) {
      _toggleWifi(false);
    } else if (_lastCommand.contains("bluetooth") &&
        _lastCommand.contains("on")) {
      _toggleBluetooth(true);
    } else if (_lastCommand.contains("bluetooth") &&
        _lastCommand.contains("off")) {
      _toggleBluetooth(false);
    } else if (_lastCommand.contains("flashlight")) {
      _toggleFlashlight();
    } else if (_lastCommand.contains("airplane mode")) {
      _toggleAirplaneMode();
    }

    _showCommandFeedback();
  }

  void _setBrightness(double value) {
    setState(() {
      _brightness = value.clamp(0.0, 1.0);
    });
    HapticFeedback.lightImpact();
  }

  void _toggleWifi(bool enabled) {
    setState(() {
      _wifiEnabled = enabled;
    });
    HapticFeedback.mediumImpact();
  }

  void _toggleBluetooth(bool enabled) {
    setState(() {
      _bluetoothEnabled = enabled;
    });
    HapticFeedback.mediumImpact();
  }

  void _toggleFlashlight() {
    setState(() {
      _flashlight = !_flashlight;
    });
    HapticFeedback.heavyImpact();
  }

  void _toggleAirplaneMode() {
    setState(() {
      _airplaneMode = !_airplaneMode;
      if (_airplaneMode) {
        _wifiEnabled = false;
        _bluetoothEnabled = false;
        _mobileData = false;
      }
    });
    HapticFeedback.heavyImpact();
  }

  void _showCommandFeedback() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Command executed: $_lastCommand",
          style: AppTheme.darkTheme.textTheme.bodyMedium,
        ),
        backgroundColor: AppTheme.surfaceDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        action: SnackBarAction(
          label: "OK",
          textColor: AppTheme.primaryCyan,
          onPressed: () {},
        ),
      ),
    );
  }

  Future<void> _refreshSystemStatus() async {
    HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(seconds: 1));
    _loadSystemState();
  }

  @override
  void dispose() {
    _glowController.dispose();
    _pulseController.dispose();
    _voiceInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundBlack,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshSystemStatus,
          color: AppTheme.primaryCyan,
          backgroundColor: AppTheme.surfaceDark,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    _buildVoiceInputSection(),
                    SizedBox(height: 2.h),
                    _buildQuickTogglesSection(),
                    SizedBox(height: 2.h),
                  ],
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: 3.w,
                    mainAxisSpacing: 2.h,
                  ),
                  delegate: SliverChildListDelegate([
                    _buildBrightnessCard(),
                    _buildVolumeCard(),
                    _buildWifiCard(),
                    _buildBluetoothCard(),
                    _buildDoNotDisturbCard(),
                    _buildBatteryOptimizationCard(),
                  ]),
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    SizedBox(height: 3.h),
                    _buildAdvancedSettingsSection(),
                    SizedBox(height: 10.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.backgroundBlack,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: CustomIconWidget(
          iconName: 'arrow_back',
          color: AppTheme.primaryCyan,
          size: 6.w,
        ),
      ),
      title: AnimatedBuilder(
        animation: _glowAnimation,
        builder: (context, child) {
          return Text(
            "System Control",
            style: AppTheme.darkTheme.textTheme.headlineSmall?.copyWith(
              color:
                  AppTheme.primaryCyan.withValues(alpha: _glowAnimation.value),
              fontWeight: FontWeight.w700,
            ),
          );
        },
      ),
      actions: [
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _isListening ? _pulseAnimation.value : 1.0,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    _isListening = !_isListening;
                  });
                  HapticFeedback.mediumImpact();
                },
                icon: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isListening
                        ? AppTheme.primaryCyan.withValues(alpha: 0.2)
                        : Colors.transparent,
                    border: Border.all(
                      color: _isListening
                          ? AppTheme.primaryCyan
                          : AppTheme.textSecondary,
                      width: 2,
                    ),
                  ),
                  child: CustomIconWidget(
                    iconName: _isListening ? 'mic' : 'mic_off',
                    color: _isListening
                        ? AppTheme.primaryCyan
                        : AppTheme.textSecondary,
                    size: 5.w,
                  ),
                ),
              ),
            );
          },
        ),
        SizedBox(width: 2.w),
      ],
    );
  }

  Widget _buildVoiceInputSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: VoiceInputWidget(
        controller: _voiceInputController,
        isListening: _isListening,
        lastCommand: _lastCommand,
        confidence: _commandConfidence,
        onCommandSubmitted: _processVoiceCommand,
        onListeningToggle: () {
          setState(() {
            _isListening = !_isListening;
          });
        },
      ),
    );
  }

  Widget _buildQuickTogglesSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Quick Toggles",
            style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.primaryCyan,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              QuickToggleWidget(
                icon: 'flashlight_on',
                label: "Flashlight",
                isEnabled: _flashlight,
                onToggle: () => _toggleFlashlight(),
              ),
              QuickToggleWidget(
                icon: 'screen_rotation',
                label: "Auto-rotate",
                isEnabled: _autoRotation,
                onToggle: () {
                  setState(() {
                    _autoRotation = !_autoRotation;
                  });
                  HapticFeedback.lightImpact();
                },
              ),
              QuickToggleWidget(
                icon: 'signal_cellular_alt',
                label: "Mobile Data",
                isEnabled: _mobileData,
                onToggle: () {
                  setState(() {
                    _mobileData = !_mobileData;
                  });
                  HapticFeedback.lightImpact();
                },
              ),
              QuickToggleWidget(
                icon: 'wifi_tethering',
                label: "Hotspot",
                isEnabled: _hotspot,
                onToggle: () {
                  setState(() {
                    _hotspot = !_hotspot;
                  });
                  HapticFeedback.lightImpact();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBrightnessCard() {
    return SystemControlCardWidget(
      title: "Brightness",
      icon: 'brightness_6',
      child: Column(
        children: [
          SizedBox(height: 2.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'brightness_low',
                color: AppTheme.textSecondary,
                size: 4.w,
              ),
              Expanded(
                child: Slider(
                  value: _brightness,
                  onChanged: _setBrightness,
                  activeColor: AppTheme.primaryCyan,
                  inactiveColor: AppTheme.borderColor,
                  thumbColor: AppTheme.primaryCyan,
                ),
              ),
              CustomIconWidget(
                iconName: 'brightness_high',
                color: AppTheme.textSecondary,
                size: 4.w,
              ),
            ],
          ),
          Text(
            "${(_brightness * 100).round()}%",
            style: AppTheme.dataDisplayStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildVolumeCard() {
    return SystemControlCardWidget(
      title: "Volume Profile",
      icon: _volumeProfile == "ring"
          ? 'volume_up'
          : _volumeProfile == "vibrate"
              ? 'vibration'
              : 'volume_off',
      child: Column(
        children: [
          SizedBox(height: 1.h),
          ...["ring", "vibrate", "silent"].map((profile) {
            return RadioListTile<String>(
              value: profile,
              groupValue: _volumeProfile,
              onChanged: (value) {
                setState(() {
                  _volumeProfile = value!;
                });
                HapticFeedback.selectionClick();
              },
              title: Text(
                profile.toUpperCase(),
                style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textPrimary,
                  fontSize: 10.sp,
                ),
              ),
              activeColor: AppTheme.primaryCyan,
              contentPadding: EdgeInsets.zero,
              dense: true,
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildWifiCard() {
    return SystemControlCardWidget(
      title: "Wi-Fi",
      icon: 'wifi',
      isEnabled: _wifiEnabled,
      onToggle: () => _toggleWifi(!_wifiEnabled),
      child: _wifiEnabled
          ? Column(
              children: [
                SizedBox(height: 1.h),
                ..._wifiNetworks.take(2).map((network) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 0.5.h),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: network["isSecured"] ? 'lock' : 'lock_open',
                          color: network["isConnected"]
                              ? AppTheme.primaryCyan
                              : AppTheme.textSecondary,
                          size: 3.w,
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            network["name"],
                            style: AppTheme.darkTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: network["isConnected"]
                                  ? AppTheme.primaryCyan
                                  : AppTheme.textSecondary,
                              fontSize: 9.sp,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        ...List.generate(
                          network["signalStrength"],
                          (index) => Container(
                            width: 1.w,
                            height: (index + 1) * 0.5.h,
                            margin: EdgeInsets.only(left: 0.5.w),
                            decoration: BoxDecoration(
                              color: network["isConnected"]
                                  ? AppTheme.primaryCyan
                                  : AppTheme.textSecondary,
                              borderRadius: BorderRadius.circular(0.5.w),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            )
          : Container(
              height: 6.h,
              alignment: Alignment.center,
              child: Text(
                "Wi-Fi Disabled",
                style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textDisabled,
                ),
              ),
            ),
    );
  }

  Widget _buildBluetoothCard() {
    return SystemControlCardWidget(
      title: "Bluetooth",
      icon: 'bluetooth',
      isEnabled: _bluetoothEnabled,
      onToggle: () => _toggleBluetooth(!_bluetoothEnabled),
      child: _bluetoothEnabled
          ? Column(
              children: [
                SizedBox(height: 1.h),
                ..._bluetoothDevices.map((device) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 0.5.h),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: device["deviceType"] == "headphones"
                              ? 'headphones'
                              : 'watch',
                          color: device["isConnected"]
                              ? AppTheme.primaryCyan
                              : AppTheme.textSecondary,
                          size: 3.w,
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                device["name"],
                                style: AppTheme.darkTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: device["isConnected"]
                                      ? AppTheme.primaryCyan
                                      : AppTheme.textSecondary,
                                  fontSize: 9.sp,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (device["isConnected"])
                                Text(
                                  "${device["batteryLevel"]}%",
                                  style: AppTheme.systemMetricsStyle.copyWith(
                                    fontSize: 8.sp,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            )
          : Container(
              height: 6.h,
              alignment: Alignment.center,
              child: Text(
                "Bluetooth Disabled",
                style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textDisabled,
                ),
              ),
            ),
    );
  }

  Widget _buildDoNotDisturbCard() {
    return SystemControlCardWidget(
      title: "Do Not Disturb",
      icon: 'do_not_disturb',
      isEnabled: _doNotDisturb,
      onToggle: () {
        setState(() {
          _doNotDisturb = !_doNotDisturb;
        });
        HapticFeedback.mediumImpact();
      },
      child: Column(
        children: [
          SizedBox(height: 1.h),
          Text(
            _doNotDisturb ? "Active" : "Inactive",
            style: AppTheme.dataDisplayStyle.copyWith(
              color:
                  _doNotDisturb ? AppTheme.primaryCyan : AppTheme.textSecondary,
            ),
          ),
          SizedBox(height: 1.h),
          if (_doNotDisturb)
            Text(
              "Until 8:00 AM",
              style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
                fontSize: 9.sp,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBatteryOptimizationCard() {
    return SystemControlCardWidget(
      title: "Battery",
      icon: 'battery_charging_full',
      child: Column(
        children: [
          SizedBox(height: 1.h),
          Text(
            "85%",
            style: AppTheme.dataDisplayStyle,
          ),
          SizedBox(height: 0.5.h),
          Text(
            "Optimized",
            style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.successGreen,
              fontSize: 9.sp,
            ),
          ),
          SizedBox(height: 1.h),
          LinearProgressIndicator(
            value: 0.85,
            backgroundColor: AppTheme.borderColor,
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.successGreen),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedSettingsSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: AdvancedSettingsWidget(
        onDeveloperOptionsPressed: () {
          // Navigate to developer options
        },
        onAccessibilityPressed: () {
          // Navigate to accessibility settings
        },
        onPrivacyPressed: () {
          Navigator.pushNamed(context, '/settings-and-privacy-screen');
        },
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      height: 8.h,
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        border: Border(
          top: BorderSide(
            color: AppTheme.borderColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem('dashboard', 'Dashboard', '/voice-dashboard-screen'),
          _buildNavItem('settings', 'Control', '/system-control-panel-screen',
              isActive: true),
          _buildNavItem('apps', 'Apps', '/app-management-screen'),
          _buildNavItem('chat', 'Communication', '/communication-hub-screen'),
          _buildNavItem('security', 'Privacy', '/settings-and-privacy-screen'),
        ],
      ),
    );
  }

  Widget _buildNavItem(String icon, String label, String route,
      {bool isActive = false}) {
    return GestureDetector(
      onTap: () {
        if (!isActive) {
          Navigator.pushNamed(context, route);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: icon,
              color: isActive ? AppTheme.primaryCyan : AppTheme.textSecondary,
              size: 5.w,
            ),
            SizedBox(height: 0.5.h),
            Text(
              label,
              style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                color: isActive ? AppTheme.primaryCyan : AppTheme.textSecondary,
                fontSize: 8.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
