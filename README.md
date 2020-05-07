[![Pub Version](https://img.shields.io/pub/v/one_context?color=%2302569B&label=pub&logo=flutter)](https://pub.dev/packages/one_context) ![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)


![logo](https://user-images.githubusercontent.com/3827308/80895558-a351aa80-8cbc-11ea-87ce-11f74c899767.png)

> #### **One Context to rule them all**


## OneContext provides a simple way to deal with Dialogs, Overlays, Navigations, Theme* and MediaQuery* with no need of BuildContext.

> If you are Flutter developer, you don’t have to learn something new. This package use the same identificators and names from framework. It’s not a specialized* implementation, so you have the power to create and do not get blocked because of that.

> If you are Flutter package developer, OneContext can be very useful too!  You can create a custom dialogs package with no need BuildContext, and release a version, that do not depends of the context, to the comunity.

![one_context_demo](https://user-images.githubusercontent.com/3827308/81240561-13727000-8fde-11ea-8400-64e2b2861a87.gif)
  
> BuildContext always is needed (in some cases we need to choose carefully the specific one to make things work as expected), but, to global things, like dialogs, it can be reached by OneContext package. 🎯


## 🎮  Let's start 

#### There are 2 ways to get OneContext singleton instance, OneContext() or OnceContext.intance. e.g.
```dart
    OneContext().pushNamed('/detail_page');
```

```dart
    OneContext.instance.pushNamed('/detail_page');
```

#### There are controllers to use navigation, overlays and dialogs. e.g.
```dart
    OneContext().navigator.pushNamed(...);
    OneContext().dialog.showDialog(...);
    OneContext().overlay.addOverlay(...);
```

#### Or, you can use the shortcuts ;)
```dart
    OneContext().pushNamed(...);
    OneContext().showDialog(...);
    OneContext().addOverlay(...);
    
    // and can access info from:
    // OneContext().mediaQuery ...
    // OneContext().textTheme ...
    // OneContext().theme ...
```

#### OneContext is:
* Fast (O(1))
* Easy to learn/use
* It use same native function names from Flutter, to keep it simple and intuitive ;)

## 💬  How to show Dialogs with no need of the BuildContext? 

```dart
// example snackBar
OneContext().showSnackBar(
    builder: (_) => SnackBar(content: Text('My awesome snackBar!'))
);
```

```dart
// example dialog
OneContext().showDialog(
    // barrierDismissible: false,
    builder: (_) => AlertDialog( 
        title: new Text("The Title"),
        content: new Text("The Body"),
    )
);
```

```dart
// example bottomSheet
OneContext().showBottomSheet(
    builder: (context) => Container(
    alignment: Alignment.topCenter,
    height: 200,
    child: IconButton(
        icon: Icon(Icons.arrow_drop_down),
        iconSize: 50,
        color: Colors.white,
        onPressed: () => Navigator.of(context).pop('sucess')), // or OneContext().popDialog('sucess');
    ),
);
```

```dart
// example modalBottomSheet
OneContext().showModalBottomSheet<String>(
    builder: (context) => Container(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
            ListTile(
                leading: Icon(Icons.music_note),
                title: Text('Music'),
                onTap: () => OneContext().popDialog('Music'); //Navigator.of(context).pop('Music')),
            ListTile(
                leading: Icon(Icons.videocam),
                title: Text('Video'),
                onTap: () => Navigator.of(context).pop('Video'),
            ),
            SizedBox(height: 45)
            ],
        ),
    )
);
```



## ⛵  How to navigate? (All methods from Navigator Class are available)
```dart
// go to second page using named route
OneContext().pushNamed('/second');
```

```dart
// go to second page using MaterialPageRoute
OneContext().push(MaterialPageRoute(builder: (_) => SecondPage()));
```

```dart
// go back from second page
OneContext().pop();
```

```dart
// Retrieve data from route when it's pops
String result = await OneContext().push<String>(MaterialPageRoute(builder: (_) => SecondPage()));
print(result);
```


## 🍰  How to show Overlays? 

```dart
// show the default progress indicator
OneContext().showProgressIndicator();
```

```dart
// hide the default progress indicator
OneContext().hideProgressIndicator();
```

```dart
// show the default progress indicator with some colors
OneContext().showProgressIndicator(
    backgroundColor: Colors.blue.withOpacity(.3),
    circularProgressIndicatorColor: Colors.white
);

// Later
OneContext().hideProgressIndicator();
```

```dart
// Show a custom progress indicator
OneContext().showProgressIndicator(
    builder: (_) => MyAwesomeProgressIndicator();
);

// Later
OneContext().hideProgressIndicator();
```

```dart
// Show a custom widget in overlay stack

String myCustomAndAwesomeOverlayId = UniqueKey().toString();

OneContext().addOverlay(
    overlayId: myCustomAndAwesomeOverlayId,
    builder: (_) => MyCustomAndAwesomeOverlay()
);

// Later
OneContext().removeOverlay(myCustomAndAwesomeOverlayId);
```

## ⚙ Theme and MediaQuery
```dart
print('Platform: ' + OneContext().theme.platform); // TargetPlatform.iOS
print('Orientation: ' + OneContext().mediaQuery.orientation); // Orientation.portrait
```

## ⚠  Important: Configure MaterialApp. e.g.
```dart
/// important: Use [OneContext().builder] in `MaterialApp` builder, in order to show dialogs and overlays.
/// important: Use [OneContext().key] in `MaterialApp` navigatorKey, in order to navigate.
return MaterialApp(
    builder: OneContext().builder,
    navigatorKey: OneContext().key,
    ...
);
```

### In initState (Can not show dialog if markNeedsBuild, so schedule to next frame)
```dart
@override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (duration) => OneContext().showDialog(
        builder: (_) => AlertDialog(
          title: new Text("On Page Load"),
          content: new Text("Hello World!"),
        ),
      ),
    );
```


## 🚦  Warnings
\* OneContex().theme and OneContex().mediaQuery are global instances of the root of the widget tree. Use it with care! It can reproduce unexpected behavior if you don't understand it.

\* OneContext().context is like a root context, so, it should not be used directly, as it can reproduce unexpected behaviors, unless you have a understanding how it works. It shouldn't work well with InheritedWidget for example.

\* This package only uses specialized implementation in Overlays, to make things easy and ensure a quick start.


## 👨‍💻👨‍💻  Contributing

#### Contributions of any kind are welcome! I'll be glad to analyse and accept them! 👾

#### If you have any question about the project:

Email-me: fastencoding@gmail.com

Connect with me at [LinkedIn](https://www.linkedin.com/in/emanuel-braz/).
