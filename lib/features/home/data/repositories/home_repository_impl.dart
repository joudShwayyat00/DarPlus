import '../../domain/repositories/home_repository.dart';
import '../data_sources/slider_service_client.dart';
import '../models/slider_item.dart';

class HomeRepositoryImpl implements HomeRepository {
  final SliderServiceClient _sliderServiceClient;

  HomeRepositoryImpl(this._sliderServiceClient);

  @override
  Future<List<SliderItem>> getSliders(String lang) async {
    final response = await _sliderServiceClient.getSliders(lang);
    return response.result;
  }
}
