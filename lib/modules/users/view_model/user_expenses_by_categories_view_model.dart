class UserExpensesByCategoriesViewModel {
  UserExpensesByCategoriesViewModel(
      {required this.categoryId,
      required this.description,
      required this.totalValue});

  final int categoryId;
  final String description;
  final double totalValue;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserExpensesByCategoriesViewModel &&
          runtimeType == other.runtimeType &&
          categoryId == other.categoryId &&
          description == other.description &&
          totalValue == other.totalValue;

  @override
  int get hashCode =>
      categoryId.hashCode ^ description.hashCode ^ totalValue.hashCode;
}
