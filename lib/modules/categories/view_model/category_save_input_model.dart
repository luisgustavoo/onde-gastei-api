class CategorySaveInputModel {
  CategorySaveInputModel(
      {required this.description,
      required this.icon,
      required this.color,
      required this.userId});

  final String description;
  final int icon;
  final int color;
  final int userId;
}
