import 'package:one_context/src/controllers/one_context.dart';
import 'package:flutter/material.dart';

typedef Future<T> DialogFuture<T>(
    {bool barrierDismissible,
    Widget Function(BuildContext) builder,
    bool useRootNavigator});
typedef Future<T> DialogModalSheet<T>(
    {Widget Function(BuildContext) builder,
    Color backgroundColor,
    double elevation,
    ShapeBorder shape,
    Clip clipBehavior,
    bool isScrollControlled,
    bool useRootNavigator,
    bool isDismissible});
typedef Widget DialogBuilder(BuildContext context);
typedef ScaffoldFeatureController<SnackBar, SnackBarClosedReason> DialogSnackBar(
    SnackBar Function(BuildContext) builder);
typedef PersistentBottomSheetController<T> DialogBottomSheet<T>(
    {Widget Function(BuildContext) builder,
    Color backgroundColor,
    double elevation,
    ShapeBorder shape,
    Clip clipBehavior});

mixin DialogController {
  /// Return dialog utility class `DialogController`
  DialogController get dialog => this;

  BuildContext get context => OneContext().context;

  DialogFuture _showDialog;
  DialogModalSheet _showModalBottomSheet;
  DialogSnackBar _showSnackBar;
  DialogBottomSheet _showBottomSheet;

  /// Displays a Material dialog above the current contents of the app, with
  /// Material entrance and exit animations, modal barrier color, and modal
  /// barrier behavior (dialog is dismissible with a tap on the barrier).
  Future<T> showDialog<T>(
      {@required Widget Function(BuildContext) builder,
      bool barrierDismissible = true,
      bool useRootNavigator = true}) async {
    assert(builder != null);
    return await _showDialog(
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
      bool isDismissible = true}) async {
    assert(builder != null);
    return await _showModalBottomSheet(
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
    return _showBottomSheet(
        builder: builder,
        backgroundColor: backgroundColor,
        elevation: elevation,
        shape: shape,
        clipBehavior: clipBehavior);
  }

  /// Register callbacks
  void registerCallback(
      {DialogFuture showDialog,
      DialogModalSheet showModalBottomSheet,
      DialogSnackBar showSnackBar,
      DialogBottomSheet showBottomSheet}) {
    _showDialog = showDialog;
    _showDialog = showDialog;
    _showSnackBar = showSnackBar;
    _showModalBottomSheet = showModalBottomSheet;
    _showBottomSheet = showBottomSheet;
  }

  /// Pop the top-most dialog off the OneContext.dialog.
  bool popDialog<T extends Object>([T result]) {
    return Navigator.of(context).pop<T>(result);
  }
}
