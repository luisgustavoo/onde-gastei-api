// ignore_for_file: avoid_equals_and_hash_code_on_mutable_classes

class User {
  User({
    required this.id,
    required this.name,
    required this.firebaseUserId,
    this.refreshToken,
  });

  final int id;
  final String name;
  final String firebaseUserId;
  final String? refreshToken;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is User &&
        other.id == id &&
        other.name == name &&
        other.firebaseUserId == firebaseUserId &&
        other.refreshToken == refreshToken;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        firebaseUserId.hashCode ^
        refreshToken.hashCode;
  }
}
