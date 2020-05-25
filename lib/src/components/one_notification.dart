import 'package:flutter/widgets.dart';

class OneNotification<T> extends Notification {
  final T data;

  OneNotification({this.data});

  static void notify<T>(BuildContext context, [T data]) {
    OneNotification<T>(data: data)..dispatch(context);
  }
}
