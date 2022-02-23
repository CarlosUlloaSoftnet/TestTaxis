import 'package:test_project/Models/Geolocalitation.dart';

class DriverService {
  String collection = 'drivers';

  Stream<List<Welcome>>? getDrivers() {
    return null;
    /*return firebaseFiretore.collection(collection).snapshots().map((event) =>
        event.documents.map((e) => DriverModel.fromSnapshot(e)).toList());*/
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