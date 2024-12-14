import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../constants/default_values.dart';
import '../../extensions/extensions.dart';

class LikeButton extends StatefulWidget {
  const LikeButton({
    super.key,
    required this.isLiked,
    required this.likes,
    required this.onPressed,
    required this.icon,
    required this.iconColor,
  });

  final bool? isLiked;
  final int likes;
  final VoidCallback? onPressed;
  final IconData icon;
  final Color iconColor;

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: widget.onPressed == null
                    ? null
                    : () {
                        widget.onPressed!();
                        _controller.forward();
                      },
                child: ScaleTransition(
                  scale: _animation,
                  child: Icon(
                    widget.icon,
                    color: widget.iconColor,
                    size: 20.r,
                  ),
                ),
              );
            }),
        Gap(DefaultValues.spacing / 4),
        Text(
          NumberFormat.compact().format(widget.likes),
          style: context.textTheme.labelSmall,
        ),
      ],
    );
  }
}
