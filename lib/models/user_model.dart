// lib/models/user_model.dart
class UserModel {
  final String id;
  final String name;
  final String? email;
  final String? accessToken;
  final String? idToken;

  UserModel({
    required this.id,
    required this.name,
    this.email,
    this.accessToken,
    this.idToken,
  });
}
