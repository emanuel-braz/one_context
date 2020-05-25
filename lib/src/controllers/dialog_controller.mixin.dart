import 'package:one_context/src/controllers/one_context.dart';
import 'package:flutter/material.dart';

typedef Widget DialogBuilder(BuildContext context);

mixin DialogController {
  /// Return dialog utility class `DialogController`
  DialogController get dialog => this;

  BuildContext get context => OneContext().context;

  Future<T> Function<T>(
      {bool barrierDismissible,
      Widget Function(BuildContext) builder,
      bool useRootNavigator}) _showDialog;
  Future<T> Function<T>(
      {Widget Function(BuildContext) builder,
      Color backgroundColor,
      double elevation,
      ShapeBorder shape,
      Clip clipBehavior,
      bool isScrollControlled,
      bool useRootNavigator,
      bool isDismissible}) _showModalBottomSheet;
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> Function(
      SnackBar Function(BuildContext) builder) _showSnackBar;
  PersistentBottomSheetController<T> Function<T>(
      {Widget Function(BuildContext) builder,
      Color backgroundColor,
      double elevation,
      ShapeBorder shape,
      Clip clipBehavior}) _showBottomSheet;

  /// Displays a Material dialog above the current contents of the app, with
  /// Material entrance and exit animations, modal barrier color, and modal
  /// barrier behavior (dialog is dismissible with a tap on the barrier).
  Future<T> showDialog<T>(
      {@required Widget Function(BuildContext) builder,
      bool barrierDismissible = true,
      bool useRootNavigator = true}) {
    assert(builder != null);

    return _showDialog<T>(
      builder: builder,
      barrierDismissible: barrierDismissible,
      useRootNavigator: useRootNavigator,
    );
  }

  /// Dismiss a [SnackBar] at the bottom of the scaffold.
  void dismissSnackBar() => Scaffold.of(context).hideCurrentSnackBar();

  /// Shows a [SnackBar] at the bottom of the scaffold.
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
      {@required SnackBar Function(BuildContext) builder}) {
    assert(builder != null);
    return _showSnackBar(builder);
  }

  /// Shows a modal material design bottom sheet.
  ///
  /// A modal bottom sheet is an alternative to a menu or a dialog and prevents
  /// the user from interacting with the rest of the app.
  Future<T> showModalBottomSheet<T>(
      {@required Widget Function(BuildContext) builder,
      Color backgroundColor,
      double elevation,
      ShapeBorder shape,
      Clip clipBehavior,
      bool isScrollControlled = false,
      bool useRootNavigator = false,
      bool isDismissible = true}) {
    assert(builder != null);
    return _showModalBottomSheet<T>(
        builder: builder,
        backgroundColor: backgroundColor,
        clipBehavior: clipBehavior,
        elevation: elevation,
        isDismissible: isDismissible,
        isScrollControlled: isScrollControlled,
        shape: shape,
        useRootNavigator: useRootNavigator);
  }

  /// Shows a material design bottom sheet in the nearest [Scaffold] ancestor. If
  /// you wish to show a persistent bottom sheet, use [Scaffold.bottomSheet].
  ///
  /// Returns a controller that can be used to close and otherwise manipulate the
  /// bottom sheet.
  PersistentBottomSheetController<T> showBottomSheet<T>(
      {@required Widget Function(BuildContext) builder,
      Color backgroundColor,
      double elevation,
      ShapeBorder shape,
      Clip clipBehavior}) {
    assert(builder != null);
    return _showBottomSheet<T>(
        builder: builder,
        backgroundColor: backgroundColor,
        elevation: elevation,
        shape: shape,
        clipBehavior: clipBehavior);
  }

  /// Register callbacks
  void registerCallback(
      {Future<T> Function<T>(
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
          showBottomSheet}) {
    _showDialog = showDialog;
    _showDialog = showDialog;
    _showSnackBar = showSnackBar;
    _showModalBottomSheet = showModalBottomSheet;
    _showBottomSheet = showBottomSheet;
  }

  /// Pop the top-most dialog off the OneContext.dialog.
  popDialog<T extends Object>([T result]) {
    return Navigator.of(context).pop<T>(result);
  }
}
