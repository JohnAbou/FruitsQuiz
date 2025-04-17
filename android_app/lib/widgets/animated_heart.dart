import 'package:flutter/material.dart';


class AnimatedHeartbeatIcon extends StatefulWidget {
  final IconData icon;
  final Color color;
  final bool animate;

  const AnimatedHeartbeatIcon({
    super.key,
    required this.icon,
    this.color = Colors.white,
    this.animate = false,
  });

  @override
  State<AnimatedHeartbeatIcon> createState() => _AnimatedHeartbeatIconState();
}

class _AnimatedHeartbeatIconState extends State<AnimatedHeartbeatIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _scale = Tween(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (!widget.animate) {
      _controller.stop();
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedHeartbeatIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate != oldWidget.animate) {
      widget.animate ? _controller.repeat(reverse: true) : _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: widget.animate ? _scale : const AlwaysStoppedAnimation(1.0),
      child: Icon(
        widget.icon,
        color: widget.color,
        size: 26,
      ),
    );
  }
}
