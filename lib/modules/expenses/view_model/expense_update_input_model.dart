class ExpenseUpdateInputModel {
  ExpenseUpdateInputModel({
    required this.description,
    required this.value,
    required this.date,
    required this.categoryId,
    this.local,
  });

  final String description;
  final double value;
  final DateTime date;
  final String? local;
  final int categoryId;
}
