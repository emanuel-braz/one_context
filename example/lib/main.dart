import 'dart:math';

import 'package:flutter/material.dart';
import 'package:one_context/one_context.dart';

bool debugShowCheckedModeBanner = false;
const localeEnglish = [Locale('en', '')];

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  OnePlatform.app = () => MyApp();
}

class MyApp extends StatelessWidget {
  MyApp() {
    print('MyApp loaded!');

    debugShowCheckedModeBanner = true;
  }

  @override
  Widget build(BuildContext context) {
    /// important: Use [OneContext().builder] in MaterialApp builder, in order to show dialogs, overlays and change the app theme.
    /// important: Use [OneContext().key] in MaterialApp navigatorKey, in order to navigate.

    return OneNotification<List<Locale>>(
      onVisited: (_, __) {
        print('Root widget visited!');
      },
      // This widget rebuild the Material app to update theme, supportedLocales, etc...
      stopBubbling: true, // avoid the data bubbling to ancestors widgets
      initialData:
          localeEnglish, // [data] is null during boot of the application, but you can set initialData ;)
      rebuildOnNull:
          true, // Allow other entities reload this widget without messing up currenty data (Data is cached on first event)

      builder: (context, dataLocale) {
        if (dataLocale != null && dataLocale != localeEnglish)
          print('Set Locale: $dataLocale');

        return OneNotification<OneThemeChangerEvent>(
            onVisited: (_, __) {
              print('Theme Changer widget visited!');
            },
            stopBubbling: true,
            builder: (context, data) {
              return MaterialApp(
                // TODO: check observers
                // navigatorObservers: [OneContext().heroController],
                debugShowCheckedModeBanner: debugShowCheckedModeBanner,
                // Configure reactive theme mode and theme data (needs OneNotification above in the widget tree)
                themeMode: OneThemeController.initThemeMode(ThemeMode.light),
                theme: OneThemeController.initThemeData(ThemeData(
                  primarySwatch: Colors.green,
                  primaryColor: Colors.green,
                  brightness: Brightness.light,
                  useMaterial3: true,
                )),
                darkTheme: OneThemeController.initDarkThemeData(ThemeData(
                    brightness: Brightness.dark, primaryColor: Colors.blue)),

                // Configure Navigator key
                navigatorKey: OneContext().navigatorKey,

                // Configure [OneContext] to dialogs, overlays, snackbars, and ThemeMode
                builder: OneContext().builder,

                // [data] it comes through events
                supportedLocales: dataLocale ?? [const Locale('en', '')],

                title: 'OneContext Demo',
                home: MyHomePage(
                  title: 'OneContext Demo',
                ),
                // routes: {'/second': (context) => SecondPage()},
                onGenerateRoute: (settings) {
                  if (settings.name == SecondPage.routeName) {
                    return MaterialPageRoute<String>(
                      builder: (context) {
                        return SecondPage();
                      },
                      settings: settings,
                    );
                  } else
                    return null;
                },
              );
            });
      },
    );
  }
}

class MyApp2 extends StatelessWidget {
  MyApp2() {
    print('MyApp2 loaded!');
    OneContext().navigatorKey = GlobalKey<NavigatorState>();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.pink),
        title: 'OneContext Demo',
        home: MyHomePage2(title: 'A NEW APPLICATION'),
        routes: {'/second': (context) => SecondPage()},
        builder: OneContext().builder,
        navigatorKey: OneContext().navigatorKey);
  }
}

class MyHomePage2 extends StatefulWidget {
  MyHomePage2({this.title, Key? key}) : super(key: key);
  final String? title;
  @override
  _MyHomePage2State createState() => _MyHomePage2State();
}

