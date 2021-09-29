import 'package:onde_gastei_api/entities/category.dart';

class UserExpenseByPeriodViewModel {
  UserExpenseByPeriodViewModel(
      {required this.expenseId,
      required this.description,
      required this.value,
      required this.date,
      required this.category});

  final int expenseId;
  final String description;
  final double value;
  final DateTime date;
  final Category category;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserExpenseByPeriodViewModel &&
          runtimeType == other.runtimeType &&
          expenseId == other.expenseId &&
          description == other.description &&
          value == other.value &&
          date == other.date &&
          category == other.category;

  @override
  int get hashCode =>
      expenseId.hashCode ^
      description.hashCode ^
      value.hashCode ^
      date.hashCode ^
      category.hashCode;
}
