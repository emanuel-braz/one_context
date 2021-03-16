import 'package:flutter/material.dart';

class OneBasicWidget extends StatelessWidget {
  final Widget? child;
  const OneBasicWidget({required Key key, required this.child})
      : assert(child != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return child!;
  }
}
