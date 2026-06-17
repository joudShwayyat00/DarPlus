import '../../data/models/rate_asset_response.dart';

abstract class RatingRepository {
  Future<RateAssetResponse> rateAsset({
    required int rating,
    required int assetId,
    String? comment,
  });
}
