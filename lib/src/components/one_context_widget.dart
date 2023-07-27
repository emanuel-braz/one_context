import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:one_context/src/controllers/one_context.dart';

class OneContextWidget extends StatefulWidget {
  final Widget? child;
  OneContextWidget({Key? key, this.child}) : super(key: key);
  _OneContextWidgetState createState() => _OneContextWidgetState();
}

class _OneContextWidgetState extends State<OneContextWidget> {
  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    if (OneContext().hasDialogVisible) {
      OneContext().popDialog();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: '/',
      observers: [OneContext().heroController],
      onGenerateRoute: (_) => MaterialPageRoute(
          builder: (context) => Scaffold(
                resizeToAvoidBottomInset: false,
                key: OneContext().scaffoldKey,
                body: widget.child!,
              )),
    );
  }
}
