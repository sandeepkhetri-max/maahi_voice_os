import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VoiceInputWidget extends StatefulWidget {
  final Function(String) onVoiceCommand;
  final bool isListening;
  final Function(bool) onListeningChanged;

  const VoiceInputWidget({
    super.key,
    required this.onVoiceCommand,
    required this.isListening,
    required this.onListeningChanged,
  });

  @override
  State<VoiceInputWidget> createState() => _VoiceInputWidgetState();
}

class _VoiceInputWidgetState extends State<VoiceInputWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _waveController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _waveAnimation;

  final TextEditingController _textController = TextEditingController();
  String _currentCommand = '';

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _waveController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _waveAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _waveController,
      curve: Curves.easeInOut,
    ));

    if (widget.isListening) {
      _startAnimations();
    }
  }

  @override
  void didUpdateWidget(VoiceInputWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isListening != oldWidget.isListening) {
      if (widget.isListening) {
        _startAnimations();
      } else {
        _stopAnimations();
      }
    }
  }

  void _startAnimations() {
    _pulseController.repeat(reverse: true);
    _waveController.repeat();
  }

  void _stopAnimations() {
    _pulseController.stop();
    _waveController.stop();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _waveController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _toggleListening() {
    widget.onListeningChanged(!widget.isListening);
    if (!widget.isListening) {
      // Simulate voice recognition
      _simulateVoiceInput();
    }
  }

  void _simulateVoiceInput() {
    // Simulate voice recognition with some example commands
    final commands = [
      'Read messages from Mom',
      'Call emergency contact',
      'Reply to last WhatsApp',
      'Check unread messages',
      'Enable privacy mode',
    ];

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        final command = commands[DateTime.now().millisecond % commands.length];
        setState(() {
          _currentCommand = command;
          _textController.text = command;
        });
        widget.onVoiceCommand(command);
        widget.onListeningChanged(false);
      }
    });
  }

  void _sendTextCommand() {
    if (_textController.text.isNotEmpty) {
      widget.onVoiceCommand(_textController.text);
      setState(() {
        _currentCommand = _textController.text;
      });
      _textController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color:
              widget.isListening ? AppTheme.primaryCyan : AppTheme.borderColor,
          width: widget.isListening ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowColor,
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
          if (widget.isListening)
            BoxShadow(
              color: AppTheme.primaryCyan.withValues(alpha: 0.2),
              blurRadius: 20,
              spreadRadius: 4,
            ),
        ],
      ),
      child: Column(
        children: [
          // Voice Command Header
          Row(
            children: [
              CustomIconWidget(
                iconName: 'record_voice_over',
                color: AppTheme.primaryCyan,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  'Voice Command Center',
                  style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.primaryCyan,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (widget.isListening)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.successGreen.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.successGreen),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppTheme.successGreen,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        'LISTENING',
                        style:
                            AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.successGreen,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          SizedBox(height: 3.h),

          // Voice Input Section
          Row(
            children: [
              // Voice Button with Animation
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: widget.isListening ? _pulseAnimation.value : 1.0,
                    child: Container(
                      width: 15.w,
                      height: 15.w,
                      decoration: BoxDecoration(
                        color: widget.isListening
                            ? AppTheme.successGreen
                            : AppTheme.primaryCyan,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: (widget.isListening
                                    ? AppTheme.successGreen
                                    : AppTheme.primaryCyan)
                                .withValues(alpha: 0.4),
                            blurRadius: widget.isListening ? 20 : 12,
                            spreadRadius: widget.isListening ? 5 : 2,
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _toggleListening,
                          borderRadius: BorderRadius.circular(50),
                          child: Center(
                            child: CustomIconWidget(
                              iconName: widget.isListening ? 'mic' : 'mic_none',
                              color: AppTheme.backgroundBlack,
                              size: 7.w,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              SizedBox(width: 4.w),

              // Text Input Field
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundBlack,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.borderColor),
                  ),
                  child: TextField(
                    controller: _textController,
                    style: AppTheme.darkTheme.textTheme.bodyMedium,
                    decoration: InputDecoration(
                      hintText: widget.isListening
                          ? 'Listening for voice command...'
                          : 'Type or speak your command',
                      hintStyle:
                          AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
                      suffixIcon: IconButton(
                        onPressed: _sendTextCommand,
                        icon: CustomIconWidget(
                          iconName: 'send',
                          color: AppTheme.primaryCyan,
                          size: 5.w,
                        ),
                      ),
                    ),
                    onSubmitted: (_) => _sendTextCommand(),
                    enabled: !widget.isListening,
                  ),
                ),
              ),
            ],
          ),

          // Voice Waveform Visualization
          if (widget.isListening) ...[
            SizedBox(height: 3.h),
            AnimatedBuilder(
              animation: _waveAnimation,
              builder: (context, child) {
                return Container(
                  height: 6.h,
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundBlack,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.primaryCyan.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(20, (index) {
                      final height = (1 +
                              (0.5 *
                                  (1 +
                                      math.sin(index * 0.1 +
                                          _waveAnimation.value * 2)))) *
                          3.h;
                      return Container(
                        width: 3,
                        height: height,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryCyan.withValues(
                            alpha: 0.3 +
                                (0.7 *
                                    (1 +
                                        math.sin(index * 0.2 +
                                            _waveAnimation.value * 3)) /
                                    2),
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      );
                    }),
                  ),
                );
              },
            ),
          ],

          // Current Command Display
          if (_currentCommand.isNotEmpty) ...[
            SizedBox(height: 2.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.primaryCyan.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppTheme.primaryCyan.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'check_circle',
                    color: AppTheme.successGreen,
                    size: 5.w,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'Command: $_currentCommand',
                      style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Quick Command Suggestions
          SizedBox(height: 2.h),
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: [
              _buildQuickCommand('Read messages'),
              _buildQuickCommand('Call emergency'),
              _buildQuickCommand('Privacy mode'),
              _buildQuickCommand('Check calls'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickCommand(String command) {
    return GestureDetector(
      onTap: () => widget.onVoiceCommand(command),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: AppTheme.borderColor,
          borderRadius: BorderRadius.circular(20),
          border:
              Border.all(color: AppTheme.textSecondary.withValues(alpha: 0.3)),
        ),
        child: Text(
          command,
          style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
      ),
    );
  }
}
