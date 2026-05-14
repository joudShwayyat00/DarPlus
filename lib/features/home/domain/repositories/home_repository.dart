import '../../data/models/slider_item.dart';

abstract class HomeRepository {
  Future<List<SliderItem>> getSliders(String lang);
}
