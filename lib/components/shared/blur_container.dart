import 'dart:ui';

import 'package:flutter/material.dart';

class BlurContainer extends StatelessWidget {
  const BlurContainer({
    Key? key,
    this.alignment,
    this.padding,
    this.decoration,
    this.foregroundDecoration,
    this.width,
    this.height,
    this.constraints,
    this.margin,
    this.transform,
    this.transformAlignment,
    this.child,
    this.clipBehavior = Clip.none,
    this.sigmaX = 5,
    this.sigmaY = 10,
    this.opacity = 0.95,
    this.color = const Color(0xFF1b1b1d),
  }) : super(key: key);

  final Widget? child;
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final double? width;
  final double? height;
  final Decoration? decoration;
  final Decoration? foregroundDecoration;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? margin;
  final Matrix4? transform;
  final AlignmentGeometry? transformAlignment;
  final Clip clipBehavior;
  final double sigmaX;
  final double sigmaY;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: sigmaX,
          sigmaY: sigmaY,
        ),
        child: Opacity(
          opacity: opacity,
          child: Container(
            color: color,
            alignment: alignment,
            padding: padding,
            width: width,
            height: height,
            decoration: decoration,
            foregroundDecoration: foregroundDecoration,
            constraints: constraints,
            margin: margin,
            transform: transform,
            transformAlignment: transformAlignment,
            clipBehavior: clipBehavior,
            child: child,
          ),
        ),
      ),
    );
  }
}
