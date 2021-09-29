class ExpenseUpdateInputModel {
  ExpenseUpdateInputModel(
      {required this.description,
      required this.value,
      required this.date,
      required this.categoryId});

  final String description;
  final double value;
  final DateTime date;
  final int categoryId;
}
