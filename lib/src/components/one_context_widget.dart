import 'package:one_context/src/controllers/one_context.dart';
import 'package:flutter/material.dart';

class OneContextWidget extends StatefulWidget {
  final Widget child;
  OneContextWidget({Key key, this.child}) : super(key: key);
  _OneContextWidgetState createState() => _OneContextWidgetState();
}

class _OneContextWidgetState extends State<OneContextWidget> {
  @override
  void initState() {
    super.initState();
    OneContext().registerDialogCallback(
        showDialog: _showDialog,
        showSnackBar: _showSnackBar,
        showModalBottomSheet: _showModalBottomSheet,
        showBottomSheet: _showBottomSheet);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (innerContext) {
          OneContext().context = innerContext;
          return widget.child;
        },
      ),
    );
  }

  Future<T> _showDialog<T>(
          {bool barrierDismissible = true,
          Widget Function(BuildContext) builder,
          bool useRootNavigator = true}) =>
      showDialog<T>(
        context: context,
        builder: (context) => builder(context),
        barrierDismissible: barrierDismissible,
        useRootNavigator: useRootNavigator,
      );

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> _showSnackBar(
          SnackBar Function(BuildContext) builder) =>
      Scaffold.of(OneContext().context)
          .showSnackBar(builder(OneContext().context));

  Future<T> _showModalBottomSheet<T>(
      {Widget Function(BuildContext) builder,
      Color backgroundColor,
      double elevation,
      ShapeBorder shape,
      Clip clipBehavior,
      bool isScrollControlled = false,
      bool useRootNavigator = false,
      bool isDismissible = true}) {
    return showModalBottomSheet<T>(
      context: context,
      builder: builder,
      backgroundColor: backgroundColor,
      clipBehavior: clipBehavior,
      elevation: elevation,
      isDismissible: isDismissible,
      isScrollControlled: isScrollControlled,
      shape: shape,
      useRootNavigator: useRootNavigator,
    );
  }

  PersistentBottomSheetController<T> _showBottomSheet<T>(
      {@required Widget Function(BuildContext) builder,
      Color backgroundColor,
      double elevation,
      ShapeBorder shape,
      Clip clipBehavior}) {
    return showBottomSheet<T>(
        context: OneContext().context,
        builder: builder,
        backgroundColor: backgroundColor,
        elevation: elevation,
        shape: shape,
        clipBehavior: clipBehavior);
  }
}
