// FAQ item data model used by settings/support FAQ screens.
class FaqItemModel {
  const FaqItemModel({
    required this.id,
    required this.question,
    required this.answer,
    this.category,
    this.order = 0,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
    this.questionEn,
    this.questionAr,
    this.answerEn,
    this.answerAr,
    this.categoryEn,
    this.categoryAr,
  });

  final int id;
  final String question;
  final String answer;
  final String? category;
  final int order;
  final bool isActive;
  final String? createdAt;
  final String? updatedAt;
  final String? questionEn;
  final String? questionAr;
  final String? answerEn;
  final String? answerAr;
  final String? categoryEn;
  final String? categoryAr;

  // Creates a FAQ item from API JSON with safe fallback values.
  factory FaqItemModel.fromJson(Map<String, dynamic> json) {
    return FaqItemModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      question: json['question']?.toString() ?? '',
      answer: json['answer']?.toString() ?? '',
      category: json['category']?.toString(),
      order: (json['order'] as num?)?.toInt() ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      questionEn: json['question_en']?.toString(),
      questionAr: json['question_ar']?.toString(),
      answerEn: json['answer_en']?.toString(),
      answerAr: json['answer_ar']?.toString(),
      categoryEn: json['category_en']?.toString(),
      categoryAr: json['category_ar']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'question': question,
    'answer': answer,
    'category': category,
    'order': order,
    'is_active': isActive,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'question_en': questionEn,
    'question_ar': questionAr,
    'answer_en': answerEn,
    'answer_ar': answerAr,
    'category_en': categoryEn,
    'category_ar': categoryAr,
  };

  String getLocalizedQuestion(bool isArabic) {
    return isArabic && questionAr != null && questionAr!.isNotEmpty
        ? questionAr!
        : (questionEn ?? question);
  }

  String getLocalizedAnswer(bool isArabic) {
    return isArabic && answerAr != null && answerAr!.isNotEmpty
        ? answerAr!
        : (answerEn ?? answer);
  }

  String getLocalizedCategory(bool isArabic) {
    return isArabic && categoryAr != null && categoryAr!.isNotEmpty
        ? categoryAr!
        : (categoryEn ?? category ?? '');
  }
}
