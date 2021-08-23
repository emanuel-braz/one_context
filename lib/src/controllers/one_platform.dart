import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:one_context/src/components/one_basic_widget.dart';

typedef Widget OnePlatformBuilder();

class OnePlatform {
  static Widget? _app;
  static set app(OnePlatformBuilder builder) => reboot(builder: builder);

  /// Warning: Use it carefully!!
  /// Avoid to use it in production, it's a hack, and can generate unexpected behaviors
  /// Just use it for debug and for fun :)
  ///
  /// e.g.
  ///
  /// ```
  /// void main() => OnePlatform.app = MyApp();
  ///
  /// //or
  ///
  /// void main() {
  ///   //Some implementation here ...
  ///   OnePlatform.app = MyApp();
  /// }
  /// ```
  ///
  /// later:
  ///
  /// ```
  /// OnePlatform.reboot(); // Reboot the currently app
  /// ```
  /// or:
  /// ```
  /// OnePlatform.reboot(MyApp2()); // Reboot a new entire App
  /// ```
  static void reboot({OnePlatformBuilder? builder, VoidCallback? setUp}) {
    setUp?.call();
    // ignore: unused_local_variable
    Widget? oldWidget = _app;
    Future.delayed(Duration.zero, () {
      Widget? newWidget = builder?.call();
      runApp(_app = newWidget ??
          OneBasicWidget(
            key: UniqueKey(),
            child: _app,
          ));
      oldWidget = null;
    });
  }
}
