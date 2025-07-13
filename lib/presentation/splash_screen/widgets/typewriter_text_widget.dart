import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class TypewriterTextWidget extends StatefulWidget {
  final String text;
  final Duration duration;

  const TypewriterTextWidget({
    Key? key,
    required this.text,
    this.duration = const Duration(milliseconds: 100),
  }) : super(key: key);

  @override
  State<TypewriterTextWidget> createState() => _TypewriterTextWidgetState();
}

class _TypewriterTextWidgetState extends State<TypewriterTextWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _characterAnimation;
  String _currentText = '';

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: widget.text.length * 80),
      vsync: this,
    );

    _characterAnimation = IntTween(
      begin: 0,
      end: widget.text.length,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward();
  }

  @override
  void didUpdateWidget(TypewriterTextWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.text != widget.text) {
      _controller.reset();
      _characterAnimation = IntTween(
        begin: 0,
        end: widget.text.length,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ));
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _characterAnimation,
      builder: (context, child) {
        _currentText = widget.text.substring(0, _characterAnimation.value);

        return Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark.withAlpha(77),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: AppTheme.primaryCyan.withAlpha(51),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Terminal-style prefix
                Text(
                  '> ',
                  style: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
                    color: AppTheme.successGreen,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // Typewriter text
                Flexible(
                  child: Text(
                    _currentText,
                    style: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
                      color: AppTheme.textPrimary,
                      fontFamily: 'monospace',
                      letterSpacing: 1.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                // Blinking cursor
                _buildBlinkingCursor(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBlinkingCursor() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return AnimatedOpacity(
          opacity: (_controller.value * 4) % 1 > 0.5 ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 100),
          child: Text(
            '█',
            style: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
              color: AppTheme.primaryCyan,
              fontFamily: 'monospace',
            ),
          ),
        );
      },
    );
  }
}
