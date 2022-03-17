import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocode/geocode.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:test_project/Models/driver.dart';
import 'package:test_project/Models/driversPositions.dart';
import 'package:test_project/services/drivers.dart';
import 'package:test_project/services/map_requests.dart';
import 'package:uuid/uuid.dart';
import 'dart:ui' as ui;
import 'package:socket_io_client/socket_io_client.dart';
import 'dart:convert' as convert;

import '../Models/Geolocalisation.dart';
import '../Models/rates.dart';
import '../Models/ride_request.dart';
import '../Models/route.dart';
import '../helpers/style.dart';
import '../services/ride_requests.dart';
import 'dart:developer';

enum Show {
  LOADING,
  DESTINATION_SELECTION,
  PICKUP_SELECTION,
  PAYMENT_METHOD_SELECTION,
  DRIVER_FOUND,
  TRIP
}

class AppStateProvider with ChangeNotifier {
  static const ACCEPTED = 'accepted';
  static const CANCELLED = 'cancelled';
  static const PENDING = 'pending';
  static const EXPIRED = 'expired';
  static const PICKUP_MARKER_ID = 'pickup';
  static const LOCATION_MARKER_ID = 'location';
  static const DRIVER_AT_LOCATION_NOTIFICATION = 'DRIVER_AT_LOCATION';
  static const REQUEST_ACCEPTED_NOTIFICATION = 'REQUEST_ACCEPTED';
  static const TRIP_STARTED_NOTIFICATION = 'TRIP_STARTED';

  Set<Marker> _markers = {};

  //  this polys will be displayed on the map
  Set<Polyline> _poly = {};

  // this polys temporarely store the polys to destination
  Set<Polyline> _routeToDestinationPolys = {};

  // this polys temporarely store the polys to driver
  Set<Polyline> _routeToDriverpoly = {};

  GoogleMapsServices _googleMapsServices = GoogleMapsServices();
  late GoogleMapController _mapController;

  // Geoflutterfire geo = Geoflutterfire();
  static LatLng? _center;
  Location? location = Location();
  LatLng? _lastPosition = _center;
  TextEditingController pickupLocationController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  LocationData? position;
  // DriverService _driverService = DriverService();
  late Socket socket;

  double initialSize = 0.2;
  double sizeDriver = 0.2;
  bool visibleFAB = false;
  double paddingFAB = 130.h;

  List<Datum> ratesList = [];

  var businessId = "621e99fcd27526d5cdd71ae9";

  //  draggable to show
  Show show = Show.DESTINATION_SELECTION;

  //   taxi pin
  late Uint8List carPin;
  late Uint8List pickUpPin;
  late Uint8List personPin;

  LatLng? get center => _center;

  LatLng? get lastPosition => _lastPosition;

  Set<Marker> get markers => _markers;

  Set<Polyline> get poly => _poly;

  GoogleMapController get mapController => _mapController;
  late RouteModel routeModel;

  //  Driver request related variables
  bool lookingForDriver = false;
  bool alertsOnUi = false;
  bool driverFound = false;
  bool driverArrived = false;
  RideRequestServices _requestServices = RideRequestServices();
  int timeCounter = 0;
  double percentage = 0;
  late Timer periodicTimer;
  late String? requestedDestination;
  late String? requestedOrigin;

  String requestStatus = "";
  late LatLng requestedDestinationLatLng;
  late LatLng requestedOriginLatLng;

  late double requestedDestinationLng;
  late RideRequestModel rideRequestModel;
  late BuildContext mainContext;

//  this variable will listen to the status of the ride request
//   StreamSubscription<QuerySnapshot> requestStream;
  // this variable will keep track of the drivers position before and during the ride
  // StreamSubscription<QuerySnapshot> driverStream;
//  this stream is for all the driver on the app
  late Future<Welcome?> allDriversStream;

  late DriverModel driverModel;
  late LatLng pickupCoordinates;
  late LatLng destinationCoordinates;
  double ridePrice = 0;
  String notificationType = "";

  AppStateProvider() {
    _setCustomMapPin();
    // _listemToDrivers();
    // location?.onLocationChanged.listen((LocationData location) {
    //   position = location;
    //   notifyListeners();
    // });
    _getUserLocation();
    _getSocket();
  }

  void setVisibleFAB(bool visible){
    visibleFAB = visible;
    notifyListeners();
  }

  void setPaddingFAB(double padding){
    paddingFAB = padding;
    notifyListeners();
  }

