import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:test_project/login.dart';
import 'package:test_project/myTrips.dart';
import 'package:test_project/navigationDrawer.dart';
import 'dart:convert' as convert;
import 'dart:ui' as ui;

import 'Geolocalitation.dart';

class MapHome extends StatelessWidget {
  const MapHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const InitMap();
  }
}

const double CAMERA_ZOOM = 16;
const double CAMERA_TILT = 80;
const double CAMERA_BEARING = 30;
const LatLng SOURCE_LOCATION = LatLng(23.634501, -102.552784);
const LatLng DEST_LOCATION = LatLng(37.335685, -122.0605916);

class InitMap extends StatefulWidget {
  const InitMap({Key? key}) : super(key: key);
  @override
  _InitMapState createState() => _InitMapState();
}

class _InitMapState extends State<InitMap> {
  final _scaffKey = GlobalKey<ScaffoldState>();

  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = <Marker>{};
  LocationData? currentLocation;
  Location? location;
  LatLng showLocation = const LatLng(27.7089427, 85.3086209);

  @override
  void initState() {
    super.initState();
    showPinsOnMap();
    location = Location();

    location!.onLocationChanged.listen((LocationData locationData) {
      currentLocation = locationData;
    });
    setInitialLocation();
  }

  void setInitialLocation() async {
    // set the initial location by pulling the user's
    // current location from the location's getLocation()
    currentLocation = await location!.getLocation();

    // hard-coded destination for this example
    /*destinationLocation = LocationData.fromMap({
      "latitude": DEST_LOCATION.latitude,
      "longitude": DEST_LOCATION.longitude
    });*/

    updatePinOnMap();
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition = const CameraPosition(
        zoom: 5,
        tilt: CAMERA_TILT,
        bearing: CAMERA_BEARING,
        target: SOURCE_LOCATION);
    if (currentLocation != null) {
      initialCameraPosition = CameraPosition(
          target:
              LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
          zoom: CAMERA_ZOOM,
          tilt: CAMERA_TILT,
          bearing: CAMERA_BEARING);
    }
    return Stack(
      children: <Widget>[
        Scaffold(
          key: _scaffKey,
          appBar: AppBar(
            centerTitle: true,
            title: const Text("Taxis"),
            backgroundColor: Colors.orange,
          ),
          drawer: _getDrawer(context),
          body: GoogleMap(
            //Map widget from google_maps_flutter package
            zoomControlsEnabled: false,
            myLocationEnabled: true,
            compassEnabled: false,
            myLocationButtonEnabled: false,
            tiltGesturesEnabled: false,
            mapToolbarEnabled: false,
            markers: _markers.map((e) => e).toSet(),
            mapType: MapType.normal,
            initialCameraPosition: initialCameraPosition,
            onMapCreated: (controller) {
              //method called when map is created
              controller.setMapStyle(Utils.mapStyles);
              _controller.complete(controller);
              /*setState(() {
              mapController = controller;
            });*/
            },
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 120),
            child: FloatingActionButton(
              onPressed: () {
                updatePinOnMap();
              },
              backgroundColor: Colors.orange,
              child: const Icon(Icons.navigation),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SingleChildScrollView(
            child: Card(
              color: Colors.white54,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              margin:
                  const EdgeInsets.only(left: 20, bottom: 20, right: 20, top: 20),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const <Widget>[
                    TextField(
                      decoration: InputDecoration(
                        hintText: "A donde vamos?", //hint text
                        hintStyle: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.orange), //hint text style
                        labelStyle: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.orange), //label style
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _getDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          const UserAccountsDrawerHeader(
            accountName: Text("Carlos Ulloa"),
            accountEmail: Text("CarlosUlloa@Softnet.mx"),
            currentAccountPicture: CircleAvatar(
                radius: 50.0,
                backgroundColor: Color(0xFF778899),
                backgroundImage: NetworkImage(
                    "https://cdn4.iconfinder.com/data/icons/small-n-flat/24/user-alt-512.png")),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.orange, Colors.white],
                    end: Alignment.bottomRight)),
          ),
          ListTile(
              leading: const Icon(Icons.travel_explore),
              title: const Text("Mis viajes"),
              selected: true,
              onTap: () => {
                    Navigator.pop(context),
                    Navigator.of(context).pushNamed("/MyTrips")
                  }),
          ListTile(
              leading: const Icon(Icons.travel_explore),
              title: const Text("Mi Perfil"),
              selected: true,
              onTap: () => {
                    Navigator.pop(context),
                    Navigator.of(context).pushNamed("/Profile")
                  })
        ],
      ),
    );
  }

  void showTravels(BuildContext context) {
    Navigator.of(context).pushNamed("/MyTrips");
    Navigator.pop(context);
  }

  void showPinsOnMap() async {
    try {
      String imgurl = "assets/taxi.png";
      final Uint8List customMarker = await getBytesFromAsset(
          path: imgurl, //paste the custom image path
          width: 100 // size of custom image as marker
          );

      var url =
          Uri.parse('https://stxi-340320.uc.r.appspot.com/api/v1/locations/1');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body);
        var geolocations = Welcome.fromJson(jsonResponse);
        geolocations.data.locations.forEach((data) {
          var position = LatLng(data.position.lat!, data.position.lng!);
          _markers.add(Marker(
            markerId: MarkerId(data.id!),
            infoWindow: InfoWindow(title: "Taxi : ${data.id}"),
            position: position,
            onTap: () {
              /*setState(() {
            currentlySelectedPin = sourcePinInfo;
            pinPillPosition = 0;
          });*/
            },
            icon: BitmapDescriptor.fromBytes(customMarker),
          ));
        });
      }
    } catch (e) {
      print("Error Catch : $e");
    }
    /*var pinPosition =
    LatLng(currentLocation!.latitude!, currentLocation!.longitude!);

    _markers.add(Marker(
        markerId: MarkerId('myPin'),
        position: pinPosition,
        onTap: () {
          */ /*setState(() {
            currentlySelectedPin = sourcePinInfo;
            pinPillPosition = 0;
          });*/ /*
        },
        icon: BitmapDescriptor.defaultMarker));
    //CONSULTAR API Y OBTENER LATITUDES Y LONGITUDES CON UN FOREACH*/
  }

  void updatePinOnMap() async {
    // create a new CameraPosition instance
    // every time the location changes, so the camera
    // follows the pin as it moves with an animation
    showPinsOnMap();
    CameraPosition cPosition = CameraPosition(
      zoom: CAMERA_ZOOM,
      tilt: CAMERA_TILT,
      bearing: CAMERA_BEARING,
      target: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
    // do this inside the setState() so Flutter gets notified
    // that a widget update is due
    setState(() {
      // updated position
      /* var pinPosition =
      LatLng(currentLocation!.latitude!, currentLocation!.longitude!);*/

      // sourcePinInfo.location = pinPosition;

      // the trick is to remove the marker (by id)
      // and add it again at the updated location
      /*_markers.removeWhere((m) => m.markerId.value == 'sourcePin');
      _markers.add(Marker(
          markerId: MarkerId('sourcePin'),
          */ /*onTap: () {
            setState(() {
              currentlySelectedPin = sourcePinInfo;
              pinPillPosition = 0;
            });
          },*/ /*
          position: pinPosition, // updated position
          icon: BitmapDescriptor.defaultMarker));*/
    });
  }

  Future<Uint8List> getBytesFromAsset(
      {required String path, required int width}) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }
}

class Utils {
  static String mapStyles = '''[
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#bdbdbd"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#ffffff"
      }
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#dadada"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "transit.station",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#c9c9c9"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  }
]''';
}
