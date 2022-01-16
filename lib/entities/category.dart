// ignore_for_file: avoid_equals_and_hash_code_on_mutable_classes

class Category {
  Category({
    required this.id,
    required this.description,
    required this.iconCode,
    required this.colorCode,
    this.userId,
  });

  final int id;
  final String description;
  final int iconCode;
  final int colorCode;
  final int? userId;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is Category &&
        other.id == id &&
        other.description == description &&
        other.iconCode == iconCode &&
        other.colorCode == colorCode &&
        other.userId == userId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        description.hashCode ^
        iconCode.hashCode ^
        colorCode.hashCode ^
        userId.hashCode;
  }
}
