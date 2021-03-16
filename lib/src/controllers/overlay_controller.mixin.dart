import 'package:one_context/src/controllers/one_context.dart';
import 'package:flutter/material.dart';

// to do...
// enum OverlayTransition {fade, slideUp, slideDown, slideRight, slideLeft}

mixin OverlayController {
  /// Return overlay utility class `OverlayController`
  OverlayController get overlay => this;
  BuildContext? get context => OneContext().context;

  OverlayEntry? _overlayEntry;
  Map<String, OverlayEntry> _overlays = Map<String, OverlayEntry>();

  /// Show the overlay widget keeped by this class (it's like a single instance)
  /// It can be used many times, without an `overlayId`
  Future<OverlayEntry> showOverlay(
      {Widget Function(BuildContext context)? builder}) async {
    hideOverlay();
    await Future.delayed(Duration.zero, () {});
    OverlayState overlayState = Overlay.of(OneContext().context!)!;
    _overlayEntry = OverlayEntry(builder: builder!);
    overlayState.insert(_overlayEntry!);
    return _overlayEntry!;
  }

  /// Hide the overlay widget keeped by this class (it's like a single instance)
  /// It can be used many times, without an `overlayId`
  hideOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }

  /// Add an widget to overlay stack
  Future<String> addOverlay(
      {required String overlayId,
      required Widget Function(BuildContext context) builder,
      OverlayEntry? below,
      OverlayEntry? above}) async {
    await Future.delayed(Duration.zero, () {});
    OverlayState overlayState = Overlay.of(OneContext().context!)!;
    OverlayEntry overlayEntry = OverlayEntry(builder: builder);
    overlayState.insert(overlayEntry, above: above, below: below);
    _overlays.putIfAbsent(overlayId, () => overlayEntry);
    return overlayId;
  }

  /// Remove a widget from overlay stack by widget id `overlayId`
  removeOverlay(String overlayId) {
    if (_overlays.containsKey(overlayId)) {
      OverlayEntry? item = _overlays[overlayId];
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

  /// Get OverlayEntry by id, if overlay with this id exists,
  /// else it will return null
  OverlayEntry? getOverlayById(String id) {
    if (_overlays.containsKey(id)) {
      return _overlays[id];
    }
    return null;
  }

  /// Remove all the entries listed in the given iterable, then reinsert them
  /// into the overlay in the given order.
  ///
  /// Entries mention in `newEntries` but absent from the overlay are inserted
  /// as if with [insertAll].
  ///
  /// Entries not mentioned in `newEntries` but present in the overlay are
  /// positioned as a group in the resulting list relative to the entries that
  /// were moved, as specified by one of `below` or `above`, which, if
  /// specified, must be one of the entries in `newEntries`:
  ///
  /// If `below` is non-null, the group is positioned just below `below`.
  /// If `above` is non-null, the group is positioned just above `above`.
  /// Otherwise, the group is left on top, with all the rearranged entries
  /// below.
  ///
  /// It is an error to specify both `above` and `below`.
  void rearrange(Iterable<OverlayEntry> newEntries,
      {OverlayEntry? below, OverlayEntry? above}) {
    OverlayState overlayState = Overlay.of(OneContext().context!)!;
    overlayState.rearrange(newEntries, below: below, above: above);
  }

  /// (DEBUG ONLY) Check whether a given entry is visible (i.e., not behind an
  /// opaque entry).
  ///
  /// This is an O(N) algorithm, and should not be necessary except for debug
  /// asserts. To avoid people depending on it, this function is implemented
  /// only in debug mode, and always returns false in release mode.
  bool debugIsVisible(OverlayEntry entry) {
    OverlayState overlayState = Overlay.of(OneContext().context!)!;
    return overlayState.debugIsVisible(entry);
  }

  /// Show circular progress indicator, or a custom widget.
  /// It can be used generally to show progress indicator,
  /// but you can use a completelly custom widget
  Future<OverlayEntry> showProgressIndicator(
      {Widget Function(BuildContext? context)? builder,
      Color? backgroundColor,
      Color? circularProgressIndicatorColor}) {
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
