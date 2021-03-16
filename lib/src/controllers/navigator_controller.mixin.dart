import 'package:one_context/src/controllers/one_context.dart';
import 'package:flutter/material.dart';

mixin NavigatorController {
  /// Return navigator utility class `NavigatorController`
  NavigatorController get navigator => this;
  BuildContext? get context => OneContext().context;

  GlobalKey<NavigatorState>? _key;

  /// Get the global key `GlobalKey<NavigatorState>()`
  ///
  /// Use [OneContext().key] in MaterialApp navigatorKey,
  /// in order to navigate.
  ///
  /// e.g.
  ///
  /// ```dart
  /// return MaterialApp(
  ///      navigatorKey: OneContext().key,
  ///      ...
  /// ```
  ///
  /// IMPORTANT: Need instantiate OneContext().key = GlobalKey<NavigatorState>(),
  /// ONLY if you use MORE THAN ONE app in same project
  ///
  /// For example, if you have MainPetShopApp() and MainBeerReferenceApp() and you want to change between them.
  ///
  /// e.g.
  ///
  /// ```
  /// OnePlatform.reboot(
  ///     setUp: () => OneContext().key = GlobalKey<NavigatorState>(),
  ///     builder: () => MyApp()
  /// );
  /// ```
  GlobalKey<NavigatorState> get key => _key ??= GlobalKey<NavigatorState>();
  set key(newKey) => _key = newKey;

  NavigatorState? get _nav {
    assert(
        _key != null,
        'Navigator key not found! MaterialApp.navigatorKey is null or not set correctly.'
        '\n\nYou need to use OneContext().navigator.key to be able to navigate! e.g. ->'
        '\n\nMaterialApp(\n    navigatorKey: OneContext().navigator.key\n    ...\n)');
    return key.currentState;
  }

  /// Push a named route onto the navigator that most tightly encloses the given
  /// context.
  String get defaultRouteName => Navigator.defaultRouteName;

  /// The state from the closest instance of this class that encloses the given context.
  NavigatorState navigatorOf({required bool rootNavigator}) =>
      Navigator.of(context!, rootNavigator: rootNavigator);

  ///  Push the given route onto the navigator.
  Future<T?> push<T extends Object?>(Route<T> route) => _nav!.push<T>(route);

  /// Whether the navigator can be popped.
  bool canPop() => _nav!.canPop();

  /// Tries to pop the current route, while honoring the route's [Route.willPop]
  /// state.
  Future<bool> maybePop<T extends Object?>([T? result]) async =>
      _nav!.maybePop<T>(result);

  /// Pop the top-most route off the navigator.
  void pop<T extends Object?>([T? result]) => _nav!.pop<T>(result);

  /// Pop the current route off the navigator and push a named route in its
  /// place.
  Future<T?> popAndPushNamed<T extends Object?, TO extends Object?>(
          String routeName,
          {TO? result,
          Object? arguments}) =>
      _nav!.popAndPushNamed<T, TO>(routeName,
          result: result, arguments: arguments);

  /// Calls [pop] repeatedly until the predicate returns true.
  ///
  /// The predicate may be applied to the same route more than once if [Route.willHandlePopInternally] is true.
  ///
  /// To pop until a route with a certain name, use the [RoutePredicate] returned from [ModalRoute.withName].
  void popUntil(RoutePredicate predicate) => _nav!.popUntil(predicate);

  /// Push the given route onto the navigator, and then remove all the previous
  /// routes until the `predicate` returns true.
  Future<T?> pushAndRemoveUntil<T extends Object?>(
          Route<T> newRoute, RoutePredicate predicate) =>
      _nav!.pushAndRemoveUntil<T>(newRoute, predicate);

  /// Push a named route onto the navigator.
  Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) =>
      _nav!.pushNamed<T>(routeName, arguments: arguments);

  /// Push the route with the given name onto the navigator, and then remove all
  /// the previous routes until the `predicate` returns true.
  Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
          String newRouteName, RoutePredicate predicate, {Object? arguments}) =>
      _nav!.pushNamedAndRemoveUntil<T>(newRouteName, predicate,
          arguments: arguments);

  /// Replace the current route of the navigator by pushing the given route and
  /// then disposing the previous route once the new route has finished
  /// animating in.
  Future<T?> pushReplacement<T extends Object?, TO extends Object?>(
          Route<T> newRoute,
          {TO? result}) =>
      _nav!.pushReplacement<T, TO>(newRoute, result: result);

  /// Replace the current route of the navigator by pushing the route named
  /// [routeName] and then disposing the previous route once the new route has
  /// finished animating in.
  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
  }) =>
      _nav!.pushReplacementNamed<T, TO>(routeName,
          result: result, arguments: arguments);

  /// Immediately remove `route` from the navigator, and [Route.dispose] it.
  void removeRoute(Route<dynamic> route) => _nav!.removeRoute(route);

  /// Immediately remove a route from the navigator, and [Route.dispose] it. The
  /// route to be replaced is the one below the given `anchorRoute`.
  void removeRouteBelow(Route<dynamic> anchorRoute) =>
      _nav!.removeRouteBelow(anchorRoute);

  /// Replaces a route on the navigator with a new route.
  void replace<T extends Object?>(
          {required Route<dynamic> oldRoute, required Route<T> newRoute}) =>
      _nav!.replace<T>(oldRoute: oldRoute, newRoute: newRoute);

  /// Replaces a route on the navigator with a new route. The route to be
  /// replaced is the one below the given `anchorRoute`.
  void replaceRouteBelow<T extends Object?>(
          {required Route<dynamic> anchorRoute, required Route<T> newRoute}) =>
      _nav!.replaceRouteBelow<T>(anchorRoute: anchorRoute, newRoute: newRoute);
}
