class UserCategoriesByPercentageViewModel {
  UserCategoriesByPercentageViewModel(
      {required this.categoryId,
      required this.description,
      required this.categoryValue,
      required this.categoryPercentage});

  final int categoryId;
  final String description;
  final double categoryValue;
  final double categoryPercentage;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserCategoriesByPercentageViewModel &&
          runtimeType == other.runtimeType &&
          categoryId == other.categoryId &&
          description == other.description &&
          categoryValue == other.categoryValue &&
          categoryPercentage == other.categoryPercentage;

  @override
  int get hashCode =>
      categoryId.hashCode ^
      description.hashCode ^
      categoryValue.hashCode ^
      categoryPercentage.hashCode;
}
