import 'package:dar_plus_app/features/assets/data/models/asset_owner.dart';
import 'package:dar_plus_app/features/owners/data/models/owner_detail.dart';
import 'package:dar_plus_app/features/owners/data/models/owner_statistics_response.dart';

abstract class OwnersRepository {
  Future<List<AssetOwner>> getOwners();
  Future<OwnerDetail> getOwnerDetail(int id);
  Future<OwnerStatisticsData> getOwnerStatistics();
}
