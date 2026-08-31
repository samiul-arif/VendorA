/// Generic Paginated List Wrapper
class PaginatedList<T> {
  final List<T> items;
  final int page;
  final int pageSize;
  final int totalCount;
  final bool hasMore;

  const PaginatedList({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.totalCount,
    required this.hasMore,
  });

  factory PaginatedList.empty() {
    return const PaginatedList(
      items: [],
      page: 1,
      pageSize: 20,
      totalCount: 0,
      hasMore: false,
    );
  }
}
