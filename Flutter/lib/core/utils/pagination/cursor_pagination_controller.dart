/* import 'package:a_tareqaak/data/model/pagination/pagination_model.dart';

/// A reusable controller that manages cursor-based pagination for any type [T].
///
/// The controller keeps track of the aggregated items and the latest cursor
/// received from the backend. It also prevents duplicate entries when an
/// [identifier] is provided.
class CursorPaginationController<T, K> {
  CursorPaginationController({
    K? Function(T value)? identifier,
  }) : _identifier = identifier;

  final K? Function(T value)? _identifier;
  final List<T> _items = <T>[];
  String? _nextCursor;

  /// An unmodifiable view of the accumulated items.
  List<T> get items => List.unmodifiable(_items);

  /// The cursor that should be used to fetch the next page.
  String? get nextCursor => _nextCursor;

  /// Whether there is potentially another page to be fetched.
  bool get hasMore => (_nextCursor ?? '').isNotEmpty;

  /// Whether the controller currently holds no items.
  bool get isEmpty => _items.isEmpty;

  /// Clears the stored items and cursor.
  void reset() {
    _items.clear();
    _nextCursor = null;
  }

  /// Replaces the current items with the contents of [page].
  void replaceWith(PaginationModel<T>? page) {
    _merge(page, append: false);
  }

  /// Appends the contents of [page] to the existing items.
  void append(PaginationModel<T>? page) {
    _merge(page, append: true);
  }


  void _merge(PaginationModel<T>? page, {required bool append}) {
    _nextCursor = page?.meta?.nextCursor;
    final List<T>? incoming = page?.data;
    if (incoming == null || incoming.isEmpty) {
      if (!append) {
        _items.clear();
      }
      return;
    }

    if (!append) {
      _items
        ..clear()
        ..addAll(incoming);
      return;
    }

    if (_identifier == null) {
      _items.addAll(incoming);
      return;
    }

    final Set<K> existingKeys = _items.map(_identifier).whereType<K>().toSet();

    for (final T item in incoming) {
      final K? key = _identifier(item);
      if (key == null || existingKeys.add(key)) {
        _items.add(item);
      }
    }
  }
}
 */