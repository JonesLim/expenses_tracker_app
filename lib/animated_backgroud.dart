import 'package:flutter/material.dart';

class AnimatedBackground extends StatefulWidget {
  final ValueChanged<Color?> onColorChanged;

  const AnimatedBackground({super.key, required this.onColorChanged});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _colorAnimation = ColorTween(
      begin: const Color(0xff5E6472),
      end: const Color(0xffB5A5D4),
    ).animate(_controller);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onColorChanged(_colorAnimation.value);
    });

    _colorAnimation.addListener(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onColorChanged(_colorAnimation.value);
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _colorAnimation.value ?? Colors.transparent,
                _colorAnimation.value?.withOpacity(0.5) ?? Colors.transparent,
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        );
      },
    );
  }
}