  void _getSocket() {
    var token =
        "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjMiLCJpYXQiOjE2NDYxNzg4OTYsImV4cCI6MTY1Mzk1NDg5Nn0.7o1Jv5Zm5cs8GJ6F4NKwX-uwrESSGrTSSLVfmKP-jA4";
    socket = io(
        'https://monitor-dot-stxi-340320.uc.r.appspot.com/',
        OptionBuilder()
            .setTransports(['websocket'])
            .setExtraHeaders({'token': token}).setQuery(
            {'token': token}).build());
    socket.on(
        "connect",
            (data) => {
          log("CONNECTED"),
          socket.emit("init", {
            // "lat": 25.681414578365192,
            // "lng": -100.3475796184339,
            "lat": _center!.latitude,
            "lng": _center!.longitude,
            "distance": 25
          }),
        });
    socket.on("nearDrivers", (data) =>_createDriversListener(data));
    socket.on('driverPositionUpdated', (id) => driverPositionUpdatedListener(id));
  }
  void _createDriversListener(List<dynamic> jsonData){
    log("DRIVERS: " + jsonData.toString());
    var data = jsonData.map((e) => DriversPositions.fromJson(e));
    updateMarkers(data);
  }

  void driverPositionUpdatedListener (bId) {
    log("UpdatedListener");
    log("UPDATEpOSITIONS" + bId.toString());
    if(bId == businessId){
    log("driverPositionUpdatedListener");
    socket.emit('refreshDrivers', {
      // "lat": 25.681414578365192,
      // "lng": -100.3475796184339,
      "lat": _center!.latitude,
      "lng": _center!.longitude,
      "distance": 5
    });
    }
  }


  setSize(double sizeDriver, double initialSize) {
    this.sizeDriver = sizeDriver;
    this.initialSize = initialSize;
    notifyListeners();
  }

  _setCustomMapPin() async {
    String car = "assets/taxi.png";
    String pickUp = "assets/pin_pickup.png";
    String person = "assets/person_marker.png";
    carPin = await _getBytesFromAsset(
        path: car,
        width: 110
        );
    pickUpPin = await _getBytesFromAsset(
        path: pickUp,
        width: 30
    );
    personPin = await _getBytesFromAsset(
        path: person,
        width: 70
    );
    /*carPin = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 2.5), 'assets/taxi.png');*/

    // locationPin = await BitmapDescriptor.fromAssetImage(
    //     const ImageConfiguration(devicePixelRatio: 2.5), 'images/pin.png');
  }

  Future<Uint8List> _getBytesFromAsset(
      {required String path, required int width}) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void _getUserLocation() async {
    position = await location!.getLocation();
    if (position != null) {
      _center = LatLng(position!.latitude!, position!.longitude!);
      /*CameraPosition cPosition = CameraPosition(
        zoom: 5,
        tilt: 80,
        bearing: 30,
        target: LatLng(position!.latitude!, position!.longitude!),
      );
      _mapController.animateCamera(CameraUpdate.newCameraPosition(cPosition));*/
      _getSocket();
      notifyListeners();
    }
  }

  void updateCamera() {
    if (_mapController != null && position != null) {
      LatLng latLng = LatLng(position!.latitude!, position!.longitude!);
      CameraUpdate cameraUpdate = CameraUpdate.newLatLngZoom(latLng, 15);
      _mapController.animateCamera(cameraUpdate);
      notifyListeners();
    }
  }

  //CONSUMIR SERVICIOS API PARA OBETENER LA LISTA DE CONDUCTORES
  _listemToDrivers() async {
    // allDriversStream = _driverService
    //     .getDrivers()
    //     .whenComplete(() => updateMarkers(allDriversStream));
    // if (allDriversStream != null) {
    //   _updateMarkers(allDriversStream);
    // }
  }

  onCreate(GoogleMapController controller) {
    _mapController = controller;
    notifyListeners();
  }

  setLastPosition(LatLng position) {
    _lastPosition = position;
    notifyListeners();
  }

  onCameraMove(CameraPosition position) {
    if (show == Show.PICKUP_SELECTION) {
      _lastPosition = position.target;
      changePickupLocationAddress(address: "Cargando...");
      if (_markers.isNotEmpty) {
        _markers.forEach((element) async {
          if (element.mapsId.value == PICKUP_MARKER_ID) {
            _markers.remove(element);
            pickupCoordinates = position.target;
            addPickupMarker(position.target);
            /*    List<Placemark> placeMark = await placemarkFromCoordinates(
                position.target.latitude, position.target.longitude);
            location.getLocation().
            pickupLocationController.text = placeMark[0].name!;*/
            GeoCode geoCode = GeoCode();
            var addresses = await geoCode.reverseGeocoding(
                latitude: position.target.latitude,
                longitude: position.target.longitude);
            pickupLocationController.text = addresses.streetAddress.toString();
            notifyListeners();
          }
        });
      }
      notifyListeners();
    }
  }

  changePickupLocationAddress({required String address}) {
    pickupLocationController.text = address;
    if (pickupCoordinates != null) {
      _center = pickupCoordinates;
    }
    notifyListeners();
  }

