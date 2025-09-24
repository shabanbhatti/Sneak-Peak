import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sneak_peak/models/caraousels_banners_model.dart';
import 'package:sneak_peak/provider/provider_objects.dart';

final bannersProvider = StreamProvider<List<CaraouselsBannersModel>>((ref) {
  var productRepo= ref.read(productServiceRepositoryProviderObject);
  return productRepo.bannerStream();
});