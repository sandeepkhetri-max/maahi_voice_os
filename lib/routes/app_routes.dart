import 'package:flutter/material.dart';

import '../presentation/app_management_screen/app_management_screen.dart';
import '../presentation/communication_hub_screen/communication_hub_screen.dart';
import '../presentation/permission_setup_screen/permission_setup_screen.dart';
import '../presentation/settings_and_privacy_screen/settings_and_privacy_screen.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/system_control_panel_screen/system_control_panel_screen.dart';
import '../presentation/voice_dashboard_screen/voice_dashboard_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String splashScreen = '/splash-screen';
  static const String permissionSetupScreen = '/permission-setup-screen';
  static const String settingsAndPrivacyScreen = '/settings-and-privacy-screen';
  static const String appManagementScreen = '/app-management-screen';
  static const String communicationHubScreen = '/communication-hub-screen';
  static const String systemControlPanelScreen = '/system-control-panel-screen';
  static const String voiceDashboardScreen = '/voice-dashboard-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splashScreen: (context) => const SplashScreen(),
    permissionSetupScreen: (context) => PermissionSetupScreen(),
    settingsAndPrivacyScreen: (context) => SettingsAndPrivacyScreen(),
    appManagementScreen: (context) => AppManagementScreen(),
    communicationHubScreen: (context) => CommunicationHubScreen(),
    systemControlPanelScreen: (context) => SystemControlPanelScreen(),
    voiceDashboardScreen: (context) => VoiceDashboardScreen(),
    // TODO: Add your other routes here
  };
}
