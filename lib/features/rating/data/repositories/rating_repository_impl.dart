import 'package:dio/dio.dart';

import '../../domain/repositories/rating_repository.dart';
import '../data_sources/rating_service_client.dart';
import '../models/rate_asset_response.dart';

class RatingRepositoryImpl implements RatingRepository {
  final RatingServiceClient _client;

  RatingRepositoryImpl(this._client);

  @override
  Future<RateAssetResponse> rateAsset({
    required int rating,
    required int assetId,
    String? comment,
  }) async {
    try {
      return await _client.rateAsset(
        rating: rating,
        assetId: assetId,
        comment: comment,
      );
    } on DioException catch (e) {
      final data = e.response?.data;
      final message = data is Map
          ? (data['message'] as String? ?? 'Failed to save rating')
          : 'Failed to save rating';
      throw Exception(message);
    }
  }
}
