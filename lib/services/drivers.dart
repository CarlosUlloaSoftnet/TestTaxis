import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:test_project/Models/Geolocalisation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../Models/rates.dart';
import '../providers/app_state.dart';

class DriverService {
  String collection = 'drivers';

  Future<Welcome?> getDrivers() async {
    var url =
        Uri.parse('https://stxi-340320.uc.r.appspot.com/api/v1/locations/1');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      var geolocations = Welcome.fromJson(jsonResponse);

      return geolocations;
    }
    return null;
    /*return firebaseFiretore.collection(collection).snapshots().map((event) =>
        event.documents.map((e) => DriverModel.fromSnapsho  t(e)).toList());*/
  }

  Future<Rates?> getRate(
      LatLng destination, LatLng origin, String businessId) async {
    var url =
        Uri.parse('https://booking-dot-stxi-340320.uc.r.appspot.com/booking-service/v2/bookings/quotations');
    var response = await http.post(
      url,
      body: {
        'origin': '${origin.latitude.toString()} , ${origin.longitude.toString()}',
        'destination': '${destination.latitude.toString()} , ${destination.longitude.toString()}',
        'businessId': businessId,
      });
    if(response.statusCode == 200){
      var jsonResponse = convert.jsonDecode(response.body);
      var rates = Rates.fromJson(jsonResponse);
      return rates;
      // var jsonResponse =
      // convert.jsonDecode(response.body) as Map<String, dynamic>;
      // var total = jsonResponse['total'];
      // return total.toString();
    }
    return null;
  }

/*  Future<Welcome> getDriverById(String id) =>
      firebaseFiretore.collection(collection).document(id).get().then((doc) {
        return DriverModel.fromSnapshot(doc);
      });*/

  Stream<Welcome>? driverStream() {
    return null;
    /*CollectionReference reference = Firestore.instance.collection(collection);
    return reference.snapshots();*/
  }
}
