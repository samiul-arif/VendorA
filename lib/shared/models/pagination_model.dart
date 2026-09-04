import '../../core/utils/formatters.dart';

/// Generic Paginated List Wrapper with Full Metadata & Formatting Helpers
class PaginatedList<T> {
  final List<T> items;
  final int currentPage;
  final int pageSize;
  final int totalItems;
  final int totalPages;

  const PaginatedList({
    required this.items,
    required this.currentPage,
    required this.pageSize,
    required this.totalItems,
    required this.totalPages,
  });

  /// 1-based start index for current page items (e.g., 1 for page 1, 21 for page 2)
  int get startIndex => totalItems == 0 ? 0 : (currentPage - 1) * pageSize + 1;

  /// 1-based end index for current page items (e.g., 20 for page 1 with 20 items, or totalItems if last page)
  int get endIndex {
    if (totalItems == 0) return 0;
    final computed = currentPage * pageSize;
    return computed > totalItems ? totalItems : computed;
  }

  /// Whether a previous page exists
  bool get hasPreviousPage => currentPage > 1;

  /// Whether a next page exists
  bool get hasNextPage => currentPage < totalPages;

  /// Whether the page item list is empty
  bool get isEmpty => items.isEmpty;

  /// Whether the page item list has items
  bool get isNotEmpty => items.isNotEmpty;

  /// Standard merchant/admin summary string, e.g. "Showing 1–20 of 2,483 products"
  String showingSummary(String itemLabelPlural) {
    if (totalItems == 0) {
      return 'Showing 0 $itemLabelPlural';
    }
    final formattedTotal = Formatters.formatNumber(totalItems);
    return 'Showing $startIndex–$endIndex of $formattedTotal $itemLabelPlural';
  }

  /// Factory for an empty list state
  factory PaginatedList.empty({int pageSize = 20}) {
    return PaginatedList(
      items: const [],
      currentPage: 1,
      pageSize: pageSize,
      totalItems: 0,
      totalPages: 0,
    );
  }

  /// Slice an in-memory or full list into a paginated subset
  factory PaginatedList.fromAllItems({
    required List<T> allItems,
    required int page,
    required int pageSize,
  }) {
    final totalItems = allItems.length;
    final totalPages = totalItems == 0 ? 0 : (totalItems / pageSize).ceil();
    final validPage = totalPages > 0 ? page.clamp(1, totalPages) : 1;
    final start = (validPage - 1) * pageSize;
    final end = (start + pageSize) > totalItems ? totalItems : (start + pageSize);

    final slicedItems = (start >= totalItems) ? <T>[] : allItems.sublist(start, end);

    return PaginatedList(
      items: slicedItems,
      currentPage: validPage,
      pageSize: pageSize,
      totalItems: totalItems,
      totalPages: totalPages,
    );
  }

  PaginatedList<T> copyWith({
    List<T>? items,
    int? currentPage,
    int? pageSize,
    int? totalItems,
    int? totalPages,
  }) {
    return PaginatedList<T>(
      items: items ?? this.items,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      totalItems: totalItems ?? this.totalItems,
      totalPages: totalPages ?? this.totalPages,
    );
  }
}
