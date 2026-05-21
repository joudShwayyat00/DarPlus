import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/dio_factory.dart';
import '../../data/data_sources/slider_service_client.dart';
import '../../data/data_sources/category_service_client.dart';
import '../../data/repositories/home_repository_impl.dart';
import '../../data/repositories/category_repository_impl.dart';
import '../../domain/repositories/home_repository.dart';
import '../../domain/repositories/category_repository.dart';
import '../../data/models/slider_item.dart';
import '../../data/models/category_item.dart';
import '../../../../controller/local_provider.dart';

part 'home_providers.g.dart';

@riverpod
SliderServiceClient sliderServiceClient(Ref ref) {
  final dio = DioFactory.getDio();
  return SliderServiceClient(dio);
}

@riverpod
HomeRepository homeRepository(Ref ref) {
  final client = ref.watch(sliderServiceClientProvider);
  return HomeRepositoryImpl(client);
}

@riverpod
CategoryServiceClient categoryServiceClient(Ref ref) {
  final dio = DioFactory.getDio();
  return CategoryServiceClient(dio);
}

@riverpod
CategoryRepository categoryRepository(Ref ref) {
  final client = ref.watch(categoryServiceClientProvider);
  return CategoryRepositoryImpl(client);
}

@riverpod
class HomeSliderController extends _$HomeSliderController {
  @override
  FutureOr<List<SliderItem>> build() async {
    final lang = ref.read(localeProvider).languageCode;
    final repository = ref.read(homeRepositoryProvider);
    return await repository.getSliders(lang);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final lang = ref.read(localeProvider).languageCode;
      final repository = ref.read(homeRepositoryProvider);
      return await repository.getSliders(lang);
    });
  }
}

@riverpod
class HomeCategoryController extends _$HomeCategoryController {
  @override
  FutureOr<List<CategoryItem>> build() async {
    final lang = ref.read(localeProvider).languageCode;
    final repository = ref.read(categoryRepositoryProvider);
    return await repository.getCategories(lang);
  }
}
