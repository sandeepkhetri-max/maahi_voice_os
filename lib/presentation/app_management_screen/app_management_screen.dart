import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/app_card_widget.dart';
import './widgets/batch_operations_widget.dart';
import './widgets/filter_chips_widget.dart';
import './widgets/voice_search_bar_widget.dart';

class AppManagementScreen extends StatefulWidget {
  const AppManagementScreen({super.key});

  @override
  State<AppManagementScreen> createState() => _AppManagementScreenState();
}

class _AppManagementScreenState extends State<AppManagementScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Recently Used';
  bool _isSystemAppsExpanded = false;
  bool _isListening = false;
  List<String> _selectedApps = [];
  bool _isBatchMode = false;

  // Mock app data
  final List<Map<String, dynamic>> _installedApps = [
    {
      "id": "com.whatsapp",
      "name": "WhatsApp",
      "icon":
          "https://upload.wikimedia.org/wikipedia/commons/6/6b/WhatsApp.svg",
      "status": "running",
      "category": "Communication",
      "size": "156 MB",
      "lastUsed": DateTime.now().subtract(const Duration(minutes: 15)),
      "screenTime": "2h 45m",
      "batteryUsage": "12%",
      "isSystemApp": false,
    },
    {
      "id": "com.instagram.android",
      "name": "Instagram",
      "icon":
          "https://upload.wikimedia.org/wikipedia/commons/a/a5/Instagram_icon.png",
      "status": "frozen",
      "category": "Social",
      "size": "89 MB",
      "lastUsed": DateTime.now().subtract(const Duration(hours: 2)),
      "screenTime": "1h 23m",
      "batteryUsage": "8%",
      "isSystemApp": false,
    },
    {
      "id": "com.spotify.music",
      "name": "Spotify",
      "icon":
          "https://upload.wikimedia.org/wikipedia/commons/1/19/Spotify_logo_without_text.svg",
      "status": "recently_used",
      "category": "Music",
      "size": "67 MB",
      "lastUsed": DateTime.now().subtract(const Duration(hours: 1)),
      "screenTime": "3h 12m",
      "batteryUsage": "15%",
      "isSystemApp": false,
    },
    {
      "id": "com.google.android.youtube",
      "name": "YouTube",
      "icon":
          "https://upload.wikimedia.org/wikipedia/commons/0/09/YouTube_full-color_icon_%282017%29.svg",
      "status": "running",
      "category": "Entertainment",
      "size": "234 MB",
      "lastUsed": DateTime.now().subtract(const Duration(minutes: 30)),
      "screenTime": "4h 56m",
      "batteryUsage": "22%",
      "isSystemApp": false,
    },
    {
      "id": "com.google.android.gms",
      "name": "Google Play Services",
      "icon":
          "https://upload.wikimedia.org/wikipedia/commons/c/c1/Google_%22G%22_logo.svg",
      "status": "running",
      "category": "System",
      "size": "512 MB",
      "lastUsed": DateTime.now(),
      "screenTime": "Always Active",
      "batteryUsage": "5%",
      "isSystemApp": true,
    },
    {
      "id": "com.android.settings",
      "name": "Settings",
      "icon":
          "https://upload.wikimedia.org/wikipedia/commons/6/6d/Android_settings_icon.svg",
      "status": "recently_used",
      "category": "System",
      "size": "45 MB",
      "lastUsed": DateTime.now().subtract(const Duration(hours: 3)),
      "screenTime": "15m",
      "batteryUsage": "1%",
      "isSystemApp": true,
    },
    {
      "id": "com.netflix.mediaclient",
      "name": "Netflix",
      "icon":
          "https://upload.wikimedia.org/wikipedia/commons/0/08/Netflix_2015_logo.svg",
      "status": "frozen",
      "category": "Entertainment",
      "size": "178 MB",
      "lastUsed": DateTime.now().subtract(const Duration(days: 2)),
      "screenTime": "45m",
      "batteryUsage": "3%",
      "isSystemApp": false,
    },
    {
      "id": "com.amazon.mShop.android.shopping",
      "name": "Amazon",
      "icon":
          "https://upload.wikimedia.org/wikipedia/commons/a/a9/Amazon_logo.svg",
      "status": "recently_used",
      "category": "Shopping",
      "size": "123 MB",
      "lastUsed": DateTime.now().subtract(const Duration(hours: 6)),
      "screenTime": "1h 8m",
      "batteryUsage": "4%",
      "isSystemApp": false,
    },
  ];

  final List<String> _filterOptions = [
    'Recently Used',
    'Alphabetical',
    'Size',
    'Category'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredApps {
    List<Map<String, dynamic>> apps =
        _installedApps.where((app) => !(app['isSystemApp'] as bool)).toList();

    // Apply search filter
    if (_searchController.text.isNotEmpty) {
      apps = apps
          .where((app) => (app['name'] as String)
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();
    }

    // Apply sorting
    switch (_selectedFilter) {
      case 'Recently Used':
        apps.sort((a, b) =>
            (b['lastUsed'] as DateTime).compareTo(a['lastUsed'] as DateTime));
        break;
      case 'Alphabetical':
        apps.sort(
            (a, b) => (a['name'] as String).compareTo(b['name'] as String));
        break;
      case 'Size':
        apps.sort((a, b) {
          final sizeA = _parseSizeToMB(a['size'] as String);
          final sizeB = _parseSizeToMB(b['size'] as String);
          return sizeB.compareTo(sizeA);
        });
        break;
      case 'Category':
        apps.sort((a, b) =>
            (a['category'] as String).compareTo(b['category'] as String));
        break;
    }

    return apps;
  }

  List<Map<String, dynamic>> get _systemApps {
    return _installedApps.where((app) => app['isSystemApp'] as bool).toList();
  }

  double _parseSizeToMB(String size) {
    final numStr = size.replaceAll(RegExp(r'[^0-9.]'), '');
    final num = double.tryParse(numStr) ?? 0;
    if (size.contains('GB')) {
      return num * 1024;
    }
    return num;
  }

  void _onAppSelected(String appId) {
    setState(() {
      if (_selectedApps.contains(appId)) {
        _selectedApps.remove(appId);
      } else {
        _selectedApps.add(appId);
      }
    });
  }

  void _toggleBatchMode() {
    setState(() {
      _isBatchMode = !_isBatchMode;
      if (!_isBatchMode) {
        _selectedApps.clear();
      }
    });
  }

  void _onAppAction(String appId, String action) {
    final app = _installedApps.firstWhere((app) => app['id'] == appId);

    switch (action) {
      case 'launch':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Launching ${app['name']}...'),
            backgroundColor: AppTheme.successGreen,
          ),
        );
        break;
      case 'uninstall':
        _showUninstallDialog(app);
        break;
      case 'force_stop':
        setState(() {
          app['status'] = 'frozen';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${app['name']} force stopped'),
            backgroundColor: AppTheme.warningAmber,
          ),
        );
        break;
      case 'app_info':
        _showAppInfoDialog(app);
        break;
      case 'freeze':
        setState(() {
          app['status'] =
              app['status'] == 'frozen' ? 'recently_used' : 'frozen';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '${app['name']} ${app['status'] == 'frozen' ? 'frozen' : 'unfrozen'}'),
            backgroundColor: AppTheme.primaryCyan,
          ),
        );
        break;
    }
  }

  void _showUninstallDialog(Map<String, dynamic> app) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Uninstall ${app['name']}?'),
        content:
            Text('This action cannot be undone. All app data will be lost.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _installedApps.removeWhere((a) => a['id'] == app['id']);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${app['name']} uninstalled'),
                  backgroundColor: AppTheme.errorRed,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorRed,
            ),
            child: const Text('Uninstall'),
          ),
        ],
      ),
    );
  }

  void _showAppInfoDialog(Map<String, dynamic> app) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(app['name'] as String),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Package: ${app['id']}'),
            SizedBox(height: 1.h),
            Text('Size: ${app['size']}'),
            SizedBox(height: 1.h),
            Text('Category: ${app['category']}'),
            SizedBox(height: 1.h),
            Text('Screen Time: ${app['screenTime']}'),
            SizedBox(height: 1.h),
            Text('Battery Usage: ${app['batteryUsage']}'),
            SizedBox(height: 1.h),
            Text('Status: ${app['status']}'),
          ],
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

  Future<void> _refreshApps() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      // Simulate refresh by updating last used times
      for (var app in _installedApps) {
        if (app['status'] == 'running') {
          app['lastUsed'] = DateTime.now();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundBlack,
      body: SafeArea(
        child: Column(
          children: [
            // Header with voice search
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                border: Border(
                  bottom: BorderSide(
                    color: AppTheme.borderColor,
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: CustomIconWidget(
                          iconName: 'arrow_back',
                          color: AppTheme.primaryCyan,
                          size: 6.w,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'App Management',
                          style: AppTheme.darkTheme.textTheme.headlineSmall
                              ?.copyWith(
                            color: AppTheme.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      IconButton(
                        onPressed: _toggleBatchMode,
                        icon: CustomIconWidget(
                          iconName: _isBatchMode ? 'close' : 'checklist',
                          color: _isBatchMode
                              ? AppTheme.errorRed
                              : AppTheme.primaryCyan,
                          size: 6.w,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  VoiceSearchBarWidget(
                    controller: _searchController,
                    isListening: _isListening,
                    onVoicePressed: () {
                      setState(() {
                        _isListening = !_isListening;
                      });
                    },
                    onSearchChanged: (value) {
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 2.h),
                  FilterChipsWidget(
                    options: _filterOptions,
                    selectedFilter: _selectedFilter,
                    onFilterChanged: (filter) {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                  ),
                ],
              ),
            ),

            // App list
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshApps,
                color: AppTheme.primaryCyan,
                backgroundColor: AppTheme.surfaceDark,
                child: CustomScrollView(
                  slivers: [
                    // Regular apps
                    SliverPadding(
                      padding: EdgeInsets.all(4.w),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 3.w,
                          mainAxisSpacing: 3.w,
                          childAspectRatio: 0.8,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final app = _filteredApps[index];
                            return AppCardWidget(
                              app: app,
                              isSelected: _selectedApps.contains(app['id']),
                              isBatchMode: _isBatchMode,
                              onTap: () {
                                if (_isBatchMode) {
                                  _onAppSelected(app['id'] as String);
                                } else {
                                  _onAppAction(app['id'] as String, 'launch');
                                }
                              },
                              onLongPress: () {
                                if (!_isBatchMode) {
                                  _showAppContextMenu(app);
                                }
                              },
                              onSwipeRight: () =>
                                  _onAppAction(app['id'] as String, 'launch'),
                              onSwipeLeft: () => _onAppAction(
                                  app['id'] as String, 'uninstall'),
                            );
                          },
                          childCount: _filteredApps.length,
                        ),
                      ),
                    ),

                    // System apps section
                    SliverToBoxAdapter(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 4.w),
                        child: ExpansionTile(
                          title: Text(
                            'System Apps (${_systemApps.length})',
                            style: AppTheme.darkTheme.textTheme.titleMedium
                                ?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          leading: CustomIconWidget(
                            iconName: 'settings',
                            color: AppTheme.textSecondary,
                            size: 5.w,
                          ),
                          iconColor: AppTheme.textSecondary,
                          collapsedIconColor: AppTheme.textSecondary,
                          initiallyExpanded: _isSystemAppsExpanded,
                          onExpansionChanged: (expanded) {
                            setState(() {
                              _isSystemAppsExpanded = expanded;
                            });
                          },
                          children: [
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.all(2.w),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 3.w,
                                mainAxisSpacing: 3.w,
                                childAspectRatio: 0.8,
                              ),
                              itemCount: _systemApps.length,
                              itemBuilder: (context, index) {
                                final app = _systemApps[index];
                                return AppCardWidget(
                                  app: app,
                                  isSelected: false,
                                  isBatchMode: false,
                                  isSystemApp: true,
                                  onTap: () => _showAppInfoDialog(app),
                                  onLongPress: () {},
                                  onSwipeRight: () {},
                                  onSwipeLeft: () {},
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Empty state
                    if (_filteredApps.isEmpty)
                      SliverFillRemaining(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomIconWidget(
                                iconName: 'search_off',
                                color: AppTheme.textSecondary,
                                size: 15.w,
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                'No apps found',
                                style: AppTheme.darkTheme.textTheme.titleLarge
                                    ?.copyWith(
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                              SizedBox(height: 1.h),
                              Text(
                                'Try adjusting your search or filters',
                                style: AppTheme.darkTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color: AppTheme.textDisabled,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Bottom navigation
            Container(
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                border: Border(
                  top: BorderSide(
                    color: AppTheme.borderColor,
                    width: 1,
                  ),
                ),
              ),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.transparent,
                elevation: 0,
                selectedItemColor: AppTheme.primaryCyan,
                unselectedItemColor: AppTheme.textSecondary,
                currentIndex: 3,
                onTap: (index) {
                  switch (index) {
                    case 0:
                      Navigator.pushReplacementNamed(
                          context, '/permission-setup-screen');
                      break;
                    case 1:
                      Navigator.pushReplacementNamed(
                          context, '/voice-dashboard-screen');
                      break;
                    case 2:
                      Navigator.pushReplacementNamed(
                          context, '/system-control-panel-screen');
                      break;
                    case 3:
                      // Current screen
                      break;
                    case 4:
                      Navigator.pushReplacementNamed(
                          context, '/communication-hub-screen');
                      break;
                    case 5:
                      Navigator.pushReplacementNamed(
                          context, '/settings-and-privacy-screen');
                      break;
                  }
                },
                items: [
                  BottomNavigationBarItem(
                    icon: CustomIconWidget(
                      iconName: 'security',
                      color: AppTheme.textSecondary,
                      size: 5.w,
                    ),
                    activeIcon: CustomIconWidget(
                      iconName: 'security',
                      color: AppTheme.primaryCyan,
                      size: 5.w,
                    ),
                    label: 'Permissions',
                  ),
                  BottomNavigationBarItem(
                    icon: CustomIconWidget(
                      iconName: 'dashboard',
                      color: AppTheme.textSecondary,
                      size: 5.w,
                    ),
                    activeIcon: CustomIconWidget(
                      iconName: 'dashboard',
                      color: AppTheme.primaryCyan,
                      size: 5.w,
                    ),
                    label: 'Dashboard',
                  ),
                  BottomNavigationBarItem(
                    icon: CustomIconWidget(
                      iconName: 'tune',
                      color: AppTheme.textSecondary,
                      size: 5.w,
                    ),
                    activeIcon: CustomIconWidget(
                      iconName: 'tune',
                      color: AppTheme.primaryCyan,
                      size: 5.w,
                    ),
                    label: 'Control',
                  ),
                  BottomNavigationBarItem(
                    icon: CustomIconWidget(
                      iconName: 'apps',
                      color: AppTheme.primaryCyan,
                      size: 5.w,
                    ),
                    activeIcon: CustomIconWidget(
                      iconName: 'apps',
                      color: AppTheme.primaryCyan,
                      size: 5.w,
                    ),
                    label: 'Apps',
                  ),
                  BottomNavigationBarItem(
                    icon: CustomIconWidget(
                      iconName: 'chat',
                      color: AppTheme.textSecondary,
                      size: 5.w,
                    ),
                    activeIcon: CustomIconWidget(
                      iconName: 'chat',
                      color: AppTheme.primaryCyan,
                      size: 5.w,
                    ),
                    label: 'Communication',
                  ),
                  BottomNavigationBarItem(
                    icon: CustomIconWidget(
                      iconName: 'settings',
                      color: AppTheme.textSecondary,
                      size: 5.w,
                    ),
                    activeIcon: CustomIconWidget(
                      iconName: 'settings',
                      color: AppTheme.primaryCyan,
                      size: 5.w,
                    ),
                    label: 'Settings',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _isBatchMode && _selectedApps.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => BatchOperationsWidget(
                    selectedApps: _selectedApps,
                    apps: _installedApps,
                    onOperationComplete: () {
                      setState(() {
                        _selectedApps.clear();
                        _isBatchMode = false;
                      });
                    },
                  ),
                );
              },
              backgroundColor: AppTheme.primaryCyan,
              foregroundColor: AppTheme.backgroundBlack,
              label: Text('${_selectedApps.length} Selected'),
              icon: CustomIconWidget(
                iconName: 'build',
                color: AppTheme.backgroundBlack,
                size: 5.w,
              ),
            )
          : FloatingActionButton(
              onPressed: () {
                setState(() {
                  _isListening = !_isListening;
                });
              },
              backgroundColor:
                  _isListening ? AppTheme.errorRed : AppTheme.primaryCyan,
              child: CustomIconWidget(
                iconName: _isListening ? 'mic' : 'mic_none',
                color: AppTheme.backgroundBlack,
                size: 6.w,
              ),
            ),
    );
  }

  void _showAppContextMenu(Map<String, dynamic> app) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.surfaceDark,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: AppTheme.borderColor),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.borderColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                children: [
                  Row(
                    children: [
                      CustomImageWidget(
                        imageUrl: app['icon'] as String,
                        width: 12.w,
                        height: 12.w,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              app['name'] as String,
                              style: AppTheme.darkTheme.textTheme.titleMedium
                                  ?.copyWith(
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            Text(
                              app['category'] as String,
                              style: AppTheme.darkTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3.h),
                  _buildContextMenuItem(
                    icon: 'launch',
                    title: 'Launch App',
                    onTap: () {
                      Navigator.pop(context);
                      _onAppAction(app['id'] as String, 'launch');
                    },
                  ),
                  _buildContextMenuItem(
                    icon: 'stop',
                    title: 'Force Stop',
                    onTap: () {
                      Navigator.pop(context);
                      _onAppAction(app['id'] as String, 'force_stop');
                    },
                  ),
                  _buildContextMenuItem(
                    icon: app['status'] == 'frozen' ? 'play_arrow' : 'pause',
                    title: app['status'] == 'frozen' ? 'Unfreeze' : 'Freeze',
                    onTap: () {
                      Navigator.pop(context);
                      _onAppAction(app['id'] as String, 'freeze');
                    },
                  ),
                  _buildContextMenuItem(
                    icon: 'info',
                    title: 'App Info',
                    onTap: () {
                      Navigator.pop(context);
                      _onAppAction(app['id'] as String, 'app_info');
                    },
                  ),
                  if (!(app['isSystemApp'] as bool))
                    _buildContextMenuItem(
                      icon: 'delete',
                      title: 'Uninstall',
                      isDestructive: true,
                      onTap: () {
                        Navigator.pop(context);
                        _onAppAction(app['id'] as String, 'uninstall');
                      },
                    ),
                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContextMenuItem({
    required String icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: icon,
        color: isDestructive ? AppTheme.errorRed : AppTheme.primaryCyan,
        size: 5.w,
      ),
      title: Text(
        title,
        style: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
          color: isDestructive ? AppTheme.errorRed : AppTheme.textPrimary,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
