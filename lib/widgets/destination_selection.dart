

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/style.dart';
import '../providers/app_state.dart';

class DestinationWidget extends StatefulWidget {
  const DestinationWidget({Key? key}) : super(key: key);

  @override
  DestinationSelectionWidget createState() => DestinationSelectionWidget();
}

class DestinationSelectionWidget extends State<DestinationWidget> {

  @override
  Widget build(BuildContext context) {
    AppStateProvider appState = Provider.of<AppStateProvider>(context);
    KeyboardVisibilityController().onChange.listen((isVisible) {
      if(isVisible){
        appState.setSize(0.50, 0.45);
      }else{
        appState.setSize(0.2,0.2);
      }

    });
    return DraggableScrollableSheet(
      initialChildSize: appState.sizeDriver,
      minChildSize: appState.sizeDriver,
      maxChildSize: 0.70,
      builder: (BuildContext context, myscrollController) {
        return Container(
          decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                    color: Colors.orange.withOpacity(.8),
                    offset: Offset(3, 2),
                    blurRadius: 7)
              ]),
          child: ListView(
            controller: myscrollController,
            children: [
              Icon(
                Icons.remove,
                size: 40,
                color: grey,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: Container(
                  // color: grey.withOpacity(.3),
                  child: TextFormField(
                    onTap: () async {
                      SharedPreferences preferences =
                      await SharedPreferences.getInstance();
                      /*Prediction? p = await PlacesAutocomplete.show(
                          context: context,
                          apiKey: GOOGLE_MAPS_API_KEY,
                          mode: Mode.overlay, // Mode.fullscreen
                          // language: "pt",
                          components: [
                            *//*new Component(Component.country,
                                preferences.getString(COUNTRY))*//*
                          ]);*/
                      /*PlacesDetailsResponse detail =
                      await places.getDetailsByPlaceId(p?.placeId);
                      double lat = detail.result.geometry?.location.lat;
                      double lng = detail.result.geometry.location.lng;*/
                     /* appState.changeRequestedDestination(
                          reqDestination: p.description, lat: lat, lng: lng);*/
                      /*appState.updateDestination(destination: p.description);
                      LatLng coordinates = LatLng(lat, lng);*/
                      // appState.setDestination(coordinates: coordinates);
                      appState.addPickupMarker(appState.center!);

                      appState.changeWidgetShowed(
                          showWidget: Show.PICKUP_SELECTION);
                      // appState.sendRequest(coordinates: coordinates);
                    },
                    textInputAction: TextInputAction.go,
                    controller: appState.destinationController,
                    cursorColor: Colors.blue.shade900,
                    decoration: InputDecoration(
                      icon: Container(
                        margin: EdgeInsets.only(left: 20, bottom: 15),
                        width: 10,
                        height: 10,
                        child: Icon(
                          Icons.location_on,
                          color: Colors.orange,
                        ),
                      ),
                      hintText: "A donde vamos?",
                      hintStyle: TextStyle(
                          color: Colors.orange,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color:Colors.orange)),
                      contentPadding: EdgeInsets.all(15),
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.deepOrange[300],
                  child: Icon(
                    Icons.home,
                    color: white,
                  ),
                ),
                title: Text("Casa"),
                subtitle: Text("Mariano de abasolo"),
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.deepOrange[300],
                  child: Icon(
                    Icons.work,
                    color: white,
                  ),
                ),
                title: Text("Trabajo"),
                subtitle: Text("Sayula 215"),
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey.withOpacity(0.18),
                  child: Icon(
                    Icons.history,
                    color: primary,
                  ),
                ),
                title: Text("Dirección recinente"),
                subtitle: Text("Av. Félix U. Gómez"),
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey.withOpacity(.18),
                  child: Icon(
                    Icons.history,
                    color: primary,
                  ),
                ),
                title: Text("Dirección recinente"),
                subtitle: Text("Av. Benito Juárez"),
              ),
            ],
          ),
        );
      },
    );
  }
}
