import '../../domain/repositories/category_repository.dart';
import '../data_sources/category_service_client.dart';
import '../models/category_item.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryServiceClient _categoryServiceClient;

  CategoryRepositoryImpl(this._categoryServiceClient);

  @override
  Future<List<CategoryItem>> getCategories(String lang) async {
    final response = await _categoryServiceClient.getCategories(lang);
    return response.result;
  }
}
