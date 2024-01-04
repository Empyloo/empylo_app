// Path: lib/ui/molecules/widgets/custom_containers.dart
import 'package:flutter/material.dart';

enum CustomContainerSize { small, medium, large }

class CustomContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Decoration? decoration;
  final CustomContainerSize? size;
  final double? height;
  final bool scrollable;

  const CustomContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.decoration,
    this.size,
    this.height,
    this.scrollable = false,
  });

  @override
  Widget build(BuildContext context) {
    const defaultPadding = EdgeInsets.all(16);
    const defaultMargin = EdgeInsets.symmetric(vertical: 8);
    final defaultDecoration = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          offset: Offset(0, 1),
          blurRadius: 2,
        ),
      ],
    );

    final screenWidth = MediaQuery.of(context).size.width;
    final screenSize = MediaQuery.of(context).size;

    double containerWidth;

    switch (size) {
      case CustomContainerSize.small:
        containerWidth = screenSize.width * 0.4;
        break;
      case CustomContainerSize.medium:
        containerWidth = screenSize.width * 0.6;
        break;
      case CustomContainerSize.large:
        containerWidth = screenSize.width * 0.8;
        break;
      default:
        containerWidth = screenWidth * 0.9;
        break;
    }

    Widget childContent = height != null ? child : child;

    if (scrollable && height == null) {
      childContent = LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: child,
            ),
          );
        },
      );
    }

    return Container(
      padding: padding ?? defaultPadding,
      margin: margin ?? defaultMargin,
      decoration: decoration ?? defaultDecoration,
      width: containerWidth,
      height: height,
      child: childContent,
    );
  }
}
