import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:sneak_peak/services/location%20service/location_ser.dart';
import 'package:sneak_peak/utils/snack_bar_helper.dart';

final locationProvider = StateNotifierProvider<LocationNotifier, Placemark>((ref) {
  return LocationNotifier();
});

class LocationNotifier extends StateNotifier<Placemark> {
  LocationNotifier(): super(Placemark());
  LocationService locationService= LocationService();

Future<void> getLocation()async{

try {
Placemark placemark=  await locationService.getCityLocation();

state= placemark;

} catch (e) {
  
SnackBarHelper.show(e.toString());

}


}

  
}