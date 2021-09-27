class User {
  User(
      {required this.id,
      required this.name,
      required this.email,
      this.password,
      this.androidToken,
      this.iosToken,
      this.refreshToken});

  final int id;
  final String name;
  final String email;
  final String? password;
  final String? androidToken;
  final String? iosToken;
  final String? refreshToken;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          email == other.email &&
          password == other.password &&
          androidToken == other.androidToken &&
          iosToken == other.iosToken &&
          refreshToken == other.refreshToken;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      email.hashCode ^
      password.hashCode ^
      androidToken.hashCode ^
      iosToken.hashCode ^
      refreshToken.hashCode;
}
