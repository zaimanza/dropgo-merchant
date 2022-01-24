import 'package:dropgo/providers/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final googleMapsProvider =
    ChangeNotifierProvider((ref) => GoogleMapsProvider());
final GoogleMapsProvider googleMapsProviderVar = GoogleMapsProvider();

class GoogleMapsProvider extends ChangeNotifier {
  late LatLng center = const LatLng(3.1390, 101.6869);
  late GoogleMapController mapController;
  late String mapStyle;
  late LatLng changeMarkerVal;
  late String city = "";
  late String postcode = "";
  bool isRead = false;
  double zoomCamera = 11.9;
  String fullAddr = "";
  ValueNotifier<List<Marker>> markers = ValueNotifier<List<Marker>>([]);
  List<Marker> googleMapsMarker = [];

  Future<void> locationEnable() async {
    try {
      if (await Geolocator.isLocationServiceEnabled()) {
        //kena tnya location enable ke tk;
        Position? _locationResult;
        try {
          _locationResult = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
          );
        } catch (e) {
          _locationResult = null;
        }
        if (_locationResult != null) {
          center = LatLng(_locationResult.latitude, _locationResult.longitude);
          getPlaceAddress(center);

          googleMapsMarker = [];
          // myCircle = [];
          // if (center != null) {
          //   markers.value.removeWhere((element) =>
          //       element.markerId == MarkerId(changeMarkerVal.toString()));
          // }
          // settingCircle(_center);
          settingMarker(center);
        }
      } else {
        Position? _locationResult;
        try {
          _locationResult = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
          );
        } catch (e) {
          _locationResult = null;
        }
        if (_locationResult != null) {
          center = LatLng(_locationResult.latitude, _locationResult.longitude);
          getPlaceAddress(center);
          // myMarker = [];
          // myCircle = [];
          // if (changeMarkerVal != null) {
          //   vendorMarkers.value.removeWhere((element) =>
          //       element.markerId == MarkerId(changeMarkerVal.toString()));
          // }
          // settingCircle(_center);
          settingMarker(center);
          locationProviderVar.locationDeniedScreenFalse();
        } else {
          locationProviderVar.locationDeniedScreenTrue();
        }
      }

      locationProviderVar.whiteScreenFalse();
    } on PlatformException catch (err) {
      // print(err);
    }

    notifyListeners();
  }

  void clearMarkers() {
    markers.value.clear();
    googleMapsMarker.clear();
  }

  handleTap(LatLng tappedPoint) async {
    isRead = false;
    center = tappedPoint;
    resetCamera(center);
    getPlaceAddress(center);
    googleMapsMarker = [];
    // myCircle = [];
    // vendorMarkers.value.removeWhere(
    //         (element) => element.markerId == MarkerId(changeMarkerVal.toString()));
    // settingCircle(_center);
    settingMarker(center);
    // print(_center);

    notifyListeners();
  }

  settingMarker(LatLng tappedPoint) {
    changeMarkerVal = tappedPoint;
    markers.value.add(
      Marker(
        markerId: const MarkerId(
          "current location",
        ),
        position: tappedPoint,
        draggable: true,
        onDragEnd: (dragEndPosition) async {
          tappedPoint = dragEndPosition;
          center = dragEndPosition;
          resetCamera(center);
          getPlaceAddress(center);
          googleMapsMarker = [];
          markers.value.removeWhere((element) =>
              element.markerId == const MarkerId("current location"));
          settingMarker(center);
          notifyListeners();
        },
      ),
    );
    notifyListeners();
    print("hi aiman");
    print(markers);
  }

  void resetCamera(LatLng coordinate) {
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: coordinate,
          zoom: zoomCamera,
        ),
      ),
    );
    notifyListeners();
  }

  void getPlaceAddress(LatLng geoLatLng) async {
    // print("get address");
    // print(geoLatLng);
    try {
      List<Placemark> placeMarks = await placemarkFromCoordinates(
          geoLatLng.latitude, geoLatLng.longitude);
      while (placeMarks == null) {
        // print("lepas jgk");
        placeMarks = await placemarkFromCoordinates(
            geoLatLng.latitude, geoLatLng.longitude);
      }
      // print(placeMarks);
      Placemark place = placeMarks[0];
      String prepAddress = "";
      if (place.street!.isNotEmpty) {
        prepAddress = "$prepAddress${place.street}, ";
      }
      if (place.thoroughfare!.isNotEmpty) {
        prepAddress = "$prepAddress${place.thoroughfare}, ";
      }
      if (place.postalCode!.isNotEmpty) {
        prepAddress = "$prepAddress${place.postalCode}, ";
        postcode = place.postalCode!;
      }
      if (place.locality!.isNotEmpty) {
        prepAddress = "$prepAddress${place.locality}, ";
        city = place.locality!;
      }
      if (place.country!.isNotEmpty) {
        prepAddress = "$prepAddress${place.country}";
      }
      if (placeMarks.isEmpty == true || prepAddress.replaceAll(' ', '') == '') {
        prepAddress = "Drop Go";
      }
      fullAddr = prepAddress;
      // print("The place name is");
      // print(_currentAddress);

      notifyListeners();
    } catch (e) {
      // print(e);
    }
  }
}