  addPickupMarker(LatLng position) {
    pickupCoordinates = position;
    _markers.add(Marker(
        markerId: MarkerId(PICKUP_MARKER_ID),
        position: position,
        // anchor: Offset(0, 0.85),
        // zIndex: 3,
        infoWindow: InfoWindow(title: "Direccion", snippet: ""),
        icon: BitmapDescriptor.fromBytes(personPin)));
        // icon: BitmapDescriptor.defaultMarker));
    notifyListeners();
  }

  Future sendRequest(
      { LatLng? origin, LatLng? destination}) async {
    LatLng _org;
    LatLng _dest;

    if (origin == null && destination == null) {
      _org = pickupCoordinates;
      _dest = destinationCoordinates;
    } else {
      _org = origin!;
      _dest = destination!;
    }

    RouteModel route =
        await _googleMapsServices.getRouteByCoordinates(_org, _dest);
    routeModel = route;

    if (origin == null) {
      //PRECIO DE VIAJE
      // getRate(_dest, _org, businessId);
      DriverService driver = DriverService();
      var rateData = await driver.getRate(_dest, _org, businessId);
      if(rateData != null){
        if(rateData.status == "success") {
          for (var element in rateData.data) {
              var data = Datum(type: element.type, estimate: element.estimate);
              ratesList.add(data);
          }
        }
      }

    // .toStringAsFixed(2)
    //   await rateData.then((value) => {
    //     ridePrice = double.parse(value.toString())
    //   });
    }
    List<Marker> mks = _markers
        .where((element) => element.markerId.value == "location")
        .toList();
    if (mks.isNotEmpty) {
      _markers.remove(mks[0]);
    }
// ! another method will be created just to draw the polys and add markers
    _addLocationMarker(destinationCoordinates, routeModel.distance!.text!);
    _center = destinationCoordinates;
    LatLng updateCamera = LatLng(pickupCoordinates.latitude, destinationCoordinates.longitude);
    CameraUpdate cameraUpdate = CameraUpdate.newLatLngZoom(updateCamera, 13);
    // LatLngBounds bound = LatLngBounds(southwest: pickupCoordinates, northeast: destinationCoordinates);
    // CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(bound, 13);
    _mapController.animateCamera(cameraUpdate);
    if (_poly != null) {
      _createRoute(route.points!, color: Colors.deepOrange);
    }
    _createRoute(
      route.points!,
    );
    _routeToDestinationPolys = _poly;
    notifyListeners();
  }

  void updateDestination({String? destination}) {
    destinationController.text = destination!;
    notifyListeners();
  }

  _addLocationMarker(LatLng position, String distance) {
    _markers.add(Marker(
        markerId: const MarkerId(LOCATION_MARKER_ID),
        position: position,
        anchor: const Offset(0, 0.85),
        infoWindow:
            InfoWindow(title: pickupLocationController.text, snippet: distance),
        icon: BitmapDescriptor.fromBytes(pickUpPin)));
    notifyListeners();
  }

  _createRoute(String decodeRoute, {Color? color}) {
    clearPoly();
    var uuid = new Uuid();
    String polyId = uuid.v1();
    _poly.add(Polyline(
        polylineId: PolylineId(polyId),
        width: 5,
        color: color ?? Colors.orange,
        onTap: () {},
        points: _convertToLatLong(_decodePoly(decodeRoute))));
    notifyListeners();
  }

