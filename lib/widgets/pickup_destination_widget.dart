import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sliding_up_panel/sliding_up_panel_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_place/google_place.dart';
import 'package:provider/provider.dart';

import '../helpers/constants.dart';
import '../helpers/style.dart';
import '../providers/app_state.dart';

class PickupSelectionWidget extends StatefulWidget {
  const PickupSelectionWidget({Key? key}) : super(key: key);

  @override
  State<PickupSelectionWidget> createState() => _PickupSelectionWidgetState();
}

class _PickupSelectionWidgetState extends State<PickupSelectionWidget> {
  SlidingUpPanelController panelController = SlidingUpPanelController();
  late ScrollController scrollController;
  late GooglePlace googlePlace;
  List<AutocompletePrediction> predictions = [];
  double heightPanelPickup = 0.h;

  @override
  void initState() {
    googlePlace = GooglePlace(GOOGLE_MAPS_API_KEY);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppStateProvider appState = Provider.of<AppStateProvider>(context);
    appState.visibleFAB = false;

    return Padding(
      padding: EdgeInsets.only(top: 80.h),
      child: SlidingUpPanelWidget(
        enableOnTap: false,
        controlHeight: 180.0.h,
        anchor: 0.4.w,
        panelController: panelController,
        child: Container(
          decoration: BoxDecoration(
              color: white,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                    color: Colors.orange.withOpacity(.8),
                    offset: const Offset(3, 2),
                    blurRadius: 7)
              ]),
          child: ListView(
            // controller: myscrollController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              Icon(
                Icons.remove,
                size: 20.h,
                color: grey,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Mueva el pin para ajustar el punto de encuentro",
                    style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange),
                  ),
                ],
              ),
              const Divider(),
              SizedBox(
                height: 8.h,
              ),
              Padding(
                padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
                child: Container(
                  // color: grey.withOpacity(.3),
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    onTap: () async {
                      panelController.expand();
                      /*SharedPreferences preferences =
                        await SharedPreferences.getInstance();
                        Prediction p = await PlacesAutocomplete.show(
                            context: context,
                            apiKey: GOOGLE_MAPS_API_KEY,
                            mode: Mode.overlay, // Mode.fullscreen
                            // language: "pt",
                            components: [
                              new Component(Component.country,
                                  preferences.getString(COUNTRY))
                            ]);
                        PlacesDetailsResponse detail =
                        await places.getDetailsByPlaceId(p.placeId);
                        double lat = detail.result.geometry.location.lat;
                        double lng = detail.result.geometry.location.lng;
                        appState.changeRequestedDestination(
                            reqDestination: p.description, lat: lat, lng: lng);
                        appState.updateDestination(destination: p.description);
                        LatLng coordinates = LatLng(lat, lng);*/
                      // appState.setPickCoordinates(coordinates: coordinates);
                      // appState.changePickupLocationAddress(
                      //     address: p.description);
                      // appState.changePickupLocationAddress(
                      //     address: "DESCRIPCION");
                    },
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        log("valueIsNotEmpty");
                        setState(() {
                          heightPanelPickup = 400.h;
                          log(heightPanelPickup.toString());
                        });
                        autoCompleteSearch(value);
                      } else if (predictions.isEmpty) {
                        setState(() {
                          predictions = [];
                        });
                      }
                    },
                    textInputAction: TextInputAction.go,
                    controller: appState.pickupLocationController,
                    cursorColor: Colors.orange.shade900,
                    style: TextStyle(
                        fontSize: 18.sp,
                        color: Colors.deepOrange,
                        fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 10.0),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      hintText: "Seleccion el origen",
                      hintStyle: TextStyle(
                          color: Colors.orange,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),Padding(
                padding: const EdgeInsets.only(top: 30),
                child: SizedBox(
                  height: heightPanelPickup,
                  child: ListView.builder(
                      itemCount: predictions.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: const CircleAvatar(
                            child: Icon(
                              Icons.pin_drop_outlined,
                              color: Colors.deepOrange,
                            ),
                          ),
                          title: Text(predictions[index].description!),
                          onTap: () async {
                            // PlacesDetailsResponse detail =
                            // await places.getDetailsByPlaceId(predictions[index].placeId!);
                            var result = await googlePlace.details
                                .get(predictions[index].placeId!);
                            if (result != null &&
                                result.result != null &&
                                mounted){
                              if (result.result!.geometry != null) {
                                double lat =
                                result.result!.geometry!.location!.lat!;
                                double lng =
                                result.result!.geometry!.location!.lng!;
                                appState.changeRequestedDestination(
                                    reqDestination: predictions[index].description, lat: lat, lng: lng);
                                appState.updateDestination(destination: predictions[index].description);
                                // LatLng coordinates = LatLng(lat, lng);
                                LatLng coordinates = LatLng(appState.center!.latitude, appState.center!.longitude);
                                appState.setPickCoordinates(coordinates: coordinates);
                                appState.changePickupLocationAddress(
                                    address: predictions[index].description!);
                              }
                            }
                            panelController.collapse();
                          },
                        );
                      }),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 15.0.w,
                    right: 15.0.w,
                  ),
                  child: ElevatedButton(
                    onPressed: () async {
                      await appState.sendRequest();
                      appState.changeWidgetShowed(
                          showWidget: Show.PAYMENT_METHOD_SELECTION);
                    },
                    style: ElevatedButton.styleFrom(primary: Colors.orange),
                    child: Text(
                      "Confirmar viaje",
                      style: TextStyle(color: white, fontSize: 16.sp),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void autoCompleteSearch(String value) async {
    log("value = " + value);
    var result = await googlePlace.autocomplete.get(value);
    log("result = " + result.toString());
    if (result != null && result.predictions != null && mounted) {
      setState(() {
        predictions = result.predictions!;
      });
    }
  }
}
