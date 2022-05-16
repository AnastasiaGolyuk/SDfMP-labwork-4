class User {
  final int id;
  final String username;
  final String email;
  final String passwordHash;
  final int isAuthorized;

  User({required this.id,
    required this.username,
    required this.email,
    required this.passwordHash,
    required this.isAuthorized});

  factory User.fromJson(Map<String, dynamic> json) =>
      User(
          id: json["id"],
          username: json["username"],
          email: json["email"],
          passwordHash: json["passwordHash"],
          isAuthorized: json["isAuthorized"],);

  Map<String, dynamic> toJson() =>
      {
        "id": id,
        "username": username,
        "email": email,
        "passwordHash": passwordHash,
        "isAuthorized": isAuthorized
      };
}
