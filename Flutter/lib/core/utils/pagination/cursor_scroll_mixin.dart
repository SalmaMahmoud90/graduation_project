import 'package:flutter/widgets.dart';

/// A mixin that wires a [ScrollController] with cursor pagination behaviour.
///
/// The mixin listens to scroll updates and triggers [onLoadMore] when the
/// scrolling position approaches the bottom of the list. It prevents redundant
/// fetches when [isLoadingMore] is true or when [canLoadMore] is false.
///
/// To customise the trigger threshold override [paginationThreshold].
mixin CursorScrollMixin<T extends StatefulWidget> on State<T> {
    late final ScrollController paginationController;

  /// The distance from the bottom of the scroll extent at which [onLoadMore]
  /// should be triggered. Defaults to `200` logical pixels.
  double get paginationThreshold => 200;

  /// Whether another page can be requested.
  bool get canLoadMore;

  /// Whether a pagination request is currently in-flight.
  bool get isLoadingMore;

  /// Called when the mixin determines that more data should be requested.
  void onLoadMore();

  @override
  void initState() {
    super.initState();
    paginationController = ScrollController()..addListener(_handleScroll);
  }

  @override
  void dispose() {
    paginationController
      ..removeListener(_handleScroll)
      ..dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (!canLoadMore || isLoadingMore) return;
    if (!paginationController.hasClients) return;

    final position = paginationController.position;
    if (!position.hasPixels || position.maxScrollExtent == double.infinity) {
      return;
    }

    if (position.extentAfter <= paginationThreshold) {
      onLoadMore();
    }
  }
}