class _MyHomePage2State extends State<MyHomePage2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? ""),
      ),
      body: Container(
        color: Colors.pink,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                child: Text('COME BACK TO THE OLD APP'),
                onPressed: () {
                  OnePlatform.reboot(
                    setUp: () {
                      OneContext().navigatorKey = GlobalKey<NavigatorState>();
                    },
                    builder: () => MyApp(),
                  );
                }),
            ElevatedButton(
                child: Text('Navigate to Second Page'),
                onPressed: () {
                  OneContext().pushNamed('/second');
                })
          ],
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String? reloadAppButtonLabel;
  MyHomePage({Key? key, this.title = "", this.reloadAppButtonLabel})
      : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  Map<String, Offset> randomOffset = Map<String, Offset>();
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

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
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              widget.title + ' - ' + debugShowCheckedModeBanner.toString()),
          actions: <Widget>[
            Switch(
                activeColor: Colors.blue,
                value: debugShowCheckedModeBanner,
                onChanged: (_) {
                  debugShowCheckedModeBanner = !debugShowCheckedModeBanner;
                })
          ],
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
                ElevatedButton(
                  child: Text(' Hard Reload'),
                  onPressed: () {
                    OneNotification.hardReloadRoot(context);
                  },
                ),
                ElevatedButton(
                  child: Text('Soft Reeboot the app'),
                  onPressed: () {
                    OnePlatform.reboot(setUp: () => print('Reboot the app!'));
                  },
                ),
                ElevatedButton(
                  child: Text('Hard Reeboot'),
                  onPressed: () {
                    OnePlatform.reboot(
                        builder: () => MyApp(),
                        setUp: () {
                          print(
                              '\n\nSetting debugShowCheckedModeBanner = true, so the debug banner should appear on the app right now.'
                              '\n\n That is useful for load environment variables and project configuration before boot the app!'
                              '\n And if you just need run some stuffs and reload the app without change it.');
                          debugShowCheckedModeBanner = true;
                        });
                  },
                ),
                ElevatedButton(
                  child: Text('Load another app'),
                  onPressed: () {
                    OnePlatform.reboot(
                        setUp: () {
                          OneContext().navigatorKey =
                              GlobalKey<NavigatorState>();
                        },
                        builder: () => MyApp2());
                  },
                ),
                ElevatedButton(
                  child: Text('Change ThemeData Light'),
                  onPressed: () {
                    OneContext().oneTheme.changeThemeData(ThemeData(
                        primarySwatch: Colors.purple,
                        brightness: Brightness.light));
                  },
                ),
                ElevatedButton(
                  child: Text('Change ThemeData Dark'),
                  onPressed: () {
                    OneContext().oneTheme.changeDarkThemeData(ThemeData(
                        primarySwatch: Colors.amber,
                        brightness: Brightness.dark));
                  },
                ),
                ElevatedButton(
                  child: Text('Toggle ThemeMode (Dark/Light)'),
                  onPressed: () {
                    OneContext().oneTheme.toggleMode();
                  },
                ),
                ElevatedButton(
                  child: Text('Change to english locale support'),
                  onPressed: () {
                    OneNotification.notify<List<Locale>>(context,
                        payload: NotificationPayload(data: [
                          Locale('en', ''), // English
                        ]));
                  },
                ),
                ElevatedButton(
                  child: Text('Show SnackBar'),
                  onPressed: () {
                    showTipsOnScreen('OneContext().showSnackBar()');
                    OneContext()
                        .hideCurrentSnackBar(); // Dismiss snackbar before show another ;)
                    OneContext().showSnackBar(
                      builder: (context) => SnackBar(
                        content: Text(
                          'My awesome snackBar!',
                          textAlign: TextAlign.center,
                          style: Theme.of(context!)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(color: Colors.white),
                        ),
                        action:
                            SnackBarAction(label: 'DISMISS', onPressed: () {}),
                      ),
                    );
                  },
                ),
                ElevatedButton(
                    onPressed: () => OneContext().hideCurrentSnackBar(),
                    child: Text('Close SnackBar')),
                ElevatedButton(
                  child: Text('Show Dialog'),
                  onPressed: () async {
                    showTipsOnScreen('OneContext().showDialog<String>()');

                    var result = await OneContext().showDialog<String>(
                        barrierColor: Colors.purple.withOpacity(0.5),
                        builder: (context) => AlertDialog(
                              title: new Text("The Title"),
                              content: new Text("The Body"),
                              actions: <Widget>[
                                new TextButton(
                                    child: new Text("OK"),
                                    onPressed: () =>
                                        OneContext().popDialog('ok')),
                                new TextButton(
                                    child: new Text("CANCEL"),
                                    onPressed: () =>
                                        OneContext().popDialog('cancel')),
                              ],
                            ));
                    print(result);
                  },
                ),
                ElevatedButton(
                  child: Text('Show modalBottomSheet'),
                  onPressed: () async {
                    showTipsOnScreen(
                        'OneContext().showModalBottomSheet<String>()');
                    var result =
                        await OneContext().showModalBottomSheet<String>(
                      barrierColor: Colors.amber.withOpacity(0.5),
                      builder: (context) => Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                                leading: Icon(Icons.music_note),
                                title: Text('Music'),
                                onTap: () => OneContext().popDialog('Music')),
                            ListTile(
                                leading: Icon(Icons.videocam),
                                title: Text('Video'),
                                onTap: () => OneContext().popDialog('Video')),
                            SizedBox(height: 45)
                          ],
                        ),
                      ),
                      showDragHandle: true,
                    );
                    print(result);
                  },
                ),
                ElevatedButton(
                  child: Text('Show bottomSheet'),
                  onPressed: () {
                    showTipsOnScreen('OneContext().showBottomSheet()');
                    OneContext().showBottomSheet(
                      constraints: BoxConstraints(maxHeight: 100),
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
                            onPressed: () {
                              OneContext().popDialog();
                            }),
                      ),
                    );
                  },
                ),
                ElevatedButton(
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
                ElevatedButton(
                  child: Text('Show default progress indicator'),
                  onPressed: () {
                    showTipsOnScreen('OneContext().showProgressIndicator()');

                    OneContext().showProgressIndicator();
                    Future.delayed(Duration(seconds: 2),
                        () => OneContext().hideProgressIndicator());
                  },
                ),
                ElevatedButton(
                  child: Text('Show progress indicator colored'),
                  onPressed: () {
                    showTipsOnScreen(
                        'OneContext().showProgressIndicator(backgroundColor, circularProgressIndicatorColor)');
                    OneContext().showProgressIndicator(
                        backgroundColor: Colors.blue.withOpacity(.3),
                        circularProgressIndicatorColor: Colors.red);
                    Future.delayed(Duration(seconds: 2),
                        () => OneContext().hideProgressIndicator());
                  },
                ),
                ElevatedButton(
                  child: Text('Show custom progress indicator'),
                  onPressed: () {
                    showTipsOnScreen(
                        'OneContext().showProgressIndicator(backgroundColor, circularProgressIndicatorColor)');
                    OneContext().showProgressIndicator(
                      builder: (_) => Container(
                          color: Colors.black38,
                          alignment: Alignment.center,
                          child: SizedBox(
                            height: 80,
                            width: 80,
                            child: Card(
                              color: Colors.white,
                              elevation: 0,
                              // shape: RoundedRectangleBorder(),
                              child: Center(child: CircularProgressIndicator()),
                            ),
                          )),
                    );
                    Future.delayed(Duration(seconds: 2),
                        () => OneContext().hideProgressIndicator());
                  },
                ),
                ElevatedButton(
                  child: Text('Show custom animated indicator'),
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
                ElevatedButton(
                  child: Text('Add a generic overlay'),
                  onPressed: () {
                    showTipsOnScreen('OneContext().addOverlay(builder)');
                    String overId = UniqueKey().toString();
                    double getY() => Random()
                        .nextInt(
                            (MediaQuery.of(context).size.height - 50).toInt())
                        .toDouble();
                    double getX() => Random()
                        .nextInt(
                            (MediaQuery.of(context).size.width - 50).toInt())
                        .toDouble();
                    randomOffset.putIfAbsent(
                        overId, () => Offset(getX(), getY()));
                    Widget w = ElevatedButton(
                        child: Text(
                          'CLOSE OR DRAG',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed))
                                return Colors.green;
                              return Colors
                                  .blue; // Use the component's default.
                            },
                          ),
                        ),
                        onPressed: () {
                          OneContext().removeOverlay(overId);
                        });
                    OneContext().addOverlay(
                        builder: (_) => Positioned(
                            top: randomOffset[overId]?.dy,
                            left: randomOffset[overId]?.dx,
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
                ElevatedButton(
                  child: Text('Push a second page (push)'),
                  onPressed: () async {
                    showTipsOnScreen('OneContext().push()');
                    String? result = await OneContext().push<String>(
                        MaterialPageRoute(builder: (_) => SecondPage()));
                    print('$result from OneContext().push()');
                  },
                ),
                ElevatedButton(
                  child: Text('Push a second page (pushNamed)'),
                  onPressed: () async {
                    showTipsOnScreen('OneContext().pushNamed()');
                    // var result = (await OneContext().pushNamed('/second'));
                    String? result =
                        (await Navigator.of(context).pushNamed('/second'));
                    print('$result from OneContext().pushNamed()');
                  },
                ),
                ElevatedButton(
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
                ElevatedButton(
                  child: Text('Show Theme info'),
                  onPressed: () async {
                    ThemeData theme = OneContext().theme;
                    String info = 'platform: ${theme.platform}\n'
                        'primaryColor: ${theme.primaryColor}\n'
                        'accentColor: ${theme.colorScheme.secondary}\n'
                        'title.color: ${theme.textTheme.headlineMedium?.color}';
                    print(info);
                    showTipsOnScreen(info, size: 200, seconds: 5);
                  },
                ),
                SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  static String routeName = "/second";
  SecondPage() {
    OneContext()
        .showDialog(
            builder: (_) => AlertDialog(
                  content: Text(
                      'Dialog opened from constructor of StatelessWidget SecondPage!'),
                  actions: [
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.blue)),
                        child: Text('Close'),
                        onPressed: () {
                          OneContext().popDialog("Nice!");
                        })
                  ],
                ))
        .then((result) => print(result));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Second Page'),
          ElevatedButton(
            child: Text('Go Back - pop("success")'),
            onPressed: () {
              showTipsOnScreen('OneContext().pop("success")');
              OneContext().pop('success');
            },
          ),
        ],
      )));
}

// Dont need context, so features can be create in any place ;)
void showTipsOnScreen(String text, {double? size, int? seconds}) {
  String id = UniqueKey().toString();
  OneContext().addOverlay(
    overlayId: id,
    builder: (_) => Align(
      alignment: Alignment.topCenter,
      child: Container(
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.symmetric(
              horizontal: kFloatingActionButtonMargin, vertical: 8),
          child: TextButton(
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
