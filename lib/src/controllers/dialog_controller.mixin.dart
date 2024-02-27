import 'package:flutter/material.dart' as mat;
import 'package:flutter/material.dart';
import 'package:one_context/src/controllers/one_context.dart';

typedef Widget DialogBuilder(BuildContext context);
mixin DialogController {
  /// Return dialog utility class `DialogController`
  DialogController get dialog => this;

  /// The current scaffold state
  /// It is used to show snackbars, dialogs, modalBottomsheets, etc.
  GlobalKey<ScaffoldState>? _scaffoldKey;
  GlobalKey<ScaffoldState> get scaffoldKey {
    _scaffoldKey ??= GlobalKey<ScaffoldState>();
    return _scaffoldKey!;
  }

  set scaffoldKey(scaffKey) => _scaffoldKey = scaffKey;
  BuildContext? get _scaffoldContext => _scaffoldKey?.currentContext;
  ScaffoldState? get _scaffoldState => _scaffoldKey?.currentState;

  ValueNotifier<List<Widget>> _dialogs = ValueNotifier([]);
  ValueNotifier<List<Widget>> get dialogNotifier => _dialogs;
  bool get hasDialogVisible => _dialogs.value.length > 0;

  void addDialogVisible(Widget widget) {
    _dialogs.value.add(widget);
  }

  /// Removes the last dialog
  void removeDialogVisible({Widget? widget}) {
    if (widget != null) {
      _dialogs.value.remove(widget);
    } else
      _dialogs.value.removeLast();
  }

  /// Pop all dialogs
  void popAllDialogs() {
    _dialogs.value.forEach((element) {
      OneContext().popDialog();
    });
    _resetDialogRegisters();
  }

  void _resetDialogRegisters() {
    _dialogs.value.clear();
  }

  /// Displays a Material dialog above the current contents of the app, with
  /// Material entrance and exit animations, modal barrier color, and modal
  /// barrier behavior (dialog is dismissible with a tap on the barrier).
  Future<T?> showDialog<T>({
    required Widget Function(BuildContext) builder,
    bool useRootNavigator = true,
    String? barrierLabel,
    RouteSettings? routeSettings,
    Offset? anchorPoint,
    bool? barrierDismissible = true,
    Color? barrierColor = Colors.black54,
    bool useSafeArea = true,
    TraversalEdgeBehavior? traversalEdgeBehavior,
  }) async {
    if (!(await _scaffoldContextLoaded())) return null;

    Widget dialog = builder(_scaffoldContext!);
    addDialogVisible(dialog);

    return mat
        .showDialog<T>(
          context: _scaffoldContext!,
          builder: (_) => dialog,
          barrierDismissible: barrierDismissible ?? true,
          useRootNavigator: useRootNavigator,
          barrierColor: barrierColor,
          barrierLabel: barrierLabel,
          useSafeArea: useSafeArea,
          routeSettings: routeSettings,
          anchorPoint: anchorPoint,
          traversalEdgeBehavior: traversalEdgeBehavior,
        )
        .whenComplete(() => removeDialogVisible(widget: dialog));
  }

  /// Removes the current [SnackBar] by running its normal exit animation.
  ///
  /// The closed completer is called after the animation is complete.
  void hideCurrentSnackBar(
      {SnackBarClosedReason reason = SnackBarClosedReason.hide}) async {
    if (!(await _scaffoldContextLoaded())) return;
    ScaffoldMessenger.of(_scaffoldContext!).hideCurrentSnackBar(reason: reason);
  }

  /// Removes the current [SnackBar] (if any) immediately.
  ///
  /// The removed snack bar does not run its normal exit animation. If there are
  /// any queued snack bars, they begin their entrance animation immediately.
  void removeCurrentSnackBar(
      {SnackBarClosedReason reason = SnackBarClosedReason.hide}) async {
    if (!(await _scaffoldContextLoaded())) return;
    ScaffoldMessenger.of(_scaffoldContext!)
        .removeCurrentSnackBar(reason: reason);
  }

  /// Shows a [SnackBar] at the bottom of the scaffold.
  Future<ScaffoldFeatureController<SnackBar, SnackBarClosedReason>?>
      showSnackBar({required SnackBar Function(BuildContext?) builder}) async {
    if (!(await _scaffoldContextLoaded())) return null;
    return ScaffoldMessenger.of(_scaffoldContext!)
        .showSnackBar(builder(_scaffoldContext));
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
    bool? showDragHandle,
    bool useSafeArea = false,
  }) async {
    if (!(await _scaffoldContextLoaded())) return null;

    Widget dialog = builder(_scaffoldContext!);
    addDialogVisible(dialog);

    return mat
        .showModalBottomSheet<T>(
          context: _scaffoldContext!,
          builder: (_) => dialog,
          backgroundColor: backgroundColor,
          clipBehavior: clipBehavior,
          elevation: elevation,
          isDismissible: isDismissible,
          isScrollControlled: isScrollControlled,
          shape: shape,
          useRootNavigator: useRootNavigator,
          constraints: constraints,
          barrierColor: barrierColor,
          enableDrag: enableDrag = true,
          routeSettings: routeSettings,
          transitionAnimationController: transitionAnimationController,
          anchorPoint: anchorPoint,
          showDragHandle: showDragHandle,
          useSafeArea: useSafeArea,
        )
        .whenComplete(() => removeDialogVisible(widget: dialog));
  }

  /// Shows a persistent bottom sheet
  Future<PersistentBottomSheetController?> showBottomSheet<T>({
    required Widget Function(BuildContext) builder,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
    Clip? clipBehavior,
    BoxConstraints? constraints,
    bool? enableDrag,
    AnimationController? transitionAnimationController,
  }) async {
    if (!(await _scaffoldContextLoaded())) return null;

    Widget dialog = builder(_scaffoldContext!);
    addDialogVisible(dialog);

    return _scaffoldState!.showBottomSheet(
      (_) => dialog,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape,
      clipBehavior: clipBehavior,
      constraints: constraints,
      enableDrag: enableDrag,
      transitionAnimationController: transitionAnimationController,
    )..closed.whenComplete(() => removeDialogVisible(widget: dialog));
  }

  /// Pop the top-most dialog off the OneContext.dialog.
  popDialog<T extends Object>([T? result]) async {
    if ((await _scaffoldContextLoaded())) {
      if (OneContext().hasDialogVisible)
        return Navigator.of(_scaffoldContext!).pop<T>(result);
    }
  }

  /// Context used by inner Navigator
  Future<bool> _scaffoldContextLoaded() async {
    await Future.delayed(Duration.zero);
    final isContextNull = _scaffoldContext == null;
    final isMounted = _scaffoldContext?.mounted ?? false;

    if ((isContextNull || !isMounted)) {
      throw NO_CONTEXT_ERROR;
    }

    return !isContextNull;
  }
}
