class ExpenseSaveInputModel {
  ExpenseSaveInputModel({
    required this.description,
    required this.value,
    required this.date,
    required this.userId,
    required this.categoryId,
    this.local,
  });

  final String description;
  final double value;
  final DateTime date;
  final String? local;
  final int userId;
  final int categoryId;
}
