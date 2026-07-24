class ReviewModel {
  final String id;
  final String comment;
  final double rating;
  final String userFirstName;
  final String userLastName;

  ReviewModel({
    required this.id,
    required this.comment,
    required this.rating,
    required this.userFirstName,
    required this.userLastName,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    String firstName = '';
    String lastName = '';

    if (json['user'] != null && json['user'] is Map<String, dynamic>) {
      firstName = json['user']['first_name'] ?? '';
      lastName = json['user']['last_name'] ?? '';
    }

    return ReviewModel(
      id: json['_id'] ?? '',
      comment: json['comment'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 4.0,
      userFirstName: firstName,
      userLastName: lastName,
    );
  }
}
