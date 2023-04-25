class User {
  final String userId;
  final String email;
  User(this.userId, this.email);

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      json['userId'],
      json['email'],
    );
  }
}
