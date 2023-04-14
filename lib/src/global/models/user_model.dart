// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  final String id;
  final String email;

  UserModel({
    required this.id,
    required this.email,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
      };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as String,
        email: json['email'] as String,
      );
}
