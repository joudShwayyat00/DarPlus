import '../../data/models/package_item.dart';

abstract class PackagesRepository {
  Future<List<PackageItem>> getPackages(String lang);
}
