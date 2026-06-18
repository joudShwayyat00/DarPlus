import '../../data/models/rate_asset_response.dart';
import '../../data/models/rate_owner_response.dart';

abstract class RatingRepository {
  Future<RateAssetResponse> rateAsset({
    required int rating,
    required int assetId,
    String? comment,
  });

  Future<RateOwnerResponse> rateOwner({
    required int ownerId,
    required int rating,
    String? comment,
  });
}
