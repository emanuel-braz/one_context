import 'package:flutter/foundation.dart';
import 'package:one_context/src/components/one_context_widget.dart';
import 'package:one_context/src/controllers/dialog_controller.mixin.dart';
import 'package:one_context/src/controllers/navigator_controller.mixin.dart';
import 'package:one_context/src/controllers/one_notification_controller.dart';
import 'package:one_context/src/controllers/overlay_controller.mixin.dart';
import 'package:flutter/material.dart';
import 'package:one_context/src/controllers/one_theme_controller.dart';

class OneContext with NavigatorController, OverlayController, DialogController {
  BuildContext _context;

  /// The almost top root context of the app,
  /// use it carefully or don't use it directly!
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

  // MediaQuery, Theme and FocusScope
  MediaQueryData get mediaQuery => MediaQuery.of(context);
  ThemeData get theme => Theme.of(context);
  TextTheme get textTheme => theme.textTheme;
  FocusScopeNode get focusScope => FocusScope.of(context);

  // Locale
  Locale get locale => Localizations.localeOf(context);

  // ThemeMode and ThemeData
  ThemeMode get themeMode => oneTheme.themeMode;
  ThemeData get themeData => oneTheme.themeData;
  ThemeData get darkThemeData => oneTheme.darkThemeData;

  // Notifiers
  OneNotificationController oneNotifier;
  OneThemeController oneTheme;

  OneContext._private() {
    oneNotifier = OneNotificationController();
    oneTheme = OneThemeController();
  }

  static OneContext instance = OneContext._private();
  factory OneContext() => instance;

  /// Register all necessary callbacks from main widget, automatically
  void registerDialogCallback({
    Future<T> Function<T>(
            {bool barrierDismissible,
            Widget Function(BuildContext) builder,
            bool useRootNavigator})
        showDialog,
    Future<T> Function<T>(
            {Widget Function(BuildContext) builder,
            Color backgroundColor,
            double elevation,
            ShapeBorder shape,
            Clip clipBehavior,
            bool isScrollControlled,
            bool useRootNavigator,
            bool isDismissible})
        showModalBottomSheet,
    ScaffoldFeatureController<SnackBar, SnackBarClosedReason> Function(
            SnackBar Function(BuildContext) builder)
        showSnackBar,
    PersistentBottomSheetController<T> Function<T>(
            {Widget Function(BuildContext) builder,
            Color backgroundColor,
            double elevation,
            ShapeBorder shape,
            Clip clipBehavior})
        showBottomSheet,
  }) {
    registerCallback(
        showDialog: showDialog,
        showSnackBar: showSnackBar,
        showModalBottomSheet: showModalBottomSheet,
        showBottomSheet: showBottomSheet);
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
