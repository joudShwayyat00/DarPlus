import '../../domain/repositories/assets_repository.dart';
import '../data_sources/assets_service_client.dart';
import '../models/asset_item.dart';

class AssetsRepositoryImpl implements AssetsRepository {
  final AssetsServiceClient _serviceClient;

  AssetsRepositoryImpl(this._serviceClient);

  @override
  Future<List<AssetItem>> getAssets(String lang) async {
    final response = await _serviceClient.getAssets(lang);
    return response.result;
  }

  @override
  Future<List<AssetItem>> getTopRatedAssets() async {
    final response = await _serviceClient.getTopRatedAssets();
    return response.result;
  }

  @override
  Future<AssetItem> getAssetDetail({
    required int id,
    required String lang,
  }) async {
    final response = await _serviceClient.getAssetDetail(id, lang);
    return response.result;
  }
}
