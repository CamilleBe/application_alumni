import 'package:flutter/widgets.dart';

/// Represents the standard layout breakpoints for the app, ensuring consistent
/// and adaptive design across different screen sizes.
abstract class Breakpoints {
  /// Defines the maximum width (in logical pixels) for a small layout.
  /// Typically used to determine when to switch from a mobile layout to a
  /// larger layout.
  static const double small = 760;

  /// Defines the maximum width (in logical pixels) for a medium layout.
  /// This might be used to differentiate between tablet and smaller desktop
  /// layouts.
  static const double medium = 1644;

  /// Defines the maximum width (in logical pixels) for a large layout.
  /// Represents full desktop layouts or larger screens, ensuring elements are
  /// appropriately spaced and proportioned.
  static const double large = 1920;
}

/// Signature for the individual builders (`small`, `large`, etc.).
typedef ResponsiveLayoutWidgetBuilder = Widget Function(BuildContext, Widget?);

/// {@template responsive_layout_builder}
/// A wrapper around [LayoutBuilder] which exposes builders for various
/// responsive breakpoints.
/// {@endtemplate}
class ResponsiveLayoutBuilder extends StatelessWidget {
  /// {@macro responsive_layout_builder}
  const ResponsiveLayoutBuilder({
    required this.small,
    required this.large,
    super.key,
    this.medium,
    this.xLarge,
    this.child,
  });

  /// [ResponsiveLayoutWidgetBuilder] for small layout.
  final ResponsiveLayoutWidgetBuilder small;

  /// [ResponsiveLayoutWidgetBuilder] for medium layout.
  final ResponsiveLayoutWidgetBuilder? medium;

  /// [ResponsiveLayoutWidgetBuilder] for large layout.
  final ResponsiveLayoutWidgetBuilder large;

  /// [ResponsiveLayoutWidgetBuilder] for xLarge layout.
  final ResponsiveLayoutWidgetBuilder? xLarge;

  /// Optional child widget which will be passed to the `small`, `large` and
  /// `xLarge` builders as a way to share/optimize shared layout.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth <= Breakpoints.small) {
          return small(context, child);
        } else if (constraints.maxWidth <= Breakpoints.medium) {
          return (medium ?? large).call(context, child);
        } else if (constraints.maxWidth <= Breakpoints.large) {
          return large(context, child);
        } else {
          return (xLarge ?? large).call(context, child);
        }
      },
    );
  }
}
