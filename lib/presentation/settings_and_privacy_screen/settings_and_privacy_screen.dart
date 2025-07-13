import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/settings_category_widget.dart';
import './widgets/settings_search_widget.dart';
import './widgets/voice_input_widget.dart';

class SettingsAndPrivacyScreen extends StatefulWidget {
  const SettingsAndPrivacyScreen({super.key});

  @override
  State<SettingsAndPrivacyScreen> createState() =>
      _SettingsAndPrivacyScreenState();
}

class _SettingsAndPrivacyScreenState extends State<SettingsAndPrivacyScreen>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _voiceInputController = TextEditingController();

  String _searchQuery = '';
  bool _isVoiceInputActive = false;

  // Settings state variables
  double _wakeWordSensitivity = 0.7;
  bool _accentAdaptation = true;
  bool _offlineOnlyMode = false;
  bool _intruderDetection = true;
  bool _accessibilityService = true;
  bool _deviceAdmin = false;
  bool _batteryOptimization = true;
  bool _notificationAccess = true;
  double _aiOrbSpeed = 0.5;
  double _particleIntensity = 0.8;
  bool _developerOptions = false;
  bool _debugLogging = false;
  bool _expertMode = false;
  String _selectedLanguage = 'Hindi-English Balance';
  String _selectedVoice = 'Female (Respectful)';
  String _selectedTheme = 'JARVIS Dark';

  final List<Map<String, dynamic>> _settingsData = [
    {
      'category': 'Voice Recognition',
      'icon': 'mic',
      'expanded': false,
      'settings': [
        {
          'title': 'Wake Word Sensitivity',
          'subtitle': 'Adjust "Hey Maahi" detection sensitivity',
          'type': 'slider',
          'value': 0.7,
          'voiceCommand': 'Set wake word sensitivity to high',
        },
        {
          'title': 'Accent Adaptation',
          'subtitle': 'Learn your pronunciation patterns',
          'type': 'toggle',
          'value': true,
          'voiceCommand': 'Enable accent adaptation',
        },
        {
          'title': 'Language Preferences',
          'subtitle': 'Hindi-English balance for commands',
          'type': 'dropdown',
          'value': 'Hindi-English Balance',
          'options': [
            'Pure Hindi',
            'Hindi-English Balance',
            'English Preferred'
          ],
          'voiceCommand': 'Change language to English preferred',
        },
        {
          'title': 'Voice Training Reset',
          'subtitle': 'Clear learned voice patterns',
          'type': 'action',
          'voiceCommand': 'Reset voice training',
        },
      ],
    },
    {
      'category': 'Privacy Controls',
      'icon': 'security',
      'expanded': false,
      'settings': [
        {
          'title': 'Offline-Only Mode',
          'subtitle': 'Disable all internet features',
          'type': 'toggle',
          'value': false,
          'voiceCommand': 'Turn on privacy mode',
        },
        {
          'title': 'Intruder Detection',
          'subtitle': 'Capture photos of unauthorized access',
          'type': 'toggle',
          'value': true,
          'voiceCommand': 'Enable intruder detection',
        },
        {
          'title': 'Data Retention',
          'subtitle': 'Session-only, no permanent storage',
          'type': 'info',
          'value': 'Session Only',
          'voiceCommand': 'Show data retention policy',
        },
        {
          'title': 'Microphone Access',
          'subtitle': 'Always listening indicator',
          'type': 'indicator',
          'value': true,
          'voiceCommand': 'Show microphone status',
        },
      ],
    },
    {
      'category': 'System Integration',
      'icon': 'settings',
      'expanded': false,
      'settings': [
        {
          'title': 'Accessibility Service',
          'subtitle': 'Required for system control',
          'type': 'toggle',
          'value': true,
          'voiceCommand': 'Enable accessibility service',
        },
        {
          'title': 'Device Admin Privileges',
          'subtitle': 'Advanced system functions',
          'type': 'toggle',
          'value': false,
          'voiceCommand': 'Grant device admin access',
        },
        {
          'title': 'Battery Optimization',
          'subtitle': 'Exempt from power saving',
          'type': 'toggle',
          'value': true,
          'voiceCommand': 'Disable battery optimization',
        },
        {
          'title': 'Notification Access',
          'subtitle': 'Read and respond to notifications',
          'type': 'toggle',
          'value': true,
          'voiceCommand': 'Enable notification access',
        },
      ],
    },
    {
      'category': 'Appearance',
      'icon': 'palette',
      'expanded': false,
      'settings': [
        {
          'title': 'AI Orb Animation Speed',
          'subtitle': 'Control central orb animation',
          'type': 'slider',
          'value': 0.5,
          'voiceCommand': 'Increase orb animation speed',
        },
        {
          'title': 'Particle Effects Intensity',
          'subtitle': 'Background particle density',
          'type': 'slider',
          'value': 0.8,
          'voiceCommand': 'Reduce particle effects',
        },
        {
          'title': 'Theme Variant',
          'subtitle': 'Visual style customization',
          'type': 'dropdown',
          'value': 'JARVIS Dark',
          'options': ['JARVIS Dark', 'Neon Blue', 'Cyber Green', 'Iron Red'],
          'voiceCommand': 'Change theme to neon blue',
        },
        {
          'title': 'Response Voice',
          'subtitle': 'AI assistant voice selection',
          'type': 'dropdown',
          'value': 'Female (Respectful)',
          'options': [
            'Female (Respectful)',
            'Male (Professional)',
            'Neutral (Robotic)'
          ],
          'voiceCommand': 'Change voice to male professional',
        },
      ],
    },
    {
      'category': 'Advanced Features',
      'icon': 'code',
      'expanded': false,
      'settings': [
        {
          'title': 'Developer Options',
          'subtitle': 'Advanced debugging features',
          'type': 'toggle',
          'value': false,
          'voiceCommand': 'Enable developer options',
        },
        {
          'title': 'Debug Logging',
          'subtitle': 'Detailed system logs',
          'type': 'toggle',
          'value': false,
          'voiceCommand': 'Turn on debug logging',
        },
        {
          'title': 'Performance Metrics',
          'subtitle': 'Real-time system monitoring',
          'type': 'action',
          'voiceCommand': 'Show performance metrics',
        },
        {
          'title': 'Expert Mode',
          'subtitle': 'Unlock all advanced features',
          'type': 'toggle',
          'value': false,
          'voiceCommand': 'Activate expert mode',
        },
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _glowController.dispose();
    _searchController.dispose();
    _voiceInputController.dispose();
    super.dispose();
  }

  void _toggleCategory(int index) {
    setState(() {
      _settingsData[index]['expanded'] = !_settingsData[index]['expanded'];
    });
  }

  void _updateSetting(String category, String title, dynamic value) {
    setState(() {
      for (var categoryData in _settingsData) {
        if (categoryData['category'] == category) {
          for (var setting in categoryData['settings']) {
            if (setting['title'] == title) {
              setting['value'] = value;
              break;
            }
          }
          break;
        }
      }

      // Update local state variables
      switch (title) {
        case 'Wake Word Sensitivity':
          _wakeWordSensitivity = value;
          break;
        case 'Accent Adaptation':
          _accentAdaptation = value;
          break;
        case 'Offline-Only Mode':
          _offlineOnlyMode = value;
          break;
        case 'Intruder Detection':
          _intruderDetection = value;
          break;
        case 'Accessibility Service':
          _accessibilityService = value;
          break;
        case 'Device Admin Privileges':
          _deviceAdmin = value;
          break;
        case 'Battery Optimization':
          _batteryOptimization = value;
          break;
        case 'Notification Access':
          _notificationAccess = value;
          break;
        case 'AI Orb Animation Speed':
          _aiOrbSpeed = value;
          break;
        case 'Particle Effects Intensity':
          _particleIntensity = value;
          break;
        case 'Developer Options':
          _developerOptions = value;
          break;
        case 'Debug Logging':
          _debugLogging = value;
          break;
        case 'Expert Mode':
          _expertMode = value;
          break;
        case 'Language Preferences':
          _selectedLanguage = value;
          break;
        case 'Response Voice':
          _selectedVoice = value;
          break;
        case 'Theme Variant':
          _selectedTheme = value;
          break;
      }
    });
  }

  void _processVoiceCommand(String command) {
    // Simple voice command processing
    String lowerCommand = command.toLowerCase();

    if (lowerCommand.contains('privacy mode') ||
        lowerCommand.contains('offline')) {
      _updateSetting('Privacy Controls', 'Offline-Only Mode', true);
    } else if (lowerCommand.contains('sensitivity') &&
        lowerCommand.contains('high')) {
      _updateSetting('Voice Recognition', 'Wake Word Sensitivity', 0.9);
    } else if (lowerCommand.contains('sensitivity') &&
        lowerCommand.contains('low')) {
      _updateSetting('Voice Recognition', 'Wake Word Sensitivity', 0.3);
    } else if (lowerCommand.contains('developer') &&
        lowerCommand.contains('enable')) {
      _updateSetting('Advanced Features', 'Developer Options', true);
    } else if (lowerCommand.contains('expert mode')) {
      _updateSetting('Advanced Features', 'Expert Mode', true);
    }

    setState(() {
      _isVoiceInputActive = false;
      _voiceInputController.clear();
    });
  }

  void _showResetDialog(String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.surfaceDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
            side: BorderSide(color: AppTheme.borderColor),
          ),
          title: Text(
            'Reset $title',
            style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.primaryCyan,
            ),
          ),
          content: Text(
            'This action cannot be undone. Say "Confirm Reset" to proceed.',
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: AppTheme.textSecondary),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Perform reset action
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$title has been reset successfully'),
                    backgroundColor: AppTheme.successGreen,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.errorRed,
                foregroundColor: AppTheme.textPrimary,
              ),
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );
  }

  void _exportSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Settings exported to local storage'),
        backgroundColor: AppTheme.successGreen,
        action: SnackBarAction(
          label: 'View',
          textColor: AppTheme.textPrimary,
          onPressed: () {},
        ),
      ),
    );
  }

  void _importSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Settings imported successfully'),
        backgroundColor: AppTheme.successGreen,
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredSettings() {
    if (_searchQuery.isEmpty) return _settingsData;

    return _settingsData.where((category) {
      bool categoryMatches = category['category']
          .toString()
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());

      bool settingsMatch = (category['settings'] as List).any((setting) =>
          setting['title']
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          setting['subtitle']
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()));

      return categoryMatches || settingsMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundBlack,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundBlack,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.primaryCyan,
            size: 24,
          ),
        ),
        title: AnimatedBuilder(
          animation: _glowAnimation,
          builder: (context, child) {
            return Text(
              'Settings & Privacy',
              style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                color: AppTheme.primaryCyan
                    .withValues(alpha: _glowAnimation.value),
                fontWeight: FontWeight.w700,
              ),
            );
          },
        ),
        actions: [
          IconButton(
            onPressed: _exportSettings,
            icon: CustomIconWidget(
              iconName: 'file_upload',
              color: AppTheme.textSecondary,
              size: 20,
            ),
          ),
          IconButton(
            onPressed: _importSettings,
            icon: CustomIconWidget(
              iconName: 'file_download',
              color: AppTheme.textSecondary,
              size: 20,
            ),
          ),
          SizedBox(width: 2.w),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search and Voice Input Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Column(
                children: [
                  SettingsSearchWidget(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                  SizedBox(height: 2.h),
                  VoiceInputWidget(
                    controller: _voiceInputController,
                    isActive: _isVoiceInputActive,
                    onToggle: () {
                      setState(() {
                        _isVoiceInputActive = !_isVoiceInputActive;
                      });
                    },
                    onSubmit: _processVoiceCommand,
                  ),
                ],
              ),
            ),

            // Settings Categories
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                itemCount: _getFilteredSettings().length,
                itemBuilder: (context, index) {
                  final categoryData = _getFilteredSettings()[index];
                  return SettingsCategoryWidget(
                    categoryData: categoryData,
                    onToggle: () => _toggleCategory(index),
                    onSettingChanged: _updateSetting,
                    onActionTap: (title) {
                      if (title.contains('Reset')) {
                        _showResetDialog(title);
                      } else if (title.contains('Performance Metrics')) {
                        Navigator.pushNamed(
                            context, '/system-control-panel-screen');
                      }
                    },
                  );
                },
              ),
            ),

            // Bottom Navigation Hint
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark.withValues(alpha: 0.8),
                border: Border(
                  top: BorderSide(color: AppTheme.borderColor),
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'info',
                    color: AppTheme.accentGlow,
                    size: 16,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'Long press any setting for voice command examples',
                      style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppTheme.surfaceDark,
        selectedItemColor: AppTheme.primaryCyan,
        unselectedItemColor: AppTheme.textSecondary,
        currentIndex: 5,
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'security',
              color: AppTheme.textSecondary,
              size: 24,
            ),
            label: 'Permissions',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'dashboard',
              color: AppTheme.textSecondary,
              size: 24,
            ),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'tune',
              color: AppTheme.textSecondary,
              size: 24,
            ),
            label: 'System',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'apps',
              color: AppTheme.textSecondary,
              size: 24,
            ),
            label: 'Apps',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'chat',
              color: AppTheme.textSecondary,
              size: 24,
            ),
            label: 'Communication',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'settings',
              color: AppTheme.primaryCyan,
              size: 24,
            ),
            label: 'Settings',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/permission-setup-screen');
              break;
            case 1:
              Navigator.pushNamed(context, '/voice-dashboard-screen');
              break;
            case 2:
              Navigator.pushNamed(context, '/system-control-panel-screen');
              break;
            case 3:
              Navigator.pushNamed(context, '/app-management-screen');
              break;
            case 4:
              Navigator.pushNamed(context, '/communication-hub-screen');
              break;
            case 5:
              // Current screen
              break;
          }
        },
      ),
    );
  }
}
