import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:one_context/src/components/one_basic_widget.dart';
import 'package:one_context/src/components/one_notification.dart';

typedef Widget OneHotReloadBuilder<T>(BuildContext context, T data);

/// Rebuild all widgets below OneHotReload
/// It can be usually used to rebuild widget tree
/// Use: OneHotReload.softReload<String>(context, data: 'some data');
///
/// `T data` send data to OneHotReload<T>
/// `stopBubbling` avoid to bubbling event and data to ancestor widgets (default = false)
/// `rebuildOnNull` if set true, it will rebuild when `data` is null (default = false)
///
/// e.g.
///
/// OneHotReload<String>(
///   builder: (context, data) {
///     return Text(data);
///   }
/// );

class OneHotReload<T> extends StatefulWidget {
  final bool stopBubbling;
  final bool rebuildOnNull;
  final T initialData;
  final Type type = T;

  final OneHotReloadBuilder<T> builder;

  OneHotReload({
    @required this.builder,
    this.initialData,
    this.stopBubbling = false,
    this.rebuildOnNull = false,
    Key key,
  })  : assert(builder != null, 'builder is required!'),
        super(key: key);

  /// Use it to reload a widget children (O(1))
  static softReload<T>(BuildContext context, {T data}) {
    OneNotification<T>(data: data)..dispatch(context);
  }

  /// Use it to reload the entire widget three, losing previous state
  static hardReload(BuildContext context) {
    _OneHotReloadState state =
        context.findRootAncestorStateOfType<_OneHotReloadState>();
    state?._hardReload();
  }

  @override
  _OneHotReloadState<T> createState() => _OneHotReloadState<T>();
}

class _OneHotReloadState<T> extends State<OneHotReload<T>> {
  T _data;
  Key _key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OneNotification>(
        child: OneBasicWidget(
          key: _key,
          child: widget.builder(context, _data ?? widget.initialData),
        ),
        onNotification: (notification) {
          if (widget.rebuildOnNull && notification?.data == null) {
            _softReload<T>();
            return widget.stopBubbling;
          } else if (notification?.data?.runtimeType?.toString() ==
                  T.toString() ||
              dynamic is T) {
            _softReload<T>(_data = notification.data);
            return widget.stopBubbling;
          } else {
            return false;
          }
        });
  }

  void _softReload<T>([T data]) {
    if (mounted) setState(() {});
  }

  void _hardReload() {
    setState(() {
      _key = UniqueKey();
    });
  }
}
