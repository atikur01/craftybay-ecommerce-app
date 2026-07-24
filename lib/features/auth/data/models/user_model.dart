class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String city;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.city,
  });

  factory UserModel.fromJson(Map<String, dynamic> jsonData) {
    return UserModel(
      city: jsonData['city'],
      email: jsonData['email'],
      firstName: jsonData['first_name'],
      lastName: jsonData['last_name'],
      id: jsonData['_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'city': city,
      'first_name': firstName,
      'last_name': lastName,
      '_id': id,
    };
  }
}
