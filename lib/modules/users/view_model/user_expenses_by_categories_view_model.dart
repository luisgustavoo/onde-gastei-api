// ignore_for_file: avoid_equals_and_hash_code_on_mutable_classes

class UserExpensesByCategoriesViewModel {
  UserExpensesByCategoriesViewModel({
    required this.categoryId,
    required this.description,
    required this.categoryIconCode,
    required this.categoryColorCode,
    required this.totalValue,
  });

  final int categoryId;
  final String description;
  final int categoryIconCode;
  final int categoryColorCode;
  final double totalValue;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserExpensesByCategoriesViewModel &&
          runtimeType == other.runtimeType &&
          categoryId == other.categoryId &&
          description == other.description &&
          categoryIconCode == other.categoryIconCode &&
          categoryColorCode == other.categoryColorCode &&
          totalValue == other.totalValue;

  @override
  int get hashCode =>
      categoryId.hashCode ^
      description.hashCode ^
      categoryIconCode.hashCode ^
      categoryColorCode.hashCode ^
      totalValue.hashCode;
}
