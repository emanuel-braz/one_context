import 'package:flutter/widgets.dart';
import 'package:one_context/src/components/one_notifier.dart';

class OneNotificationController {
  void notify<T>(BuildContext? context, [NotificationPayload<T>? payload]) {
    OneNotifier.notify<T>(context, payload);
  }
}
