import 'package:one_context/src/controllers/one_context.dart';
import 'package:flutter/material.dart';

// to do...
// enum OverlayTransition {fade, slideUp, slideDown, slideRight, slideLeft}

mixin OverlayController {
  /// Return overlay utility class `OverlayController`
  OverlayController get overlay => this;
  BuildContext get context => OneContext().context;

  OverlayEntry _overlayEntry;
  Map<String, OverlayEntry> _overlays = Map<String, OverlayEntry>();

  /// Show the overlay widget keeped by this class (it's like a single instance)
  /// It can be used many times, without an `overlayId`
  // ignore: missing_return
  OverlayEntry showOverlay({Widget Function(BuildContext context) builder}) {
    hideOverlay();
    Future.delayed(Duration.zero, () {
      OverlayState overlayState = Overlay.of(OneContext().context);
      _overlayEntry = OverlayEntry(builder: builder);
      overlayState.insert(_overlayEntry);
      return _overlayEntry;
    });
  }

  /// Hide the overlay widget keeped by this class (it's like a single instance)
  /// It can be used many times, without an `overlayId`
  hideOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry.remove();
      _overlayEntry = null;
    }
  }

  /// Add an widget to overlay stack
  // ignore: missing_return
  String addOverlay(
      {@required String overlayId,
      @required Widget Function(BuildContext context) builder}) {
    assert(builder != null);
    assert(overlayId != null);

    Future.delayed(Duration.zero, () {
      OverlayState overlayState = Overlay.of(OneContext().context);
      OverlayEntry overlayEntry = OverlayEntry(builder: builder);
      overlayState.insert(overlayEntry);
      _overlays.putIfAbsent(overlayId, () => overlayEntry);
      return overlayId;
    });
  }

  /// Remove a widget from overlay stack by widget id `overlayId`
  removeOverlay(String overlayId) {
    if (_overlays.containsKey(overlayId)) {
      OverlayEntry item = _overlays[overlayId];
      _overlays.remove(overlayId);
      item?.remove();
      item = null;
    }
  }

  /// Remove all overlays previously added from stack
  removeAllOverlays() {
    _overlays.keys.forEach((key) => removeOverlay(key));
    _overlays = Map<String, OverlayEntry>();
  }

  /// Show circular progress indicator, or a custom widget.
  /// It can be used generally to show progress indicator,
  /// but you can use a completelly custom widget
  OverlayEntry showProgressIndicator(
      {Widget Function(BuildContext context) builder,
      Color backgroundColor,
      Color circularProgressIndicatorColor}) {
    return showOverlay(
        builder: (_) => Stack(
              children: <Widget>[
                ModalBarrier(
                  dismissible: false,
                  color: backgroundColor ?? Colors.black45,
                ),
                builder != null
                    ? builder(context)
                    : Center(
                        child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            circularProgressIndicatorColor ?? Colors.white),
                      ))
              ],
            ));
  }

  /// Hide progress indicator if it is visible
  void hideProgressIndicator() => hideOverlay();
}
