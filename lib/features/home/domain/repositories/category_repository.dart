import '../../data/models/category_item.dart';

abstract class CategoryRepository {
  Future<List<CategoryItem>> getCategories(String lang);
}
