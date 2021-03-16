import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:one_context/src/components/one_basic_widget.dart';
import 'package:one_context/src/components/one_notifier.dart';

typedef Widget NotificationBuilder<T>(BuildContext context, T data);
typedef void OnVisited<T>(BuildContext context, T? data);

/// Rebuild the widget below OneNotification
/// It can be usually used to rebuild widget tree
/// Use: OneNotififier.notify(BuildContext, NotificationPayload<Type>);
///
/// `stopBubbling` avoid to bubbling event and data to ancestor widgets (default = false)
/// `rebuildOnNull` if set true, it will rebuild when `payload` is null (default = false), but it will use cached data instead
/// `rebuildOnData` if set true, it will rebuild when `payload` has data (default = true) and data has the same type of generics
///
/// e.g.
///
/// OneNotification<String>(
///   builder: (context, data) {
///     return Text(data);
///   }
/// );
///
/// If you dont use generic, it assume that is a dynamic type, and builder always is get dispatched if rebuildOnData = true(default = true)
/// So, ever use a generic type to avoid unexpected behaviors.

class OneNotification<T> extends StatefulWidget {
  final NotificationBuilder<T?> builder;
  final bool stopBubbling;
  final bool rebuildOnNull;
  final bool rebuildOnData;
  final OnVisited? onVisited;
  final T? initialData;
  final List<Type>? types;

  OneNotification({
    required this.builder,
    this.initialData,
    this.onVisited,
    this.stopBubbling = false,
    this.rebuildOnNull = false,
    this.rebuildOnData = true,
    this.types,
    Key? key,
  }) : super(key: key);

  /// Use it to reload a OneNotification widget children
  /// It use the type of NotificationPayload.data to decide if it has to make changes
  static notify<T>(BuildContext context, {NotificationPayload<T>? payload}) {
    OneNotifier(payload: payload)..dispatch(context);
  }

  /// Use it to reload the entire widget three, loose previous data of most top OneNotification found
  /// Cunrrently it recreate most top OneNotification
  static hardReloadRoot(BuildContext context) {
    _OneNotificationState? state =
        context.findRootAncestorStateOfType<_OneNotificationState>();
    state?._hardReload();
  }

  /// Cunrrently it rebuild most top OneNotification
  static softReloadRoot(BuildContext context) {
    _OneNotificationState? state =
        context.findRootAncestorStateOfType<_OneNotificationState>();
    state?._softReload();
  }

  @override
  _OneNotificationState<T> createState() => _OneNotificationState<T>();
}

class _OneNotificationState<T> extends State<OneNotification<T>> {
  T? _data;
  Key _key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OneNotifier>(
        child: OneBasicWidget(
          key: _key,
          child: widget.builder(context, _data ?? widget.initialData),
        ),
        onNotification: (notification) {
          widget.onVisited?.call(context, notification.payload?.data);

          /// Null data received
          if (widget.rebuildOnNull && notification.payload?.data == null) {
            _softReload();
            return widget.stopBubbling;

            /// Data received and try match type
          } else if (notification.payload?.data?.runtimeType.toString() ==
                  T.toString() ||
              dynamic is T) {
            _data = notification.payload?.data;

            if (widget.rebuildOnData) if (notification
                    .payload?.forceHardHeload ==
                true)
              _hardReload();
            else
              _softReload();

            return widget.stopBubbling;
          } else {
            return false;
          }
        });
  }

  void _softReload() {
    if (mounted) setState(() {});
  }

  void _hardReload() {
    setState(() {
      _key = UniqueKey();
    });
  }
}
