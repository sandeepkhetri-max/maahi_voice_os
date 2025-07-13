import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/conversation_card_widget.dart';
import './widgets/emergency_contact_widget.dart';
import './widgets/voice_input_widget.dart';

class CommunicationHubScreen extends StatefulWidget {
  const CommunicationHubScreen({super.key});

  @override
  State<CommunicationHubScreen> createState() => _CommunicationHubScreenState();
}

class _CommunicationHubScreenState extends State<CommunicationHubScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedBottomNavIndex = 4; // Communication Hub is 5th tab (index 4)
  bool _isListening = false;
  bool _privacyMode = false;
  String _voiceCommand = '';

  // Mock data for conversations
  final List<Map<String, dynamic>> _conversations = [
    {
      "id": 1,
      "contactName": "Mom",
      "contactPhoto":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "lastMessage": "Beta, khana kha liya? Call me when you get home safely.",
      "timestamp": DateTime.now().subtract(const Duration(minutes: 15)),
      "unreadCount": 2,
      "messageType": "SMS",
      "isEmergencyContact": true,
      "phoneNumber": "+91 98765 43210"
    },
    {
      "id": 2,
      "contactName": "Rahul Sharma",
      "contactPhoto":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "lastMessage":
          "Boss, meeting ka time change ho gaya hai. 4 PM instead of 3 PM.",
      "timestamp": DateTime.now().subtract(const Duration(hours: 1)),
      "unreadCount": 0,
      "messageType": "WhatsApp",
      "isEmergencyContact": false,
      "phoneNumber": "+91 87654 32109"
    },
    {
      "id": 3,
      "contactName": "Priya Singh",
      "contactPhoto":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "lastMessage": "Happy Birthday! 🎉 Party tonight at 8 PM. Don't forget!",
      "timestamp": DateTime.now().subtract(const Duration(hours: 3)),
      "unreadCount": 1,
      "messageType": "WhatsApp",
      "isEmergencyContact": false,
      "phoneNumber": "+91 76543 21098"
    },
    {
      "id": 4,
      "contactName": "Papa",
      "contactPhoto":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "lastMessage":
          "Car ki service karwa li hai. Keys kitchen table pe rakhi hain.",
      "timestamp": DateTime.now().subtract(const Duration(hours: 5)),
      "unreadCount": 0,
      "messageType": "SMS",
      "isEmergencyContact": true,
      "phoneNumber": "+91 98765 43211"
    },
    {
      "id": 5,
      "contactName": "Office Group",
      "contactPhoto":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "lastMessage":
          "Team: Tomorrow's presentation slides ready hain. Review kar lena.",
      "timestamp": DateTime.now().subtract(const Duration(hours: 8)),
      "unreadCount": 3,
      "messageType": "WhatsApp",
      "isEmergencyContact": false,
      "phoneNumber": "+91 65432 10987"
    }
  ];

  final List<Map<String, dynamic>> _emergencyContacts = [
    {
      "name": "Mom",
      "phoneNumber": "+91 98765 43210",
      "photo":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "relationship": "Mother"
    },
    {
      "name": "Papa",
      "phoneNumber": "+91 98765 43211",
      "photo":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "relationship": "Father"
    },
    {
      "name": "Dr. Agarwal",
      "phoneNumber": "+91 98765 43212",
      "photo":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "relationship": "Doctor"
    }
  ];

  final List<Map<String, dynamic>> _recentCalls = [
    {
      "contactName": "Mom",
      "phoneNumber": "+91 98765 43210",
      "callType": "incoming",
      "timestamp": DateTime.now().subtract(const Duration(hours: 2)),
      "duration": "5:23"
    },
    {
      "contactName": "Rahul Sharma",
      "phoneNumber": "+91 87654 32109",
      "callType": "outgoing",
      "timestamp": DateTime.now().subtract(const Duration(hours: 4)),
      "duration": "12:45"
    },
    {
      "contactName": "Unknown",
      "phoneNumber": "+91 99999 88888",
      "callType": "missed",
      "timestamp": DateTime.now().subtract(const Duration(hours: 6)),
      "duration": "0:00"
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleVoiceCommand(String command) {
    setState(() {
      _voiceCommand = command;
    });

    // Process voice commands
    final lowerCommand = command.toLowerCase();

    if (lowerCommand.contains('read messages') ||
        lowerCommand.contains('check messages')) {
      _readMessages();
    } else if (lowerCommand.contains('call') &&
        lowerCommand.contains('emergency')) {
      _showEmergencyCallDialog();
    } else if (lowerCommand.contains('privacy mode')) {
      _togglePrivacyMode();
    } else if (lowerCommand.contains('reply to')) {
      _handleReplyCommand(command);
    }
  }

  void _readMessages() {
    if (_privacyMode) {
      _showSnackBar("Privacy mode is active. Message reading disabled.",
          isError: true);
      return;
    }

    final unreadMessages = _conversations
        .where((conv) => (conv["unreadCount"] as int) > 0)
        .toList();
    if (unreadMessages.isEmpty) {
      _showSnackBar("No unread messages, Boss.");
    } else {
      _showSnackBar("Reading ${unreadMessages.length} unread messages, Boss.");
      // Here you would integrate with TTS to read messages
    }
  }

  void _handleReplyCommand(String command) {
    // Extract contact name from command and show reply dialog
    _showVoiceReplyDialog("Mom"); // Example
  }

  void _togglePrivacyMode() {
    setState(() {
      _privacyMode = !_privacyMode;
    });
    _showSnackBar(_privacyMode
        ? "Privacy mode activated, Boss."
        : "Privacy mode deactivated, Boss.");
  }

  void _showEmergencyCallDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppTheme.borderColor),
        ),
        title: Text(
          'Emergency Call',
          style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.errorRed,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _emergencyContacts
              .map((contact) => ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(contact["photo"] as String),
                      radius: 20,
                    ),
                    title: Text(
                      contact["name"] as String,
                      style: AppTheme.darkTheme.textTheme.bodyLarge,
                    ),
                    subtitle: Text(
                      contact["relationship"] as String,
                      style: AppTheme.darkTheme.textTheme.bodySmall,
                    ),
                    trailing: CustomIconWidget(
                      iconName: 'phone',
                      color: AppTheme.successGreen,
                      size: 24,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _makeEmergencyCall(contact["phoneNumber"] as String,
                          contact["name"] as String);
                    },
                  ))
              .toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _makeEmergencyCall(String phoneNumber, String contactName) {
    _showSnackBar("Calling $contactName at $phoneNumber, Boss.");
    // Here you would integrate with phone calling functionality
  }

  void _showVoiceReplyDialog(String contactName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppTheme.borderColor),
        ),
        title: Text(
          'Voice Reply to $contactName',
          style: AppTheme.darkTheme.textTheme.titleLarge,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.backgroundBlack,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppTheme.primaryCyan.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: _isListening ? 'mic' : 'mic_off',
                    color: _isListening
                        ? AppTheme.successGreen
                        : AppTheme.textSecondary,
                    size: 24,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      _isListening
                          ? 'Listening...'
                          : 'Tap to start voice reply',
                      style: AppTheme.darkTheme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 2.h),
            if (_voiceCommand.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.primaryCyan.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Message: $_voiceCommand',
                  style: AppTheme.darkTheme.textTheme.bodyMedium,
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _voiceCommand.isNotEmpty
                ? () {
                    Navigator.pop(context);
                    _sendVoiceReply(contactName, _voiceCommand);
                  }
                : null,
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  void _sendVoiceReply(String contactName, String message) {
    _showSnackBar("Sending reply to $contactName: '$message', Boss.");
    // Here you would integrate with messaging APIs
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppTheme.errorRed : AppTheme.surfaceDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundBlack,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundBlack,
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _privacyMode ? AppTheme.errorRed : AppTheme.successGreen,
                boxShadow: [
                  BoxShadow(
                    color: (_privacyMode
                            ? AppTheme.errorRed
                            : AppTheme.successGreen)
                        .withValues(alpha: 0.3),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
            SizedBox(width: 2.w),
            Text(
              'Communication Hub',
              style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                color: AppTheme.primaryCyan,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            if (_privacyMode)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.errorRed.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.errorRed),
                ),
                child: Text(
                  'PRIVATE',
                  style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.errorRed,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => _togglePrivacyMode(),
            icon: CustomIconWidget(
              iconName: _privacyMode ? 'visibility_off' : 'visibility',
              color: _privacyMode ? AppTheme.errorRed : AppTheme.textSecondary,
              size: 24,
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.primaryCyan,
          labelColor: AppTheme.primaryCyan,
          unselectedLabelColor: AppTheme.textSecondary,
          tabs: const [
            Tab(text: 'Messages'),
            Tab(text: 'Calls'),
            Tab(text: 'Emergency'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Voice Input Section
          VoiceInputWidget(
            onVoiceCommand: _handleVoiceCommand,
            isListening: _isListening,
            onListeningChanged: (listening) =>
                setState(() => _isListening = listening),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMessagesTab(),
                _buildCallsTab(),
                _buildEmergencyTab(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildMessagesTab() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      itemCount: _conversations.length,
      itemBuilder: (context, index) {
        final conversation = _conversations[index];
        return ConversationCardWidget(
          conversation: conversation,
          onTap: () => _openConversation(conversation),
          onReply: () =>
              _showVoiceReplyDialog(conversation["contactName"] as String),
          onCall: () => _makeCall(conversation["phoneNumber"] as String,
              conversation["contactName"] as String),
        );
      },
    );
  }

  Widget _buildCallsTab() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      itemCount: _recentCalls.length,
      itemBuilder: (context, index) {
        final call = _recentCalls[index];
        return Card(
          margin: EdgeInsets.only(bottom: 2.h),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppTheme.primaryCyan.withValues(alpha: 0.2),
              child: CustomIconWidget(
                iconName: _getCallIcon(call["callType"] as String),
                color: _getCallColor(call["callType"] as String),
                size: 20,
              ),
            ),
            title: Text(
              call["contactName"] as String,
              style: AppTheme.darkTheme.textTheme.bodyLarge,
            ),
            subtitle: Text(
              '${call["phoneNumber"]} • ${_formatTimestamp(call["timestamp"] as DateTime)} • ${call["duration"]}',
              style: AppTheme.darkTheme.textTheme.bodySmall,
            ),
            trailing: IconButton(
              onPressed: () => _makeCall(
                  call["phoneNumber"] as String, call["contactName"] as String),
              icon: CustomIconWidget(
                iconName: 'phone',
                color: AppTheme.successGreen,
                size: 24,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmergencyTab() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Emergency Contacts',
            style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.errorRed,
            ),
          ),
          SizedBox(height: 2.h),
          Expanded(
            child: ListView.builder(
              itemCount: _emergencyContacts.length,
              itemBuilder: (context, index) {
                final contact = _emergencyContacts[index];
                return EmergencyContactWidget(
                  contact: contact,
                  onCall: () => _makeEmergencyCall(
                      contact["phoneNumber"] as String,
                      contact["name"] as String),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        border: Border(
          top: BorderSide(color: AppTheme.borderColor, width: 1),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedBottomNavIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: AppTheme.primaryCyan,
        unselectedItemColor: AppTheme.textSecondary,
        onTap: (index) {
          setState(() => _selectedBottomNavIndex = index);
          _navigateToScreen(index);
        },
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
                iconName: 'security', color: AppTheme.textSecondary, size: 24),
            activeIcon: CustomIconWidget(
                iconName: 'security', color: AppTheme.primaryCyan, size: 24),
            label: 'Permissions',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
                iconName: 'dashboard', color: AppTheme.textSecondary, size: 24),
            activeIcon: CustomIconWidget(
                iconName: 'dashboard', color: AppTheme.primaryCyan, size: 24),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
                iconName: 'settings', color: AppTheme.textSecondary, size: 24),
            activeIcon: CustomIconWidget(
                iconName: 'settings', color: AppTheme.primaryCyan, size: 24),
            label: 'System',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
                iconName: 'apps', color: AppTheme.textSecondary, size: 24),
            activeIcon: CustomIconWidget(
                iconName: 'apps', color: AppTheme.primaryCyan, size: 24),
            label: 'Apps',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
                iconName: 'message', color: AppTheme.textSecondary, size: 24),
            activeIcon: CustomIconWidget(
                iconName: 'message', color: AppTheme.primaryCyan, size: 24),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
                iconName: 'privacy_tip',
                color: AppTheme.textSecondary,
                size: 24),
            activeIcon: CustomIconWidget(
                iconName: 'privacy_tip', color: AppTheme.primaryCyan, size: 24),
            label: 'Privacy',
          ),
        ],
      ),
    );
  }

  void _navigateToScreen(int index) {
    final routes = [
      '/permission-setup-screen',
      '/voice-dashboard-screen',
      '/system-control-panel-screen',
      '/app-management-screen',
      '/communication-hub-screen',
      '/settings-and-privacy-screen',
    ];

    if (index < routes.length && index != _selectedBottomNavIndex) {
      Navigator.pushReplacementNamed(context, routes[index]);
    }
  }

  void _openConversation(Map<String, dynamic> conversation) {
    // Open detailed conversation view
    _showSnackBar(
        "Opening conversation with ${conversation["contactName"]}, Boss.");
  }

  void _makeCall(String phoneNumber, String contactName) {
    _showSnackBar("Calling $contactName at $phoneNumber, Boss.");
    // Here you would integrate with phone calling functionality
  }

  String _getCallIcon(String callType) {
    switch (callType) {
      case 'incoming':
        return 'call_received';
      case 'outgoing':
        return 'call_made';
      case 'missed':
        return 'call_missed';
      default:
        return 'phone';
    }
  }

  Color _getCallColor(String callType) {
    switch (callType) {
      case 'incoming':
        return AppTheme.successGreen;
      case 'outgoing':
        return AppTheme.primaryCyan;
      case 'missed':
        return AppTheme.errorRed;
      default:
        return AppTheme.textSecondary;
    }
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
