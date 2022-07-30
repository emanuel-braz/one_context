import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:one_context/src/controllers/one_context.dart';

typedef Widget DialogBuilder(BuildContext context);
mixin DialogController {
  /// Return dialog utility class `DialogController`
  DialogController get dialog => this;

  /// The current context
  BuildContext? get context => OneContext().context;

  ValueNotifier<List<Widget>> _dialogs = ValueNotifier([]);
  ValueNotifier<List<Widget>> get dialogNotifier => _dialogs;
  bool get hasDialogVisible => _dialogs.value.length > 0;

  void addDialogVisible(Widget widget) {
    _dialogs.value.add(widget);
  }

  void removeDialogVisible({Widget? widget}) {
    if (widget != null) {
      _dialogs.value.remove(widget);
    } else
      _dialogs.value.removeLast();
  }

  void popAllDialogs() {
    _dialogs.value.forEach((element) {
      OneContext().popDialog();
    });
    _resetDialogRegisters();
  }

  void _resetDialogRegisters() {
    _dialogs.value.clear();
  }

  Future<T?> Function<T>({
    required Widget Function(BuildContext) builder,
    bool? barrierDismissible,
    bool useRootNavigator,
    Color? barrierColor,
    String? barrierLabel,
    bool useSafeArea,
    RouteSettings? routeSettings,
    Offset? anchorPoint,
  })? _showDialog;

  Future<T?> Function<T>({
    required Widget Function(BuildContext) builder,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
    Clip? clipBehavior,
    bool isScrollControlled,
    bool useRootNavigator,
    bool isDismissible,
    BoxConstraints? constraints,
    Color? barrierColor,
    bool? enableDrag,
    RouteSettings? routeSettings,
    AnimationController? transitionAnimationController,
    Offset? anchorPoint,
  })? _showModalBottomSheet;

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> Function(
      SnackBar Function(BuildContext?) builder)? _showSnackBar;

  PersistentBottomSheetController<T> Function<T>({
    Widget Function(BuildContext) builder,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
    Clip? clipBehavior,
    BoxConstraints? constraints,
    bool? enableDrag,
    AnimationController? transitionAnimationController,
  })? _showBottomSheet;

  /// Displays a Material dialog above the current contents of the app, with
  /// Material entrance and exit animations, modal barrier color, and modal
  /// barrier behavior (dialog is dismissible with a tap on the barrier).
  Future<T?> showDialog<T>({
    required Widget Function(BuildContext) builder,
    bool useRootNavigator = true,
    String? barrierLabel,
    RouteSettings? routeSettings,
    Offset? anchorPoint,
    bool barrierDismissible = true,
    Color? barrierColor = Colors.black54,
    bool useSafeArea = true,
  }) async {
    if (!(await _contextLoaded())) return null;

    Widget dialog = builder(context!);
    if (barrierDismissible == true) addDialogVisible(dialog);

    return _showDialog!<T>(
      builder: (_) => dialog,
      barrierDismissible: barrierDismissible,
      useRootNavigator: useRootNavigator,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
      useSafeArea: useSafeArea,
      routeSettings: routeSettings,
      anchorPoint: anchorPoint,
    ).whenComplete(() {
      if (barrierDismissible == true) removeDialogVisible(widget: dialog);
    });
  }

  /// Removes the current [SnackBar] by running its normal exit animation.
  ///
  /// The closed completer is called after the animation is complete.
  void hideCurrentSnackBar(
      {SnackBarClosedReason reason = SnackBarClosedReason.hide}) async {
    if (!(await _contextLoaded())) return;
    ScaffoldMessenger.of(context!).hideCurrentSnackBar(reason: reason);
  }

  /// Removes the current [SnackBar] (if any) immediately.
  ///
  /// The removed snack bar does not run its normal exit animation. If there are
  /// any queued snack bars, they begin their entrance animation immediately.
  void removeCurrentSnackBar(
      {SnackBarClosedReason reason = SnackBarClosedReason.hide}) async {
    if (!(await _contextLoaded())) return;
    ScaffoldMessenger.of(context!).removeCurrentSnackBar(reason: reason);
  }

  /// Shows a [SnackBar] at the bottom of the scaffold.
  Future<ScaffoldFeatureController<SnackBar, SnackBarClosedReason>?>
      showSnackBar({required SnackBar Function(BuildContext?) builder}) async {
    if (!(await _contextLoaded())) return null;
    return _showSnackBar!(builder);
  }

  /// Shows a modal material design bottom sheet.
  ///
  /// A modal bottom sheet is an alternative to a menu or a dialog and prevents
  /// the user from interacting with the rest of the app.
  Future<T?> showModalBottomSheet<T>({
    required Widget Function(BuildContext) builder,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
    Clip? clipBehavior,
    bool isScrollControlled = false,
    bool useRootNavigator = false,
    bool isDismissible = true,
    BoxConstraints? constraints,
    Color? barrierColor,
    bool? enableDrag,
    RouteSettings? routeSettings,
    AnimationController? transitionAnimationController,
    Offset? anchorPoint,
  }) async {
    if (!(await _contextLoaded())) return null;

    Widget dialog = builder(context!);
    if (isDismissible == true) addDialogVisible(dialog);

    return _showModalBottomSheet!<T>(
      builder: builder,
      backgroundColor: backgroundColor,
      clipBehavior: clipBehavior,
      elevation: elevation,
      isDismissible: isDismissible,
      isScrollControlled: isScrollControlled,
      shape: shape,
      useRootNavigator: useRootNavigator,
      constraints: constraints,
      barrierColor: barrierColor,
      enableDrag: enableDrag,
      routeSettings: routeSettings,
      transitionAnimationController: transitionAnimationController,
      anchorPoint: anchorPoint,
    ).whenComplete(() {
      if (isDismissible == true) removeDialogVisible(widget: dialog);
    });
  }

  /// Shows a material design bottom sheet in the nearest [Scaffold] ancestor. If
  /// you wish to show a persistent bottom sheet, use [Scaffold.bottomSheet].
  ///
  /// Returns a controller that can be used to close and otherwise manipulate the
  /// bottom sheet.
  Future<PersistentBottomSheetController<T>?> showBottomSheet<T>({
    required Widget Function(BuildContext) builder,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
    Clip? clipBehavior,
    BoxConstraints? constraints,
    bool? enableDrag,
    AnimationController? transitionAnimationController,
  }) async {
    if (!(await _contextLoaded())) return null;
    return _showBottomSheet!<T>(
      builder: builder,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape,
      clipBehavior: clipBehavior,
      constraints: constraints,
      enableDrag: enableDrag,
      transitionAnimationController: transitionAnimationController,
    );
  }

  /// Register callbacks
  void registerCallback(
      {Future<T?> Function<T>({
        required Widget Function(BuildContext) builder,
        bool? barrierDismissible,
        bool useRootNavigator,
        Color? barrierColor,
        String? barrierLabel,
        bool useSafeArea,
        RouteSettings? routeSettings,
        Offset? anchorPoint,
      })?
          showDialog,
      Future<T?> Function<T>({
        required Widget Function(BuildContext) builder,
        Color? backgroundColor,
        double? elevation,
        ShapeBorder? shape,
        Clip? clipBehavior,
        bool? isScrollControlled,
        bool? useRootNavigator,
        bool? isDismissible,
        BoxConstraints? constraints,
        Color? barrierColor,
        bool? enableDrag,
        RouteSettings? routeSettings,
        AnimationController? transitionAnimationController,
        Offset? anchorPoint,
      })?
          showModalBottomSheet,
      ScaffoldFeatureController<SnackBar, SnackBarClosedReason> Function(
              SnackBar Function(BuildContext?) builder)?
          showSnackBar,
      PersistentBottomSheetController<T> Function<T>({
        Widget Function(BuildContext)? builder,
        Color? backgroundColor,
        double? elevation,
        ShapeBorder? shape,
        Clip? clipBehavior,
        BoxConstraints? constraints,
        bool? enableDrag,
        AnimationController? transitionAnimationController,
      })?
          showBottomSheet}) {
    _showDialog = showDialog;
    _showSnackBar = showSnackBar;
    _showModalBottomSheet = showModalBottomSheet;
    _showBottomSheet = showBottomSheet;
  }

  /// Pop the top-most dialog off the OneContext.dialog.
  popDialog<T extends Object>([T? result]) async {
    if (!(await _contextLoaded())) return;
    return Navigator.of(context!).pop<T>(result);
  }

  Future<bool> _contextLoaded() async {
    await Future.delayed(Duration.zero);
    if (!OneContext.hasContext && !kReleaseMode) {
      throw NO_CONTEXT_ERROR;
    }
    return OneContext.hasContext;
  }
}
