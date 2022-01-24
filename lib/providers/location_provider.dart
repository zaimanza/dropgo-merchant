import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:geolocator/geolocator.dart';

import 'google_maps_provider.dart';

final locationProvider = ChangeNotifierProvider((ref) => LocationProvider());
final LocationProvider locationProviderVar = LocationProvider();

class LocationProvider extends ChangeNotifier {
  late LocationPermission _permissionGranted;
  bool whiteScreen = true;
  bool locationDeniedForeverScreen = false;
  bool locationDeniedScreen = false;

  Future<bool> askLocationPermission() async {
    _permissionGranted = await Geolocator.checkPermission();
    if (_permissionGranted == LocationPermission.denied) {
      _permissionGranted = await Geolocator.requestPermission();
    }
    if (_permissionGranted == LocationPermission.denied ||
        _permissionGranted == LocationPermission.deniedForever) {
      if (_permissionGranted == LocationPermission.denied) {
        whiteScreen = false;
        locationDeniedScreen = true;
        notifyListeners();
        return false;
      }
      if (_permissionGranted == LocationPermission.deniedForever) {
        whiteScreen = false;
        locationDeniedForeverScreen = true;
        notifyListeners();
      }

      LocationPermission permissionRequestedResult;
      if (_permissionGranted == LocationPermission.denied) {
        permissionRequestedResult = await Geolocator.requestPermission();
        if (permissionRequestedResult == LocationPermission.always ||
            permissionRequestedResult == LocationPermission.whileInUse) {
          locationDeniedForeverScreen = false;
          googleMapsProviderVar.locationEnable();
          notifyListeners();
          return true;
        } else if (_permissionGranted == LocationPermission.deniedForever ||
            permissionRequestedResult == LocationPermission.deniedForever) {
          whiteScreen = false;
          locationDeniedForeverScreen = true;
          notifyListeners();
          return false;
        } else if (permissionRequestedResult == LocationPermission.denied) {
          whiteScreen = false;
          locationDeniedScreen = true;
          notifyListeners();
          return false;
        }
      }
    } else if (_permissionGranted == LocationPermission.always ||
        _permissionGranted == LocationPermission.whileInUse) {
      locationDeniedForeverScreen = false;
      whiteScreen = false;
      googleMapsProviderVar.locationEnable();
      notifyListeners();
      return true;
    }
    notifyListeners();
    return true;
  }

  void whiteScreenTrue() {
    whiteScreen = true;
    notifyListeners();
  }

  void whiteScreenFalse() {
    whiteScreen = false;
    notifyListeners();
  }

  void locationDeniedScreenTrue() {
    locationDeniedScreen = true;
    notifyListeners();
  }

  void locationDeniedScreenFalse() {
    locationDeniedScreen = false;
    notifyListeners();
  }
}
