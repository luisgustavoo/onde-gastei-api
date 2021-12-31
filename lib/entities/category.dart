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
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Category &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          description == other.description &&
          iconCode == other.iconCode &&
          colorCode == other.colorCode &&
          userId == other.userId;

  @override
  int get hashCode =>
      id.hashCode ^
      description.hashCode ^
      iconCode.hashCode ^
      colorCode.hashCode ^
      userId.hashCode;
}
