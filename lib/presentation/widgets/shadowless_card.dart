import '../../extensions/extensions.dart';
import 'package:flutter/material.dart';


class ShadowlessCard extends StatelessWidget {
  final Color? color;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final double? elevation;
  final ShapeBorder? shape;
  final bool borderOnForeground;
  final Clip? clipBehavior;
  final EdgeInsetsGeometry? margin;
  final bool semanticContainer;
  final double? opacity;
  final Widget? child;

  const ShadowlessCard({
    super.key,
    this.color,
    this.shadowColor,
    this.surfaceTintColor,
    this.elevation,
    this.shape,
    this.borderOnForeground = true,
    this.margin,
    this.clipBehavior,
    this.semanticContainer = true,
    this.opacity,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color ?? context.colorScheme.secondaryContainer.withOpacity(opacity ?? 0.3),
      elevation: elevation ?? 0,
      surfaceTintColor: surfaceTintColor,
      shadowColor: shadowColor,
      margin: margin,
      clipBehavior: clipBehavior ?? Clip.antiAlias,
      shape: shape,
      borderOnForeground: borderOnForeground,
      semanticContainer: semanticContainer,
      child: child,
    );
  }
}