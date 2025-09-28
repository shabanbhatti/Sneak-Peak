import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sneak_peak/provider/provider_objects.dart';
import 'package:sneak_peak/repository/admin%20repository/product_cloud_db_repository.dart';
import 'package:sneak_peak/utils/constant_brands.dart';

final flChartProvider = StateNotifierProvider<
  FlChartStateNotifier,
  ({
    int ndure,
    int bata,
    int servis,
    int stylo,
    bool isLoading,
    bool isError,
    String error,
  })
>((ref) {
  return FlChartStateNotifier(
    productRepository: ref.read(productServiceRepositoryProviderObject),
  );
});

class FlChartStateNotifier
    extends
        StateNotifier<
          ({
            int ndure,
            int bata,
            int servis,
            int stylo,
            bool isLoading,
            bool isError,
            String error,
          })
        > {
  final ProductCloudDbRepository productRepository;
  FlChartStateNotifier({required this.productRepository})
    : super((
        ndure: 0,
        bata: 0,
        servis: 0,
        stylo: 0,
        isLoading: false,
        isError: false,
        error: '',
      ));

  Future<void> getData() async {
    state = (
      ndure: 0,
      bata: 0,
      servis: 0,
      stylo: 0,
      isLoading: true,
      isError: false,
      error: '',
    );
    try {
      var ndureData = await productRepository.getFlChartDataByBrand(ndure);
      var ndureValue = ndureData['total_solds'] ?? 0;

      var bataData = await productRepository.getFlChartDataByBrand(bata);
      var bataValue = bataData['total_solds'] ?? 0;

      var servisData = await productRepository.getFlChartDataByBrand(servis);
      var servisvalue = servisData['total_solds'] ?? 0;

      var styloData = await productRepository.getFlChartDataByBrand(stylo);
      var styloValue = styloData['total_solds'] ?? 0;

      state = (
        bata: bataValue,
        ndure: ndureValue,
        servis: servisvalue,
        stylo: styloValue,
        isLoading: false,
        isError: false,
        error: '',
      );
    } catch (e) {
      print('------------------------$e');
      state = (
        ndure: 0,
        bata: 0,
        servis: 0,
        stylo: 0,
        isLoading: false,
        isError: true,
        error: e.toString(),
      );
    }
  }

  Future<void> initialize() async {
    try {
      state = (
      ndure: 0,
      bata: 0,
      servis: 0,
      stylo: 0,
      isLoading: true,
      isError: false,
      error: '',
    );
      await productRepository.initializeFlChart();

       state = (
      ndure: 0,
      bata: 0,
      servis: 0,
      stylo: 0,
      isLoading: false,
      isError: false,
      error: '',
    );
    } catch (e) {
      state = (
        ndure: 0,
        bata: 0,
        servis: 0,
        stylo: 0,
        isLoading: false,
        isError: true,
        error: e.toString(),
      );
    }
  }
}
