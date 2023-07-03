class UserModel {
  final String id;
  final String email;
  final String? profilePictureUrl;

  UserModel({
    required this.id,
    required this.email,
    this.profilePictureUrl,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
      };

  factory UserModel.fromJson(Map<String, dynamic> json) {
    String? profilePictureUrl = json['profilePictureUrl'] as String;
    if (profilePictureUrl.isEmpty) {
      profilePictureUrl = null;
    }

    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      profilePictureUrl: profilePictureUrl,
    );
  }
}
