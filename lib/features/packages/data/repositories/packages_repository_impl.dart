import '../../domain/repositories/packages_repository.dart';
import '../data_sources/packages_service_client.dart';
import '../models/package_item.dart';

class PackagesRepositoryImpl implements PackagesRepository {
  final PackagesServiceClient _client;

  PackagesRepositoryImpl(this._client);

  @override
  Future<List<PackageItem>> getPackages(String lang) async {
    final response = await _client.getPackages(lang);
    return response.items;
  }
}
