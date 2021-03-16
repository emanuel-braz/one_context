import 'package:flutter/widgets.dart';

class OneNotifier<T> extends Notification {
  final NotificationPayload<T>? payload;

  OneNotifier({this.payload});

  static void notify<T>(BuildContext? context,
      [NotificationPayload<T>? payload]) {
    OneNotifier<T>(payload: payload)..dispatch(context);
  }
}

class NotificationPayload<T> {
  final bool? forceHardHeload;
  final T? data;
  NotificationPayload({this.data, this.forceHardHeload});
}
