import 'dart:convert';

import 'package:dropgo/models/vendor_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:shared_preferences/shared_preferences.dart';

final vendorProvider = ChangeNotifierProvider((ref) => VendorProvider());
final VendorProvider vendorProviderVar = VendorProvider();

class VendorProvider extends ChangeNotifier {
  late VendorModel vendorModel = VendorModel("", "", "", "", "", "", [], "");

  bool initialPrefCall = false;
  String accessToken = "";

  initState() async {
    if (initialPrefCall == false) {
      getSharedPreference();
    }
  }

  Future<String> getToken() async {
    if (accessToken != "") {
      return accessToken;
    }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString('accessToken') != null) {
      accessToken = sharedPreferences.getString('accessToken')!;
      return accessToken;
    }
    return "";
  }

  setVendorModel(vendorResult) {
    List<String> tempOrders = [];
    print("setVendorModel");
    vendorResult['orders'].forEach((order) {
      tempOrders.add(order["_id"].toString());
    });

    vendorModel = VendorModel(
      vendorResult['_id'] ?? "",
      vendorResult['name'] ?? "",
      vendorResult['email'] ?? "",
      vendorResult['pNumber'] ?? "",
      vendorResult['createAt'] ?? "",
      vendorResult['updateAt'] ?? "",
      tempOrders,
      vendorResult['accessToken'] ?? "",
    );
    accessToken = vendorResult['accessToken'];
    notifyListeners();
    syncSharedPreference();
  }

  updateVendorModel(email, fullName, pNumber) {
    vendorModel.email = email;
    vendorModel.name = fullName;
    vendorModel.pNumber = pNumber;
    notifyListeners();
    syncSharedPreference();
  }

  syncSharedPreference() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(
        'vendor', json.encode(vendorModel.toJson()));
    await sharedPreferences.setString('accessToken', accessToken);
  }

  deleteSharedPreference() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    vendorModel = VendorModel("", "", "", "", "", "", [], "");
    accessToken = "";
    sharedPreferences.remove("accessToken");
    sharedPreferences.remove("vendor");
    notifyListeners();
  }

  Future getSharedPreference() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString('accessToken') != null) {
      accessToken = sharedPreferences.getString('accessToken')!;

      notifyListeners();
    }

    if (sharedPreferences.getString('vendor') != null) {
      var resultVendor = sharedPreferences.getString('vendor');
      Map tempDecodeVendor = json.decode(resultVendor!);
      VendorModel tempvendorModel = VendorModel(
        tempDecodeVendor['id'] ?? "",
        tempDecodeVendor['name'] ?? "",
        tempDecodeVendor['email'] ?? "",
        tempDecodeVendor['pNumber'] ?? "",
        tempDecodeVendor['createAt'] ?? "",
        tempDecodeVendor['updateAt'] ?? "",
        tempDecodeVendor['orders'].split(',') ?? [],
        tempDecodeVendor['accessToken'] ?? "",
      );
      vendorModel = tempvendorModel;
    }

    initialPrefCall = true;
    notifyListeners();
  }
}
