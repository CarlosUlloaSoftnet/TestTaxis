import 'package:provider/provider.dart';
import 'package:test_project/Models/Geolocalisation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

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