import 'package:one_context/src/components/one_context_widget.dart';
import 'package:one_context/src/controllers/dialog_controller.dart';
import 'package:one_context/src/controllers/navigator_controller.dart';
import 'package:one_context/src/controllers/overlay_controller.dart';
import 'package:flutter/material.dart';

class OneContext with NavigatorController, OverlayController, DialogController {
  BuildContext _context;

  /// The almost root context of the app,
  /// use it carefully or don't use it isolated!
  /// Warning: You are on your own right here
  BuildContext get context {
    assert(
        _context != null,
        'OneContext not initiated! please use builder method.'
        '\n\nYou need to use the OneContext().builder function to be able to show dialogs and overlays! e.g. ->'
        '\n\n MaterialApp(\n    builder: OneContext().builder,'
        '\n    ...'
        '\n )');
    return _context;
  }

  set context(newContext) => _context = newContext;

  MediaQueryData get mediaQuery => MediaQuery.of(context);
  ThemeData get theme => Theme.of(context);
  TextTheme get textTheme => theme.textTheme;
  FocusScopeNode get focusScope => FocusScope.of(context);

  OneContext._private();
  static OneContext instance = OneContext._private();
  factory OneContext() => instance;

  /// Register all necessary callbacks from main widget, automatically
  void registerDialogCallback(
      {DialogFuture showDialog,
      DialogModalSheet showModalBottomSheet,
      DialogSnackBar showSnackBar,
      DialogBottomSheet showBottomSheet}) {
    registerCallback(
      showDialog: showDialog,
      showSnackBar: showSnackBar,
      showModalBottomSheet: showModalBottomSheet,
      showBottomSheet: showBottomSheet,
    );
  }

  /// Use [OneContext().builder] in MaterialApp builder,
  /// in order to show dialogs and overlays.
  ///
  /// e.g.
  ///
  /// ```dart
  /// return MaterialApp(
  ///       builder: OneContext().builder,
  ///      ...
  /// ```
  Widget builder(BuildContext context, Widget widget,
          {Key key,
          MediaQueryData mediaQueryData,
          String initialRoute,
          Route<dynamic> Function(RouteSettings) onGenerateRoute,
          Route<dynamic> Function(RouteSettings) onUnknownRoute,
          List<NavigatorObserver> observers = const <NavigatorObserver>[]}) =>
      ParentContextWidget(
        child: widget,
        mediaQueryData: mediaQueryData,
        initialRoute: initialRoute,
        onGenerateRoute: onGenerateRoute,
        onUnknownRoute: onUnknownRoute,
        observers: observers,
      );
}

class ParentContextWidget extends StatelessWidget {
  final MediaQueryData mediaQueryData;
  final String initialRoute;
  final Route<dynamic> Function(RouteSettings) onGenerateRoute;
  final Route<dynamic> Function(RouteSettings) onUnknownRoute;
  final List<NavigatorObserver> observers;
  final Widget child;

  const ParentContextWidget(
      {Key key,
      this.child,
      this.mediaQueryData,
      this.initialRoute,
      this.onGenerateRoute,
      this.onUnknownRoute,
      this.observers = const <NavigatorObserver>[]})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: mediaQueryData ?? MediaQuery.of(context),
      child: Navigator(
        initialRoute: initialRoute,
        onUnknownRoute: onUnknownRoute,
        observers: observers,
        onGenerateRoute: onGenerateRoute ??
            (settings) => MaterialPageRoute(
                builder: (context) => OneContextWidget(
                      child: child,
                    )),
      ),
    );
  }
}
