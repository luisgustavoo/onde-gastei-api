// ignore_for_file: avoid_equals_and_hash_code_on_mutable_classes

import 'package:onde_gastei_api/entities/category.dart';

class UserCategoriesByPercentageViewModel {
  UserCategoriesByPercentageViewModel({
    required this.value,
    required this.percentage,
    required this.category,
  });

  final double value;
  final double percentage;
  final Category category;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is UserCategoriesByPercentageViewModel &&
        other.value == value &&
        other.percentage == percentage &&
        other.category == category;
  }

  @override
  int get hashCode => value.hashCode ^ percentage.hashCode ^ category.hashCode;
}
