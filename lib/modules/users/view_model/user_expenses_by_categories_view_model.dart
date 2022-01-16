// ignore_for_file: avoid_equals_and_hash_code_on_mutable_classes

import 'package:onde_gastei_api/entities/category.dart';

class UserExpensesByCategoriesViewModel {
  UserExpensesByCategoriesViewModel({
    required this.totalValue,
    required this.category,
  });

  final double totalValue;
  final Category category;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is UserExpensesByCategoriesViewModel &&
        other.totalValue == totalValue &&
        other.category == category;
  }

  @override
  int get hashCode => totalValue.hashCode ^ category.hashCode;
}
