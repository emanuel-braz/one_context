import 'dart:math';
import 'package:one_context/one_context.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /// important: Use [OneContext().builder] in MaterialApp builder, in order to show dialogs and overlays.
    /// important: Use [OneContext().key] in MaterialApp navigatorKey, in order to navigate.
    return MaterialApp(
      builder: OneContext().builder,
      navigatorKey: OneContext().key,
      // builder: (context, widget) => OneContext().builder(context, widget, mediaQueryData: MediaQuery.of(context).copyWith(textScaleFactor: 1.0)),
      title:
          'OneContext Demo - Dialogs, Overlays and Navigations without BuildContext',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'OneContext Demo'),
      routes: {
        '/second': (context) => SecondPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  Map<String, Offset> randomOffset = Map<String, Offset>();
  AnimationController _controller;
  Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: Offset(0, -1),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 20),
              RaisedButton(
                child: Text('Show SnackBar'),
                onPressed: () {
                  showTipsOnScreen('OneContext().showSnackBar()');
                  OneContext()
                      .dismissSnackBar(); // Dismiss snackbar before show another ;)
                  OneContext().showSnackBar(
                      builder: (context) => SnackBar(
                            content: Text(
                              'My awesome snackBar!',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .title
                                  .copyWith(color: Colors.white),
                            ),
                            action: SnackBarAction(
                                label: 'DISMISS', onPressed: () {}),
                          ));
                },
              ),
              RaisedButton(
                child: Text('Show Dialog'),
                onPressed: () async {
                  showTipsOnScreen('OneContext().showDialog<String>()');

                  var result = await OneContext().showDialog<String>(
                      // Don't need context to show alertDialog
                      builder: (context) => AlertDialog(
                            title: new Text("The Title"),
                            content: new Text("The Body"),
                            actions: <Widget>[
                              new FlatButton(
                                  child: new Text("OK"),
                                  onPressed: () =>
                                      OneContext().popDialog('ok')),
                              new FlatButton(
                                  child: new Text("CANCEL"),
                                  onPressed: () =>
                                      OneContext().popDialog('cancel')),
                            ],
                          ));
                  print(result);
                },
              ),
              RaisedButton(
                child: Text('Show modalBottomSheet'),
                onPressed: () async {
                  showTipsOnScreen(
                      'OneContext().showModalBottomSheet<String>()');
                  var result = await OneContext().showModalBottomSheet<String>(
                      builder: (context) => Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                    leading: Icon(Icons.music_note),
                                    title: Text('Music'),
                                    onTap: () =>
                                        OneContext().popDialog('Music')),
                                ListTile(
                                    leading: Icon(Icons.videocam),
                                    title: Text('Video'),
                                    onTap: () =>
                                        OneContext().popDialog('Video')),
                                SizedBox(height: 45)
                              ],
                            ),
                          ));
                  print(result);
                },
              ),
              RaisedButton(
                child: Text('Show bottomSheet'),
                onPressed: () {
                  showTipsOnScreen('OneContext().showBottomSheet()');
                  OneContext().showBottomSheet(
                    builder: (context) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.red,
                      ),
                      margin: EdgeInsets.all(16),
                      alignment: Alignment.topCenter,
                      height: 200,
                      child: IconButton(
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 50,
                          color: Colors.white,
                          onPressed: () => OneContext().popDialog()),
                    ),
                  );
                },
              ),
              RaisedButton(
                  child: Text('Show and block till input'),
                  onPressed: () async {
                    showTipsOnScreen('OneContext().showDialog<int>()');
                    switch (await OneContext().showDialog<int>(
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return SimpleDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            title: const Text('Select assignment'),
                            children: <Widget>[
                              SimpleDialogOption(
                                onPressed: () {
                                  OneContext().popDialog(1);
                                },
                                child: const Text('Number 1'),
                              ),
                              SimpleDialogOption(
                                onPressed: () {
                                  OneContext().popDialog(2);
                                },
                                child: const Text('Number 2'),
                              ),
                            ],
                          );
                        })) {
                      case 1:
                        print('number one');
                        break;
                      case 2:
                        print('number two');
                        break;
                    }
                  }),
              RaisedButton(
                child: Text('Show default progress indicator'),
                onPressed: () {
                  showTipsOnScreen('OneContext().showProgressIndicator()');

                  OneContext().showProgressIndicator();
                  Future.delayed(Duration(seconds: 2),
                      () => OneContext().hideProgressIndicator());
                },
              ),
              RaisedButton(
                child: Text('Show progress indicator colored'),
                onPressed: () {
                  showTipsOnScreen(
                      'OneContext().showProgressIndicator(backgroundColor, circularProgressIndicatorColor)');
                  OneContext().showProgressIndicator(
                      backgroundColor: Colors.blue.withOpacity(.3),
                      circularProgressIndicatorColor: Colors.white);
                  Future.delayed(Duration(seconds: 2),
                      () => OneContext().hideProgressIndicator());
                },
              ),
              RaisedButton(
                child: Text('Show custom progress indicator'),
                onPressed: () {
                  showTipsOnScreen(
                      'OneContext().showProgressIndicator(builder)');
                  OneContext().showProgressIndicator(
                      builder: (_) => SlideTransition(
                            position: _offsetAnimation,
                            child: Container(
                              padding: EdgeInsets.only(top: 120),
                              alignment: Alignment.topCenter,
                              child: Container(
                                  alignment: Alignment.center,
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.yellow,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: CircularProgressIndicator()),
                            ),
                          ),
                      backgroundColor: Colors.transparent);
                  _controller.reset();
                  _controller.forward();
                  Future.delayed(Duration(seconds: 3), () {
                    _controller.reverse().whenComplete(
                        () => OneContext().hideProgressIndicator());
                  });
                },
              ),
              RaisedButton(
                child: Text('Add a generic overlay'),
                onPressed: () {
                  showTipsOnScreen('OneContext().addOverlay(builder)');
                  String overId = UniqueKey().toString();
                  double getY() => Random()
                      .nextInt(
                          (MediaQuery.of(context).size.height - 50).toInt())
                      .toDouble();
                  double getX() => Random()
                      .nextInt((MediaQuery.of(context).size.width - 50).toInt())
                      .toDouble();
                  randomOffset.putIfAbsent(
                      overId, () => Offset(getX(), getY()));
                  Widget w = RaisedButton(
                      child: Text(
                        'CLOSE OR DRAG',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.blue,
                      onPressed: () {
                        OneContext().removeOverlay(overId);
                      });
                  OneContext().addOverlay(
                      builder: (_) => Positioned(
                          top: randomOffset[overId].dy,
                          left: randomOffset[overId].dx,
                          child: Draggable(
                            onDragEnd: (DraggableDetails detail) =>
                                randomOffset[overId] = detail.offset,
                            childWhenDragging: Container(),
                            child: w,
                            feedback: w,
                          )),
                      overlayId: overId);
                },
              ),
              RaisedButton(
                child: Text('Push a second page (push)'),
                onPressed: () async {
                  showTipsOnScreen('OneContext().push()');
                  String result = await OneContext().push<String>(
                      MaterialPageRoute(builder: (_) => SecondPage()));
                  print('$result from OneContext().push()');
                },
              ),
              RaisedButton(
                child: Text('Push a second page (pushNamed)'),
                onPressed: () async {
                  showTipsOnScreen('OneContext().pushNamed()');
                  Object result = await OneContext().pushNamed('/second');
                  print('$result from OneContext().pushNamed()');
                },
              ),
              RaisedButton(
                child: Text('Show MediaQuery info'),
                onPressed: () async {
                  MediaQueryData mediaQuery = OneContext().mediaQuery;
                  String info =
                      'orientation: ${mediaQuery.orientation.toString()}\n'
                      'devicePixelRatio: ${mediaQuery.devicePixelRatio}\n'
                      'platformBrightness: ${mediaQuery.platformBrightness.toString()}\n'
                      'width: ${mediaQuery.size.width}\n'
                      'height: ${mediaQuery.size.height}\n'
                      'textScaleFactor: ${mediaQuery.textScaleFactor}';
                  print(info);
                  showTipsOnScreen(info, size: 200, seconds: 5);
                },
              ),
              RaisedButton(
                child: Text('Show Theme info'),
                onPressed: () async {
                  ThemeData theme = OneContext().theme;
                  String info = 'platform: ${theme.platform}\n'
                      'primaryColor: ${theme.primaryColor}\n'
                      'accentColor: ${theme.accentColor}\n'
                      'title.color: ${theme.textTheme.title.color}';
                  print(info);
                  showTipsOnScreen(info, size: 200, seconds: 5);
                },
              ),
              SizedBox(height: 24),
              Text(
                'Dialogs, Overlays and Navigations with no need BuildContext.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Second Page'),
          RaisedButton(
            child: Text('Go Back - pop("success")'),
            onPressed: () {
              showTipsOnScreen('OneContext().pop("success")');
              OneContext.instance.pop('success');
            },
          ),
        ],
      )));
}

// Dont need context, so features can be create in any place ;)
void showTipsOnScreen(String text, {double size, int seconds}) {
  String id = UniqueKey().toString();
  OneContext().addOverlay(
    overlayId: id,
    builder: (_) => Align(
      alignment: Alignment.topCenter,
      child: Container(
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.symmetric(
              horizontal: kFloatingActionButtonMargin, vertical: 8),
          child: FlatButton(
            onPressed: null,
            child: Text(
              text,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          color: Colors.red,
          height: size ?? 100,
          width: double.infinity),
    ),
  );
  Future.delayed(
      Duration(seconds: seconds ?? 2), () => OneContext().removeOverlay(id));
}