  List<LatLng> _convertToLatLong(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  clearPoly() {
    _poly.clear();
    notifyListeners();
  }

  List _decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = [];
    int index = 0;
    int len = poly.length;
    int c = 0;
// repeating until all attributes are decoded
    do {
      var shift = 0;
      int result = 0;

      // for decoding value of one attribute
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      /* if value is negetive then bitwise not the value */
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

/*adding to previous value as done in encoding */
    for (var i = 2; i < lList.length; i++) {
      lList[i] += lList[i - 2];
    }

    print(lList.toString());

    return lList;
  }

  void _addDriverMarker(
      {required LatLng position,
      required double rotation,
      required String driverId}) {
    // var uuid = new Uuid();
    // String markerId = uuid.v1();
    log("ADDMARKER: " + driverId);
    _markers.add(Marker(
        markerId: MarkerId(driverId),
        position: position,
        rotation: rotation,
        draggable: false,
        zIndex: 2,
        flat: true,
        infoWindow: InfoWindow(title: "Taxi : $driverId"),
        anchor: const Offset(1, 1),
        icon: BitmapDescriptor.fromBytes(carPin)));
    // icon: carPin));
  }

  updateMarkers(Iterable<DriversPositions> drivers) {
    log("UPDATEMARKERS");
//    this code will ensure that when the driver markers are updated the location marker wont be deleted
    List<Marker> locationMarkers = _markers
        .where((element) => element.markerId.value == 'location')
        .toList();
    clearMarkers();
    if (locationMarkers.isNotEmpty) {
      _markers.add(locationMarkers[0]);
    }

    for (var element in drivers) {
      for (var value in element.actualLocation.coordinates) {
        _addDriverMarker(
            driverId: element.id.toString(),
            position: LatLng(element.actualLocation.coordinates[1], element.actualLocation.coordinates[0]),
            rotation: 10);
      }
    }

//    here we are updating the drivers markers
    /*drivers.then((value) => {
          for (var driver in value!.data.locations)
            {
              _addDriverMarker(
                  driverId: driver.id.toString(),
                  position: LatLng(driver.position.lat!, driver.position.lng!),
                  rotation: 10)
              // rotation: driver.position.heading);
            }
        });*/
    notifyListeners();
  }

  clearMarkers() {
    log("CLEARMARKERS");
    _markers.clear();
    notifyListeners();
  }

  _clearDriverMarkers() {
    _markers.forEach((element) {
      String _markerId = element.markerId.value;
      if (_markerId != driverModel.id ||
          _markerId != LOCATION_MARKER_ID ||
          _markerId != PICKUP_MARKER_ID) {
        _markers.remove(element);
        notifyListeners();
      }
    });
  }

  changeMainContext(BuildContext context) {
    mainContext = context;
    notifyListeners();
  }

  changeRequestedDestination({String? reqDestination, required double lat, required double lng}) {
    requestedDestination = reqDestination;
    requestedDestinationLatLng = LatLng(lat, lng);
  }
  changeRequestedOrigin({String? reqDestination, required double lat, required double lng}) {
    requestedOrigin = reqDestination;
    requestedOriginLatLng = LatLng(lat, lng);
  }

  changeWidgetShowed({required Show showWidget}) {
    show = showWidget;
    if(showWidget == Show.DESTINATION_SELECTION){
      if(_poly.isNotEmpty){
        clearPoly();
        LatLng updateCamera = LatLng(_center!.latitude, _center!.longitude);
        CameraUpdate cameraUpdate = CameraUpdate.newLatLngZoom(updateCamera, 15);
        _mapController.animateCamera(cameraUpdate);
        for (var element in _markers) {
          if(element.markerId == const MarkerId(LOCATION_MARKER_ID)){
            _markers.remove(element);
          }
        }
      }
    }
    notifyListeners();
  }

  showRequestCancelledSnackBar(BuildContext context) {}

  showRequestExpiredAlert(BuildContext context) {
    if (alertsOnUi) Navigator.pop(context);

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 200,
              child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("No se encontraron conductores! \n Intente de nuevo")
                    ],
                  )),
            ),
          );
        });
  }

  showDriverBottomSheet(BuildContext context) {
    if (alertsOnUi) Navigator.pop(context);

    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
              height: 400,
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("7 MIN AWAY",
                          style: TextStyle(
                              color: green, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Visibility(
                        visible: driverModel?.photo == null,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(40)),
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 45,
                            child: Icon(
                              Icons.person,
                              size: 65,
                              color: white,
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: driverModel?.photo != null,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.deepOrange,
                              borderRadius: BorderRadius.circular(40)),
                          child: CircleAvatar(
                            radius: 45,
                            backgroundImage: NetworkImage(
                                "https://panama.didiglobal.com/wp-content/uploads/sites/13/2020/08/FOTO-03.jpg"),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("NOMBRE DEL CONDUCTOR (SERVICIO)"),
                    ],
                  ),
                  SizedBox(height: 10),
                  // _stars(rating: driverModel.rating, votes: driverModel.votes),
                  Text("CALIFICACION EN ESTRELLAS"),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      FlatButton.icon(
                          onPressed: null,
                          icon: Icon(Icons.directions_car),
                          label: Text(driverModel.car ?? "Nan")),
                      Text("MARCA DEL VEHICULO",
                          style: TextStyle(
                            color: Colors.deepOrange,
                          )),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        child: Text("Llamar"),
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            primary: green, shadowColor: Colors.green),
                      ),
                      ElevatedButton(
                        child: Text("Cancelar"),
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            primary: red, shadowColor: Colors.redAccent),
                      ),
                    ],
                  )
                ],
              ));
        });
  }

  //PENDIENTE ALGUN WIDGET PARA MOSTRAR ESTRELLAS DE CALIFICACION

  _saveDeviceToken() async {
    //TOKEN PARA GUARDAR DISPOSITIVO
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // if (prefs.getString('token') == null) {
    //   String deviceToken = await fcm.getToken();
    //   await prefs.setString('token', deviceToken);
    // }
  }
  setPickCoordinates({required LatLng coordinates}) {
    pickupCoordinates = coordinates;
    notifyListeners();
  }

  setDestination({required LatLng coordinates}) {
    destinationCoordinates = coordinates;
    notifyListeners();
  }
}
