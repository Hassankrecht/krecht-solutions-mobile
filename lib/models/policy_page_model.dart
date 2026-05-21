/// Represents a `Page` record from `GET /pages/{slug}`.
/// Slugs used: about | privacy-policy | terms | security
class PolicyPageModel {
  const PolicyPageModel({
    required this.id,
    required this.title,
    required this.slug,
    this.content,
    this.metaTitle,
    this.metaDescription,
    this.isPublished = true,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final String title;
  final String slug;
  final String? content;
  final String? metaTitle;
  final String? metaDescription;
  final bool isPublished;
  final String? createdAt;
  final String? updatedAt;

  factory PolicyPageModel.fromJson(Map<String, dynamic> json) {
    return PolicyPageModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      content: json['content']?.toString(),
      metaTitle: json['meta_title']?.toString(),
      metaDescription: json['meta_description']?.toString(),
      isPublished: json['is_published'] as bool? ?? true,
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'slug': slug,
    'content': content,
    'meta_title': metaTitle,
    'meta_description': metaDescription,
    'is_published': isPublished,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };
}
