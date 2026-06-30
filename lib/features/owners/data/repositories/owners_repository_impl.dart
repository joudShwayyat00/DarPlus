import 'package:dio/dio.dart';
import 'package:dar_plus_app/features/assets/data/models/asset_owner.dart';
import 'package:dar_plus_app/features/owners/data/models/owner_detail.dart';
import 'package:dar_plus_app/features/owners/data/models/owner_statistics_response.dart';

import '../../domain/repositories/owners_repository.dart';
import '../data_sources/owners_service_client.dart';

class OwnersRepositoryImpl implements OwnersRepository {
  final OwnersServiceClient _client;

  OwnersRepositoryImpl(this._client);

  @override
  Future<List<AssetOwner>> getOwners() async {
    final response = await _client.getOwners();
    return response.data;
  }

  @override
  Future<OwnerDetail> getOwnerDetail(int id) async {
    final response = await _client.getOwnerDetail(id);
    return response.data;
  }

  @override
  Future<OwnerStatisticsData> getOwnerStatistics() async {
    try {
      final response = await _client.getOwnerStatistics();
      return response.data;
    } on DioException catch (e) {
      final data = e.response?.data;
      final message = data is Map
          ? (data['message'] as String? ?? 'Failed to load statistics')
          : 'Failed to load statistics';
      throw Exception(message);
    }
  }
}
