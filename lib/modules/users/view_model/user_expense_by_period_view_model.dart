// ignore_for_file: avoid_equals_and_hash_code_on_mutable_classes

import 'package:onde_gastei_api/entities/category.dart';

class UserExpenseByPeriodViewModel {
  UserExpenseByPeriodViewModel({
    required this.expenseId,
    required this.description,
    required this.value,
    required this.date,
    required this.category,
    this.local,
  });

  final int expenseId;
  final String description;
  final double value;
  final DateTime date;
  final String? local;
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
          local == other.local &&
          category == other.category;

  @override
  int get hashCode =>
      expenseId.hashCode ^
      description.hashCode ^
      value.hashCode ^
      date.hashCode ^
      local.hashCode ^
      category.hashCode;
}
