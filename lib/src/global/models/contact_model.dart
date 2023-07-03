class ContactModel {
  String? id;
  String? name;

  /// @email é utilizado apenas para adicionar o contact.
  String? email;

  /// @userProfilePictureUrl é utilizado apenas para trazer a url de picture do user.
  String? userProfilePictureUrl;
  String? userId;

  ContactModel({
    this.id,
    this.name,
    this.email,
    this.userId,
    this.userProfilePictureUrl,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'userId': userId,
      };

  factory ContactModel.fromJson(Map<String, dynamic> json) => ContactModel(
        id: json['id'],
        name: json['name'],
        userId: json['userId'],
      );
}
