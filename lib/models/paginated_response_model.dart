/// Wraps Laravel's root-level paginator response.
/// Shape (from response()->json($paginator)):
/// {
///   "current_page": 1,
///   "data": [...],
///   "last_page": 5,
///   "per_page": 12,
///   "total": 60,
///   "from": 1,
///   "to": 12,
///   "next_page_url": "...",
///   "prev_page_url": null
/// }
/// Note: pagination keys are at root level, NOT inside a "meta" wrapper.
class PaginatedResponseModel<T> {
  const PaginatedResponseModel({
    required this.data,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
    this.from,
    this.to,
    this.nextPageUrl,
    this.prevPageUrl,
  });

  final List<T> data;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final int? from;
  final int? to;
  final String? nextPageUrl;
  final String? prevPageUrl;

  // True when another page can be requested from the backend.
  bool get hasNextPage => currentPage < lastPage;

  // Parses paginated JSON and delegates item parsing to the caller.
  factory PaginatedResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromItem,
  ) {
    return PaginatedResponseModel<T>(
      data: (json['data'] as List<dynamic>)
          .map((e) => fromItem(Map<String, dynamic>.from(e as Map)))
          .toList(),
      currentPage: (json['current_page'] as num).toInt(),
      lastPage: (json['last_page'] as num).toInt(),
      perPage: (json['per_page'] as num).toInt(),
      total: (json['total'] as num).toInt(),
      from: (json['from'] as num?)?.toInt(),
      to: (json['to'] as num?)?.toInt(),
      nextPageUrl: json['next_page_url'] as String?,
      prevPageUrl: json['prev_page_url'] as String?,
    );
  }
}
