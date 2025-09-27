import 'package:flutter/material.dart';

class ContentContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final bool hasTopRadius;

  const ContentContainer({
    super.key,
    required this.child,
    this.padding,
    this.hasTopRadius = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5F0),
        borderRadius: hasTopRadius
            ? const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              )
            : null,
      ),
      child: child,
    );
  }
}