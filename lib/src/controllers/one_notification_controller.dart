import 'package:flutter/widgets.dart';
import 'package:one_context/src/components/one_notification.dart';

class OneNotificationController {
  void notify<T>(BuildContext context, [T data]) {
    OneNotification<T>(data: data)..dispatch(context);
  }
}
