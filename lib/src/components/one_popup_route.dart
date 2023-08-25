import 'package:flutter/material.dart';

class DialogRoute extends PopupRoute {
  DialogRoute({
    this.barrierColor,
    this.barrierLabel,
    this.builder,
    bool? semanticsDismissible,
    RouteSettings? settings,
  }) : super(
          settings: settings,
        ) {
    _semanticsDismissible = semanticsDismissible;
  }

  final WidgetBuilder? builder;
  bool? _semanticsDismissible;

  @override
  final String? barrierLabel;

  @override
  final Color? barrierColor;

  @override
  bool get barrierDismissible => true;

  @override
  bool get semanticsDismissible => _semanticsDismissible ?? false;

  @override
  Duration get transitionDuration => Duration(milliseconds: 300);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return builder!(context);
  }
}
